#python3.8
import numpy as np
from moviepy.editor import *
from moviepy.video.fx import *
import os
import glob
## open video
## make shader
## discard to frames
## and than put frames back together
if input("Do you want to split the video into frames (y/n)?:") =="y":
    path=input("Please input the path:").replace("\/","\/\/").replace("\"","")

    print("the path is: ", path)
    p_out=path.split(".")
    p_out=p_out[0]+"_out_."+p_out[1]
    print("the path out is:", p_out)


    y_n=input("make video gray scale or invert color g/c")

    if y_n=="g":
        v_cl=VideoFileClip(path)###no valid argument
        print("after read in")
        v_cl=blackwhite.blackwhite(v_cl)
    elif y_n=="c":
        v_cl=VideoFileClip(path)
        print("after read in")
        v_cl=invert_colors.invert_colors(v_cl)

    make_resize=input("Please input the resize size e.g.:(1300,720): ")
    print("The resize factor is:", make_resize)
    v_cl.resize(eval(make_resize))
    print("before write out")

    v_cl.write_videofile(p_out)

    import time

    print("waiting until the file is generated")


    time.sleep(10)
    v1=VideoFileClip(p_out)
    duration=float(v1.duration)
    print("clip duration ", duration)
    p_out=p_out.split("\\")
    p_out="\\".join(p_out[:-1])
    p_out=p_out+"\\"
    print("path to save frame :", p_out)
    cl=[v1.save_frame(p_out+str(i)+".jpg", t=i) for i in np.arange(0, duration, 0.1)]

    all_pics=[ os.rename(pic,pic.split(".")[0]+"."+pic.split(".")[1][:1]+".jpg") for pic in glob.glob("*.jpg")]

if input("change name (y/n)")=="y":
    arr=glob.glob("*.jpg")
    arr_new_name=[os.rename(f,f.split(".jpg")[0]+"b.jpg") for f in arr]

if input("do you want to generate a video from pics(y/n)")=="y":
    arr_pics=glob.glob("*.jpg")
    print(arr_pics)
    clip=ImageSequenceClip(arr_pics, fps=10)
    try:
        clip.write_videofile(p_out+"zam.mp4")
    except:
        p_out=os.getcwd()
        clip.write_videofile(p_out+"\\zam.mp4")
    
fmt=input("Do you want to concatenate video clips. Please input the format y/n?")

clips=[]
if fmt!="":
    clips=glob.glob("*."+fmt)
    vc_clips=[VideoFileClip(f) for f in clips]
    p_out=os.getcwd()
    clip.write_videofile(p_out+"\\zam_zam_zam.mp4")
