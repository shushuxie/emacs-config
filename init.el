;;; lexical-binding 
(setq gc-cons-threshold (* 50 1000 1000)) ;垃圾回收50M启动
;;; 配置文件加载路径
(add-to-list 'load-path "~/.emacs.d/lisp-config")
(setq custom-file "~/.emacs.d/lisp-config/custome.el")
(load custom-file)
(require 'init-basic2)
(require 'init-function) ;自己编写的函数
(require 'init-packages)
(require 'init-latex)
(require 'init-evil)
(require 'init-program)
(require 'init-org)


(provide 'init)
