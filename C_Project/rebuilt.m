close all;
clear all;

% trainpath = 'faces/newanufaces/';
% new_trainpath = 'faces/newtrainingset/';
% %this is the path of testing set, already include my own pic
% testpath = 'faces/testanufaces1/';
% new_testpath = 'faces/newtestest/';
% %select all the file use s*
% file = 's*';  
% file1 = 'a*';
% %structured the file name of the trainning set
% train_filenames = dir([trainpath file]); 
% %structured the file name of the testing set
% test_filenames = dir([testpath file1]);
% %location identify the location of the pic in the set
% location=1;
% %resize all the pics with 100*100
% length=256; 
% width=256; 
% trainingset=[];
% for i=1:414
%         %get the kth file name in the trianning set
%         filename = [trainpath train_filenames(location).name];   
%         %read the file 
%         I = imread(filename);
%         %resize to 100*100
%         I1 = imresize(I,[length width]);
%         new_img = product(I1);
%         new_filename = [new_trainpath train_filenames(location).name];
%         imwrite(new_img,new_filename);
%         location = location + 1;
% end
% location =1;
% for i=1:49
%         %get the kth file name in the trianning set
%         filename = [testpath test_filenames(location).name];   
%         %read the file 
%         I = imread(filename);
%         %I = rgb2gray(I);
%         %resize to 100*100
%         I1 = imresize(I,[length width]);
%         new_img = product(I1);
%         new_filename = [new_testpath test_filenames(location).name];
%         imwrite(new_img,new_filename);
%         location = location + 1;
% end
im1 = imread('faces/testset/s4.png');
im1 = rgb2gray(im1);
[LL LH HL HH] = haar_dwt2D(im1);
figure();
subplot(3,2,1);imshow(LL);title('LL');
subplot(3,2,2);imshow(LH);title('LH');
subplot(3,2,3);imshow(HL);title('HL');
subplot(3,2,4);imshow(HH);title('HH');
new = LL + 0.5*HL +0.5*LH;
subplot(3,2,5);imshow(new);title('Comb');
subplot(3,2,6);imshow(im1);


function y = product(img)
    [LL LH HL HH] = haar_dwt2D(img);
    %y = LL;
    y = LL + LH + HL;
    %y = LL;
end


function [L H]=haar_dwt(f)
    n=n/2;
    L=zeros(1,n);   
    H=zeros(1,n);   
    for i=1:n
        L(i)=(f(2*i-1)+f(2*i))/sqrt(2);
        H(i)=(f(2*i-1)-f(2*i))/sqrt(2);
    end
    
end

function [LL LH HL HH]=haar_dwt2D(img)
    [m n]=size(img);
    for i=1:m       
        [L H]=haar_dwt(img(i,:));
        img(i,:)=[L H];
    end
    for j=1:n       
       [L H]=haar_dwt(img(:,j));
       img(:,j)=[L H];
    end
    LL=img(1:m/2,1:n/2);          
    LH=img(1:m/2,n/2+1:n);        
    HL=img(m/2+1:m,1:n/2);        
    HH=img(m/2+1:m,n/2+1:n);       
end


