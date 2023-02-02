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

# Python
pip install --upgrade \
	black \
	flake8\
	mypy\
	python-lsp-server[all] \
	pylsp-mypy\
	python-lsp-black

npm install -g yaml-language-server
npm install -g prettier
