;;; lexical-binding 
(setq gc-cons-threshold (* 50 1000 1000)) ;垃圾回收50M启动
;;; 配置文件加载路径
(add-to-list 'load-path "~/.emacs.d/lisp-config")
(setq custom-file "~/.emacs.d/lisp-config/custome.el")
(load custom-file)
(require 'init-basic)
(require 'init-packages)
(require 'init-org)
(require 'init-latex)
(require 'init-evil)
(require 'init-program)
(setq-default word-wrap t);;文本自动换行显示

;;; custom org emhasis color
;(require 'org)
;(setq org-emphasis-alist
      ;(cons '("+" '(:strike-through t :foreground "gray"))
	    ;(delete* "+" org-emphasis-alist :key 'car :test 'equal)))
;
;(setq org-emphasis-alist
      ;(cons '("*" '(:emphasis t :foreground "red"))
	                ;(delete* "*" org-emphasis-alist :key 'car :test 'equal)))

;;;; end
(setq valign-fancy-bar t) ;表格支持像素级对齐

;; org-bable
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   (C .t)))

(setq org-confirm-babel-evaluate nil);风险提示关闭
(setq org-babel-python-command "/Library/Frameworks/Python.framework/Versions/3.11/bin/python3")
;(set-frame-font "SF Mono 16")
(setq default-frame-alist
      '((font . "SF Mono 16"))) ; 设置整个frame的默认字体为SF Mono Bold，大小为12pt
(setq default-text-scale-factor 1.0) ; 如果需要，可以调整文本缩放比例
(setq dap-lldb-debug-program '("/usr/local/bin/lldb-mi"))

;; 启用保存位置模式
(save-place-mode 1)
;; 配置保存位置的文件路径
(setq save-place-file (concat user-emacs-directory "places"))
;; 确保每个 buffer 都记录位置
(setq-default save-place t)
(global-hl-line-mode t)

(provide 'init)
