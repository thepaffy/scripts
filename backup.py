#!/usr/bin/python3

import sys
import os
import tempfile
import tarfile
import shutil

if len(sys.argv) < 5:
    print("Using: backup.py basepath backuppath backupfilename ext-1 ext-2 .....")
    quit()

basepath = sys.argv[1]
backuppath = sys.argv[2]
tempdir = tempfile.mkdtemp()
backupfile = sys.argv[3] + ".tar.bz2"

filenameextensions = []

for i in range(len(sys.argv) - 4):
    filenameextensions.append(sys.argv[i + 4])

backupfiles = [] 
   
for root, dirs, files in os.walk(basepath):
    for file in files:
        for extension in filenameextensions:
            if file.endswith(extension):
                backupfiles.append(os.path.join(root, file))
                
tar = tarfile.open(os.path.join(tempdir, backupfile), "w|bz2")
for file in backupfiles:
    tar.add(file)
tar.close();

if not os.path.exists(backuppath):
    os.mkdir(backuppath)
    
shutil.copy2(os.path.join(tempdir, backupfile), backuppath)
