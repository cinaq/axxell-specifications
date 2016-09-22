SWAGGER=java -jar swagger-codegen/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar
FOOTER="Auto generated, see https://github.com/cinaq/axxell-specifications"
CLIENTS=axxell-client-php axxell-client-java axxell-client-python axxell-client-go axxell-client-javascript

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

diff: $(CLIENTS)
	for target in $^ ; do \
		cd $$target && git diff && cd ../ ; \
	done

commitall: $(CLIENTS)
	for target in $^ ; do \
		cd $$target && git commit -avm "Auto generate" && cd ../ ; \
	done

push: $(CLIENTS)
	for target in $^ ; do \
		cd $$target && git push origin master && cd ../ ; \
	done

clean-clients:
	rm -rf $(CLIENTS) || true

clean: clean-clients
	rm -rf swagger-codegen
