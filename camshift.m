clear;
clc;


%% parameter
user_entry = input('Please enter an avi filename: ','s');
maxIterations = 60; % max mean shift iterations
dist_threshold = 2; % threshold of mean shift converge
increasePixel = 7;  % pixel increase by mean shift square each times

%% main
obj = VideoReader(user_entry);

frameTotal = obj.NumberOfFrames;


frame1 = read(obj, 1);
imshow(frame1);
 
% get search window for first frame
[ cmin, cmax, rmin, rmax ] = select( frame1 );
cmin = round(cmin);
cmax = round(cmax);
rmin = round(rmin);
rmax = round(rmax);
ccenter = round(cmax-cmin);
rcenter = round(rmax-rmin);

wsize(1) = abs(rmax - rmin);
wsize(2) = abs(cmax - cmin);
 


hsvimage = rgb2hsv(frame1);
huenorm = hsvimage(:,:,1);
hue = huenorm*255;

hue = uint8(hue);
 

% Getting Histogram of Image:
histogram = zeros(256);

for i=rmin:rmax
    for j=cmin:cmax
        index = uint8(hue(i,j)+1);  
             %count number of each pixel
        histogram(index) = histogram(index) + 1;
    end
end
 
% % create "tracking video.avi" and "backprojection video" "tracking video.avi" and "backprojection video"
avi_trackingVideo = VideoWriter('E:\360MoveData\Users\Administrator\Desktop\Meanshift的matlab代码\基于Meanshift的视频目标跟踪算法研究matlab代码 孙昊一\contrast\box_kalman.avi');





avi_backProjectionVideo = VideoWriter('backprojection video.avi');


