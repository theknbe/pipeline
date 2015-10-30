##**Imaging Pipeline for the Silver Lab**

Thorough instructions for utilizing the pipeline can be found on the Silver Lab wiki

###Required Dependencies:

[Chris Rorden's dcm2niix tool](https://github.com/neurolabusc/dcm2niix/tree/master/osx_binary)

[FMRIB Analysis Group's FSL package](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)

[The Laboratory for Computational Neuroimaging's Freesurfer package](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall)

[The VISTA Lab's ITKGray program](http://web.stanford.edu/group/vista/cgi-bin/wiki/index.php/ITKGray_Install)

[The VISTA Lab's vistasoft package](https://github.com/vistalab/vistasoft)

[Kendrick Kay's knkutils repository](https://github.com/kendrickkay/knkutils)

###Stepwise Overview:

1. manual step - review raw DICOM files and organize session directories 
2. kb_dicom2nifti.py - converts image files from DICOM to NIFTI format 
3. kb_moco.py - performs motion correction on EPI files, plots and stores motion parameters 
4. kb_generateSeg.sh - generates an automated segmentation of the cortical surface and converts to NIFTI format     
5. manual step - the initial segmentation should be inspected for errors and manually edited, then copied into the subject's NIFTI directory 
6. kb_initializeVista.m - initiates an mrVista session 
7. manual step - the inplane anatomical must be aligned to the high-resolution anatomical 
8. kb_alignInplaneToAnatomical.m - refines the manual alignment 
9. kb_installSeg.m - installs an existing cortical segmentation into an existing mrSESSION 
10. kb_macCreateMesh.m - builds and saves a smoothed and inflated mesh for the left and right hemispheres

Once you've made it this far, you're ready to move on to analysis!

