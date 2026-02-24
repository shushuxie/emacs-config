;;; lexical-binding 
(setq gc-cons-threshold (* 50 1000 1000)) ;垃圾回收50M启动
;;; 配置文件加载路径
(add-to-list 'load-path "~/.emacs.d/lisp-config")
(setq custom-file "~/.emacs.d/lisp-config/custome.el")
(load custom-file)

;;; -------------org 内置版本冲突-----------------------
 ;; --- 1. 尽早处理警告，防止初始化崩溃 ---
 (setq warning-minimum-level :error) ;; 只显示错误，忽略版本不匹配警告
 (defvar warning-suppress-types nil)  ;; 预定义变量，防止 void-variable 错误

 ;; --- 2. 强制 Package 优先加载 ELPA 路径 ---
 (require 'package)
 (setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                          ("melpa" . "https://melpa.org/packages/")))
 (setq package-enable-at-startup nil) 
 (package-initialize)

 ;; 这行代码必须在任何 (require 'org) 或使用 org 功能之前执行
 (when (package-installed-p 'org)
   (add-to-list 'load-path (expand-file-name "elpa/org-*" user-emacs-directory)))


;;; -------------------------加载的模块----------------------------
(require 'init-org)
(require 'init-packages)
(require 'init-basic2)
(require 'init-ui)       ; 加载 UI 配置
(require 'init-program)
(require 'init-latex)
(require 'init-evil)
(require 'init-function) ;自己编写的函数

(provide 'init)
