close all;
clear all;

%135 yale trainning pics plus 9 my own trianning pics
Num_training_files = 414;
%10 yale trainnning pics plus 1 my own trainning pic
Num_test_files = 49;

%this is the path of trainning set, already include my own pic
trainpath = 'faces/newanufaces/';
%this is the path of testing set, already include my own pic
%testpath = 'faces/testanufaces1/';
testpath = 'faces/testanufaces1/';
%select all the file use s*
file = 's*';
file1 = 'a*';
%structured the file name of the trainning set
train_filenames = dir([trainpath file]); 
%structured the file name of the testing set
test_filenames = dir([testpath file1]);
%location identify the location of the pic in the set
location=1;
%resize all the pics with 100*100
length=256; 
width=256; 
%Matrix A contain all the pics pixeled information in the trainning set
%A is a 10000*414 size matrix, 10000=100*100, is all pixel info of one pic
%414 is the number of trianed pictures
A = [];
trainingset=[];
%Vectorise and make a big data matrix A
for i=1:Num_training_files
        %get the kth file name in the trianning set
        filename = [trainpath train_filenames(location).name];   
        %read the file 
        I = imread(filename);
        %resize to 100*100
        I1 = imresize(I,[length width]);
        %reshaple to 10000*1
        I2 = reshape(I1,[length*width 1]);
        %map all the 414 10000*1 image vector to the 10000*414 matrix
        trainingset=[trainingset I2];
        A(:,location)=I2(:);
        location = location+1;
