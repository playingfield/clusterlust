VAGRANT_DEFAULT_PROVIDER=vmware_fusion
.PHONY: up
up:
	vagrant up --no-provision
	vagrant provision

.PHONY: secureboot
secureboot:
	pwsh 'Set-VMFirmware -VMName "k8s-node" -EnableSecureBoot On -SecureBootTemplate "MicrosoftUEFICertificateAuthority"'

.PHONY: provision
provision:
	./provision.yml -b -l k8s_cluster

.PHONY: clean
clean:
	vagrant destroy -f
	rm -rf galaxy_roles/*

.PHONY: all
all: up provision
