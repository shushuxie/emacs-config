(require 'org)

;; 更改行间距        
(with-eval-after-load 'org
  (setq line-spacing 0.25))
     
   (defface org-bold
  '((t :foreground "#d2268b"
     :background "#fefefe"
     :weight bold
     :underline t
     :overline t))
  "Face for org-mode bold."
  :group 'org-faces )


;; 添加新模板到现有的 org-structure-template-alist 中
(add-to-list 'org-structure-template-alist '("x" . "latex"))

;; 隐藏强调标记
(setq org-hide-emphasis-markers t)

;; 自定义强调样式
(setq org-emphasis-alist
      '(("*" org-bold)
        ("/" italic)
        ("_" underline)
        ("=" org-verbatim verbatim)
        ("~" org-code verbatim)
        ("+" (:strike-through t))))

;; 设置加粗和原文样式的背景颜色
(set-face-background 'org-bold "#fefefe")
(set-face-background 'org-verbatim "#fefefe")


;;; todo技巧
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i!)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")
	))

;;capture
(setq org-default-notes-file  "~/Documents/capture/gtd.org")
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Documents/capture/gtd.org" "Tasks")
	 "* TODO %?\n %i\n %a")
	("d" "daily task" entry(file+datetree "~/Documents/capture/smallThings.org")
	 "* TODO [%] \n  - [ ] %?\n  :LOGBOOK:\n  - timestamp:%T\n  :END:")
	("n" "notes" entry(file+datetree "~/Documents/capture/note.org")
	 "* %?\nEntered on %U\n %i")
	("j" "Journal,日志" entry (file+datetree "~/Documents/capture/journal.org")
	          "* %?\nEntered on %U\n %i\n %a")))


;(setq org-agenda-use-time-grid nil);关闭每天时间分割线
(setq org-agenda-use-time-grid nil);关闭小时分割线
(setq org-agenda-hide-tags-regexp ".");关闭标签
(setq org-agenda-skip-scheduled-if-done t);关闭已完成事项
(setq org-agenda-hide-done-tasks t);隐藏已完成事项
(setq org-agenda-window-setup 'current-window);窗口显示
(setq org-agenda-deadline-faces
      '((1.001 . error)
        (1.0 . org-warning)
        (0.5 . org-upcoming-deadline)
        (0.0 . org-upcoming-distant-deadline)));紧迫感线条

;;; list 样式
(font-lock-add-keywords
 'org-mode
 '(("^ +\\([-*]\\) "
    (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "▻"))))))


(with-eval-after-load 'org
  (setq org-special-ctrl-a/e t));使用ctrl移动到开头和结尾

;; 更改headline样式
(with-eval-after-load 'org
  (custom-set-faces
   '(outline-1 ((t (:weight extra-bold :height 1.25))))
   '(outline-2 ((t (:weight bold :height 1.15))))
   '(outline-3 ((t (:weight bold :height 1.12))))
   '(outline-4 ((t (:weight semi-bold :height 1.09))))
   '(outline-5 ((t (:weight semi-bold :height 1.06))))
   '(outline-6 ((t (:weight semi-bold :height 1.03))))
   '(outline-8 ((t (:weight semi-bold))))
   '(outline-9 ((t (:weight semi-bold))))
   '(org-document-title ((t (:height 1.2))))))

    
(use-package pangu-spacing
  :ensure t
  :config
  (global-pangu-spacing-mode 1)
  ;; 在中英文符号之间真正地插入空格
  (setq pangu-spacing-real-insert-separator t))

;; 更改链接 斜体样式
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil))

     
  ;; 中英文混排table显示 
(use-package valign
  :config
  (setq valign-fancy-bar t)
  (add-hook 'org-mode-hook #'valign-mode))
     
(setq valign-fancy-bar t) ;表格支持像素级对齐

;; 替换折叠状态符号
(with-eval-after-load 'org
  (setq org-ellipsis " ▾ "))

;; 行内折叠代码块,alt+tab迅速折叠
(defun my-search-and-tab ()
  "Search for '#+' and trigger TAB key."
  (interactive)
  (let ((case-fold-search nil)) ; Ensure case-sensitive search
    (if (search-forward "#+end" nil t)
        (progn
          (goto-char (match-beginning 0))
          (call-interactively 'org-cycle))
      (message "No '#+end' found in the buffer"))))


;;; 代码块默认折叠
;; 确保所有代码块默认折叠
(setq org-startup-folded 'content)
(setq org-startup-with-inline-images t)
(setq org-startup-with-latex-preview t)
(setq org-hide-block-startup t)

(defun my-org-mode-setup ()
  "Custom configurations for Org mode."
  ;; 遍历所有代码块并折叠
  (org-babel-map-src-blocks nil
    (org-hide-block-all)))

(add-hook 'org-mode-hook 'my-org-mode-setup)
;;;===============================


;;; org-download
(use-package org-download
  :ensure t
  :config
  ;; 自动插入相对路径
  (setq org-download-link-format "[[file:%s]]")
  ;; 绑定快捷键
  (define-key org-mode-map (kbd "C-S-y") 'org-download-screenshot)
  (define-key org-mode-map (kbd "C-S-p") 'org-download-clipboard))

(add-hook 'org-mode-hook
          (lambda ()
            (setq org-download-image-dir "./images")
            (message "org-download-image-dir: %s" org-download-image-dir)))

(provide 'init-org)