% for each framemm
for i = 1:frameTotal 
    disp(['frame ' int2str(i) '/' int2str(frameTotal)]);
    
    thisFrame = read(obj,i);
     
     
    % translate to hsv
    hsvimage = rgb2hsv(thisFrame);
    hue = hsvimage(:,:,1);
    hue = hue * 255;
    hue = uint8(hue);
    
     
     
    [rows ,cols] = size(hue);
     % the search window is (cmin, rmin) to (cmax, rmax)
 
     
     
  % create a probability map
    probabilityMap = zeros(rows, cols);
    for r=1:rows
        for c=1:cols
            if(hue(r,c) ~= 0)
                probabilityMap(r,c)= histogram(hue(r,c));  
            end
        end 
    end
    probabilityMap = probabilityMap / max(max(probabilityMap));
    probabilityMap = probabilityMap * 255;
     
    count = 0;
     
    rowcenter = rcenter;
    colcenter = ccenter;
    rowcenterold = rcenter;
    colcenterold = ccenter;
    
    
    while (  (sqrt((rowcenter - rowcenterold)^2 + (colcenter - colcenterold)^2) > dist_threshold) || (count < maxIterations) )
        %increase window size and check for center
        rmin = rmin - increasePixel;  
        rmax = rmax + increasePixel;
        cmin = cmin - increasePixel;
        cmax = cmax + increasePixel;
        
        if rmin < 1
            rmin = 1;
        elseif rmax > obj.Height
            rmax = obj.Height;
        end
        
        if cmin < 1
            cmin = 1;
        elseif cmax > obj.Width
            cmax = obj.Width;
        end
        
         
        rowcenterold = rowcenter;
        colcenterold = colcenter;
        %**********Kalman Filter**********
        N=633; %Simulation time or total number of sequences
        %噪声
        Q=eye(4);%Process noise variance
        R=eye(2); %Observed noise variance
        W=sqrt(Q)*randn(4,N);
        V=sqrt(R)*randn(2,N);
        %Coefficient matrix
        A=[1 0 0.1 0;0 1 0 0.1;0 0 1 0;0 0 0 1;];%Coefficient matrix
        B=0;
        U=0;
        H=[1 0 0 0;0 1 0 0];%Observation matrix
        %initialization
        X=zeros(4,N);%Coordinate and velocity components（x,y,vx,vy）
        X_pre=zeros(4,N);
        X(:,1)=[rowcenterold,colcenterold,0,0]';%Initial displacement and velocity
        P0=1000000*eye(4);%Initial covariance
        Z=zeros(2,N);
        Z(:,1)=H*X(:,1);%Initial observation
        Xkf=zeros(4,N);
        Xkf(:,1)=X(:,1);
        I=eye(4); 
        k=2;
        X(:,k)=A*X(:,k-1)+B*U+W(k);
        Z(:,k)=H*X(:,k)+V(k);
        
        X_pre(:,k)=A*Xkf(:,k-1)+B*U;%State prediction
        X_pre_center= X_pre(1:2,k)';
        
        [ rowcenter ,colcenter, M00 ] = meanshift(thisFrame, rmin, rmax, cmin, cmax, probabilityMap);

        X_pre(:,k)=[rowcenter,colcenter,0,0]'; 
        Z(1,k)=rowcenter;%Give the value of meanshift processing to the observation value zk
        Z(2,k)=colcenter;
        P_pre=A*P0*A'+Q;%Covariance prediction
        Kg=P_pre*H'*inv(H*P_pre*H'+R);%Calculate Kalman gain
        Xkf(:,k)=X_pre(:,k)+Kg*(Z(:,k)-H*X_pre(:,k));%Status update
        l=1
        P0=1/l *(eye(4)-Kg*H)*P_pre;%Covariance update
        rowcenter=Xkf(1,k);
        colcenter=Xkf(2,k) ;
        % % redetermine window around new center
        rmin = round(rowcenter - wsize(1)/2);
        rmax = round(rowcenter + wsize(1)/2);
        cmin = round(colcenter - wsize(2)/2);
        cmax = round(colcenter + wsize(2)/2);
        
        % Prevent the search window from exceeding the image range
        if rmin < 1
            rmin = 1;
        elseif rmax > obj.Height
            rmax = obj.Height;
        end
        
        if cmin < 1
            cmin = 1;
        elseif cmax > obj.Width
            cmax = obj.Width;
        end
        
        wsize(1) = abs(rmax - rmin);
        wsize(2) = abs(cmax - cmin);
        %Record rect tracking results
        data_test(i,:)=[cmin,rmin,wsize(1),wsize(2)]
        count = count + 1;
    end
     
  

    

     %Write tracking target box in tracking video
     % Here a box with a width of two pixels is selected, in order to make the tracking effect more obvious
     % Set RGB
    R=0.933;
    G=0.375;
    B=0.375;
    thisFrame(rmin:rmax, cmin:cmin+1,1)=R;
    thisFrame(rmin:rmax, cmax-1:cmax,1)=R ;
    thisFrame(rmin:rmin+1, cmin:cmax,1)=R ;
    thisFrame(rmax-1:rmax, cmin:cmax,1)=R;
    
    
    thisFrame(rmin:rmax, cmin:cmin+1,2)=G;
    thisFrame(rmin:rmax, cmax-1:cmax,2)=G ;
    thisFrame(rmin:rmin+1, cmin:cmax,2)=G ;
    thisFrame(rmax-1:rmax, cmin:cmax,2)=G;

%     thisFrame(rmin:rmax, cmin:cmin+1,3)=B;
%     thisFrame(rmin:rmax, cmax-1:cmax,3)=B ;
%     thisFrame(rmin:rmin+1, cmin:cmax,3)=B ;
%     thisFrame(rmax-1:rmax, cmin:cmax,3)=B;
    imshow(thisFrame);
    open(avi_trackingVideo);
    writeVideo(avi_trackingVideo,thisFrame);
   
    % write backprojection
    
%     backProjectionFrame = zeros(obj.Height,obj.Width,3);
%     backProjectionFrame(:,:,3) = probabilityMap;
%     backProjectionFrame = hsv2rgb(backProjectionFrame)/255;
% 
%     open(avi_backProjectionVideo);
%     writeVideo(avi_backProjectionVideo,backProjectionFrame);
    
  
    % k =1.5 or k=2 or...
    windowsize = 1.5 * sqrt(M00/256);w
     
   % get side length ... window size is an area so sqrt(Area)=sidelength
    sidelength = windowsize;
    
 
    rmin = round(rowcenter-sidelength/2);
    rmax = round(rowcenter+sidelength/2);
    cmin = round(colcenter-sidelength/2);
    cmax = round(colcenter+sidelength/2);
    wsize(1) = abs(rmax - rmin);
    wsize(2) = abs(cmax - cmin);
    while(k<N)
        k=k+1;
    end
end

close(avi_trackingVideo);
% close(avi_backProjectionVideo);

