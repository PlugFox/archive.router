clean:
	@echo "Cleaning the project"
	@flutter clean

format:
	@echo "Formatting the code"
	@dart fix --apply .
	@dart format -l 120 --fix .

get:
	@echo "Geting dependencies"
	@flutter pub get

upgrade: get
	@echo "Upgrading dependencies"
	@flutter pub upgrade

upgrade-major: get
	@echo "Upgrading dependencies --major-versions"
	@flutter pub upgrade --major-versions

codegen: get
	@echo "Running codegeneration"
	@flutter pub run build_runner build --delete-conflicting-outputs --release

outdated:
	@flutter pub outdated

serve: codegen
	@echo "Serve as web app"
	flutter run -d web-server

build-web:
	@echo "Build release docker image with flutter web and nginx"
	docker-compose -f ./example-router.compose.yml build --no-cache --force-rm --compress --parallel

push: build-web
	@echo "Push docker image with flutter web and nginx"
	docker-compose -f ./example-router.compose.yml push

run:
	@echo "Run release docker image with flutter web and nginx"
	docker run -d -p 80:80 --name example-router registry.plugfox.dev/example-router

deploy:
	@echo "Deploy release into docker swarm"
	docker --log-level debug --host "ssh://pfx@api.plugfox.dev" stack deploy --compose-file ./example-router.stack.yml --orchestrator swarm --prune --with-registry-auth example-router