function imds = CT10_dcm2datastore(datapath,file_ext,label_option)
global imgPreProcParam; 
% imds = CT10_dcm2datastore(datapath,file_ext,label_option)
% 
% file_ext: '.dcm'
% label_option: 0 or 1
% mode: 'ori', 'cnn','tlm', 
% image size for original is [1024 1024]
% image size for cnn is [50 50]
% image size for tlm is [227 227]
% Example: img = CT10_dicompreprocess(filepath,'cnn');
% Example: imds = dcm2datastore(pwd,'.dcm',0, 'cnn');


% Get folder list
dinfo = dir(datapath);
dirFlags = [dinfo.isdir];
dinfo = dinfo(dirFlags);
dinfo(ismember( {dinfo.name}, {'.', '..'})) = [];

% Initiate parameters
if length(label_option)<=1
    label_option = 0:length(dinfo)-1; 
end

% Create image datastore using foldername and input file extension
filelocation = {};
for i=1:length(dinfo)
    if ismember(i-1,label_option)
        if isunix
            filelocation{i} = [datapath '/' dinfo(i).name]; 
        else 
            filelocation{i} = [datapath '\' dinfo(i).name]; 
        end
    end
end
if (imgPreProcParam.en)
    imds = imageDatastore(filelocation,'FileExtensions',file_ext,'LabelSource','foldernames','ReadFcn',@CT10_DicomPreProc);
else
    imds = imageDatastore(filelocation,'FileExtensions',file_ext,'LabelSource','foldernames','ReadFcn',@dicomread);
end

end