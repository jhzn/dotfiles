#!/bin/bash -x

#language stuff
go install github.com/mattn/efm-langserver@latest

# GO
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/jhzn/delver@latest
go install github.com/cweill/gotests/gotests@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
