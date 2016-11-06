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

imDir = dir('*.png');                                                   %filenames saved to variable imDir.name
lenPic = length(imDir);                                                 %number of pictures
pics = [];                                                              %empty array to store pics
tempFileName = [];

%%
%initialise crop area from first image
I = imread(imDir(1).name);                                              %read first image
[x1, y1, z1] = size(I);                                                 %get dimensions of first image

dispText = sprintf('First image in folder is: %d pixels wide by %d pixels high\n', x1, y1); %display dimensions of first image
disp(dispText);

scaleSize = input('Please choose a value for the scaled images from 0.0 (smallest) to 1.0 (default size): \n'); %get user input on size to scale images
Iscaled = imresize(I, scaleSize);                                       %scale image based on user input

[I2, rect] = imcrop(Iscaled);                                           %save crop region to variable 'rect' to use for all images
close;                                                                  %close current figure


exist tempCropsDir dir                                                  %create temporary folder for cropped images if it doesn't already exist
if ans ~=7;
    mkdir tempCropsDir
end

tempLoc = strcat(mainDir,'\','tempCropsDir');                           %string for file location of cropped images directory



%%
for i = 1:lenPic
    pics(i).loc             = strcat(mainDir,'\',imDir(i).name);        %read image locations to variable pics.loc
    pics(i).img             = imread(pics(i).loc);                      %read image data  to variable pics.img
    pics(i).smallImg        = imresize(pics(i).img, scaleSize);         %scale pics.img based on user input and save to pics.smallImg
    pics(i).crop            = imcrop(pics(i).smallImg,rect);            %crop pics.smallImg based on user crop and save to pics.crop
    tempFileName(i).name    = strcat(tempLoc, '\', num2str(i),'.jpg');  %string containing desired image crop file location
    imwrite(pics(i).crop, tempFileName(i).name);                        %save cropped image to file location (required for montage)
  
end
 
tempDirOutput = dir(fullfile(tempLoc,'*.jpg'));                         %filenames saved to variable for montage
tempFileNames = {tempDirOutput.name};
 
dispText = sprintf('Number of images is: %d', lenPic);                  %display number of images in command window
disp(dispText);

 
x = input('Please input X dimension for crop montage \n');              %ask for user input for montage display width
y = input('Please input Y dimension for crop montage \n');              %ask for user input for montage display height
cd(tempLoc);                                                            %change directory to cropped image location (required for montage)
 
figure;
fig = montage(tempFileNames, 'Size', [y x]);                            %display cropped images as montage

cd(mainDir);                                                            %change directory to original directory
saveas(fig,'output.jpg');                                               %save figure as a file 'output.jpg'
 
