;; -*- coding: utf-8 -*-
;;; basic config include bootstra
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
			 ("popkit" . "http://elpa.popkit.org/packages/")))
(package-initialize)

;; basic config
(setq confirm-kill-emacs #'yes-or-no-p)      ;     Emacs               
(electric-pair-mode t)                       ;       
(add-hook 'prog-mode-hook #'show-paren-mode) ;                     
(column-number-mode t)                       ;   Mode line      
(global-auto-revert-mode t)                  ;               Emacs      Buffer
(delete-selection-mode t)                    ;                                  
(setq inhibit-startup-message t)             ;      Emacs       
(setq make-backup-files nil)                 ;         
(add-hook 'prog-mode-hook #'hs-minor-mode)   ;              
(global-display-line-numbers-mode 1)         ;   Window     
(tool-bar-mode -1)                           ;           Tool bar
(when (display-graphic-p) (toggle-scroll-bar -1)) ;           
(setq custom-safe-themes t) ;           

(savehist-mode 1)                            ;        Buffer       
(setq display-line-numbers-type 'relative)   ;           
;(add-to-list 'default-frame-alist '(width . 90))  ;                  Frame        
;(add-to-list 'default-frame-alist '(height . 55)) ;                  Frame        
(require 'org-tempo) ;  <c         
(fset 'yes-or-no-p 'y-or-n-p)

(setq org-confirm-babel-evaluate nil);      
;(set-frame-font "SF Mono 16")
(setq default-frame-alist
      '((font . "SF Mono 16"))) ;     frame      SF Mono Bold    12pt
(setq default-text-scale-factor 1.0) ;                
(setq dap-lldb-debug-program '("/usr/local/bin/lldb-mi"))

;;         
(save-place-mode 1)
;;            
(setq save-place-file (concat user-emacs-directory "places"))
;;      buffer      
(setq-default save-place t)
(global-hl-line-mode -1) ;       

;;        start
(defun my-keyboard-translate ()
  (keyboard-translate ?� ?`)
  (keyboard-translate ?� ?~))
(add-hook 'after-init-hook 'my-keyboard-translate)
;;        end

;;       
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil) ;    Emacs     `ls-lisp`
(setq ls-lisp-UCA-like-collation t) ;       



;;    org-element-cache   
(require 'warnings)

;;    org-element-cache   
(add-hook 'after-init-hook
          (lambda ()
            (with-eval-after-load 'org
              (add-to-list 'warning-suppress-types '(org-element-cache)))))
;;      
(defun my-disable-bell-in-org-mode ()
  "Disable bell in Org mode."
  (setq-local ring-bell-function 'ignore))

(add-hook 'org-mode-hook #'my-disable-bell-in-org-mode)

;; globe kbd
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

(global-set-key (kbd "C-j") nil)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-c C- ") 'org-insert-structure-template)
(global-set-key (kbd "C-S-y") 'org-download-clipboard-resize)

;;   
;;      
(set-face-attribute 'default nil :height 160)

;; minibuffer prompt   
(set-face-attribute 'minibuffer-prompt nil :height 240)


;; ===============================
;; Emacs           
;;    Mac GUI   Terminal
;; ===============================

;; ---        ---
;;      UTF-8 
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(setq org-tag-alist
      '(
	(:startgroup)
	;; 内容性质
	("记录" . ?j)
	("思考" . ?t)
	("总结" . ?z)
	(:endgroup)

	(:startgroup)
	;; 领域
	("编程" . ?c)
	("emacs" . ?e)
	("算法" . ?a)
	("工具" . ?g)
	("阅读" . ?r)
	(:endgroup)

	(:startgroup)
	;; 状态/价值
	("待整理" . ?d)
	("重要" . ?i)
	("长期" . ?l)
	("个人" . ?p)
	("情绪" . ?q)
	(:endgroup)
	))

;; 强制转码utf-8
(defun my/force-buffer-utf8 ()
  "Force the current buffer to UTF-8 encoding, replacing invalid characters.
Handles old files with non-UTF8 or hidden chars.
Disables org-appear temporarily to avoid hook errors."
  (interactive)
  (let ((orig-point (point))
        (org-appear-was-enabled (and (boundp 'org-appear-mode) org-appear-mode)))
    (when org-appear-was-enabled
      (org-appear-mode -1)) ;; 临时关闭
    (condition-case err
        (progn
          ;; 重新以 utf-8-unix 读取 buffer 内容
          (revert-buffer-with-coding-system 'utf-8-unix)
          ;; 设置 buffer 默认编码为 utf-8
          (set-buffer-file-coding-system 'utf-8-unix)
          (setq buffer-file-coding-system 'utf-8-unix)
          (goto-char orig-point)
          (message "Buffer successfully converted to UTF-8."))
      (error
       (message "Failed to convert buffer to UTF-8: %s" (error-message-string err))))
    ;; 恢复 org-appear
    (when org-appear-was-enabled
      (org-appear-mode 1))))
(defun my/force-buffer-utf8 ()
  "Force the current buffer to UTF-8 encoding, replacing invalid characters.
This works for old files with non-UTF8 or hidden characters.
After running, buffer-file-coding-system will be set to 'utf-8-unix'."
  (interactive)
  (let ((orig-point (point)))  ;; 保存光标位置
    (condition-case err
        (progn
          ;; 重新以 utf-8-unix 读取 buffer 内容
          (revert-buffer-with-coding-system 'utf-8-unix)
          ;; 设置 buffer 默认编码为 utf-8
          (set-buffer-file-coding-system 'utf-8-unix)
          ;; 修正 mode line
          (setq buffer-file-coding-system 'utf-8-unix)
          ;; 恢复光标
          (goto-char orig-point)
          (message "Buffer successfully converted to UTF-8."))
      (error
       ;; 如果出现错误，提示用户
       (message "Failed to convert buffer to UTF-8: %s" (error-message-string err))))))


;; 终端剪贴板可以使用y,p复制粘贴
(unless (display-graphic-p)      ; 如果不是图形界面（即在终端里）
  (when (fboundp 'osx-clipboard-mode)
    (osx-clipboard-mode 1)))     ; 开启 macOS 剪切板同步


;;    Emacs      
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; explore file
(provide 'init-basic)
