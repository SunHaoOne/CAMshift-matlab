# CAMshift-matlab
CAMshift is used for the target tracking,and we add the kalman filter to make the result more accurate
We use the TIGER in the OTB100,the main fuction is CAMshift.m

1.First use pic2video.m ,to create a video list(I have upload the movie.avi,so you can go to step 2,provided you get the picture sequence,you need to run pic2video.m)

2.Then open the CAMshift.m,meanshift.m and select.m

3.RUN IT!!!

4.Then you copy the video files,and after you seleting the areas,The result will generate in the files you set in the CAMshift.m.

5.finalcontrast.m This function provide the contrast between 2 algorithm ,each of the algorithm has to contrast with the ground truth.
  the ground truth contains 4 parameters,  （Upper left corner coordinates，Weight，Height）Provided you wanna make some anaylisis, here is the Precise plot and Success plot,and their errors curve.
 
6.The ground truth is related to the video in this file,and if you want to make contrast with the other algorithms, you need to change your data format as 5.
such as (101,55,33,44).

7.The picture in this file shows the contrast with the CAMshift+Kalman filter and CAMshift , you can remove the part of the kalman filter so that you can generate the result as it shows.

BTW,The matlab is 2016a，some fuctions in the early version may be not available.

You can see more details about CAMshift in https://blog.csdn.net/qwe900/article/details/105841154
and the more details about finalcontrast in https://blog.csdn.net/qwe900/article/details/106587322
