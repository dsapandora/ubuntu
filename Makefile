BOX_FILENAMES := $(wildcard ubuntu*.json)
BOXES ?= $(basename $(BOX_FILENAMES))
TEMPLATES ?= vagrant esxi
PACKER_ARGS ?=

export cm ?= puppet
export cm_version ?=
export headless ?= false
export version ?= $(shell cat VERSION)

.PHONY : clean

all: clean build-vagrant build-esxi

build-%: tpl-%.json
	@for box in $(BOXES) ; do \
	  packer build $(PACKER_ARGS) -var-file=$$box.json -var-file=$@.json $< ; \
	done

tpl-ubuntu.json:
	jq -s '.[1] as $$b | .[0].builders |= map(.+$$b) | .[0]' tpl/base.json tpl/builder_default.json > tpl-ubuntu.json

tpl-vagrant.json: tpl-ubuntu.json
	jq -s '.[0]["post-processors"] = .[1] | .[0]' tpl-ubuntu.json tpl/postprocess_vagrant.json > tpl-vagrant.json

tpl-esxi.json: tpl-ubuntu.json
	jq -s '.[0]["post-processors"] = .[1] | .[0]' tpl-ubuntu.json tpl/postprocess_esxi.json > tpl-esxi.json

clean:
	$(RM) tpl-*.json
	$(RM) box/**/*.box