% clear all
function []=main5(str)
str='Agronomy';

changeDefaultWorkers(10);
images_folder = dir(strcat(pwd,'/',str,'/*.JPG'));

result_path=strcat(pwd,'/result',str);
mkdir(result_path,'matFiles')
mkdir(result_path,'path')
mkdir(result_path,'matFilesForChecking')

firstIter=1;
secondIter=length(images_folder);
catchName=[];
parfor picName = firstIter:secondIter
    picName
    disp('initialization ...')
    [first_length,second_length,first_angle,second_angle,length_tassel,central_length,branching_zone,branching_zone1,...
        circleDensityVarTemp,centralAreaDensityTemp1,centralAreaDensityTemp2]=initialization();
    
    image = imread(strcat(pwd,'/',str,'/',images_folder(picName).name));
    matching_name{picName,1}={images_folder(picName).name};
    try
        [thickness,binary,skel,starting_point,yellow_minor,yellow_rotation]=toBinaryAndSkel(image);
        
        [long_path,tip,graph]=longestPath(skel,starting_point(1,3));
        disp('looking for endpoints ...')
        
        [end_points,entire_objects_with_endpoints,WithoutLongestpath,sendToBP]=findEndPoints(skel,long_path);
        disp('looking for branch points ...')
        
        [branch_points]=findBranchPoints(skel,graph,starting_point(1,3),long_path,WithoutLongestpath,entire_objects_with_endpoints,sendToBP);
        disp('extracting the traits. ..')
        
        [branching_zone1,branching_zone,branching_zone_path,central_path,central_length,tassel_path,length_tassel]=findBZ(branch_points,skel,graph,tip);
        
        [centralAreaDensityTemp,circleDensityVarTemp]=getFeatures(branch_points,binary,thickness,branching_zone_path);
        
        [first_path,first_length]=branchLength(branch_points,end_points,entire_objects_with_endpoints,starting_point,skel,1);
        
        [second_path,second_length]=branchLength(branch_points,end_points,entire_objects_with_endpoints,starting_point,skel,2);
        
        [first_angle,second_angle] = angleForTwoPaths(first_path,second_path,tassel_path);
        
        disp('saving ...')
        parSave(result_path,picName,images_folder,thickness,binary,skel,starting_point,yellow_minor,...
            yellow_rotation,long_path,tip,graph,end_points,entire_objects_with_endpoints,WithoutLongestpath,sendToBP,...
            branch_points,branching_zone1,branching_zone,branching_zone_path,central_path,central_length,tassel_path,...
            length_tassel,centralAreaDensityTemp,circleDensityVarTemp,first_path,first_length,second_path,second_length,...
            first_angle,second_angle);
        
        flbl{picName,1} = first_length;
        slbl{picName,1} = second_length;
        flba{picName,1} = first_angle;
        slba{picName,1} = second_angle;
        tassel{picName,1} = length_tassel;
        central{picName,1} = central_length;
        zone{picName,1} = branching_zone;
        zone1{picName,1} = branching_zone1;
        circle{picName,1} = circleDensityVarTemp(end,4);
        center1{picName,1} = centralAreaDensityTemp(1,1);
        center2{picName,1} = centralAreaDensityTemp(1,2);
	num_branches{picName,1} = size(end_points,1);
        yellow{picName,1} = yellow_minor;
        
        disp('plots ...')
        savePlot(image,images_folder,result_path,branching_zone_path,central_path,tassel_path,first_path,...
            second_path,picName)
    catch
        flbl{picName,1} = -1;
        slbl{picName,1} = -1;
        flba{picName,1} = -1;
        slba{picName,1} = -1;
        tassel{picName,1} = -1;
        central{picName,1} = -1;
        zone{picName,1} = -1;
        zone1{picName,1} = -1;
        circle{picName,1} = -1;
        center1{picName,1} = -1;
        center2{picName,1} = -1;
        num_branches{picName,1} = -1;
        yellow{picName,1} = -1;
        catchName = [catchName;picName];
    end
end
result_table = [cell2table(matching_name) cell2table(flbl) cell2table(slbl) cell2table(flba) cell2table(slba) cell2table(tassel)...
    cell2table(central) cell2table(zone) cell2table(zone1) cell2table(circle) cell2table(center1) cell2table(center2) cell2table(num_branches) cell2table(yellow)];
[~,today]=fileparts(pwd);
save(strcat(result_path,'/matFilesForChecking/',today,'.mat'),'result_table');

end
