function [branch_points]=findBranchPoints(skel,graph,starting_point,long_path,WithoutLongestpath,entire_objects_with_endpoints,sendToBP)
bp=[];
long_path_sort=sortrows(long_path);
CC2 = bwconncomp(WithoutLongestpath);
for ObjectIter1=1:size(sendToBP,1)
    ObjectIter = sendToBP(ObjectIter1,2);
    NumoftestBranches = 1000;
    clear object yObject xObject primeObject xprimeObject yprimeObject
    object=zeros(size(WithoutLongestpath));
    object(CC2.PixelIdxList{1,ObjectIter}(:,1))=1;

    branchPointsALLObjectsOriginal{ObjectIter1,1}=object;
    counter=0;
    tempEndPoint = [];
    for pp=1:100
        
        clear Endpoints
        
        nn=bwmorph(object,'endpoints');
        [vv ww]=find(nn);
        
        Endpoints = [vv ww];
        
        Index=[];
        for interIter = floor(-counter/2):ceil(counter/2)
            clear checkinterRight checkinterLeft ibRight ibLeft
            checkinterRight=[vv ww+pp+interIter];
            checkinterRight1=[vv ww+pp+interIter+1];
            checkinterLeft=[vv ww-pp-interIter];
            checkinterLeft1=[vv ww-pp-interIter-1];
            [RightBranches,iaRight,ibRight]=intersect(long_path_sort,checkinterRight,'rows');
            [RightBranches1,iaRight1,ibRight1]=intersect(long_path_sort,checkinterRight1,'rows');
            [LeftBranches,iaLeft,ibLeft]=intersect(long_path_sort,checkinterLeft,'rows');
            [LeftBranches1,iaLeft1,ibLeft1]=intersect(long_path_sort,checkinterLeft1,'rows');
            Index=[Index;ibLeft;ibLeft1;ibRight;ibRight1];
        end
        
        [Branches,ia,ib]=intersect(long_path_sort,Endpoints,'rows');
        Index=[Index;ib];
        if ~isempty(Index)
            Endpointsib = Endpoints(Index,:);
            [Cib,iaib] = setdiff(Endpoints,Endpointsib,'rows');
            Endpoints(iaib,:)=[];
        end
        
        numofall(pp,1)=size(Endpoints,1);
        for kk=1:size(Endpoints,1)
            object(Endpoints(kk,1),Endpoints(kk,2))=0;
        end

        
        if (pp==1)
            tempEndPoint=Endpoints;
        else
            if size(Endpoints,1)>1
                [Idx,D]=knnsearch(tempEndPoint,Endpoints,'K',1);
                [Iddr,Iddc]=find (D>=2);
                Endpoints(Iddr,:)=[];
                
            end
        end
        if size(Endpoints,1)==1
            break;
            break;
            break;
        end
        
        counter=counter+1;
        clear tempEndPoint
        tempEndPoint = Endpoints;
        NumoftestBranches = size(Endpoints,1);
        
        
        
        CC = bwconncomp(object);
        if (CC.NumObjects >= sendToBP(ObjectIter1,1))
            numPixels = cellfun(@numel,CC.PixelIdxList);
            a = sort(numPixels(:));
            I_gray = bwareaopen(object, max(a));
            clear object
            object = I_gray;
            BW2= imfill(object,'holes');
            clear object
            object=bwmorph(BW2,'thin',inf);
        else
            break;
        end
        
        
    end
    
    bp=[bp;Endpoints,repmat(ObjectIter,size(Endpoints,1),1)];

end

[yskeBWOriginal,xskeBWOriginal] = find(skel);
skeBWOriginalPath = [yskeBWOriginal,xskeBWOriginal];
for iterBranchMain=1:size(bp)
    [yObject,xObject] = find(entire_objects_with_endpoints{bp(iterBranchMain,3),1});
    objectPath = [yObject,xObject];
    newBpID = knnsearch(objectPath,bp(iterBranchMain,1:2),'k',1);
    bpNew(iterBranchMain,:)=[yObject(newBpID),xObject(newBpID),bp(iterBranchMain,3)];
    bpNewID=find(yskeBWOriginal(:,1)==bpNew(iterBranchMain,1) &...
        xskeBWOriginal(:,1)==bpNew(iterBranchMain,2));
    [dist, path, pred]=graphshortestpath(graph,starting_point,bpNewID);
    pathBranch=[yskeBWOriginal(path),xskeBWOriginal(path)];
    [intersectedMainBranch,iaRight,ibRight]=intersect(long_path,pathBranch,'rows');
    intersectedMainBranchSorted=sortrows(intersectedMainBranch);
    
    newBpID = knnsearch(objectPath,intersectedMainBranchSorted(1,:),'k',1);
    bpMain(iterBranchMain,1:2) = [yObject(newBpID),xObject(newBpID)];
    bpMain(iterBranchMain,3)=bp(iterBranchMain,3);
end

% end
bp_sort=sortrows(bpMain);
branch_points=flipud(unique(bp_sort,'rows'));