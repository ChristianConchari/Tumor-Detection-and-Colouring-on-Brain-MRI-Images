clear; clc; close all;
IM=imread('BT\BT ().tif');
%------------------------------------------------
% computes the lower and upper limits that can be used for contrast stretching
% Adjust image intensity
J=imadjust(IM,stretchlim(IM,[.65 .99]),[]);
UU=rgb2gray(J);
bw=im2bw(J, 0.5);
% Label connected components in 2-D binary imag
label=bwlabel(bw);
%------------------------------------------------
% Measure properties of image regions
stats=regionprops(label,'Solidity', 'Area');
% Obtain Area data
density=[stats.Solidity];
area=[stats.Area];
% Discriminate the density
hdensity=density>0.2;
% Find the max value on density data
maxArea=max(area(hdensity));
% Find indices and values of nonzero elements
tumorl=find(area==maxArea);
% Array elements that are members of set array
tumor=ismember(label,tumorl);
%------------------------------------------------
se=strel('square',8);
% Morphological Operations
tumor=imdilate(tumor,se);
figure(1)
%------------------------------------------------
[f,c,~]= size (J);
Id=double(J);
Inew=zeros(f,c,3);
for i=1:f
    for j=1:c
        if Id(i,j,1)>200
            Id(i,j,1)=255; Id(i,j,2)=0; Id(i,j,3)=0;
        elseif Id(i,j,1)<200 && Id(i,j,1)>90
            Id(i,j,1)=247; Id(i,j,2)=116; Id(i,j,3)=29;
        elseif Id(i,j,1)<90 && Id(i,j,1)>1
            Id(i,j,1)=218; Id(i,j,2)=247; Id(i,j,3)=29;
        else
            Id(i,j,1)=87; Id(i,j,2)=247; Id(i,j,3)=29;
        end
    end
end
%------------------------------------------------
Inew=uint8(Id);
subplot(2,4,1), imshow(J, []), title('contrast stretching')
subplot(2,4,2), imshow(tumor,[]), title('Tumor detectado');
subplot(2,4,5), imshow(labeloverlay(IM,tumor)), title('tumor remarcado')
subplot(2,4,6), imshow(Inew, []), title('Imagen coloreada')
subplot(2,4,[3,4,7,8]), imshow(IM, []), title('Original')

