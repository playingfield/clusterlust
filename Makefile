.PHONY: up
up:
	vagrant up --no-provision
	vagrant provision

.PHONY: provision
provision:
	./provision.yml -b -l k8s_cluster

.PHONY: clean
clean:
	vagrant destroy -f
	rm -rf roles/openssh

.PHONY: all
all: up provision
