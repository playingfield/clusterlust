VAGRANT_DEFAULT_PROVIDER=vmware_fusion
.PHONY: up
up:
	vagrant up --no-provision
	vagrant provision

.PHONY: secureboot
secureboot:
	pwsh 'Set-VMFirmware -VMName "k8s-node" -EnableSecureBoot On -SecureBootTemplate "MicrosoftUEFICertificateAuthority"'

.PHONY: cluster
cluster:
	./cluster.yml -b

.PHONY: clean
clean:
	vagrant destroy -f

.PHONY: all
all: clean up cluster
