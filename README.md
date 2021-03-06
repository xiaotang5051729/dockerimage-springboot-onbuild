# ~~dockerimage-springboot-onbuild~~

**本项目已经过时，spring-boot v2.3.0+ 提供了分层镜像功能，强烈推荐。**
**基于fat-jar的Docker镜像相对笨重。**

> Convention over configuration!

如果您开发了一个基于`spring-boot`的`Java`应用程序，欢迎使用本项目作为您的基础镜像。

 * JDK-8: 
    * `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8`
    * `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8-china`
 * JDK-11:
    * `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11`
    * `registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11-china`

### 使用

构建上下文目录结构如下

```
<context>
├── .configkeep			<- 空文件，占位用，此文件必要
├── .dockerignore		<- .dockerignore 可选
├── Dockerfile			<- 您的Dockerfile文件
├── executable-app.jar		<- 可执行jar文件
├── my-config.xml		<- 其他配置文件 可选
└── my-config.properties	<- 其他配置文件 可选
```

您的Dockerfile，最少只需要一行即可。

```Dockerfile
FROM registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8
```

### 构建时行为

* (1) 通过ONBUILD指令，拷贝可执行Jar文件到 `/home/spring/app.jar`。您必须保证构建上下文必需**有且只有一个**可执行jar文件！
* (2) 通过ONBUILD指令，拷贝上下文`*.conf` `*.yaml` `*.yml` `*.json` `*.properties` `*.xml` `*.toml` `*.ini` `*.groovy` `*.cfg` `*.cnf`到`/home/spring/config/`。

### 运行时行为

* (1) 检查环境变量等。
* (2) 启动应用程序。

### 属主与属组

默认属主 | 默认属组 |
--------|---------|
root    | root    |

### 预设目录

* `/opt/`: 存放可执行jar文件 (fat-jar)。
* `/opt/lib/`: 其他`CLASSPATH`。fat-jar之外所需的依赖请存放于此。这个目录可以为空。
* `/opt/config/`: 其他配置文件。这个目录可以为空。
* `/opt/k8s-probe/`: kubernetes探针所需的脚本或文件请存放于此。这个目录可以为空。
* `/opt/tmp/`: 临时目录。本项目并不使用`/tmp/`作为临时目录。这个目录可以为空。
* `/opt/log/`: 日志目录。这个目录可以为空。
  * `/var/log/`是这个目录的软连接。
* `/opt/data/`: 其他数据文件存放目录。这个目录可以为空。

### 环境变量配置

* debug模式: 如果为true，则开启 `java -jar /opt/app.jar --debug`。默认为关闭。
  * `APP_DEBUG`

* 时区: 默认为`UTC`，如果需要设置，以下两者任意的环境变量设定一种即可。
  * `APP_TIMEZONE` 
  * `APP_TZ`
  
* 语言: 默认为`en`，如果需要设置，可通过环境变量设置。
  * `APP_LANG` 

* 国家: 默认为`US`，如果需要设置，可通过环境变量设置。
  * `APP_COUNTRY` 

* spring active profile: 默认为`default`，如果需要设置，以下两者任意设定一种即可。
  * `APP_PROFILES`
  * `SPRING_PROFILES_ACTIVE`

### 其他信息

* (1) 镜像是基于`alpine`构建的，如果您在使用过程发现缺乏必要的软件，请自行安装。
* (2) 镜像是基于`OpenJDK`构建的，而不是基于`OracleJDK`。
