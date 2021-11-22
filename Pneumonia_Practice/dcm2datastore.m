function imds = dcm2datastore(datapath,file_ext,label_option)

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
        filelocation{i} = [datapath '\' dinfo(i).name]; 
    end
end
%imds = imageDatastore(filelocation,'FileExtensions',file_ext,'LabelSource','foldernames','ReadFcn',@dicomread);
imds = imageDatastore(filelocation,'FileExtensions',file_ext,'LabelSource','foldernames','ReadFcn',@dicompreprocess);

end