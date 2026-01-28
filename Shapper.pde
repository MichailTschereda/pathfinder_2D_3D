//int Z_OFF,Y_OFF, X_OFF;
int Z_OFF=1;
int Y_OFF=1;
int X_OFF=1;
int Z_EXTRUDE=12;
PImage face;
String path="C:\\Users\\Dell\\Documents\\Processing\\Shapper\\frames\\";
String patho="C:\\Users\\Dell\\Documents\\Processing\\Shapper\\frames\\fr\\";
public ArrayList<PVector> aar_vektor;
public PShape sh;
public float INDEX=109.0;

void setup() {
  size(1920, 1080);
  //for(float i =0.0; i<44.0;i=i+0.1) {
  
  
  //saveFrame(patho+str(0.0)+".jpg");
  //}
  //shape = get2DShape(aar_vektor);
    start_ping();
}

void start_ping() {
  //image(face,0,0);
   //sh = get2DShape(aar_vektor);
   
   for(float i =0.0; i<INDEX;i+=0.1) {
     try {
         i=round(i*10)/10.0;
         System.out.println(i);
         sh=returnVectorShape(i);
         shape(sh,0,0);
         saveFrame(patho+str(i)+".jpg");
         exit();
     } catch (Exception e) {
       continue;
     }
       
   }
   
}

PShape returnVectorShape(float idx) {
  face = loadImage(path+str(idx)+".jpg");
  CoordinateWithBrightnessDifference coorDiff = new CoordinateWithBrightnessDifference(face);
  ArrayList<PVector> aa_list= coorDiff.getPixelWithBrightnessDifference();
  CoordinatePairs cp_pairs = new CoordinatePairs(aa_list);
  aar_vektor = cp_pairs.sortCoordinates();
  //System.out.println(aar_vektor);
  sh = get2DShape(aar_vektor);
  return sh;
}



public class CoordinateWithBrightnessDifference {

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
                float diffPix =abs(brightness(colorPix)- brightness(colorOfLeftNeighBour));
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

PShape get2DShape(ArrayList <PVector> sortedCo) {
    PShape shape2D = createShape();
    shape2D.beginShape();
    shape2D.fill(random(0,255));
    for(int i=0; i < sortedCo.size(); i++) {
      shape2D.vertex(sortedCo.get(i).x - X_OFF, sortedCo.get(i).y - Y_OFF, Z_OFF);
    }
    shape2D.vertex(sortedCo.get(1).x -X_OFF, sortedCo.get(1).y - Y_OFF, Z_OFF);
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
