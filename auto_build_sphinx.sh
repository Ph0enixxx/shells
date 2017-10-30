#!/bin/bash 

# to auto build documents
svn up
rm -rf _build.bak
mv _build _build.bak
make html&& make dirhtml  
chown nginx:nginx _build -R
pkill nginx
service nginx restart
