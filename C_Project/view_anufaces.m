function viewanufaces()
%% This function will read some of ANU face images and display
%       Download and unzip the files which will create directories
%       
%       anufaces/ - contains 414 images (from 138 students with 3 images each)
%                   each image is pre-cropped with size of 256x256 pixels.
%       Please note that the images are roughly aligned with respect to 
%       the height of each face and the aspect ratios have changed slightly
%       from the cropping process.
%
%       The images would require further preprocessing if necessary, for
%       example histogram equalisation, aligning face features (eyes or
%       nose), or rotation.


close all;

trainpath = 'anufaces/';
file = 's*';
train_filenames = dir([trainpath file]);    % return a structure with filenames
num_images = numel(train_filenames);

nRow = 256;                   % pre-cropped image size  
nCol = 256;                   % pre-cropped image size 
nTileRow = 2;                 % two rows in tilted plot
nTileCol = 9;                 % 9 images per row 

figure;

% Read 18 training images and display them as 2x9 tiles
Y = zeros(nRow*nTileRow,nCol*nTileCol);     % to store whole images
index = 1;

for index_display = 1:num_images/18
    k=1;
    for i=1:nTileRow
        for j=1:nTileCol
            filename = [trainpath train_filenames(index).name];   % kth-filename in the list
            I = imread(filename);
            Y((i-1)*nRow+1:(i)*nRow, (j-1)*nCol+1:(j)*nCol) = I;
            k = k+1;
            index =index + 1;
        end
    end
    imagesc(Y); title('3 images per subject (Press space to continue...)');
    colormap(gray);axis image; axis off;
    
    pause;
end





