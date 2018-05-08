function [first_angle,second_angle] = angleForTwoPaths(first_path,second_path,tassel_path)

if isempty(first_path)
    first_angle = -2;
end

if isempty(second_path)
    second_angle = -2;
end
stepValue=3;
if ~isempty(first_path)
    
    tassel_pathSorted=flipud(sortrows(tassel_path));
    step1=floor((size(first_path,1))/stepValue);
    step2=floor((size(tassel_pathSorted,1))/stepValue);
    
    idx1 = knnsearch(first_path,tassel_pathSorted(1,:),'k',1);
    if idx1>size(first_path,1)/2
        first_path = flipud(first_path);
    end
    
    p1=first_path(step1,:);
    
    p2=tassel_pathSorted(1,:);
    p3=tassel_pathSorted(step2,:);
    
    y12= p1(1,1)-p2(1,1); x12  = p1(1,2)-p2(1,2);
    y32 = p3(1,1)-p2(1,1); x32 = p3(1,2)-p2(1,2);
    
    
    first_angle = (atan2(abs(x12*y32-x32*y12),x12*x32+y12*y32))*180/pi;
    
    
    
    
end
if ~isempty(second_path)
    tassel_pathSorted=flipud(sortrows(tassel_path));
    idx1 = knnsearch(second_path,tassel_pathSorted(1,:),'k',1);
    if idx1>size(first_path,1)/2
        second_path = flipud(second_path);
    end
    
 
    
    idx2 = knnsearch(tassel_path,second_path(1,:),'k',1);
    pathsecond_anglePath = [tassel_path(idx2:end,1) tassel_path(idx2:end,2)];

    step1=floor((size(second_path,1))/stepValue);
    step2=floor((size(pathsecond_anglePath,1))/stepValue);
    
    
    p1=second_path(step1,:);
    p2=tassel_path(idx2,:);
    p3=pathsecond_anglePath(step2,:);
    
    y12= p1(1,1)-p2(1,1); x12  = p1(1,2)-p2(1,2);
    y32 = p3(1,1)-p2(1,1); x32 = p3(1,2)-p2(1,2);
    
    
    second_angle = (atan2(abs(x12*y32-x32*y12),x12*x32+y12*y32))*180/pi;
    
    
    
    
    
end

% end