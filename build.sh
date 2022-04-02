#!/bin/bash

echo "build.sh修改自柚柚的 https://gitee.com/deepin-opensource/one-cuter"

VERSION="1.2.2"
ARCH=`dpkg --print-architecture`
cd `dirname $0`

# 编译
echo "-------------------"
echo "开始编译"
mkdir -p build
qmake src/spark-dstore-patch.pro -spec linux-g++ CONFIG+=qtquickcompiler -o build/
cd build/
make -j
cd ..
echo "编译完成"
echo "-------------------"
#echo "更新翻译"
#lrelease ./translations/*.ts



#放置编译好的文件

mv build/spark-dstore-patch pkg/opt/durapps/spark-dstore-patch/spark-dstore-patch
#cp translations/*.qm dabao/extract/opt/apps/top.yzzi.onecuter/files/translations/
rm -rf build

#打包
echo "构建软件包"
SIZE=`du -s ./pkg/opt`
SIZE=`echo ${SIZE%%.*}`
# 生成control文件
echo 生成control文件
echo "版本号为$VERSION，可以在脚本中修改"
echo "检测到编译机的架构为$ARCH"
echo "检测到安装后的目录大小为$SIZE"
cat  << EOF >pkg/DEBIAN/control
Package: spark-dstore-patch
Version: $VERSION
Architecture: $ARCH
Maintainer: shenmo <shenmo@spark-app.store>
Installed-Size: $SIZE
Depends: libc6 (>= 2.25)
Section: admin
Priority: optional
Homepage: https://gitee.com/deepin-community-store/spark-dstore-patch
Description: Patch for deepin-app-store packages

EOF


find pkg/ -type f -print0 |xargs -0 md5sum > pkg/DEBIAN/md5sums
cd pkg
dpkg -b . ../
cd ..

rm pkg/DEBIAN/md5sums
rm pkg/DEBIAN/control
