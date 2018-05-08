function [bz1,bz,bzPath,mainSpikePath,central_length,tassel_path,length_tassel]=findBZ(branch_points,skel,graph,tip)

bpMainSort=flipud(sortrows(branch_points));
[yskeBWOriginal,xskeBWOriginal] = find(skel);
bzPath=[];

tassel_path=[];
if (size(bpMainSort,1)>=2)
    
    % branching Zone 1
bp1NewID=find(yskeBWOriginal(:,1)==bpMainSort(1,1) &...
    xskeBWOriginal(:,1)==bpMainSort(1,2));
bp2NewID=find(yskeBWOriginal(:,1)==bpMainSort(2,1) &...
    xskeBWOriginal(:,1)==bpMainSort(2,2));
[distBZ1, pathBZ1, predBZ1]=graphshortestpath(graph,bp1NewID,bp2NewID);
bz1Path=[yskeBWOriginal(pathBZ1),xskeBWOriginal(pathBZ1)];
bz1 = size(bz1Path,1);
%%branching Zone 

bpEndNewID=find(yskeBWOriginal(:,1)==bpMainSort(end,1) &...
    xskeBWOriginal(:,1)==bpMainSort(end,2));
[distBZ, pathBZ, predBZ]=graphshortestpath(graph,bp1NewID,bpEndNewID);
bzPath=[yskeBWOriginal(pathBZ),xskeBWOriginal(pathBZ)];
bz = size(bzPath,1);

%%centralSpikeLength
[distMainLength, pathMainLength, predMainLength]=graphshortestpath(graph,bpEndNewID,tip);
mainSpikePath=[yskeBWOriginal(pathMainLength),xskeBWOriginal(pathMainLength)];
central_length = size(mainSpikePath,1);
[distBZ1, pathBZ1, predBZ1]=graphshortestpath(graph,bp1NewID,bp2NewID);

[dist_tassel_path, path_tassel_path, pred_tassel_path]=graphshortestpath(graph,bp1NewID,tip);
tassel_path = [yskeBWOriginal(path_tassel_path),xskeBWOriginal(path_tassel_path)];

elseif (size(bpMainSort,1)==1)
    bp1NewID=find(yskeBWOriginal(:,1)==bpMainSort(1,1) &...
    xskeBWOriginal(:,1)==bpMainSort(1,2));
    [distMainLength, pathMainLength, predMainLength]=graphshortestpath(graph,bp1NewID,tip);
    mainSpikePath=[yskeBWOriginal(pathMainLength),xskeBWOriginal(pathMainLength)];
    bz1=0;
    bz=0;
    tassel_path = mainSpikePath;
    
else
    bz1=0;
    bz=0;
    mainSpikePath = 0;
    tassel_path=[];

end
length_tassel = bz+size(mainSpikePath,1);
end
