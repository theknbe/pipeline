#**imaging pipeline for the Silver Lab**

thorough instructions for utilizing the pipeline can be found on the Silver Lab wiki

required dependencies (also listed separately for each step):
*[Chris Rorden's dcm2niix tool](https://github.com/neurolabusc/dcm2niix/tree/master/osx_binary)
*[FMRIB Analysis Group's FSL package](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)
*[The Laboratory for Computational Neuroimaging's Freesurfer package](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall)
*[The VISTA Lab's ITKGray program](http://web.stanford.edu/group/vista/cgi-bin/wiki/index.php/ITKGray_Install)
*[The VISTA Lab's vistasoft package](https://github.com/vistalab/vistasoft)
*[Kendrick Kay's knkutils repository](https://github.com/kendrickkay/knkutils)

step order/overview:
1. **manual step** - review raw DICOM files and organize session directories 
      *this will require a DICOM viewer, of which there are many (my personal recommendation is Pixmeo's Osirix)
2. kb_dicom2nifti.py - converts image files from DICOM to NIFTI format 
      *required dependency - Chris Rorden's dcm2niix
3) kb_moco.py - performs motion correction on EPI files, plots and stores motion parameters 
      *required dependencies - Chris Rorden's dcm2niix & FMRIB Analysis Group's FSL package
4) kb_generateSeg.sh - generates an automated segmentation of the cortical surface which is then converted to NIFTI format     
      *required dependencies - The Laboratory for Computational Neuroimaging's Freesurfer package, Mathworks' MATLABR2012b,   
      and kb_fs_ribbon2itk.m (included in the silverVista directory of this repository)
5) **manual step** - the initial segmentation generated in the last step should be inspected for errors and manually edited, once finished it should be saved as t1Class.nii and saved into the subject's NIFTI directory 
      *required dependency - The VISTA Lab's ITKGray
6) kb_initializeVista.m - initiates an mrVista session 
      *required dependency - The VISTA Lab's vistasoft package
7) **manual step** - the inplane anatomical must be aligned to the high-resolution anatomical 
      *required dependency - vistasoft's rxAlign
8) kb_alignInplaneToAnatomical.m - refines the manual alignment 
      *required dependencies - The VISTA Lab's vistasoft package, Kendrick Kay's knkutils, pre-existing mrSESSION in working 
      directory
9) kb_installSeg.m - installs an existing cortical segmentation into an existing mrSESSION 
      *required dependency - The VISTA Lab's vistasoft package
10) kb_macCreateMesh.m - builds and saves a smoothed and inflated mesh for the left and right hemispheres
      *required dependency - The VISTA Lab's vistasoft package

