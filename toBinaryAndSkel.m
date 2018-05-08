function [thickness,binary,skel,starting_point,yellow_minor,yellow_rotation]=toBinaryAndSkel(image)
knnImage=knnRB(image,2);
temp=knnImage(:,:,1);
binary=logical(temp);

[ytempLogicalMain,xtempLogicalMain]=find(binary);
yellow_bw = (image(:,:,1) >= 240) & (image(:,:,2)>190 & (image(:,:,3)<100));

[yellow_bw_biggest] = biggestComponent(yellow_bw);
yellow_width_main=regionprops(yellow_bw_biggest,'MinorAxisLength','Orientation');
yellow_minor=yellow_width_main.MinorAxisLength(1,1);

if (yellow_width_main.Orientation < 0)
    angle_rotatation = -(yellow_width_main.Orientation + 90);
else
    angle_rotatation =  90-yellow_width_main.Orientation;
end
yellow_bw_rotated = imrotate(yellow_bw_biggest,angle_rotatation);
[~,xYellowBW2]=find(yellow_bw_rotated);
yellow_rotation = max(xYellowBW2(:,1)) - min(xYellowBW2(:,1));

red_bW = (image(:,:,1) >= 230) & (image(:,:,2)<50 & (image(:,:,3)<50));
[red_bw_biggest] = biggestComponent(red_bW);
[yRedBW,xRedBW]=find(red_bw_biggest);
point=[max(yRedBW) min(xRedBW)+(max(xRedBW)-min(xRedBW))/2];

                            
                            
[aThick,~]=find(ytempLogicalMain==min(yRedBW)-20 & (xtempLogicalMain>=min(xRedBW)& xtempLogicalMain<=max(xRedBW)));
thickness = max(xtempLogicalMain(aThick))-min(xtempLogicalMain(aThick));

bw = im2uint8(binary);
skel=bwmorph(bw,'thin',inf);
[y_skel,x_skel]=find(skel);
pointId = knnsearch([y_skel,x_skel],point,'k',1);
starting_point=[point pointId];

end