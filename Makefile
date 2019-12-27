timestamp             = $(shell /bin/date "+%F %T")

no_default:
	@echo "no defualt target"; false

github:
	@git add .
	@git commit -m "$(timestamp)"
	@git push

release:
	@docker image build -f $(CURDIR)/Dockerfile-8 -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8 .
	@docker image build -f $(CURDIR)/Dockerfile-11 -t registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11 .
	@docker login --username=yingzhor@gmail.com --password="${ALIYUN_PASSWORD}" registry.cn-shanghai.aliyuncs.com &> /dev/null
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8
	@docker image push registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11
	@docker logout registry.cn-shanghai.aliyuncs.com &> /dev/null
	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:8 -f
	@docker image rm registry.cn-shanghai.aliyuncs.com/yingzhuo/springboot-onbuild:11 -f
	@docker image ls -q --filter=dangling=true | xargs docker image rm -f &> /dev/null

.PHONY: no_default github release