%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This file is used to align training set by using Viola-jones method   %
%Author: Yinbo Yang                                                    %
%Date:2017/5/22                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function chopTrainingSet()
    trainpath = 'anufaces\';
    file = 's*';
    train_filenames = dir([trainpath file]);    % return a structure with filenames
    num_images = numel(train_filenames);
    newTrainpath="newanufaces\";
    for index=1:num_images
        filename = [trainpath train_filenames(index).name];   % kth-filename in the list
        I = imread(filename);
        Detector=vision.CascadeObjectDetector();
        bboxes = step(Detector, I);
        newimg=I;
        if size(bboxes,1)>0
            
            newimg=imresize(I(bboxes(1,2):bboxes(1,2)+bboxes(1,4)-1 , bboxes(1,1):bboxes(1,1)+bboxes(1,3)-1),[256 256]);
        end
        name=strcat(newTrainpath,train_filenames(index).name);
        imwrite(newimg,char(name));
    end

    


end