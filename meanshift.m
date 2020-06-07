function [ rowcenter colcenter M00 ] = meanshift(I, rmin, rmax, cmin, cmax, probmap)

    M00 = 0; 
    M10 = 0; 
    M01 = 0;
 rmin = round(rmin);
 rmax = round(rmax);
 cmin = round(cmin);
 cmax = round(cmax);
    % determine zeroth moment
    for c = cmin:cmax
        for r = rmin:rmax
            M00 = M00 + probmap(r, c);
        end
    end

      % determine first moment for x(col) and y(row)
    for c = cmin:cmax
        for r = rmin:rmax
            M10 = M10 + c*probmap(r,c);
            M01 = M01 + r*probmap(r,c);
        end
    end

    colcenter = M10/M00;
    rowcenter = M01/M00;
 
end
    
    
    