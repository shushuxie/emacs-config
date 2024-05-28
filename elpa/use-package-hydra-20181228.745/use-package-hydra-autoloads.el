;;; use-package-hydra-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from use-package-hydra.el

(defalias 'use-package-normalize/:hydra 'use-package-hydra--normalize "\
Normalize for the definition of one or more hydras.")
(autoload 'use-package-handler/:hydra "use-package-hydra" "\
Generate defhydra with NAME for `:hydra' KEYWORD.
ARGS, REST, and STATE are prepared by `use-package-normalize/:hydra'.

(fn NAME KEYWORD ARGS REST STATE)")
(register-definition-prefixes "use-package-hydra" '("use-package-hydra--n"))

;;; End of scraped data

(provide 'use-package-hydra-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; use-package-hydra-autoloads.el ends here
