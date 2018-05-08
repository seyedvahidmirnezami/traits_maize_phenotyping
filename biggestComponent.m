function [biggest] = biggestComponent(bw)
    CC = bwconncomp(bw);    
    numOfPixels = cellfun(@numel,CC.PixelIdxList);
    [unused,indexOfMax] = max(numOfPixels);
    biggest = zeros(size(bw));
    biggest(CC.PixelIdxList{indexOfMax}) = 1;
end
    