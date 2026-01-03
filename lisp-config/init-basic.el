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
  (keyboard-translate ?± ?`)
  (keyboard-translate ?§ ?~))
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

;; --- GUI       (Mac   ) ---
(when (display-graphic-p)
  (setq ns-selection-coding-system 'utf-8))

;; ---           æŽ~    ---
(defun my/clean-pasted-text ()
  "            è~æŽ~    "
  (let ((inhibit-read-only t))
    (when (use-region-p)
      (save-excursion
        (goto-char (region-beginning))
        (while (re-search-forward "[\x00-\x08\x0B\x0C\x0E-\x1F]" (region-end) t)
          (replace-match ""))))))

;;   yank      
(advice-add 'yank :after #'my/clean-pasted-text)


;; ---        ---
;; $LANG   $LC_CTYPE   UTF-8
;;  shell       
;; export LANG=zh_CN.UTF-8
;; export LC_CTYPE=zh_CN.UTF-8

(provide 'my-web-text-utf8)



;;    Emacs      
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; explore file
(provide 'init-basic)
