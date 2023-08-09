#
# ansible-bsd-iscsi-initiator
#

.PHONY: lint ## Test YAML syntax
lint:
	@ansible-lint .

.PHONY: vagrant-variables ## Test vagrant env variables
vagrant-variables:
	@echo -n "Checking VAGRANT_BOX_NAME... "
	@[ ! "$$VAGRANT_BOX_NAME" = "" ] && echo OK

.PHONY: vagrant-destroy ## Destroy vagrant boxes
vagrant-destroy:
	@vagrant destroy -f

.PHONY: vagrant-vbox ## Test the playbook using vagrant and virtualbox
vagrant-vbox: vagrant-variables
	@vagrant up --provider=virtualbox
	@vagrant provision

.PHONY: help ## This help message
help:
	@awk -F: \
		'/^([a-z-]+): [a-z\/- ]*## (.+)$$/ {gsub(/: .*?\s*##/, "\t");print}' \
		Makefile \
	| expand -t20 \
	| sort
