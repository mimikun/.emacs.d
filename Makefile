.DEFAULT_GOAL := help

today   = $(shell date "+%Y%m%d")
product_name = emacs-conf

## Create a patch and copy it to windows
.PHONY : patch
patch : clean diff-patch copy2win-patch

## Create a patch
.PHONY : diff-patch-raw
diff-patch-raw :
	bash utils/create-patch.sh

## Create a patch
.PHONY : diff-patch
diff-patch : diff-patch-raw

## Create a patch branch
.PHONY : patch-branch
patch-branch :
	git switch -c patch-$(today)

## Switch to master branch
.PHONY : switch-master
switch-master :
	git switch master

## Delete patch branch
.PHONY : delete-branch
delete-branch : clean switch-master
	git branch --list "patch*" | xargs -n 1 git branch -D

## Run clean
.PHONY : clean
clean :
	bash utils/clean.sh

## Copy patch to Windows
.PHONY : copy2win-patch-raw
copy2win-patch-raw :
	cp *.patch $$WIN_HOME/Downloads/

## Copy patch to Windows
.PHONY : copy2win-patch
copy2win-patch : copy2win-patch-raw

## Run tests
.PHONY : test
test : lint

## Run lints
.PHONY : lint
lint : typo-check shell-lint

## Run typos
.PHONY : typo-check
typo-check :
	typos .

## Run shellcheck
.PHONY : shell-lint
shell-lint :
	bash utils/lint.sh

## Run format
.PHONY : fmt
fmt : format

## Run format
.PHONY : format
format : shell-format

## Run shfmt
.PHONY : shell-format
shell-format :
	bash utils/format.sh

## Add commit message up to `origin/master` to CHANGELOG.md
.PHONY : changelog
changelog :
	bash utils/changelog.sh

## Run git cleanfetch
.PHONY : clean-fetch
clean-fetch :
	git cleanfetch

## Run git pull
.PHONY : pull
pull :
	git pull

## Run workday morning routine
.PHONY : morning-routine
morning-routine : clean-fetch delete-branch pull patch-branch

## Show help
.PHONY : help
help :
	@make2help $(MAKEFILE_LIST)
