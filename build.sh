#!/bin/bash


VERSION=1.3.1
#打包
echo "构建软件包"
SIZE=`du -s ./pkg/opt`
SIZE=`echo ${SIZE%%.*}`
# 生成control文件
echo 生成control文件
echo "版本号为$VERSION，可以在脚本中修改"
echo "检测到安装后的目录大小为$SIZE"
cat  << EOF >pkg/DEBIAN/control
Package: spark-dstore-patch
Version: $VERSION
Architecture: all
Maintainer: shenmo <shenmo@spark-app.store>
Installed-Size: $SIZE
Depends: bash
Section: admin
Priority: optional
Homepage: https://gitee.com/spark-community-works-collections/spark-dstore-patch
Description: Patch for deepin-app-store packages

EOF


find pkg/ -type f -print0 |xargs -0 md5sum > pkg/DEBIAN/md5sums
cd pkg
fakeroot dpkg -b . ../
cd ..

rm pkg/DEBIAN/md5sums
rm pkg/DEBIAN/control
