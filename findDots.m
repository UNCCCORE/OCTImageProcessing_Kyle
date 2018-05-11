%Author: Kyle Tucker
%Date: April 18, 2018
%Purpose: To take in an OCT image and locate dot centroids
%Notes: Program currently works best with dark images. This program 
    %typically takes 10 seconds with a 4000x6000 pixel image. 
    %A small part of this code came from: 
    %https://www.mathworks.com/matlabcentral/answers/195257-how-can-i-detect-round-objects-and-remove-other-objects-in-an-image-using-matlab#answer_173284
    %Centroid locations are stored in this order:
        %Yellow Circles, Red Circles, Blue Circles,
        %Yellow Triangles, Red Triangles, Blue Triangles,
        %Yellow Squares, Red Squares, Blue Squares
    %This image is searched from left to right to find these shapes
    %In the GUI, these will be reordered to match OCT array numbering
function [centroidX,centroidZ] = findDots(image,region_minsize,region_maxsize,circularity_limit,triangular_bottom_limit,triangular_upper_limit,square_bottom_limit,square_upper_limit)
RGB = imread(image); %image variable is just the file location of the image from the GUI
%Adjustable Parameters:
%region_minsize establishes minimum pixel size of circles
%region_maxsize establishes maximum pixel size of circles
%circularity_limit establishes circularity of shapes
%triangular_bottom_limit establishes minimum circularity limit for triangles
%triangular_upper_limit establishes maximum circularity limit for triangles
%breaks image into three gray scale images, filtered red, green, and blue
redChannel = RGB(:, :, 1);
greenChannel = RGB(:, :, 2);%This channel is currently used to find yellow dots. Yellow dots that also show up in red channel are kicked out at end of code
blueChannel = RGB(:, :, 3);
%the next six lines run Otsu's method on all three filtered images, returning black and white versions
level_red = graythresh(redChannel);%finds threshold level
BW_red = imbinarize(redChannel,(level_red));%creates binary image based on that threshold
level_green = graythresh(greenChannel);
BW_green = imbinarize(greenChannel,(level_green));
level_blue = graythresh(blueChannel);
BW_blue = imbinarize(blueChannel,(level_blue));
%putting a stop at the next available line, running findDots from GUI, and opening BW_red, BW_green, or BW_blue
%is THE BEST way to understand why image processing isn't finding a dot.
%Below code filters out shapes not within pixel limits established by min and max pixel size
%Red
uvals = unique(BW_red(:));%gets list of possible values in array. Creates vector of 0s and 1s
for K = 1 : length(uvals)
   BW2 = bwareafilt(BW_red, [region_minsize, region_maxsize]);  %discard areas that are too small and too large
end
%Green
uvals_1 = unique(BW_green(:));
for K = 1 : length(uvals_1)
   BW1 = bwareafilt(BW_green, [region_minsize, region_maxsize]);  %discard areas that are too small and too large
end
%Blue
uvals_2 = unique(BW_blue(:));
for K = 1 : length(uvals_2)
   BW3 = bwareafilt(BW_blue, [region_minsize, region_maxsize]);  %discard areas that are too small and too large
end
%Below code checks for circularity of blobs in images and removes blobs not circular
%enough in all three images
a = 1;%this variable is used later for storing centroid information
for i=1:3
    %determines which channel (Red,Green, or Blue) will be filtered
    if i==1
        BlackWhite = BW1;%Makes BlackWhite the BW green image
    elseif i==2
        BlackWhite = BW2;%Makes BlackWhite the BW red image
    else
        BlackWhite = BW3;%Makes BlackWhite the BW blue image
    end
% Label the blobs in the image
labeledImage = bwlabel(BlackWhite);
measurements = regionprops(labeledImage,'Area','Perimeter');
% Do size filtering and roundness filtering.
% Get areas and perimeters of all the regions into single arrays.
allAreas = [measurements.Area];
allPerimeters = [measurements.Perimeter];
% Compute circularities.
circularities = (4*pi*allAreas)./allPerimeters.^2;
% Find objects that have "round" values of circularities.
keeperBlobs = circularities > circularity_limit;
% Get actual index numbers instead of a logical vector
% so we can use ismember to extract those blob numbers.
roundObjects = find(keeperBlobs);
% Compute new binary image with only the small, round objects in it.
BW = ismember(labeledImage, roundObjects) > 0;
if i==1
    BW__1 = BW;%Green channel
elseif i==2
    BW__2 = BW;%Red channel
