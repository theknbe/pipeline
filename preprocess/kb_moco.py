#!/Library/Frameworks/Python.framework/Versions/Current/bin/python

#Kelly Byrne | Silver Lab | UC Berkeley | 2015-09-02
#modified from RD's motioncorrect.py and motionparams.py | 2011-10-17

"""kb_moco.py: calls MCFLIRT to perform motion correction on EPI scans, plots and stores resulting motion parameters. 
uses the first volume of the first EPI scan as the reference volume [sound logic assuming that this volume was 
acquired immediately after an inplane anatomical]. expects EPIs to be labeled epi01_description etc.
required command-line argument: full path to session directory 
usage example: kb_moco.py /Volumes/server/myProject/subject001"""  

import os
import glob
import numpy as np
import sys
import subprocess
from matplotlib import pyplot as plt

if __name__ == "__main__":

	sessDir = sys.argv[1]
        if sessDir[-1]=='/':
                sessDir=sessDir[:-1]
        sessName = os.path.split(sessDir)[1]
	dicomDir = sessDir + '/' + 'dicom'
	niftiDir = sessDir + '/' + 'nifti'
        os.chdir(niftiDir)
        niftiList = np.array(glob.glob('*'))

	#create reference volume from first epi
	
	os.chdir(dicomDir)
	dicomList = np.array(glob.glob('*'))
	for scan in dicomList:
		if scan.startswith('epi01'):
			print('Creating reference volume from first EPI scan')
			refDir = dicomDir + '/' + os.path.splitext(scan)[0]
			os.chdir(refDir)
			RV = glob.glob('*0001.dcm')
			str = ''.join(RV)
			subprocess.check_call(['dcm2niix', '-z', 'N', '-s', 'Y', '-f', 'refVol' '-o', niftiDir, refDir + '/' + str])
			nii = glob.glob('*.nii*')
			ref = ''.join(nii)
			os.chdir(niftiDir)

	for scan in niftiList:
		if scan.startswith('epi'):
			#call mcflirt to do the motion correction and align to reference volume
			print('Correcting for motion in ' + scan + ' by aligning to reference volume')
			subprocess.check_call(['mcflirt', '-in', scan, '-refvol', 'refVol.nii', '-report', '-plots'])
	
	#extract motion param info
	
	mcList = np.array(glob.glob('*'))
	parList = []
	for par in mcList:
		if par.endswith('mcf.par'):
			parList.append(par)
	print parList

	#make empty containers to add the motion params to, for plotting purposes:
    	
    	r1 = np.array([])
    	r2 = np.array([])
    	r3 = np.array([])
    	t1 = np.array([])
    	t2 = np.array([])
    	t3 = np.array([])
	
	for par in parList: 
       		dt = dict(names = ('R1','R2','R3','T1','T2','T3'), 
                formats = (np.float32,np.float32,np.float32,
                np.float32,np.float32,np.float32))
        	MP = np.loadtxt(par,dt)
            
        	r1 = np.append(r1,MP['R1'])
        	r2 = np.append(r2,MP['R2'])
        	r3 = np.append(r3,MP['R3'])
        	t1 = np.append(t1,MP['T1'])
        	t2 = np.append(t2,MP['T2']) 
        	t3 = np.append(t3,MP['T3'])

	#plot and save
	
	fig = plt.figure()
    	ax1 = fig.add_subplot(2,1,1)
    	ax1.plot(t1)
    	ax1.plot(t2)
    	ax1.plot(t3)
    	ax1.set_ylabel('Translation (mm)')
    	ax2 = fig.add_subplot(2,1,2) 
    	ax2.plot(r1)
    	ax2.plot(r2)
    	ax2.plot(r3)
    	ax2.set_ylabel('Rotation (rad)')
    	ax2.set_xlabel('Time (TR)')
    	fig.savefig(sessName + '_motionParams.png')
    	p = np.column_stack((r1,r2,r3,t1,t2,t3))
    	np.savetxt('motionParams.txt',p)

	#clean up nifti directory
	
	cleanList = np.array(glob.glob('*'))
	os.mkdir('raw')
	os.mkdir('mcFiles')
	for file in cleanList:
		if file.startswith('epi') and not file.endswith(('.par', '_mcf.nii.gz')):
			subprocess.call(['mv', file, 'raw'])
		if file.endswith(('.nii', '.par', '.png', '.txt')):
			subprocess.call(['mv', file, 'mcFiles'])
		if file.startswith('GEMS'):
			os.rename(file, 'gems.nii.gz')
		if file.startswith('t1'):
			os.rename(file, 'mprage.nii.gz')

	#calculate and display range of motion for each of the primary axes
	#of rotation and translation - column order matches MCFLIRT output
	#of pitch, roll, yaw, x, y, z
	
	mcDir = niftiDir + '/' + 'mcFiles'
        os.chdir(mcDir)
        data = np.loadtxt('motionParams.txt', unpack=True)
        maxVals = np.amax(data, axis=1)
        minVals = np.amin(data, axis=1)
        rangeList = maxVals - minVals
        print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
        print('Range of motion for ' + sessName + ':')
        print(rangeList)
        print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	np.savetxt('rangeOfMotion.txt', rangeList)
	subprocess.call(['open', sessName + '_motionParams.png'])
