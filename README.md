# CAMshift-matlab
CAMshift is used for the target tracking,and we add the kalman filter to make the result more accurate
We use the TIGER in the OTB100,the main fuction is CAMshift.m
1.First use pic2video.m ,to create a video fist
2.Then open the CAMshift.m,meanshift.m and select.m
3.RUN IT!!!
4.Then you copy the video files,and after you seleting the areas,The result will generate in the files you set in the CAMshift.m.

Provided you wanna make some anaylisis, here is the Precise plot and Success plot,and their errors curve.


5.finalcontrast.m This function provide the contrast between 2 algorithm ,each of the algorithm has to contrast with the ground truth.
  the ground truth contains 4 parameters,  （Upper left corner coordinates，Weight，Height）

BTW,The matlab is 2016a，some fuctions in the early version may be not available.
