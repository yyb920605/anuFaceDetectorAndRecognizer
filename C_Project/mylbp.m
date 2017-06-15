close all;
clear all;

% img = rgb2gray(imread('yalefaces/testset/s1.png'));
% filtered_img = lbp(img);
% subplot(2,2,1);imshow(img);
% subplot(2,2,2);imshow(filtered_img);
% subplot(2,2,3);histogram(img);
% subplot(2,2,4);histogram(filtered_img);

trainpath = 'faces/newanufaces/';
new_trainpath = 'faces/lbptrainingset/';
%this is the path of testing set, already include my own pic
testpath = 'faces/testanufaces1/';
new_testpath = 'faces/lbptestset/';
%select all the file use s*
file1 = 's*'; 
file = 'a*';  
%structured the file name of the trainning set
train_filenames = dir([trainpath file1]); 
%structured the file name of the testing set
test_filenames = dir([testpath file]);
%location identify the location of the pic in the set
location=1;
%resize all the pics with 100*100
length=256; 
width=256; 
trainingset=[];
for i=1:414
        %get the kth file name in the trianning set
        filename = [trainpath train_filenames(location).name];   
        %read the file 
        I = imread(filename);
        %resize to 100*100
        I1 = imresize(I,[length width]);
        new_img = lbp(I1);
        new_filename = [new_trainpath train_filenames(location).name];
        imwrite(new_img,new_filename);
        location = location + 1;
end
location =1;
for i=1:49
        %get the kth file name in the trianning set
        filename = [testpath test_filenames(location).name];   
        %read the file 
        I = imread(filename);
        %I = rgb2gray(I);
        %resize to 100*100
        I1 = imresize(I,[length width]);
        new_img = lbp(I1);
        new_filename = [new_testpath test_filenames(location).name];
        imwrite(new_img,new_filename);
        location = location + 1;
end


function filtered_img = lbp(img)
%% LBP image descriptor
[nrows, ncols] = size(img);

filtered_img = zeros(nrows, ncols, 'uint8');
for j = 2:ncols-1
    for i = 2:nrows-1
        nhood = nhood8(i, j);
        for k = 1:size(nhood, 1)
            filtered_img(i, j) = filtered_img(i, j) + ...
                (int8(img(nhood(k, 1), nhood(k, 2)))-int8(img(i, j)) >= 0) * 2^(k-1);
        end
    end
end

end

function idx = nhood8(i, j)
%% Computes the 8-neighborhood of a pixel
idx = [
    i-1, j-1;
    i-1, j;
    i-1, j+1;
    
    i, j-1;
    i, j+1;

    i+1, j-1;
    i+1, j;
    i+1, j+1
];

end