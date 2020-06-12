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
 
