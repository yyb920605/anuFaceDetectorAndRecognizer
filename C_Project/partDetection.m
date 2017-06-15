
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function is used to boost the accuracy of face detection. It exams%
%whether the potential face has certain part: LeftEye,RightEye,Nose and %
%Mouth                                                                  %
%Author: Yinbo Yang                                                     %
%Date:2017/5/22                                                         %
%img: RGB image but this should be the image that has been detected as  %
%frontal face.                                                          %
%part: should either 'LeftEye','RightEye','Mouth'or 'Nose'              %
%stdsize: Normalized image size which depends on your traing images     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bool=partDetection(img,part,stdsize)
bool=0;
region=[];
if(strcmp(part,'LeftEye'))
    region = [1,int32(stdsize*2/3); 1, int32(stdsize*2/3)];
elseif(strcmp(part,'RightEye') )
    region = [int32(stdsize/3),stdsize; 1, int32(stdsize*2/3)];
elseif(strcmp(part,'Mouth'))
    region = [1,stdsize; int32(stdsize/3), stdsize];
elseif(strcmp(part,'Nose'))
    region = [int32(stdsize/5),int32(stdsize*4/5); int32(stdsize/3),stdsize];
else
    region = [1,stdsize;1,stdsize];
end
%To minimize the time of computation by narrow down the detection area
narrowedImg=img(region(2,1):region(2,2),region(1,1):region(1,2),:);
partDetector=vision.CascadeObjectDetector(part);
bboxes = step(partDetector, narrowedImg);
if( size(bboxes,1) > 0 )
    bool=1;
end


end