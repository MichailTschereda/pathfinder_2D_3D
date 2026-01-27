int Z_OFF,Y_OFF, X_OFF;
Z_OFF=1;
Y_OFF=1;
X_OFF=1;

public class CoordinatesWithBrightnessDifference {

    private ArrayList<PVector> unsortedCoordinates;
    private PImage imgIn;
    private final static int FILTER_FACTOR = 30;
    private final static int MIN_BRIGHTNESS = 4;
    
    public CoordinateWithBrightnessDifference(final PImage imgIn) {
        this.unsortedCoordinates = new ArrayList<PVector>();
        this.imgIn=imgIn;
    }
    
    public ArrayList<PVector> getPixelWithBrightnessDifference() {
        imgIn.loadPixels();
        int runFilter = 0;
        
        for(int x=1; x < width; x++) {
            for(int y=0; y < height; y++){
                int locPix = x + y*imgIn.width;
                color colorPix = imgIn.pixels[locPix];
                int locLeftPix = (x -1) + y*imgIn.width;
                color colorOfLeftNeighBour = imgIn.pixels[locLeftPix];
                float diffPix =abs(brightness(colorPix)- brightness(colorOftLeftNeighBour));
                if (diffPix > MIN_BRIGHTNESS) {
                    if (runFilter == FILTER_FACTOR) {
                        unsortedCoordinates.add(new PVector(x,y));
                        runFilter=0;
                    }
                    runFilter++;
                }
            }
        }
        return unsortedCoordinates;
    }
}

public class CoordinatePairs {
    private ArrayList<PVector> unsortedCo;
    private ArrayList<PVector> sortedCo;
    private int newSuitedIndex;
    private int lastIndexOfSortedCo;
    
    public CoordinatePairs(final ArrayList<PVector> unsortedCo) {
        this.unsortedCo = unsortedCo;
        this.sortedCo = new ArrayList();
        this.newSuitedIndex=0;
        this.lastIndexOfSortedCo =0;
        
    }
    
    public ArrayList<PVector> sortCoordinates() {
        this.sortedCo.add(this.unsortedCo.get(this.newSuitedIndex));
        this.unsortedCo.remove(this.newSuitedIndex);
        if (this.unsortedCo.size() !=1) {
            this.newSuitedIndex = findNextSuitedVector();
            this.sortCoordinates();
        }
        return this.sortedCo;
    }
    
    private int findNextSuitedVector() {
        this.lastIndexOfSortedCo = this.sortedCo.size()-1;
        int lengthOfUnsortedCo = this.unsortedCo.size();
        float allDistances[] = new float[lengthOfUnsortedCo];
        for(int i=0; i < unsortedCo.size(); i++) {
            float distance = distanceBetweenCo(this.sortedCo.get(this.lastIndexOfSortedCo), this.unsortedCo.get(i));
            allDistances[i]=distance;
        }
        int nextSuitedIndex = returnOfIndexMin(allDistances);
        return nextSuitedIndex;
    }
    
    private int returnOfIndexMin(final float distanceArray[]) {
        int index = 0;
        float minValu = min(distanceArray);
        for(int i=0; i < distanceArray.length; i++) {
            if (distanceArray[i] == minValu) {
                index=i;
                break;
            }
        }
        return index;
    }
    
    private float distanceBetweenCo(final PVector v1, final PVector v2) {
        float deltaX = abs(v1.x-v2.x);
        float deltaY = abs(v1.y-v2.y);
        float distanceBetweenV1V2 = pow(deltaX,2) + pow(deltaY,2);
        distanceBetweenV1V2 = sqrt(distanceBetweenV1V2);
        return distanceBetweenV1V2;
    }
}

PShape get2DShape(ArrayList<PVector> sortedCo) {
    PShape shape2D = createShape();
    shape2D.beginShape();
    shape2D.fillShape();
    for(int i=0; i < sortedCo.size(); i++) {
      shape2D.vertex(sortedCo.get(i).x - X_OFF, sortedCo.get(i).y - Y_OFF, Z_OFF);
    }
    shape2D.vertex(sortedCo.get(1).x -X_OFF, sorted.get(1).y - Y_OFF, Z_OFF);
    shape2D.endShape(CLOSE);
    return shape2D;
}

PShape extrudeShape(PShape before) {
   PShape after = createShape();
   after.beginShape(QUAD_STRIP);
   for(int i =0; i < before.getVertexCount(); i++) {
       float x = before.getVertexX(i);
       float y = before.getVertexY(i);
       after.vertex(x,y, Z_EXTRUDE);
       after.vertex(x,y, -Z_EXTRUDE);
   }
   after.endShape(CLOSE);
   return after;
}
