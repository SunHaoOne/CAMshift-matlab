

imPath = 'E:\BaiduNetdiskDownload\OTB100\Box\img'; imExt = 'jpg'; %set picture file
%检查图片文件路径是否存在
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end
%载入路径中的文件
filearray = dir([imPath filesep '*.' imExt]); % 获取目录下所有文件
NumImages = size(filearray,1); %图片数量
if NumImages < 0
    error('No image in the directory');
end
disp('Loading image files from the video sequence, please be patient...');


%获取图片参数
imgname = [imPath filesep filearray(1).name]; %获取图片名
myObj = VideoWriter('E:\BaiduNetdiskDownload\OTB100\Box\movie.avi');%write avi file
I = imread(imgname);
open(myObj);
writerObj.FrameRate = 60;%修改帧率
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; %获取图片名
    frame = imread(imgname); %放入所有图片
    writeVideo(myObj,frame);
end
close(myObj);
disp('The video myObj has generated.');

