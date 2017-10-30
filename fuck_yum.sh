#!/bin/bash
# migrate the yum dependence
#


COMMAND=$1
TAR_FILE_PATH=$2
DIFF_FILE_PATH=$3

TMP_PATH=/tmp/
TMP_FILE=${TMP_PATH}yum_filtered.lst

help(){
    echo "fuck_yum.sh migrate dependence for people"
    echo "usage: sh fuck_yum.sh [-fdxh] <tar file path> <diff file path>"
    echo "       -f --full full migrate"
    echo "       -m --make make a diff file list"
    echo "       -d --diff diff migrate with a file list"
    echo "       -x --extract extract the tar file for this machine"
    echo "       -h --help show this message"
    echo ""
    echo "example: "
    echo "       create a full migrate file: sh fuck_yum.sh -f ./migrate.tar"
    echo "       extract a migrate file: sh fuck_yum.sh -x ./migrate.tar"
}

log_info(){
    echo $1
}

full(){
    log_info "prepare file list"
    make ${TMP_FILE}
    log_info "packing files"
    tar -cvf ./yum_full.tar -T ${TMP_FILE}
}

make(){
    log_info "making diff file"
    path=$1
    rpm -qal \
    |grep -Ev "^/boot" \
    |grep -v "^/$" \
    |grep -v "^/dev" \
    |grep -v "^/proc" \
    |grep -v "^/root" \
    |grep -v "^/tmp" \
    |grep -v "^/etc$" \
    |grep -v "^/usr$" \
    |grep -v "^/sys" \
    |grep -v "^/home" \
    |grep -v "^/run" \
    |grep -v "etc/sysconfig" \
    |grep -v "etc/usb_modeswitch.d" \
    > ${path} 

    # 有bug 不要试图去乱削减『不必要的文件』
    # |grep -v "etc/sysconfig" \
    # |grep -v "etc/usb_modeswitch.d" \
    # |grep -v "usr/share/man" \
    # |grep -v "usr/lib/firmware" 
    # |grep -v "etc/bash" \
    # |grep -v "usr/lib/kbd/" \
    #  需要home
    # tar --delete --file=collection.tar blues
    # |grep -v "^/usr/share" \
    # rm -rf  /usr/share/ 不需要  dict manpage一类的东西
    # rm -rf  /usr/src/ 不需要 linux 源码
    # /etc/selinux
    echo "/home/" >> ${path} # 按需添加home
    echo "/data" >> ${path}
    echo "/etc/sysconfig/iptables" >> ${path}  # fix iptables
}

diff(){
    diff_list=$3
    make ${TMP_FILE}
    log_info "comparing diff files"
    comm -23 ${TMP_FILE} ${diff_list}
    tar -cvf ./yum_full.tar -T ${TMP_FILE}2
}

extract(){
    log_info "extracting..."
    tar -xvf $TAR_FILE_PATH -C /
}

main(){
    #init
    case $COMMAND in
	-f| --full)
           full
           ;;
        -d| --diff)
           diff
       	   ;;
	-m| --make)
	   make
	   ;;
	-x| --extract)			       
       	   extract
       	   ;;
	-h| --help| *)
	   help
	   ;;
    esac
}

main
