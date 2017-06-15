close all;
clear all;
% %% read all the trainning data
% %store all the trainning date into a 10000*3 matrix
% %this is the path of trainning set, already include my own pic
% trainpath = 'yalefaces/trainingset/';
% %this is the path of testing set, already include my own pic
% testpath = 'yalefaces/testset/';
% %select all the file use s*
% file = 's*';  
% %structured the file name of the trainning set
% train_filenames = dir([trainpath file]); 
% %structured the file name of the testing set
% test_filenames = dir([testpath file]);
% %location identify the location of the pic in the set
% location=1;
% %resize all the pics with 100*100
% length=256; 
% width=256; 
% %Matrix A contain all the pics pixeled information in the trainning set
% %A is a 10000*414 size matrix, 10000=100*100, is all pixel info of one pic
% %414 is the number of trianed pictures
% A = [];
% trainingset=[];
% %Vectorise and make a big data matrix A
% for i=1:414
%         %get the kth file name in the trianning set
%         filename = [trainpath train_filenames(location).name];   
%         %read the file 
%         I = imread(filename);
%         %resize to 100*100
%         I1 = imresize(I,[length width]);
%         %reshaple to 10000*1
%         I2 = reshape(I1,[length*width 1]);
%         %map all the 414 10000*1 image vector to the 10000*414 matrix
%         trainingset=[trainingset I2];
%         A(:,location)=I2(:);
%         location = location+1;
% end
% save('A.mat','A');
load('A.mat');
figure();
for p = 1:6
    name = strcat('yalefaces/testset/s',num2str(p),'.png');
    testimg = imread(name);
    testimg = rgb2gray(testimg);
    testimg = imresize(testimg,[256 256]); 
    subplot(6,2,p*2-1);imshow(testimg);
    testimg = reshape(testimg,[256*256 1]);

    distance=[];
    for i = 1:414
        img1 = im2double(A(:,i));
        img2 = im2double(testimg);
        d = norm(img1-img2);
        distance = [distance d];
    end
    c=sort(distance);

    k=70;
    for i = 1:k
        flag = 1;
        x(i) = find(distance == c(i));
        y(i) = uint8(x(i)/3);
        for(k = 1:i-1)
            if y(k) == y(i)
                flag = flag + 1;
            end
        end
        if flag == 2
            i
            res_img = A(:,x(i));
            res_img = reshape(res_img,[256 256]);
            subplot(6,2,p*2);imshow(uint8(res_img));
        end
    end
end
