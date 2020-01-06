# dockerimage-springboot-onbuild

> Convention over configuration!

如果您开发了一个基于`spring-boot`的`Java`应用程序，欢迎使用本项目作为您的基础镜像。

 * JDK-8:  
    * `yingzhuo/springboot:8`
    * `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8`
 * JDK-11: 
    * `yingzhuo/springboot:11` 
    * `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11`

### 使用

构建上下文目录结构如下

```
<context>
├── .configkeep			<- 空文件，占位用，如果你没有其他配置文件，此文件必要
├── .dockerignore		<- .dockerignore 可选
├── Dockerfile			<- 您的Dockerfile文件
├── executable-app.jar		<- 可执行jar文件
├── my-config.xml		<- 其他配置文件 可选
└── my-config.properties	<- 其他配置文件 可选
```

你的Dockerfile，最少只需要一行即可。

```Dockerfile
FROM registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8
```

### 构建时行为

* (1) 通过ONBUILD指令，拷贝可执行Jar文件到 `/opt/app.jar`。您的构建上下文必需**有且只有一个**可执行jar文件！
* (2) 通过ONBUILD指令，拷贝上下文`*.conf` `*.yaml` `*.yml` `*.json` `*.properties` `*.xml` `*.toml` `*.ini` `*.groovy` `*.cfg` `*.cnf`到`/opt/config/`。

### 运行时行为

* (1) 检查环境变量等。
* (2) 依次检查如下文件是否存在并可以执行，如果存在并可执行，则执行脚本。基础镜像已经预装了`bash`和`sh`可供使用，shebang分别是 `#!/bin/bash` `#!/bin/sh`。如果您的脚本执行结果为非零值，则容器启动失败。
   * `/opt/app-init.sh`
   * `/opt/app-init`
   * `/opt/init.sh`
   * `/opt/init`
* (3) 启动`spring-boot`应用程序。

### 预设目录

* `/opt/`: 存放可执行jar文件 (fat-jar)
* `/opt/lib/`: 其他`CLASSPATH`。fat-jar之外所需的依赖请存放于此。这个目录可以是空目录。
* `/opt/config/`: 其他配置文件 
   * 本目录实际上是`/config/`的软连接
* `/var/tmp/`: 临时目录。本项目并不使用`/tmp/`作为临时目录。
* `/var/log/`: 日志目录
* `/var/data/`: 其他数据文件存放目录

### 环境变量配置

* debug模式: 如果为true，则开启 `java -jar app.jar --debug`。默认为关闭。
  * `APP_DEBUG`

* 时区: 默认为`UTC`，如果需要设置，以下两者任意设定一种即可。
  * `APP_TIMEZONE` 
  * `APP_TZ`

* spring active profile: 默认为`default`，如果需要设置，以下两者任意设定一种即可。
  * `APP_PROFILES`
  * `SPRING_PROFILES_ACTIVE`

* 端口: 如果需要强制覆盖应用程序指定的端口可以使用如下环境变量
  * `APP_SERVER_PORT`

### 其他信息

* (1) 镜像是基于`alpine`构建的，如果你在使用过程发现缺乏必要的软件，请自行安装。
* (2) 镜像是基于`OpenJDK`构建的，而不是基于`Oracle JDK`。
