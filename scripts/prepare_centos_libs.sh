set -xe

PROJECT_DIR=${PWD}
CACHE_DIR=${PROJECT_DIR}/prod_images/rpm_cache
LIB_DST_DIR=${PROJECT_DIR}/prod_images/centos_to_ubuntu_libs
DOWNLOAD_CACHE=${PROJECT_DIR}/prod_images/download_cache

mkdir -p ${CACHE_DIR}
mkdir -p ${LIB_DST_DIR} 
mkdir -p ${DOWNLOAD_CACHE}

rm -rf ${CACHE_DIR}/*
rm -rf ${LIB_DST_DIR}/*

file_to_download=(
    "https://rpmfind.net/linux/epel/7/x86_64/Packages/n/nanomsg-1.1.5-6.el7.x86_64.rpm"
    "https://rpmfind.net/linux/centos/7.9.2009/updates/x86_64/Packages/openssl-libs-1.0.2k-22.el7_9.x86_64.rpm"
    "https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/boost-program-options-1.53.0-28.el7.x86_64.rpm"
    "https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/lua-5.1.4-15.el7.x86_64.rpm"
    "https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/krb5-libs-1.15.1-50.el7.x86_64.rpm"
    "https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/keyutils-libs-1.5.8-3.el7.x86_64.rpm"
    "https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/libgomp-4.8.5-44.el7.x86_64.rpm"
    "https://rpmfind.net/linux/centos/7.9.2009/os/x86_64/Packages/readline-6.2-11.el7.x86_64.rpm"
)

for url in ${file_to_download[@]} ; do
    wget -c -P ${DOWNLOAD_CACHE} ${url}
done

cp ${DOWNLOAD_CACHE}/*.rpm ${CACHE_DIR} 

cd ${CACHE_DIR}

rpm_files=$(ls *.rpm)
for rpm_file in ${rpm_files[@]} ; do
    rpm2cpio ${rpm_file} | cpio -i --make-directories 
done

## ignore cp -r error
cp usr/lib64/* ${LIB_DST_DIR} || true
cp lib64/* ${LIB_DST_DIR} || true


