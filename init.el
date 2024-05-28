;;; lexical-binding 
(setq gc-cons-threshold (* 50 1000 1000)) ;垃圾回收50M启动
;;; 配置文件加载路径
(add-to-list 'load-path "~/.emacs.d/lisp-config")
(require 'init-basic)
(require 'init-packages)
(require 'init-org)
(require 'custome)
;(setq custom-file "~/.emacs.d/lisp-config/custome.el")
;(load custom-file)
(setq-default word-wrap t);;文本自动换行显示

;;; custom org emhasis color
(require 'org)
(setq org-emphasis-alist
      (cons '("+" '(:strike-through t :foreground "gray"))
	    (delete* "+" org-emphasis-alist :key 'car :test 'equal)))

(setq org-emphasis-alist
      (cons '("*" '(:emphasis t :foreground "red"))
	                (delete* "*" org-emphasis-alist :key 'car :test 'equal)))

;;;; end
(setq valign-fancy-bar t) ;表格支持像素级对齐

;; vim输入法切换
;(defun my-evil-insert-state-input-method ()
    ;"Switch to Chinese input method in insert state."
    ;(set-input-method "chinese-py"))
;
;(defun my-evil-normal-state-input-method ()
    ;"Switch back to default (usually English) input method in normal state."
    ;(set-input-method nil))
;
;(add-hook 'evil-insert-state-exit-hook 'my-evil-normal-state-input-method)



;; 加载不同模块


;; org-bable
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   (C .t)))

(setq org-confirm-babel-evaluate nil);风险提示关闭


(setq org-babel-python-command "/Library/Frameworks/Python.framework/Versions/3.11/bin/python3")


