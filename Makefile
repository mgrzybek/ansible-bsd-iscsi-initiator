#
# ansible-bsd-iscsi-initiator
#

.PHONY: lint ## Test YAML syntax
lint:
	@ansible-lint .

.PHONY: help ## This help message
help:
	@awk -F: \
		'/^([a-z-]+): [a-z\/- ]*## (.+)$$/ {gsub(/: .*?\s*##/, "\t");print}' \
		Makefile \
	| expand -t20 \
	| sort
