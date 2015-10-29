#!/Library/Frameworks/Python.framework/Versions/Current/bin/python

#Kelly Byrne | Silver Lab | UC Berkeley | 2015-09-02	
#modified from RD's dicom2vista.py | 2011-10-17

#requires Chris Rorden's dcm2niix - available for OSX at: https://github.com/neurolabusc/dcm2niix/tree/master/osx_binary

"""kb_dicom2nifti.py: converts dicom images to nifti format and organizes resulting subdirectories

required command-line argument: full path to the session directory

usage example: kb_dicom2nifti.py /Volumes/server/myProject/subject001"""

import os
import glob
import numpy as np
import sys
import errno
import subprocess

if __name__ == "__main__":

	sessDir = sys.argv[1]
	if sessDir[-1]=='/':
		sessDir=sessDir[:-1]
	sessName = os.path.split(sessDir)[1]
	os.chdir(sessDir)
	dirList = np.array(glob.glob('*'))
	
	#make some new directories

	try:
		os.mkdir('dicom')
		os.mkdir('nifti')
	except OSError as e:
		if e.errno != errno.EEXIST:
			raise e
		pass
	dicomDir = sessDir + '/' + 'dicom'
	niftiDir = sessDir + '/' + 'nifti'

	#convert dicoms to nifti

	for scan in dirList:
		print("Converting dicom files in " + scan)
		subprocess.check_call(['dcm2niix', '-z', 'Y', '-f', scan, '-o', niftiDir, sessDir + '/' + scan])

	#move files

	for scan in dirList:
		os.chdir(sessDir)
		subprocess.call(['mv', scan, dicomDir])

