#!/bin/sh

(echo "!_TAG_FILE_SORTED	2	/2=foldcase/";(gfind . \( -name .svn -o -name .git -o -wholename ./classes \) -prune -o -not -iregex '.*\.\(o\|lib\|a\|jar\|gif\|jpg\|class\|exe\|dll\|pdd\|sw[op]\|xls\|doc\|pdf\|zip\|tar\|ico\|ear\|war\|dat\).*' -type f -printf "%f\t%p\t1\n" |sort -f)) > filenametags

gfind . -iregex '.*\.[chm][px]\{0,2\}' -o -iregex '.*\.cc' > gtags.file
if [ ! -e "./GTAGS" ];then
gtags > /dev/null 2>&1
else
global -u > /dev/null 2>&1
fi

