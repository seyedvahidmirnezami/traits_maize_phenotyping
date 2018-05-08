function [path_branch,length]=branchLength(branch_points,end_points,entire_objects_with_endpoints,starting_point,skel,num)

if ~isempty(branch_points)
    if ~isempty(end_points)
        if size(branch_points,1)>=num
            iterObjectPath=num;
            
            %%%%%%% here you select on branch point and find its object
            %%%%%%% and you will go with only that branch point but
            %%%%%%% there might be another branch points in that object
            try
                [checkObjectNumber,~] = find(end_points(:,3)==branch_points(iterObjectPath,3));
                pp2 = end_points(checkObjectNumber(1,1),4);
                tempEnd=end_points(checkObjectNumber,:);
                object=entire_objects_with_endpoints{branch_points(iterObjectPath,3),1};
            catch
                tempEnd = end_points;
                object=skel;
            end
            for iterOne=1:size(branch_points)
                object(branch_points(iterOne,1),branch_points(iterOne,2))=1;
            end
            [yObject,xObject]=find(object);
            
            
            %%%%%% Hre you just look at the updated object
            [DistMatObject]=FourthFindGraph(object);
            
            if (size(tempEnd,1)==1)
                
                startTempBranch = find(yObject(:,1)==branch_points(iterObjectPath,1) &...
                    xObject(:,1)==branch_points(iterObjectPath,2));
                
                startTempEnd = find(yObject(:,1)==tempEnd(1,1) &...
                    xObject(:,1)==tempEnd(1,2));
                [distEach, pathEach, predEach]=graphshortestpath(DistMatObject,startTempEnd,startTempBranch);
                pathCheckEach=[yObject(pathEach),xObject(pathEach)];
                path_branch=pathCheckEach;
                index=1;
            elseif (size(tempEnd,1)>1)
                
                tempEnd2=tempEnd;
                tempEnd(abs(tempEnd(:,2)-starting_point(1,2))<200,:)=[];
                if isempty(tempEnd)
                    tempEnd=tempEnd2;
                end
                startTempBranch = find(yObject(:,1)==branch_points(iterObjectPath,1) &...
                    xObject(:,1)==branch_points(iterObjectPath,2));
                
                curveFinalPaths = [];
                error=[];
                
                for iterCheckEnd=1:size(tempEnd,1)
                    startTempEnd = find(yObject(:,1)==tempEnd(iterCheckEnd,1) &...
                        xObject(:,1)==tempEnd(iterCheckEnd,2));
                    distEach=[];
                    pathEach=[];
                    predEach=[];
                    pathEachBoth=[];
                    [distEach, pathEach, predEach]=graphshortestpath(DistMatObject,startTempBranch,startTempEnd);
                    pathEachBoth=[yObject(pathEach),xObject(pathEach)];
                    curve = [];
                    %                                 scatter(pathEachBoth(:,2),pathEachBoth(:,1),'*b','LineWidth',5)
                    [onePulse,curve] = suddenChange(pathEachBoth);
                    curveFinalPaths=[curveFinalPaths;iterCheckEnd curve onePulse size(pathEachBoth,1)+tempEnd(iterCheckEnd,4)];
                    %                 error=[error;error_ellipse(pathEachBoth)];
                end
                
                
                curveFinalPathsCurve = curveFinalPaths(curveFinalPaths(:,2)==0,:);
                if isempty(curveFinalPathsCurve)
                    curveFinalPathsCurve = curveFinalPaths(curveFinalPaths(:,3)==0,:);
                    
                    if isempty(curveFinalPathsCurve)
                        curveFinalPathsCurve = curveFinalPaths(curveFinalPaths(:,3)==1,:);
                        
                        if isempty(curveFinalPathsCurve)
                            curveFinalPathsSorted = sortrows(curveFinalPaths,4,'descend');
                            index = curveFinalPathsSorted(1,1);
                        else
                            curveFinalPathsSorted = sortrows(curveFinalPathsCurve,4,'descend');
                            index = curveFinalPathsSorted(1,1);
                        end
                        
                    else
                        curveFinalPathsSorted = sortrows(curveFinalPathsCurve,4,'descend');
                        index = curveFinalPathsSorted(1,1);
                    end
                    
                else
                    curveFinalPathsSorted = sortrows(curveFinalPathsCurve,4,'descend');
                    index = curveFinalPathsSorted(1,1);
                end
                
                startTempEnd = find(yObject(:,1)==tempEnd(index,1) &...
                    xObject(:,1)==tempEnd(index,2));
                
                [distEach, pathEach, predEach]=graphshortestpath(DistMatObject,startTempBranch,startTempEnd);
                pathEachBoth=[yObject(pathEach),xObject(pathEach)];
                path_branch=pathEachBoth;
                
            end
            length = size(path_branch,1)+tempEnd(index,4);
        else
            length = 0;
        end
    else
        length = 0;
    end
else
    length = 0;
end





