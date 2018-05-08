function [] = savePlot(image,images_folder,result_path,branching_zone_path,central_path,tassel_path,first_path,...
    second_path,picName)


h=figure;
set(h, 'Visible', 'off');
subplot(1,2,1)
imshow(image)
subplot(1,2,2)
imshow(image)
hold on

scatter(first_path(:,2),first_path(:,1),'*b','LineWidth',2)

scatter(second_path(:,2),second_path(:,1),'*r','LineWidth',2)

scatter(tassel_path(:,2),tassel_path(:,1),'*k','LineWidth',2)

scatter(central_path(:,2),central_path(:,1),'*y','LineWidth',2)

scatter(branching_zone_path(:,2),branching_zone_path(:,1),'*g','LineWidth',2)


saveas(h,strcat(result_path,'/path/',strcat(strtok(images_folder(picName).name,'.JPG'),'.jpg')));

end