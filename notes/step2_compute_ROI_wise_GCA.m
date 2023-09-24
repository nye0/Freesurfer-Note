clear;clc
%datafile所有灰质文件(.nii)所在的文件夹路径
datafile='D:\CaSCN\GM_PT';
%brainmaskfile指定全脑灰质mask，可以选择vbm统计结果文件夹下的mask.nii
brainmaskfile='D:\CaSCN\stats\mask.nii';
%seedmask指定种子点mask
seedmask='D:\CaSCN\stats\thalamus.nii';
%sigmask1指定voxel-wise结果显著的n-ary mask
sigmask1='D:\CaSCN\voxel_wise_GCA\zgc_seed01tomap_none05_nmask.nii';
%sigmask2指定另一个voxel-wise结果显著的n-ary mask，如果不需要，就注释掉这一行
sigmask2='D:\CaSCN\voxel_wise_GCA\zgc_maptoseed01_none05_nmask.nii';
%结果保存文件夹
savedir='D:\CaSCN\ROI_wise_GCA';
%认知量表
scores='D:\CaSCN\cognition.txt';
order=1;%阶数
method='ascend';%被试根据量表升序排列还是降序排列，%'ascend'和'descend'
covs=[];%协变量，如年龄、性别、TIV等，放在一个txt里，行是被试，列是协变量，没有就置空[]
flag_regscore=1;%是否回归协变量，1，是，0，否，如果是，自动回归协变量以及量表分的间隔
thresh=0.05;%FDR校正后的显著性水平
%% 以下不用改
ts0=JQ_extractROIts(datafile,seedmask);
ts1=JQ_extractROIts(datafile,sigmask1);
if exist('sigmask2','var')
    if exist(sigmask2,'file')
        ts2=JQ_extractROIts(datafile,sigmask2);
        ts=[ts0,ts1,ts2];
    end
else
    ts=[ts0,ts1];
end
[x2y,zx2y]=JQ_gca_ROIwise(ts,savedir,order,covs,scores,method,flag_regscore);
zvec=reshape(zx2y,1,[]);
pvec=2*(1-normcdf(abs(zvec)));
pfdr=mafdr(pvec,'BHFDR',true);

px2y=reshape(pvec,size(zx2y));
pfdrx2y=reshape(pfdr,size(zx2y));
sigx2y=double(pfdrx2y<thresh);

sigx2y=sigx2y.*x2y;
outdegree=sum(abs(x2y.*sigx2y),2)';
outdegree_bin=sum(abs(sigx2y),2)';
indegree=sum(abs(x2y.*sigx2y),1);
indegree_bin=sum(abs(sigx2y),1);

mkdir(savedir);

save(fullfile(savedir,'gca.txt'),'x2y','-ascii');
save(fullfile(savedir,'zgca.txt'),'zx2y','-ascii');
save(fullfile(savedir,'siggca.txt'),'sigx2y','-ascii');

save(fullfile(savedir,'pgca.txt'),'px2y','-ascii');
save(fullfile(savedir,'pfdrgca.txt'),'pfdrx2y','-ascii');

save(fullfile(savedir,'sig_outdegree.txt'),'outdegree','-ascii');
save(fullfile(savedir,'sig_indegree.txt'),'indegree','-ascii');
save(fullfile(savedir,'sig_outdegree_bin.txt'),'outdegree_bin','-ascii');
save(fullfile(savedir,'sig_indegree_bin.txt'),'indegree_bin','-ascii');