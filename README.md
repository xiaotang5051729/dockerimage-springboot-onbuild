# dockerimage-springboot-onbuild

如果您开发了一个基于`spring-boot`的`Java`应用程序，欢迎使用本项目作为您的基础镜像。

 * JDK-8:  `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8`
 * JDK-11: `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11`

### 使用

构建上下文目录结构如下

```
<context>
├── .configkeep		<- 空文件，占位用，如果你没有其他配置文件，此文件必要
├── .dockerignore		<- .dockerignore 可选
├── Dockerfile		<- 你知道这是什么
├── executable-app.jar   <- 可执行jar文件
├── my-config.xml          <- 其他配置文件 可选
└── my-config.properties     <- 其他配置文件 可选
```

你的Dockerfile，最少只需要一行即可。
```Dockerfile
FROM registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11
```

### 构建时行为

* (1) 通过ONBUILD指令，拷贝可执行Jar文件到 `/opt/app.jar`
* (2) 通过ONBUILD指令，拷贝上下文`*.yaml` `*.yml` `*.properties` `*.xml` `*.toml` `*.ini` `*.groovy` `*.json`到`/opt/config/`。

### 运行时行为

* (1) 依次检查如下文件是否存在并可以执行，如果存在并可执行，则执行脚本。基础镜像已经预装了`bash`和`sh`可供使用。
   * `/opt/app-init.sh`
   * `/opt/app-init`
   * `/opt/init.sh`
   * `/opt/init`
* (2) 启动应用程序。

### 预设目录

* `/opt/`: 存放可执行jar文件
* `/opt/config/`: 其他配置文件 
   * 本目录实际上是`/config/`的软连接
* `/opt/lib/`: 其他`CLASSPATH`
* `/var/tmp/`: 临时目录
* `/var/log/`: 日志目录
* `/var/data/`: 其他数据文件存放目录

### 环境变量配置

* 时区:  默认为`UTC`，如果需要设置，以下两者任意设定一种即可。
  * `APP_TIMEZONE` 
  * `APP_TZ`
 
* spring active profile: 默认为`default`，如果需要设置，以下两者任意设定一种即可。
  * `APP_PROFILES`
  * `SPRING_PROFILES_ACTIVE`

### 其他信息

* (1) 镜像是基于`alpine`构建的，如果你在使用过程发现缺乏必要的软件，请自行安装。
* (2) 镜像是基于`OpenJDK`构建的。