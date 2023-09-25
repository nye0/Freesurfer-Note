# Freesurfer-Note
## **1. recon-all Parallel** from *[Andy's Brain Book](https://andysbrainbook.readthedocs.io/en/latest/FreeSurfer/FS_ShortCourse/FS_04_ReconAllParallel.html)*
- package needed: parallel
```
#------install parallel---------
# mac os:
brew install parallel
# ubuntu:
sudo apt-get install parallel
#------data structure-----------
cd /Folder/Contain/RawData
tree
├── sub1.nii
├── sub2.nii
├── sub3.nii
#------------run----------------
NumberOfCore=4
ls *.nii | parallel --jobs $NumberOfCore recon-all -s {.} -i {} -all -qcache
#The {.} for the -s option signifies that the .nii extension should be removed; in other words, the input to -s will be sub1, sub2 .
```
 
## FSL clustering 
``` bash
# step1 生成显著性水平p<0.05的团块结果mask
cluster -i tbss_tfce_corrp_tstat1.nii.gz -t 0.95 -o cluster.nii.gz

# 结果报告有1和2，说明有两个团块具有显著性差异，然后需要拆分，将cluster分成cluster1和cluster2

# step2 拆分
fslmaths cluster.nii.gz -thr 1 -uthr 1 cluster1.nii.gz
fslmaths cluster.nii.gz -thr 2 -uthr 2 cluster2.nii.gz

# 现在就是有了每个显著性团块的结果，下一步去查询看每个团块有哪些纤维束的概率

# step3 查询图谱
atlasquery -a "JHU White-Matter Tractography Atlas" -m cluster1.nii.gz
# 输出结果为团块1的属于纤维束的概率，概率最大的纤维束可认为是主体

atlasquery -a "JHU White-Matter Tractography Atlas" -m cluster2.nii.gz
# 输出结果为团块2的属于纤维束的概率

# step4 提取每个团块内FA值
fslmeants -i all_FA_skeletonised.nii.gz -m cluster1.nii.gz
# 结果输出就是该团块每个被试的FA值

fslmeants -i all_FA_skeletonised.nii.gz -m cluster2.nii.gz
```
