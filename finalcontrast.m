data=importdata('E:\BaiduNetdiskDownload\OTB100\Tiger1\groundtruth_rect.txt')
%data_test =CAM+KALMAN
%data_old =CAM
 sub=data-data_test
 subold=data-data_old
 %sub =GROUND TRUTH -(CAM+KALMAN) 
 %subold =GROUND TRUTH - CAM
 frame=254
 interval=51
 c(interval)=0;
 d(interval)=0;
 e(interval)=0
 f(interval)=0

 error_threshold=(0:2:100)
 overlap_threshold=(0:0.02:1)
 %Count the number of frames that meet the error threshold conditions
 for i=1:frame
    for j=1:interval
        if abs(sub(i,1))<error_threshold(j) & abs(sub(i,2))<error_threshold(j)
            c(j)=c(j)+1
        end
        if abs(subold(i,1))<error_threshold(j) & abs(subold(i,2))<error_threshold(j)
           d(j)=d(j)+1
        end
    end
end
for j=1:interval
c(j)=c(j)/frame
d(j)=d(j)/frame
end
 %Count the number of frames that meet the overloop threshold conditions
 for i=1:frame
   
   %data_old =CAM
    x1(i)=data_old(i,1)
    y1(i)=data_old(i,2)
    w1(i)=data_old(i,3)
    h1(i)=data_old(i,4)
    
   %data_test =CAM+KALMAN
    x2(i)=data_test(i,1)
    y2(i)=data_test(i,2)
    w2(i)=data_test(i,3)
    h2(i)=data_test(i,4)
   %data_old =GROUND TRUTH
    x3(i)=data(i,1)
    y3(i)=data(i,2)
    w3(i)=data(i,3)
    h3(i)=data(i,4)
    
   %caculate CAM or GROUNDTRUTH
    area_or1=(w1(i)-abs(x1(i)-x3(i)))*(h1(i)-abs(y1(i)-y3(i)))
    area_and1=w1(i)*h1(i)-area_or1
    overlap_score1=area_or1/area_and1
    
   %caculate CAM+KALMAN or GROUNDTRUTH
    area_or2=(w2(i)-abs(x2(i)-x3(i)))*(h2(i)-abs(y2(i)-y3(i)))
    area_and2=w2(i)*h2(i)-area_or2
    overlap_score2=area_or2/area_and2
    
    for j=1:interval
    if overlap_score1>overlap_threshold(j)
        e(j)=e(j)+1
    end
     if overlap_score2>overlap_threshold(j)
        f(j)=f(j)+1
    end
    end
        
end
for j=1:interval
e(j)=e(j)/frame
f(j)=f(j)/frame
end
% subplot(2,2,1)
% plot(error_threshold,c,'r')
% xlabel('Location error threshold')
% ylabel('Precision')
% hold on
% plot(error_threshold,d,'b')
% 
% subplot(2,2,2)
% plot(error_threshold,(c-d),'g')
% xlabel('Location error threshold')
% ylabel('error')

subplot(1,2,1)
plot(overlap_threshold,e,'r')
xlabel('Overlap threshold')
ylabel('Success ')
hold on
plot(overlap_threshold,f,'b')

subplot(1,2,2)
plot(overlap_threshold,(e-f),'g')
xlabel('Overlap error threshold')
ylabel('error')