end
%get the mean face of all trainning images
mean_face=mean(A,2);
show_mean = reshape(mean_face,[length width])/256;
%imshow(show_mean);title('this is the mean face');
%this two steps compute the variance
A=A-mean_face;
B=(A'*A)./Num_training_files;
%get the e-value and the e-vector
[v,d]=eig(B);
d=diag(d);
[d_sorted,index]=sort(d,'descend');
v=v(:,index);
k=10;
eigenface=[];
%compute the eigenface 
for i=1:k
    vector=A*v(:,i);
    eigenface=[eigenface vector];
end
%compute the energy persentage
k_energy = 0;
for i=414-k:414
    k_energy = k_energy + d(i)^2;
end
total_energy = 0;
for i=1:414
    total_energy = total_energy + d(i)^2;
end
%show the persentage
persentage = (k_energy/total_energy)*100;
persentage

%display the 10 eigenfaces
figure;colormap(gray);title('eigenface (10)');
for i=1:10
    subplot(2,5,i);imagesc(reshape(eigenface(:,i),[length,width]));
end

%project training set to eigenface space
projected_train_face=(A'*eigenface)';

    
location=1;
% C the test image matrix
C=[];
testset=[];
for i=1:Num_test_files
        filename = [testpath test_filenames(location).name];   % kth-filename in the list
        I = imread(filename);
        %I = rgb2gray(I);
        %resize the image to 100*100
        I1 = imresize(I,[length width]);
        % convert the 100*100 image to 10000*1 vector
        I2 = reshape(I1,[length*width 1]); 
        testset=[testset I2];
        C(:,location)=I2(:);
        location = location+1;
end
C=C-mean_face;
%project test images into eigenface space
PA=(C'*eigenface)';

Classifier= [];
F = [];
for n =1:Num_test_files
    selected_test_face=PA(:,n);
    %calculate Euclidean distance to projected training matrix
    Edist=[];
    for i=1:Num_training_files
        dist=(norm(projected_train_face(:,i)-selected_test_face))^2;
        Edist=[Edist dist];
    end
    [sorted_Edist index]=sort(Edist);
    top5 = [index(1) index(2) index(3) index(4) index(5)];   
    F = [F,index(1)];
    %knn
    %figure;
    k=100;
    for i = 1:k
        flag = 1;
        y(i) = uint8(index(i)/3);
        for(k = 1:i-1)
            if y(k) == y(i)
                flag = flag + 1;
            end
        end
        if flag == 3
            %subplot(2,1,1);imshow(reshape(trainingset(:,index(i)),[length width]));title('top1');
            %Classifier = [Classifier;[y(i) n]];
            %F = [F,y(i)];
            break;
        end
    end 
    %this is the path of trainning set, already include my own pic
%     for i = 1:5
%         trainpath1 = 'yalefaces/trainingset/';
%         %this is the path of testing set, already include my own pic
%         testpath1 = 'yalefaces/testest/';
%         %select all the file use s*
%         file1 = 's*';  
%         %structured the file name of the trainning set
%         train_filenames1 = dir([trainpath file]); 
%         filename = [trainpath1 train_filenames1(top5(i)).name];    
%         II = imread(filename);
%         II1 = imresize(II,[length width]);
%         subplot(2,3,i);imshow(II1);
%     end     
%     subplot(2,3,1);imshow(reshape(trainingset(:,top5(1)),[length width]));title('top 1');
%     subplot(2,3,2);imshow(reshape(trainingset(:,top5(2)),[length width]));title('top 2');
%     subplot(2,3,3);imshow(reshape(trainingset(:,top5(3)),[length width]));title('top 3');
%     subplot(2,3,4);imshow(reshape(trainingset(:,top5(4)),[length width]));title('top 4');
%     subplot(2,3,5);imshow(reshape(trainingset(:,top5(5)),[length width]));title('top 5');
    %subplot(2,1,2);imshow(reshape(testset(:,n),[length width]));title('test pic');
end
F = uint8(F/3);
faceDetection(F);

% %% test if the new student in the class
% for studentnum = 1:18
%     studentnum = uint8(studentnum);
%     if studentnum > 18
%         loop = 2;
%         break;
%     end
%     C1=[];
%     testset1=[];
%     testpath1 = 'yalefaces/findstudent/';
%     test_filenames1 = dir([testpath1 file]);
%     filename1 = [testpath1 test_filenames1(studentnum).name];   % kth-filename in the list
%     I = imread(filename1);
%     %I = rgb2gray(I);
%     %resize the image to 100*100
%     I1 = imresize(I,[length width]);
%     % convert the 100*100 image to 10000*1 vector
%     I2 = reshape(I1,[length*width 1]); 
%     testset1=[testset1 I2];
%     C1(:,studentnum)=I2(:);
%     C1=C1-mean_face;
%     %project test images into eigenface space
%     PA=(C1'*eigenface)';
% 
%     selected_test_face=PA(:,studentnum);
%     %calculate Euclidean distance to projected training matrix
%     Edist=[];
%     for i=1:Num_training_files
%         dist=(norm(projected_train_face(:,i)-selected_test_face))^2;
%         Edist=[Edist dist];
%     end
%     [sorted_Edist index]=sort(Edist);
% 
%     newstudentclass = uint8(index(1)/2);
%     %newstudentclass
%     %F
%     fc = uint8(F(:,1)/3);
%     tureorfalse = ismember(newstudentclass,fc);
%     if tureorfalse == 1
%         display(strcat('stuendt: ',filename1,' is in this class'));
%     end
%     if tureorfalse == 0
%         display(strcat('stuendt: ',filename1,' is NOT in this class'));
%     end
% end

%Classifier
%% this part is my own image grayscaling and resizing and renaming
% myfacepath = 'myfaces/';
% file = 's*';  file2 = 'm*';   
% my_train_filenames = dir([myfacepath file2]);    % return a structure with filenames
% m=1;
% %x and y represent resized wideth and height
% x=480; %wideth
% y=480; %height
% figure;
% for i=1:1019

%         filename = [myfacepath my_train_filenames(m).name];   % kth-filename in the list
%         I = imread(filename);
%         I1 = imresize(I,[x y]);
%         imgray=rgb2gray(I1);
%         subplot(2,5,i);imshow(imgray);
%         imwrite(imgray,[myfacepath 'subject16_' num2str(i) '.jpg']);
%         m=m+1;
% end
