BOX_FILENAMES := $(wildcard ubuntu*.json)
BOXES ?= $(basename $(BOX_FILENAMES))
TEMPLATES ?= vagrant vsphere
PACKER_ARGS ?=

JQ_SET_POST_PROCESSOR := .[0]["post-processors"] = .[1]
JQ_VMWARE_BUILDS_ONLY := .[0]["builders"] = [.[0]["builders"][] | select(.type == "vmware-iso")]

export cm ?= puppet
export cm_version ?=
export headless ?= false
export version ?= $(shell cat VERSION)

.PHONY : clean

all: clean build-vagrant build-vsphere

build-%: tpl-%.json
	@for box in $(BOXES) ; do \
	  packer build $(PACKER_ARGS) -var-file=$$box.json -var-file=$@.json $< ; \
	done

tpl-ubuntu.json:
	jq -s '.[1] as $$b | .[0].builders |= map(.+$$b) | .[0]' tpl/base.json tpl/builder_default.json > tpl-ubuntu.json

tpl-vagrant.json: tpl-ubuntu.json
	jq -s '$(JQ_SET_POST_PROCESSOR) | .[0]' tpl-ubuntu.json tpl/postprocess_vagrant.json > tpl-vagrant.json

tpl-vsphere.json: tpl-ubuntu.json
	jq -s '$(JQ_SET_POST_PROCESSOR) | $(JQ_VMWARE_BUILDS_ONLY) | .[0]' tpl-ubuntu.json tpl/postprocess_vsphere.json > tpl-vsphere.json

publish:
	rsync -av --include '*/' --include '*.box' --exclude '*' box/ -e ssh automaton@dist.nerc-lancaster.ac.uk:/www/boxes
	ruby bin/atlas.rb register

release:
	ruby bin/atlas.rb release
	bash bin/bump.sh tag
	bash bin/bump.sh patch

clean:
	$(RM) -r output-*
	$(RM) tpl-*.json
	$(RM) box/**/*.box
