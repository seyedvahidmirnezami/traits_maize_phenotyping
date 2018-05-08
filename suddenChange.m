function [onePulse,curve] = suddenChange(pathEachBoth)
diff=[];
stepSize = 200;
curve=0;

for part=1:100:size(pathEachBoth,1)-200
    
    smoothPath = smoothdata(pathEachBoth(part:part+stepSize,:),'sgolay','SmoothingFactor',1);
    hold on
    scatter(smoothPath(:,2),smoothPath(:,1),'.r')
    p1 = smoothPath(1,:);
    p2 = smoothPath(floor(size(smoothPath,1)/2),:);
    p3 = smoothPath(end,:);
    
    y12= p1(1,1)-p2(1,1); x12  = p1(1,2)-p2(1,2);
    y32 = p3(1,1)-p2(1,1); x32 = p3(1,2)-p2(1,2);
    
    
    ang = (atan2(abs(x12*y32-x32*y12),x12*x32+y12*y32))*180/pi;  % <-- The angle
    if part==1
        checkAngle=ang;
    else
        diff=[diff;abs(checkAngle-ang)];
        if (abs(checkAngle-ang))>45 & (abs(checkAngle-ang))<150
            curve = 1;
        end
        checkAngle=ang;
        
    end
end
onePulse=0;
checkDiff = diff(diff>30 & diff<150);
if curve==1 & ~isempty(checkDiff)
    if size(checkDiff,1)>1
        onePulse=2;
    else
        onePulse=1;
    end
end
if curve==0 & ~isempty(checkDiff)
    
    curve=1;
    if size(checkDiff,1)>1
        onePulse=2;
    else
        onePulse=1;
    end
end



end