SWAGGER=java -jar swagger-codegen/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar
FOOTER="Auto generated, see https://github.com/cinaq/axxell-specifications"

all: clients api-docs

swagger-codegen:
	[ -d "swagger-codegen" ] || git clone https://github.com/swagger-api/swagger-codegen.git
	cd swagger-codegen && git pull && mvn package -DskipTests

api-docs:
	$(SWAGGER) generate -i swagger.yaml -l html -o html

clients: clean-clients client-php client-java client-python client-go client-javascript

client-php: swagger-codegen
	git clone git@github.com:cinaq/axxell-client-php.git
	$(SWAGGER) generate -i swagger.yaml -l php -o axxell-client-php-temp -c swagger-config-php.json
	rsync -rva axxell-client-php-temp/axxell-client-php/ axxell-client-php
	echo "$(FOOTER)" >> axxell-client-php/README.md
	rm -rf axxell-client-php-temp

client-java: swagger-codegen
	git clone git@github.com:cinaq/axxell-client-java.git
	rm axxell-client-java/README.md
	$(SWAGGER) generate -i swagger.yaml -l java -o axxell-client-java -c swagger-config-java.json
	echo "$(FOOTER)" >> axxell-client-java/README.md

client-python: swagger-codegen
	git clone git@github.com:cinaq/axxell-client-python.git
	$(SWAGGER) generate -i swagger.yaml -l python -o axxell-client-python -c swagger-config-python.json
	echo "$(FOOTER)" >> axxell-client-python/README.md

client-go: swagger-codegen
	git clone git@github.com:cinaq/axxell-client-go.git
	$(SWAGGER) generate -i swagger.yaml -l go -o axxell-client-go -c swagger-config-go.json
	echo "$(FOOTER)" >> axxell-client-go/README.md

client-javascript: swagger-codegen
	git clone git@github.com:cinaq/axxell-client-javascript.git
	$(SWAGGER) generate -i swagger.yaml -l javascript -o axxell-client-javascript
	echo "$(FOOTER)" >> axxell-client-javascript/README.md

diff:
	cd axxell-client-php && git diff
	cd axxell-client-java && git diff
	cd axxell-client-python && git diff
	cd axxell-client-go && git diff
	cd axxell-client-javascript && git diff

commitall:
	cd axxell-client-php && git commit -avm "Auto generate"
	cd axxell-client-java && git commit -avm "Auto generate"
	cd axxell-client-python && git commit -avm "Auto generate"
	cd axxell-client-go && git commit -avm "Auto generate"
	cd axxell-client-javascript && git commit -avm "Auto generate"

push:
	cd axxell-client-php && git push origin master
	cd axxell-client-java && git push origin master
	cd axxell-client-python && git push origin master
	cd axxell-client-go && git push origin master
	cd axxell-client-javascript && git push origin master

clean-clients:
	rm -rf axxell-client-python axxell-client-java axxell-client-php axxell-client-go axxell-client-javascript|| true

clean: clean-clients
	rm -rf swagger-codegen
