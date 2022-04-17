#!/bin/bash -
#===============================================================================
#
#          FILE: color_coded.sh
#
#         USAGE: ./color_coded.sh
#
#   DESCRIPTION: 
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/03/2022 05:34:44 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

mkdir build
cd build
rm * -fr
cmake -DLLVM_ROOT_DIR=/usr/local/lib64/ -DDOWNLOAD_CLANG=0 ..








