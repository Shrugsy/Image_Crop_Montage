clc;
clear;
close all;

mainDir = fullfile(cd);

imDir = dir('*.png');       %filesnames saved to variable imDir.name
lenPic = length(imDir);     %number of pictures
pics = [];                   %empty array to store pics
tempFileName = [];

%initialise crop area
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

 
 x = input('Please input X dimension \n');
 y = input('Please input Y dimension \n');
 montage(tempFileNames, 'Size', [y x]);
 
 
 
 %return to main directory
 cd(mainDir);

