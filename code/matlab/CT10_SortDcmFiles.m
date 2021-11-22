clear; ; 
label = readtable('dcm/data_info.csv');
Negative_idx = find(label{:,2});
Typical_idx = find(label{:,3});
Atypical_idx = find(label{:,4});

for n1=1:1:400
    fname = [cell2mat(label{Negative_idx(n1),1}) '.dcm'];
%     movefile(['dcm/' fname], ['dcm/train/Negative/' fname]);
    movefile(['dcm\train\' fname], ['dcm\train\Negative\' fname]);
end 


for n1=1:1:400
    fname = [cell2mat(label{Typical_idx(n1),1}) '.dcm'];
%     movefile(['dcm/' fname], ['dcm/train/Typical/' fname]);
    movefile(['dcm\train\' fname], ['dcm\train\Typical\' fname]);
end 


for n1=1:1:400
    fname = [cell2mat(label{Atypical_idx(n1),1}) '.dcm'];
%     movefile(['dcm/' fname], ['dcm/train/Atypical/' fname]);
    movefile(['dcm\train\' fname], ['dcm\train\Atypical\' fname]);
end 