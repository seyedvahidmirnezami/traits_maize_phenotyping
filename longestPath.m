function [long_path,tip,graph]=longestPath(skel,starting_point)
[y,x] = find(skel);
Pt = [y x];

%find distance matrix between all these useful point
% [null] = Func_Diagnostic('Computing Distance Matrix...');
% waitbar(0.375,h,'Computing Distance Matrix..')
[IDX,D] = knnsearch(Pt,Pt,'K',10);

%removes self counting
D(:,1)= [];
IDX(:,1) = [];
%preallocates the distance matrix
DistMat = sparse(max(size(y)));
k = 0;

for i=1:size(y,1)
    %you are at node i
    
    %find neighbors ID
    NN = find( D(i,:) < 2);
    if NN == 1;
        %%change name
        leaf_ID(k+1) = IDX(i,NN);
        k = k+1;
    end
    NN_ID = IDX(i,NN);
    n_NN_ID = max(size(NN_ID));
    
    %find distance from NN_ID to i
    for j=1:n_NN_ID
        DistMat(i,NN_ID(j)) = D(i,NN(j));
        DistMat(NN_ID(j),i) = D(i,NN(j));
    end
end
% disp('Done.')


%finding closest start point to the coordinates the user has input
%after skeletonizing,since everything has become one pixel
% startpts = [max(size(skel)),min(size(skel))/2];
% startpts = round(startpts);
% [Istart,Dstart] = knnsearch(Pt,startpts, 'K',2);

%Locates all the leafs on the graph, and creates a shortest path from the
%start point to each leaf. Using this concept, the end point of the primary
%root can be located, by using the longest "shortest path" from the
%starting point to the leaf.
% [null] = Func_Diagnostic('Finding Longest Shortest Path...');
% waitbar(0.5,h,'Finding Best Path..')
max_length = max(size(leaf_ID));
dist = zeros(max_length,1); %preallocate memory for shortest distance of all leaf ids
for n = 1 : max_length
    [dist(n)]=graphshortestpath(DistMat,starting_point,leaf_ID(n));
end
%ID of the longest "shortest path"
n = find(dist == max(dist));
nn=n;
% disp('Done.')

%Outputs details of the shortest path.
[dist, path, pred]=graphshortestpath(DistMat,starting_point,leaf_ID(n(1)));


tip=leaf_ID(n(1));

pp1=x(path);
pp2=y(path);
long_path=[pp2 pp1];
graph = DistMat;
