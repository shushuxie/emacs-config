;;; lexical-binding 
(setq gc-cons-threshold (* 50 1000 1000)) ;垃圾回收50M启动
;;; 配置文件加载路径
(add-to-list 'load-path "~/.emacs.d/lisp-config")
(setq custom-file "~/.emacs.d/lisp-config/custome.el")
(load custom-file)
(require 'init-packages)
(require 'init-basic2)
(require 'init-ui)       ; 加载 UI 配置
(require 'init-program)
(require 'init-latex)
(require 'init-evil)
(require 'init-org)
(require 'init-function) ;自己编写的函数

(provide 'init)
