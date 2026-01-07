;;; lisp-config/init-org.el
(defvar org-default-notes-file nil)
(use-package org
  :ensure nil  ; org 是自带的，不需要 ensure
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  ;; --- 1. 基础变量设置 (解决 Void Variable 的核心) ---
  (setq org-hide-emphasis-markers t
        org-use-fast-tag-selection 'expert
        org-ellipsis " ▾ "
        org-special-ctrl-a/e t
        org-hide-block-startup t
        org-startup-folded 'content
        org-startup-with-inline-images t
        org-startup-with-latex-preview t)

  ;; --- 2. Agenda 与 Capture ---
  (setq org-default-notes-file "~/Documents/capture/gtd.org")
  (setq org-agenda-files
        (append
         (directory-files-recursively "~/Documents/typora" "\\.org$")
         (directory-files-recursively "~/Documents/capture" "\\.org$")))
  
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/Documents/capture/gtd.org" "Tasks")
           "* TODO %?\n %i\n %a")
          ("d" "daily task" entry(file+datetree "~/Documents/capture/smallThings.org")
           "* TODO [%] \n  - [ ] %?\n  :LOGBOOK:\n  - timestamp:%T\n  :END:")
          ("n" "notes" entry(file+datetree "~/Documents/capture/note.org")
           "* %?\nEntered on %U\n %i")
          ("j" "Journal,日志" entry (file+datetree "~/Documents/capture/journal.org")
           "* %?\nEntered on %U\n %i\n %a")))

  ;; --- 3. 样式与面孔 (Faces) ---
  (defface org-bold
    '((t :foreground "#d2268b" :background "#fefefe" :weight bold :underline t :overline t))
    "Face for org-mode bold.")

  (setq org-emphasis-alist
        '(("*" org-bold) ("/" italic) ("_" underline) ("=" org-verbatim verbatim)
          ("~" org-code verbatim) ("+" (:strike-through t))))

  (custom-set-faces
   '(outline-1 ((t (:weight extra-bold :height 1.25))))
   '(outline-2 ((t (:weight bold :height 1.15))))
   '(org-document-title ((t (:height 1.2)))))
   

  ;; --- 4. 模板与钩子 ---
  (add-to-list 'org-structure-template-alist '("x" . "latex"))
  (add-hook 'org-mode-hook (lambda () (setq line-spacing 0.25))))

;; --- 5. Org 扩展插件 (独立出来) ---
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil))

(use-package valign
  :hook (org-mode . valign-mode)
  :config (setq valign-fancy-bar t))

(use-package org-download
  :bind (:map org-mode-map
              ("C-S-y" . org-download-screenshot)
              ("C-S-p" . org-download-clipboard))
  :config
  (setq org-download-link-format "[[file:%s]]")
  (add-hook 'org-mode-hook (lambda () (setq org-download-image-dir "./images"))))

(provide 'init-org)
