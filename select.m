function [ cmin, cmax, rmin, rmax ] = select( I )

    image(I);
    k = waitforbuttonpress;
    point1 = get(gca,'CurrentPoint');
    rectregion = rbbox;  
    point2 = get(gca,'CurrentPoint');
    point1 = point1(1,1:2);
    point2 = point2(1,1:2);
    lowerleft = min(point1, point2);
    upperright = max(point1, point2);
    
    cmin = round(lowerleft(1));
    cmax = round(upperright(1));
    rmin = round(lowerleft(2));
    rmax = round(upperright(2));

end