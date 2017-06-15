function a=faceDetection(faceset)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:Yinbo Yang u5457700
% Date:2017-05-20
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%the time of beginning
t1=clock;
testdir="detectface/";
faceDetector=vision.CascadeObjectDetector();
classImgName='anuclass01';
classImg=imread(strcat(classImgName,'.JPG'));
%image 2 51
%image 1 49
%It is used to decrease the computation time
faceDetector.MinSize = [30 30];
%faceDetector.MaxSize = [300 300];
figure;
imshow(classImg);
bboxes = step(faceDetector, classImg); % Detect faces
ground_truth=57;
potential_face_set=zeros(70,256,256,3);
numberOfpotentialfaces=size(bboxes,1);
%store potential faces to a matrix
for i=1:numberOfpotentialfaces
    potential_face=classImg(bboxes(i,2):bboxes(i,2)+bboxes(i,4)-1,bboxes(i,1):bboxes(i,1)+bboxes(i,3)-1,:);
    potential_face=imresize(potential_face,[256 256]);
    potential_face_set(i,1:256,1:256,1:3)=potential_face;
    %imshow(potential_face);
end
potential_face_set=potential_face_set(1:i,:,:,:);
%imshow(uint8(reshape(potential_face_set(20,:),[256 256 3])));
%%%%%%%%%%%%%%%%%%%%%%%%To show these potential faces%%%%%%%%%%%%%%%%%%%%%%
nTileRow = 8;                 % two rows in tilted plot
nTileCol = 8;                 % 8 images per row 
nRow = 256;                   % pre-cropped image size  
nCol = 256;                   % pre-cropped image size 
figure;

% 
Y = zeros(nRow*nTileRow,nCol*nTileCol);     % to store whole images
index = 1;

for i=1:nTileRow
    for j=1:nTileCol
        if index<=numberOfpotentialfaces
            
            I = rgb2gray(uint8(reshape(potential_face_set(index,:),[256 256 3])));
            Y((i-1)*nRow+1:(i)*nRow, (j-1)*nCol+1:(j)*nCol) = I;
            index =index + 1;
        else
            break;
        end
    end
end
imagesc(Y); title('potential faces');
colormap(gray);axis image; axis off;
fprintf("Now we have %d potential faces\n",numberOfpotentialfaces);
fprintf("The precision rate:%f \n",49/numberOfpotentialfaces);
fprintf("The recall rate:%f \n",49/ground_truth);
%%%%%%%%%%%%%%%%%%%%%%%%do part detection%%%%%%%%%%%%%%%%%%%%%%%%%
newPotentialfaces=[];
for i=1:numberOfpotentialfaces
    temp=uint8(reshape(potential_face_set(i,:),[256 256 3]));
    bool=partDetection(temp,'LeftEye',256);
    if(bool~=0)
        newPotentialfaces=[newPotentialfaces i];
    else
        bool2=partDetection(temp,'Nose',256);
        if bool2~=0
            newPotentialfaces=[newPotentialfaces i];
        end
    end
end
%%%%%%%%%%%%%%%%To show refined images%%%%%%%%%%%%%%%%%%%%%
figure;
numberOfpotentialfaces=size(newPotentialfaces,2);
% 
Y = zeros(nRow*nTileRow,nCol*nTileCol);     % to store whole images
index = 1;

for i=1:nTileRow
    for j=1:nTileCol
        if index<=numberOfpotentialfaces
            
            I = rgb2gray(uint8(reshape(potential_face_set(newPotentialfaces(index),:),[256 256 3])));
            name=strcat(testdir,classImgName,'_',num2str(index),'.jpg');
            imwrite(I,char(name));
            Y((i-1)*nRow+1:(i)*nRow, (j-1)*nCol+1:(j)*nCol) = I;
            index =index + 1;
        else
            break;
        end
    end
end
imagesc(Y); title('new potential faces');
colormap(gray);axis image; axis off;
fprintf("Now we have %d new potential faces\n",numberOfpotentialfaces);
fprintf("The precision rate:%f \n",49/numberOfpotentialfaces);
fprintf("The recall rate:%f \n",49/ground_truth);
newbboxes=zeros(numberOfpotentialfaces,4);
for i=1:numberOfpotentialfaces
    newbboxes(i,:)=bboxes(newPotentialfaces(i),:);
end

% Annotate detected faces
IFaces = insertObjectAnnotation(classImg, 'rectangle', newbboxes, faceset,'TextBoxOpacity',0.9,'FontSize',30);   
figure, imshow(IFaces), title('Detected faces'); 
t2=clock;
fprintf("time:%f s \n",etime(t2,t1));
end