else
    BW__3 = BW;%Blue channel
end
% store centroids in array
measurements = regionprops(BW,'Centroid');
allCentroids = [measurements.Centroid];
if allCentroids ~= 0
    for b=1:length(allCentroids)/2
        centroidX(a) = allCentroids(b*2-1);
        centroidZ(a) = allCentroids(b*2);
        a=a+1;
    end
end
end

%checks for circularity of blobs in images and keeps triangular images
%very similar to above code, but this time it keeps triangles, not circles
for i=1:3
    if i==1
        BlackWhite = BW1;%Green channel
    elseif i==2
        BlackWhite = BW2;%Red channel
    else
        BlackWhite = BW3;%Blue channel
    end
% Label the blobs.
labeledImage = bwlabel(BlackWhite);
measurements = regionprops(labeledImage,'Area','Perimeter');
% Do size filtering and roundness filtering.
% Get areas and perimeters of all the regions into single arrays.
allAreas = [measurements.Area];
allPerimeters = [measurements.Perimeter];
% Compute circularities.
circularities = (4*pi*allAreas)./allPerimeters.^2;
% Find objects that have "round" values of circularities.
keeperBlobs_1 = circularities < triangular_upper_limit; %Establishes bottom limit
keeperBlobs_2 = circularities > triangular_bottom_limit;
keeperBlobs = ((keeperBlobs_1+keeperBlobs_2)==2);
% Get actual index numbers instead of a logical vector
% so we can use ismember to extract those blob numbers.
roundObjects = find(keeperBlobs);
% Compute new binary image with only the small, triangular objects in it.
BW = ismember(labeledImage, roundObjects) > 0;
if i==1
    BW__1 = BW;%Green
elseif i==2
    BW__2 = BW;%Red
else
    BW__3 = BW;%Blue
end
% store centroids in array
measurements = regionprops(BW,'Centroid');
allCentroids = [measurements.Centroid];
for b=1:length(allCentroids)/2
    centroidX(a) = allCentroids(b*2-1);
    centroidZ(a) = allCentroids(b*2);
    a=a+1;
end
end
%Below code checks for circularity of blobs in images and keeps square images
%very similar to above code, but this time it keeps squares, not circles or
%triangles
for i=1:3
    if i==1
        BlackWhite = BW1;
    elseif i==2
        BlackWhite = BW2;
    else
        BlackWhite = BW3;
    end
% Label the blobs.
labeledImage = bwlabel(BlackWhite);
measurements = regionprops(labeledImage,'Area','Perimeter');
% Do size filtering and roundness filtering.
% Get areas and perimeters of all the regions into single arrays.
allAreas = [measurements.Area];
allPerimeters = [measurements.Perimeter];
% Compute circularities.
circularities = (4*pi*allAreas)./allPerimeters.^2;
% Find objects that have "round" values of circularities.
keeperBlobs_1 = circularities < square_upper_limit; %Establishes bottom limit
keeperBlobs_2 = circularities > square_bottom_limit;
keeperBlobs = ((keeperBlobs_1+keeperBlobs_2)==2);
% Get actual index numbers instead of a logical vector
% so we can use ismember to extract those blob numbers.
roundObjects = find(keeperBlobs);
% Compute new binary image with only the small, triangular objects in it.
BW = ismember(labeledImage, roundObjects) > 0;
if i==1
    BW__1 = BW ; 
elseif i==2
    BW__2 = BW;
else
    BW__3 = BW;
end
% store centroids in array
measurements = regionprops(BW,'Centroid');
allCentroids = [measurements.Centroid];
for c=1:length(allCentroids)/2
    centroidX(a) = allCentroids(c*2-1);
    centroidZ(a) = allCentroids(c*2);
    a=a+1;
end
end

%checks for repeated values of x centroids, deletes second and third
%occurrences
l = length(centroidX);%finds length of array for loop
i = 1;
while(i<=l)
    j = 1;
    while(j<=l)
        if(i~=j && (abs(centroidX(i)-centroidX(j))<=20) && (abs(centroidZ(i)-centroidZ(j))<=20))%removes centroids that are within 20 pixels of each other.
            %This means that the code interprets that two centroids within
            %20 pixels of each other are the same centroid being found twice
            centroidX(j)=[];%Makes space in array blank
            centroidZ(j)=[];
            l=l-1;%Accounts for array shrinking
            j=j-1;%Checks same spot where value was deleted from to avoid skipping values
        end
        j=j+1;
    end
    i=i+1;
end
end