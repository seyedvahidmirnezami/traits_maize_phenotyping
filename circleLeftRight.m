function [circleRatioLeft,circleRatioRight,circleRatioTop,circleRatio]=circleLeftRight(yCircle,xCircle,temp,thickness)
% pathCentralSub = [yskeBW(pathCentral),xskeBW(pathCentral)];
% pathCentralSubSort = sortrows(pathCentralSub);
% xCircle = pathCentralSubSort(end,2);
% yCircle = pathCentralSubSort(end,1);
% bpCentralSpike(picName,1:2)=[yCircle xCircle];
th = 0:0.0001:2*pi;
counterCircle=0;
for radiusIter=thickness:50:500
    try
        clear xunit yunit
        
        xunit = floor(radiusIter * cos(th) + xCircle);
        
        yunit = floor((radiusIter * sin(th) + yCircle));
        mat=[yunit',xunit'];
        
        [rCheckBottom, cCheckBottom] = find(mat(:,1)>yCircle+radiusIter);
        if (~isempty(rCheckBottom))
            for hh=1:size(rCheckBottom,1)
                mat(rCheckBottom(hh,1),cCheckBottom(hh,1))=yCircle+radiusIter;
            end
        end
        
        [rCheckTop, cCheckTop] = find(mat(:,1)<yCircle-radiusIter);
        if (~isempty(rCheckTop))
            for hh=1:size(rCheckTop,1)
                mat(rCheckTop(hh,1),cCheckTop(hh,1))=yCircle-radiusIter;
            end
        end
        
        [rCheckLeft, cCheckLeft] = find(mat(:,2)<xCircle-radiusIter);
        if (~isempty(rCheckLeft))
            for hh=1:size(rCheckLeft,1)
                mat(rCheckLeft(hh,1),cCheckLeft(hh,1))=xCircle-radiusIter;
            end
        end
        
        [rCheckRight, cCheckRight] = find(mat(:,2)>xCircle+radiusIter);
        if (~isempty(rCheckRight))
            for hh=1:size(rCheckRight,1)
                mat(rCheckRight(hh,1),cCheckRight(hh,1))=xCircle+radiusIter;
            end
        end
        matTemp = [];
        matTemp = mat;
        matTemp(mat(:,2)>xCircle,:)=[];
        areaCircleLeft=0;
        nnzCircleLeft=0;
        uu = [];
        uu = unique(matTemp(:,2));
        matTempUnique = sortrows(unique([matTemp(:,2) matTemp(:,1)],'rows'));
        for iterTemp=1:size(uu,1)
            [a,b] =find(matTempUnique(:,1)==uu(iterTemp,1));
            if (size(a,1)>=2)
                topPart = min(matTempUnique(a,2));
                bottomPart = max(matTempUnique(a,2));
                nnzCircleLeft = nnzCircleLeft+nnz(temp(topPart:bottomPart,uu(iterTemp,1 )));
                areaCircleLeft = areaCircleLeft + abs(bottomPart-topPart)+1;
            end
            
        end
        
        matTemp = [];
        matTemp = mat;
        matTemp(mat(:,2)<xCircle,:)=[];
        areaCircleRight=0;
        nnzCircleRight=0;
        nnzCircleTop=0;
        uu = [];
        uu = unique(matTemp(:,2));
        matTempUnique = sortrows(unique([matTemp(:,2) matTemp(:,1)],'rows'));
        for iterTemp=1:size(uu,1)
            [a,b] =find(matTempUnique(:,1)==uu(iterTemp,1));
            if (size(a,1)>=2)
                topPart = min(matTempUnique(a,2));
                bottomPart = max(matTempUnique(a,2));
                nnzCircleRight = nnzCircleRight+nnz(temp(topPart:bottomPart,uu(iterTemp,1 )));
                areaCircleRight = areaCircleRight + abs(bottomPart-topPart)+1;
            end
            
        end
        
        matTemp = [];
        matTemp = mat;
        matTemp(mat(:,1)>yCircle,:)=[];
        areaCircleTop=0;
        nnzCircleTop=0;
        uu = [];
        uu = unique(matTemp(:,1));
        matTempUnique = sortrows(unique([matTemp(:,1) matTemp(:,2)],'rows'));
        for iterTemp=1:size(uu,1)
            [a,b] =find(matTempUnique(:,1)==uu(iterTemp,1));
            if (size(a,1)>=2)
                leftPart = min(matTempUnique(a,2));
                RightPart = max(matTempUnique(a,2));
                nnzCircleTop = nnzCircleTop+nnz(temp(uu(iterTemp,1),leftPart:RightPart));
                areaCircleTop = areaCircleTop + abs(RightPart-leftPart)+1;
            end
            
        end
        
        
        counterCircle=counterCircle+1;
        circleRatioLeft(counterCircle,1) = nnzCircleLeft/areaCircleLeft;
        circleRatioRight(counterCircle,1) = nnzCircleRight/areaCircleRight;
        circleRatioTop(counterCircle,1) = nnzCircleTop/areaCircleTop;
        circleRatio(counterCircle,1) = (nnzCircleLeft+nnzCircleRight)/(areaCircleLeft+areaCircleRight);
    catch
        counterCircle=counterCircle+1;
        circleRatioLeft(counterCircle,1) =nan;
        circleRatioRight(counterCircle,1) =nan;
        circleRatioTop(counterCircle,1) =nan;
        circleRatio(counterCircle,1) =nan;
    end
end

end




% matTempUnique = sortrows(unique([matTemp(:,2) matTemp(:,1)],'rows'));
% for iterTemp=1:size(matTempUnique,1)
%     [a,b] =find(matTempUnique(:,2)==matTempUnique(iterTemp,2));
%     if (size(a,1)==2)
%         nnzCircle = nnzCircle+nnz(temp(matTempUnique(a(1),2):matTempUnique(a(2),2),matTempUnique(iterTemp,2)));
%     end
%     if (size(a,1)>2)
%         topPart = min(matTempUnique(a,2));
%         bottomPart = max(matTempUnique(a,2));
%         nnzCircle = nnzCircle+nnz(temp(topPart:bottomPart,matTempUnique(iterTemp,2)));
%     end
%
% end
%