%usage: script should be in same location as the images to be cropped
%no additional images should be present in the folder
%the first image will be displayed, crop the image using the GUI crop box
%double click in the crop box or right click -> crop image
%matlab command window will display number of images and ask for dimensions
%for crop montage
%remember to make the command window active!

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
[I2, rect] = imcrop(I);
%I2: cropped area
%rect: four-element position vector describing crop rectangle
close;  %close figure


%create temp folder if it doesnt exist
exist tempCropsDir dir
if ans ~=7
    mkdir tempCropsDir
end

temploc = strcat(mainDir,'\','tempCropsDir')
cd(temploc);


%%
 for i = 1:lenPic
    pics(i).loc = strcat(mainDir,'\',imDir(i).name);
    pics(i).img = imread(pics(i).loc); %read image to variable 'pics'
    pics(i).crop = imcrop(pics(i).img,rect);
    tempFileName(i).name = strcat(num2str(i),'.jpg');
    imwrite(pics(i).crop, tempFileName(i).name);

 end
 
 tempDirOutput = dir(fullfile(temploc,'*.jpg'));
 tempFileNames = {tempDirOutput.name};
 
 dispText = sprintf('Number of images is: %d', lenPic);
 disp(dispText);

 
 x = input('Please input X dimension for crop montage \n');
 y = input('Please input Y dimension for crop montage \n');
 montage(tempFileNames, 'Size', [y x]);
 
 
 
 %return to main directory
 cd(mainDir);
