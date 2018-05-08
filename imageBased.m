clear all;
names = [725;726;727;728;730;731;801;802;804;806;809;811;815;818;822;830;908];
resultTraitsTableAll=[];
charityPath = '/ptmp/baskargroup/vahid/2017LightBox/lightBox10192017/correctFiles';
filesPath = '/ptmp/baskargroup/vahid/2017LightBox/lightBox10192017';
mkdir(pwd,'BZandTasselLength')
mkdir(pwd,'firstBranch')
mkdir(pwd,'secondBranch')
for j=1:size(names,1)
    j
    clearvars -except names j
    parentFol = dir(strcat(pwd,'/MatFiles_','0',num2str(names(j,1)),'2017/*.mat'));
    
    imgs = strcat(filesPath,'/',num2str(names(j,1)),'2017/');
    catchi = [];
    for i = 1:length(parentFol)
%         try
            i
            clearvars -except i parentFol imgs catchi names j
            
            load(strcat(charityPath,'/MatFiles_','0',num2str(names(j,1)),'2017/',parentFol(i).name));
            load(strcat(imgs,'matFilesForChecking/',parentFol(i).name));
            I = imread(strcat(imgs,'Agronomy/',parentFol(i).name(1,12:end-4),'.JPG'));
            
            
            [DistMat]=FourthFindGraph(WithoutLongestpath);
            [row,col] = find(WithoutLongestpath);
            SkeBwPoints = [row,col];
            
            selectedPoints = [bp1(1,:);ep1(1,:);bp2(1,:);ep2(1,:);bp3(1,:);ep3(1,:)];
            
            [IDX,D] = knnsearch(SkeBwPoints,selectedPoints);  % finds the nearest neighbor in X for each point in Y.
            
            [dist1, firstPathIDX, pred1]=graphshortestpath(DistMat,IDX(1,1),IDX(2,1));
            
            [dist2, secondPathIDX, pred2]=graphshortestpath(DistMat,IDX(3,1),IDX(4,1));
            
            [dist3, centralSpikePathIDX, pred3]=graphshortestpath(DistMat,IDX(5,1),IDX(6,1));
            
            [dist4, tasselPathIDX, pred4]=graphshortestpath(DistMat,IDX(1,1),IDX(6,1));
            
            [dist5, bsPathIDX, pred5]=graphshortestpath(DistMat,IDX(1,1),IDX(3,1));
            
            firstLowestBranchPath = [row(firstPathIDX),col(firstPathIDX)];
            secondLowestBranchPath = [row(secondPathIDX),col(secondPathIDX)];
            centralSpikePath = [row(centralSpikePathIDX),col(centralSpikePathIDX)];
            tasselPath = [row(tasselPathIDX),col(tasselPathIDX)];
            branchingSpacePath = [row(bsPathIDX),col(bsPathIDX)];
            
            [angle1,angle2] = angleForTwoPaths(firstLowestBranchPath,secondLowestBranchPath,tasselPath);
            
            resultTraits={};
            
            resultTraits{1,1}=strcat(parentFol(i).name(1,12:end-4),'.JPG');
            resultTraits{1,2}=size(tasselPath,1);
            resultTraits{1,3}=size(centralSpikePath,1);
            resultTraits{1,4}=size(tasselPath,1) - size(centralSpikePath,1);
            resultTraits{1,5}=size(branchingSpacePath,1);
            resultTraits{1,6}=size(firstLowestBranchPath,1);
            resultTraits{1,7}=size(secondLowestBranchPath,1);
            resultTraits{1,8}=angle1;
            resultTraits{1,9}=angle2;
            resultTraits{1,10}=yellow_minor;
            resultTraitsTable = cell2table(resultTraits);
            
            resultTraitsTable.Properties.VariableNames = {'Name','tasselLength','CentralSpike','branchingZone',...
                'BranchingSpace1','LengthofBranch1','LengthofBranch2','AngleofBranch1','AngleofBranch2','yellow'};
            resultTraitsTableAll = [resultTraitsTableAll;resultTraitsTable];
            
            close all
            h=figure;
            set(h, 'Visible', 'off');
            subplot(1,2,1)  
            imshow(I)
            hold on
            scatter(tasselPath(:,2),tasselPath(:,1),'*y','LineWidth',2)
        
            subplot(1,2,1)        
            imshow(I)
            hold on
            scatter(centralSpikePath(:,2),centralSpikePath(:,1),'*y','LineWidth',2)
            
            f = parentFol(i).name;
            if str2num(f(1,18))==1
                
                imshow(I)
                hold on
                scatter(firstLowestBranchPath(:,2),firstLowestBranchPath(:,1),'*r','LineWidth',2)
                saveas(h,strcat(pwd,'/firstBranch/0',num2str(names(j,1)),'2017/',parentFol(i).name(1,12:end-4),'.jpg'))
                
            elseif str2num(f(1,18))==5
                imshow(I)
                hold on
                scatter(secondLowestBranchPath(:,2),secondLowestBranchPath(:,1),'*r','LineWidth',2)
                saveas(h,strcat(pwd,'/secondBranch/0',num2str(names(j,1)),'2017/',parentFol(i).name(1,12:end-4),'.jpg'))
                
            end
            
%         catch
%             catchi = [catchi;i j];
%         end
        
    end
    
end

save('imageBasedMeasurementAll.mat');

writetable(resultTraitsTableAll,'imageBasedMeasurement.xlsx')