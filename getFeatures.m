function [centralAreaDensityTemp,circleDensityVarTemp]=getFeatures(branch_points,binary,thickness,bzPath)

centralAreaDensityTemp=[];
bpMainSort=flipud(sortrows(branch_points));


if (size(bpMainSort,1)>=2)
    if ~isempty(bzPath)
        
        counterArea = 0;
        for hyperArea=thickness:50:500
            counterArea=counterArea+1;
            areaAroundCentral = 2 * hyperArea * size(bzPath,1);
            pathCentralLeft = [bzPath(:,1) bzPath(:,2)-hyperArea];
            pathCentralRight = [bzPath(:,1) bzPath(:,2)+hyperArea];
            
            nnzInCentralArea = 0;
            for iterNNZ = 1:size(bzPath,1)
                nnzInCentralArea=nnzInCentralArea+nnz(binary(pathCentralRight(iterNNZ,1),...
                    pathCentralLeft(iterNNZ,2):pathCentralRight(iterNNZ,2)));
            end
            centralAreaDensityTemp(1,counterArea) = nnzInCentralArea/areaAroundCentral;
        end
    else
        
        centralAreaDensityTemp(1,1:17) = repmat(-17,1,17);
    end
    
elseif (size(bpMainSort,1)==1)
    centralAreaDensityTemp(1,1:17) = repmat(-17,1,17);
else
    centralAreaDensityTemp(picName,1:17) = repmat(-17,1,17);
    
end

if ~isempty(branch_points)
    xCircle = branch_points(end,2);
    yCircle = branch_points(end,1);
    [circleRatioLeft,circleRatioRight,circleRatioTop,circleRatio]=circleLeftRight(yCircle,xCircle,binary,thickness);
    circleDensityVarTemp = [circleRatioLeft circleRatioRight circleRatioTop circleRatio];
    
else
    circleDensityVarTemp = [];
end







end
