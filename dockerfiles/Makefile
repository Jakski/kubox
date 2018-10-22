base:
	docker build . -t kubox:$(@) -f $(@).dockerfile

golang-%:
	docker build . -t kubox:$(@) -f golang.dockerfile \
		--build-arg=GO_VERSION=$(@:golang-%=%)

python-%:
	docker build . -t kubox:$(@) -f python.dockerfile \
		--build-arg=PYTHON_VERSION=$(@:python-%=%)

nodejs-%:
	docker build . -t kubox:$(@) -f nodejs.dockerfile \
		--build-arg=NODEJS_VERSION=$(@:nodejs-%=%)
