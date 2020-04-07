timestamp := $(shell /bin/date "+%F %T")

no_default:
	@echo "no defualt target"

github:
	@git add .
	@git commit -m "$(timestamp)"
	@git push

release-java-8:
	@docker image build -f $(CURDIR)/Dockerfile-8 -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8 .
	@docker login --username=yingzhor@gmail.com --password="${ALIYUN_PASSWORD}" registry.cn-shanghai.aliyuncs.com &> /dev/null
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8
	@docker logout registry.cn-shanghai.aliyuncs.com &> /dev/null

	@docker image tag registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8  yingzhuo/springboot:8
	@docker login --username=yingzhuo --password="${DOCKERHUB_PASSWORD}" &> /dev/null
	@docker image push yingzhuo/springboot:8
	@docker logout &> /dev/null

	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8 -f
	@docker image rm yingzhuo/springboot:8 -f

release-java-11:
	@docker image build -f $(CURDIR)/Dockerfile-11 -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11 .
	@docker login --username=yingzhor@gmail.com --password="${ALIYUN_PASSWORD}" registry.cn-shanghai.aliyuncs.com &> /dev/null
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11
	@docker logout registry.cn-shanghai.aliyuncs.com &> /dev/null

	@docker image tag registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11  yingzhuo/springboot:11
	@docker login --username=yingzhuo --password="${DOCKERHUB_PASSWORD}" &> /dev/null
	@docker image push yingzhuo/springboot:11
	@docker logout &> /dev/null

	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11 -f
	@docker image rm yingzhuo/springboot:11 -f

release-all: release-java-8 release-java-11

.PHONY: no_default github release-java-8 release-java-11 release-all