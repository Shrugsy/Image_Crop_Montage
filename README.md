# Image_Crop_Montage
Matlab script to crop the same region from multiple images and display cropped regions as a montage

usage: Script should be in same location as the images to be cropped. 
No additional images should be present in the folder. Program will say dimensions of first image and ask user to scale images (from 0.0 to 1.0 default). The first image will be displayed, crop the image using the GUI crop box. Double click in the crop box or right click -> crop image. Matlab command window will display number of images and ask for dimensions for crop montage. Remember to make the command window active! Currently works only for .png files, can be altered to be used for other images.
Output will be saved as 'Output.jpg' in original folder.
