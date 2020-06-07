

imPath = 'E:\BaiduNetdiskDownload\OTB100\Box\img'; imExt = 'jpg'; %set picture file
%���ͼƬ�ļ�·���Ƿ����
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end
%����·���е��ļ�
filearray = dir([imPath filesep '*.' imExt]); % ��ȡĿ¼�������ļ�
NumImages = size(filearray,1); %ͼƬ����
if NumImages < 0
    error('No image in the directory');
end
disp('Loading image files from the video sequence, please be patient...');


%��ȡͼƬ����
imgname = [imPath filesep filearray(1).name]; %��ȡͼƬ��
myObj = VideoWriter('E:\BaiduNetdiskDownload\OTB100\Box\movie.avi');%write avi file
I = imread(imgname);
open(myObj);
writerObj.FrameRate = 60;%�޸�֡��
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; %��ȡͼƬ��
    frame = imread(imgname); %��������ͼƬ
    writeVideo(myObj,frame);
end
close(myObj);
disp('The video myObj has generated.');

