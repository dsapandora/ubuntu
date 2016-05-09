.PHONY : clean
all:

ubuntu-tpl.json:
	jq -s '.[1] as $$b | .[0].builders |= map(.+$$b) | .[0]' tpl/base.json tpl/builder_default.json > ubuntu-tpl.json

ubuntu-vagrant-tpl.json: ubuntu-tpl.json
	jq -s '.[0]["post-processors"] = .[1] | .[0]' ubuntu-tpl.json tpl/postprocess_vagrant.json > ubuntu-vagrant-tpl.json

clean:
	$(RM) *-tpl.json