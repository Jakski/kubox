base:
	docker build . -t kubox:$(@) -f $(@).dockerfile

golang-%: base
	docker build . -t kubox:$(@) -f golang.dockerfile \
		--build-arg=GO_VERSION=$(@:golang-%=%)

python-%: base
	docker build . -t kubox:$(@) -f python.dockerfile \
		--build-arg=PYTHON_VERSION=$(@:python-%=%)

nodejs-%: base
	docker build . -t kubox:$(@) -f nodejs.dockerfile \
		--build-arg=NODEJS_VERSION=$(@:nodejs-%=%)
