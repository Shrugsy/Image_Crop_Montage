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
iptsetpref('ImshowBorder','tight');


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

cropQuest = input('Crop images? y/n:\n', 's')
if strcmp(cropQuest, 'y');
    [I2, rect] = imcrop(Iscaled);                                       %save crop region to variable 'rect' to use for all images
    close;                                                              %close current figure
elseif strcmp(cropQuest, 'n');
    %filler
else
    disp('Incorrect input, please type y/n:');
end

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
    if strcmp(cropQuest, 'y');
        pics(i).crop            = imcrop(pics(i).smallImg,rect);            %crop pics.smallImg based on user crop and save to pics.crop
    end
    tempFileName(i).name    = strcat(tempLoc, '\', num2str(i),'.jpg');  %string containing desired image crop file location
   
    if strcmp(cropQuest, 'y');
        imwrite(pics(i).crop, tempFileName(i).name);                        %save cropped image to file location (required for montage)
    else
        imwrite(pics(i).smallImg, tempFileName(i).name);
    end
end
 
tempDirOutput = dir(fullfile(tempLoc,'*.jpg'));                         %filenames saved to variable for montage
tempFileNames = {tempDirOutput.name};
 
dispText = sprintf('Number of images is: %d', lenPic);                  %display number of images in command window
disp(dispText);

 
x = input('Please input X dimension for crop montage \n');              %ask for user input for montage display width
y = input('Please input Y dimension for crop montage \n');              %ask for user input for montage display height
cd(tempLoc);                                                            %change directory to cropped image location (required for montage)
 
figure;

questString = ('Display using ''montage'' function or ''imdisp'' (imdisp is not a native matlab function) (WARNING: imdisp currently has display issues in this program and will terminate with an error in the temp directory!)');
questResult = questdlg(questString, 'Display using ''montage'' or ''imdisp''', 'montage', 'imdisp', 'montage');

if strcmp(questResult, 'montage')
    fig = montage(tempFileNames, 'Size', [y x]);                            %display cropped images as montage
elseif strcmp(questResult, 'imdisp')
%imdisp used for images of varying heights
%this is not a native matlab function and must be included separately
%http://au.mathworks.com/matlabcentral/fileexchange/22387-imdisp
fig = imdisp(tempFileNames, 'Size', [y x]);
else
    disp('No choice found for montage method');
end

cd(mainDir);                                                            %change directory to original directory

hgexport(gcf, 'output.jpg', hgexport('factorystyle'), 'Format', 'jpeg'); %save figure as a file 'output.jpg'