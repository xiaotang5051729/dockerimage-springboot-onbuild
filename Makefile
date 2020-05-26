timestamp := $(shell /bin/date "+%F %T")

no_default:
	@echo "no defualt target"

github:
	@git add .
	@git commit -m "$(timestamp)"
	@git push

release-java-8:
	@docker login --username=yingzhor@gmail.com --password="${ALIYUN_PASSWORD}" registry.cn-shanghai.aliyuncs.com &> /dev/null

	@docker image build -f $(CURDIR)/Dockerfile-8 -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8 .
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8
	@docker image build -f $(CURDIR)/Dockerfile-8-CN -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8-china .
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8-china

	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8 -f
	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8-china -f

	@docker logout registry.cn-shanghai.aliyuncs.com &> /dev/null

release-java-11:
	@docker login --username=yingzhor@gmail.com --password="${ALIYUN_PASSWORD}" registry.cn-shanghai.aliyuncs.com &> /dev/null

	@docker image build -f $(CURDIR)/Dockerfile-11 -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11 .
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11
	@docker image build -f $(CURDIR)/Dockerfile-11-CN -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11-china .
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11-china

	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11 -f
	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11-china -f

	@docker logout registry.cn-shanghai.aliyuncs.com &> /dev/null

release-all: release-java-8 release-java-11

.PHONY: no_default github release-java-8 release-java-11 release-all