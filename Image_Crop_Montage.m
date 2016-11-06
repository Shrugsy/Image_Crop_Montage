%usage: script should be in same location as the images to be cropped
%no additional images should be present in the folder
%the first image will be displayed, crop the image using the GUI crop box
%double click in the crop box or right click -> crop image
%matlab command window will display number of images and ask for dimensions
%for crop montage
%remember to make the command window active!


%%
clc;
clear;
close all;

mainDir = fullfile(cd);

imDir = dir('*.png');       %filenames saved to variable imDir.name
lenPic = length(imDir);     %number of pictures
pics = [];                  %empty array to store pics
tempFileName = [];

%initialise crop area from first image
I = imread(imDir(1).name);
[x1, y1, z1] = size(I);

dispText = sprintf('First image in folder is: %d pixels wide by %d pixels high\n', x1, y1);
disp(dispText);

scaleSize = input('Please choose a value for the scaled images from 0.0 (smallest) to 1.0 (default size): \n');

Iscaled = imresize(I, scaleSize);

[I2, rect] = imcrop(Iscaled);
%I2: cropped area
%rect: four-element position vector describing crop rectangle
close;  %close figure


%create temp folder if it doesnt exist
exist tempCropsDir dir
if ans ~=7;
    mkdir tempCropsDir
end

% exist tempCropsSmallDir dir
% if ans ~=7
%     mkdir tempCropsSmallDir
% end

tempLoc = strcat(mainDir,'\','tempCropsDir');
%tempLocSmall = strcat(mainDir, '\', 'tempCropsSmallDir');
%cd(temploc);


%%
 for i = 1:lenPic
    pics(i).loc = strcat(mainDir,'\',imDir(i).name);
    pics(i).img = imread(pics(i).loc); %read image to variable 'pics'
    pics(i).smallImg = imresize(pics(i).img, scaleSize);
    pics(i).crop = imcrop(pics(i).smallImg,rect);
    tempFileName(i).name = strcat(tempLoc, '\', num2str(i),'.jpg');
    imwrite(pics(i).crop, tempFileName(i).name);
    
    
    %for reduced size images:
    %if image is over certain size:
    %pics(i).smallCrop=imresize(pics(i).crop, scaleSize);
    %tempFileName(i).small = strcat(tempLocSmall, '\', num2str(i), '.jpg');
    %imwrite(pics(i).smallCrop, tempFileName(i).small);

 end
 
 tempDirOutput = dir(fullfile(tempLoc,'*.jpg'));
 tempFileNames = {tempDirOutput.name};
 
 dispText = sprintf('Number of images is: %d', lenPic);
 disp(dispText);

 
 x = input('Please input X dimension for crop montage \n');
 y = input('Please input Y dimension for crop montage \n');
 cd(tempLoc);
 
 figure;
fig = montage(tempFileNames, 'Size', [y x]);

 %return to main directory
cd(mainDir); 
saveas(fig,'output.jpg');
 
