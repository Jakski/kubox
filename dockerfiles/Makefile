REPOSITORY = jakski/kubox

base:
	docker build . -t $(REPOSITORY):$(@) -f $(@).dockerfile

golang-%: base
	docker build . -t $(REPOSITORY):$(@) -f golang.dockerfile \
		--build-arg=GO_VERSION=$(@:golang-%=%)

python-%: base
	docker build . -t $(REPOSITORY):$(@) -f python.dockerfile \
		--build-arg=PYTHON_VERSION=$(@:python-%=%)

nodejs-%: base
	docker build . -t $(REPOSITORY):$(@) -f nodejs.dockerfile \
		--build-arg=NODEJS_VERSION=$(@:nodejs-%=%)
