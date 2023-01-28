start: docker-up proxy-start server-start cache-clear

stop: docker-down proxy-stop server-stop

restart: docker-down proxy-stop server-stop docker-up proxy-start server-start cache-clear

restart-clear: docker-down-clear proxy-stop server-stop docker-up proxy-start server-start cache-clear

docker-up:
	@docker-compose up -d

docker-down:
	@docker-compose down

docker-down-clear:
	@docker-compose down -v

proxy-start:
	@symfony proxy:start

proxy-stop:
	@symfony proxy:stop

server-start:
	@symfony server:start

server-stop:
	@symfony server:stop

cache-clear:
	@symfony console cache:clear

dump: env-var
	@docker-compose exec -T pgsql pg_dump -U "$(DBUSER)" -d "$(DBNAME)" | gzip > ./backups/oro_db_$(shell date +%Y_%m_%d_%H_%M_%S).gz

restore: env-var $(if $(DUMP), dump) unset-db
	@gunzip < $(FILE) | docker-compose exec -T pgsql psql -U "$(DBUSER)" -d "$(DBNAME)"

unset-db: env-var
	@docker-compose exec -T pgsql dropdb -U "$(DBUSER)" "$(DBNAME)"
	@docker-compose exec -T pgsql createdb -U "$(DBUSER)" "$(DBNAME)"

csfixer:
	@vendor/bin/php-cs-fixer fix src --config .php-cs-fixer.dist.php --using-cache=no --dry-run --verbose --allow-risky=yes

phpmd:
	@vendor/bin/phpmd src text ./phpmd_rules.xml

phpstan:
	@vendor/bin/phpstan analyse -l 9 src

testunit:
	@vendor/bin/phpunit -c ./ --testsuite=norsys-unit

testfunctional:
	@vendor/bin/phpunit -c ./ --testsuite=norsys-functional

env-var:
	$(eval DBUSER = $(shell symfony var:export ORO_DB_USER))
	$(eval DBNAME = $(shell symfony var:export ORO_DB_NAME))