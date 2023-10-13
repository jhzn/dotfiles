#!/bin/bash -x

#language stuff
go install github.com/mattn/efm-langserver@latest

# GO
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/jhzn/delver@latest
go install github.com/cweill/gotests/gotests@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/daixiang0/gci@latest
go install golang.org/x/perf/cmd/benchstat@latest

go install golang.org/x/tools/...@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
go install github.com/magefile/mage@latest
go install github.com/ktr0731/evans@latest

# Python
pip install --upgrade \
	black \
	flake8\
	mypy\
	python-lsp-server[all] \
	pylsp-mypy\
	python-lsp-black

# sudo npm install -g yaml-language-server
# sudo npm install -g prettier
