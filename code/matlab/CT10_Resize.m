clear; ; 
label = readtable('dcm\data_info.csv');
Negative_idx = find(label{:,2});
Typical_idx = find(label{:,3});
Atypical_idx = find(label{:,4});
valid = dir('dcm\valid\*.dcm');
new_size = [1024 1024];

mkdir dcm_resize\train\Negative;
mkdir dcm_resize\train\Typical;
mkdir dcm_resize\train\ATypical;
mkdir dcm_resize\valid;


% for n1=1:1:400
%     rfname = ['dcm\train\Negative\' cell2mat(label{Negative_idx(n1),1}) '.dcm'];
%     wfname = ['dcm_resize\train\Negative\' cell2mat(label{Negative_idx(n1),1}) '.dcm'];
%     img = dicomread(rfname);
%     % dcm_resize = imresize(img, new_size);
%     % dcm_resize = uint8(255 * mat2gray(dcm_resize)); % Scale min=0, max = 255    
%     % dcm_resize = myResizePad(dcm, new_size);
%     dcm_resize = myResizeCrop(img, new_size);
%     % imshow(img,'DisplayRange',[]); 
%     dicomwrite(dcm_resize, wfname);    
% end 
% 
% for n1=1:1:400
%     rfname = ['dcm\train\Typical\' cell2mat(label{Typical_idx(n1),1}) '.dcm'];
%     wfname = ['dcm_resize\train\Typical\' cell2mat(label{Typical_idx(n1),1}) '.dcm'];
%     img = dicomread(rfname);
%     % dcm_resize = imresize(img, new_size);
%     % dcm_resize = uint8(255 * mat2gray(dcm_resize)); % Scale min=0, max = 255   
%     % dcm_resize = myResizePad(dcm, new_size);    
%     dcm_resize = myResizeCrop(img, new_size);
%     dicomwrite(dcm_resize, wfname);    
% end 

for n1=1:1:400
    rfname = ['dcm\train\Atypical\' cell2mat(label{Atypical_idx(n1),1}) '.dcm'];
    wfname = ['dcm_resize\train\Atypical\' cell2mat(label{Atypical_idx(n1),1}) '.dcm'];
    img = dicomread(rfname);
    % dcm_resize = imresize(img, new_size);
    % dcm_resize = uint8(255 * mat2gray(dcm_resize)); % Scale min=0, max = 255   
    % dcm_resize = myResizePad(dcm, new_size);    
    dcm_resize = myResizeCrop(img, new_size);
    dicomwrite(dcm_resize, wfname);    
end 

for n1=1:1:150
    rfname = ['dcm\valid\' valid(n1).name];
    wfname = ['dcm_resize\valid\' valid(n1).name];
    img = dicomread(rfname);
    % dcm_resize = imresize(img, new_size);
    % dcm_resize = uint8(255 * mat2gray(dcm_resize)); % Scale min=0, max = 255 
    % dcm_resize = myResizePad(dcm, new_size);
    dcm_resize = myResizeCrop(img, new_size);
    dicomwrite(dcm_resize, wfname);    
end 

function dcm_resize = myResizePad(img, new_size)
dcm_resize = zeros(new_size) ;
if (size(img,1)>size(img,2))
    img2 = imresize(img,[size(new_size,1), nan]);
else     
    img2 = imresize(img,[nan, size(new_size,2)]);
end
dcm_resize(1:size(img2,1), 1:size(img2,2)) =  img2;
end

function dcm_resize = myResizeCrop(img, new_size)
if (size(img,1)<size(img,2))
    img2 = imresize(img,[new_size(1), nan]);
else     
    img2 = imresize(img,[nan, new_size(2)]);
end
img2_size = round(size(img2)/2)*2;
dcm_resize =  img2(img2_size(1)/2-new_size(1)/2+1:img2_size(1)/2+new_size(1)/2,img2_size(2)/2-new_size(2)/2+1:img2_size(2)/2+new_size(2)/2);
end
