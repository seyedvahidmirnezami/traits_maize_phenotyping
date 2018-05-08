function [end_points,entire_objects_with_endpoints,WithoutLongestpath,sendToBP]=findEndPoints(skel,long_path)
sendToBP=[];
for i=1:size(long_path,1)
    skel(long_path(i,1),long_path(i,2))=0;
end
end_points=[];
hyper = floor(nnz(skel)/15);
WithoutLongestpath=bwareaopen(skel,hyper);
CC2 = bwconncomp(WithoutLongestpath);
Ep=[];

for ObjectIter=1:CC2.NumObjects
    
    object=zeros(size(WithoutLongestpath));
    object(CC2.PixelIdxList{1,ObjectIter}(:,1))=1;
    
    entire_objects_with_endpoints{ObjectIter,1}=object;
    
    
    ObjectForEp=object;
    Endpoints=[];
    for pp=1:200
        BW2=[];
        BW2= imfill(ObjectForEp,'holes');
        
        ObjectForEp=bwmorph(BW2,'thin',inf);
        nn=bwmorph(ObjectForEp,'endpoints');
        [vv,ww]=find(nn);
        
        
        LastEndpoints=Endpoints;
        
        Endpoints = [vv ww];
        EndpointsCheckLeft=[vv(:,1) ww(:,1)-1];
        EndpointsCheckRight=[vv(:,1) ww(:,1)+1;];
        [intersectedBranchPointsMain,iaMain,ibMain]=intersect(long_path,Endpoints,'rows');
        [intersectedBranchPointsLeft,iaLeft,ibLeft]=intersect(long_path,EndpointsCheckLeft,'rows');
        [intersectedBranchPointsRight,iaRight,ibRight]=intersect(long_path,EndpointsCheckRight,'rows');
        index=[ibMain;ibLeft;ibRight];
        if (~isempty(index))
            Endpoints(index,:)=[];
        end
        linearInd = sub2ind(size(WithoutLongestpath),Endpoints(:,1),Endpoints(:,2));
        ObjectForEp(linearInd)=0;
        if (isempty(linearInd))
            Endpoints=LastEndpoints;
            break;
        end
    end
    sendToBP =[sendToBP; size(Endpoints,1) ObjectIter];
    Ep=Endpoints;
    EpMain = [];
    for iterEndMain=1:size(Ep)
        [yObject,xObject] = find(entire_objects_with_endpoints{ObjectIter,1});
        objectPath = [yObject,xObject];
        newBpID = knnsearch(objectPath,Ep(iterEndMain,1:2),'k',1);
        EpMain=[EpMain;yObject(newBpID),xObject(newBpID)];
    end
    
    
    entire_objects_with_endpoints{ObjectIter,2}=EpMain;
end_points=[end_points;EpMain repmat(ObjectIter,size(EpMain,1),1) repmat(pp,size(EpMain,1),1)];
end

