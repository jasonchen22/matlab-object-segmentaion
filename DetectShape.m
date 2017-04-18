
clear all; 
clc; 
close all;

RGB = imread('ref.jpg');
RGB = mat2gray(RGB);
figure; imshow(RGB)

HSV = rgb2hsv(RGB);
H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);

h1 = 0.31; h2 = 4.2;
s1 = 0.45; s2 = 1.0;

H(H<h1 | H>h2) = 0; 
S(S<s1 | S>s2) = 0; 

bw = H>0 & S>0;
bw = imfill(bw,'holes');
bw = imdilate(bw,strel('disk',15));
bw = imerode(bw,strel('disk',13));

prps = regionprops(bw,'Area','PixelIdxList','BoundingBox');
k = 1; Amx = prps(1).Area;
for i=2:length(prps)
    if Amx > prps(i).Area, continue; end
    Amx = prps(i).Area;
    k = i;
end
pidx = prps(k).PixelIdxList;
bw(:) = 0; bw(pidx) = 1;
Bbnd = ceil(prps(k).BoundingBox);

g = rgb2gray(RGB);

grad = imgradient(g);
grad = imfilter(grad,ones(4,4));
grad(grad<0.85) = 0;

bw1 = imfill(grad>0,'holes');
prps = regionprops(bw1,'Area','PixelIdxList');
k = 1; Amx = prps(1).Area;
for i=2:length(prps)
    if Amx > prps(i).Area, continue; end
    Amx = prps(i).Area;
    k = i;
end
pidx = prps(k).PixelIdxList;
bw1(:) = 0; bw1(pidx) = 1;

bw1 = imdilate(bw1,strel('disk',15));
bw1 = imerode(bw1,strel('disk',20));

y1 = Bbnd(2)+10; y2 = size(bw1,1);
x1 = 1; x2 = size(bw1,2);
bw1(y1:y2,x1:x2) = bw(y1:y2,x1:x2);
bw = bw1;
bw = imdilate(bw,strel('disk',10));
bw = imerode(bw,strel('disk',10));

R = RGB(:,:,1); G = RGB(:,:,2); B = RGB(:,:,3);
R1 = zeros(size(R)); G1 = zeros(size(R)); B1 = zeros(size(R));
R1(bw) = R(bw); G1(bw) = G(bw); B1(bw) = B(bw); 

RGB1(:,:,1) = R1; RGB1(:,:,2) = G1; RGB1(:,:,3) = B1; 
figure; imshow(RGB1);

imwrite(RGB1, 'result.jpg');


