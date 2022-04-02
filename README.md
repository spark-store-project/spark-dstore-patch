# spark-dstore-patch

#### 介绍
从星火商店主仓库分离出来的补丁单独包，方便使用。星火商店自带了该补丁，如果已经安装过星火商店，则不需要额外安装此补丁

星火商店官网:https://spark-app.store/#/

星火商店源码:https://gitee.com/deepin-community-store/spark-store

星火商店下载:https://gitee.com/deepin-community-store/spark-store/releases/

为了方便使用的仓库，当你不想使用星火商店但还是想安装UOS包的时候可以只编译本仓库。

如果发现本仓库的代码落后于星火内置的版本，请提issue或者pr来帮助同步

启动`./build.sh`来构建

安装依赖：`sudo apt install qt5-default g++ fakeroot`