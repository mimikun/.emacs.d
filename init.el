(require 'org)
(defvar my-config-dir (concat user-emacs-directory "lisp/"))
(org-babel-load-file
 (expand-file-name "init.org" my-config-dir))
