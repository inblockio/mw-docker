.PHONY: build bash test container test-script uninstall logs

build:
	docker build --pull mw$(version) --target pro-mw -t inblockio/mediawiki:$(version) -t local-mw:$(version)

bash:
	docker exec -it temp-mw bash

test:
	$(MAKE) uninstall || true
	$(MAKE) version=$(version) container
	$(MAKE) test-script || true
	$(MAKE) uninstall

container:
	docker run --name temp-mw -p 127.0.0.1:80:80 -d local-mw:$(version)
	docker cp setup.sh temp-mw:/var/www/html/setup.sh
	docker exec temp-mw bash /var/www/html/setup.sh

test-script:
	bash test.sh

uninstall:
	docker rm temp-mw -f

logs:
	docker logs temp-mwo

build-and-publish:
	$(MAKE) version=37php74 build
	$(MAKE) version=37php74 test
	docker push inblockio/mediawiki:37php74
#	$(MAKE) version=35 build
#	$(MAKE) version=35 test
#	docker push inblockio/mediawiki:35
