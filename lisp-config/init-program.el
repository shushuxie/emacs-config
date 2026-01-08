;;; lisp-config/init-program.el

;; --- 1. 自动补全 (Company + Yasnippet) ---
(use-package company
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 3
        company-tooltip-align-annotations t
        company-idle-delay 1.0
        company-selection-wrap-around t
        company-transformers '(company-sort-by-occurrence)))

(use-package company-box
  :if window-system
  :hook (company-mode . company-box-mode))

(use-package yasnippet
  :config
  (yas-global-mode 1)
  (setq yas-key-sequence '(("<tab>" . nil) ("S-<tab>" . "complete"))))

;; --- 2. 语法检查 (Flycheck) ---
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq truncate-lines nil)
  (setq lsp-prefer-flymake nil)) ; 优先使用 flycheck

;; --- 3. 编程语言基石 (LSP Mode) ---
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c-mode c++-mode python-mode javascript-mode) . lsp)
  :config
  (setq lsp-enable-symbol-highlighting t
        lsp-ui-doc-enable t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

;; --- 4. 特定语言配置 (C/C++ & Python) ---
(use-package ccls
  :after lsp-mode
  :config
  (setq lsp-clients-ccls-executable "/opt/homebrew/bin/ccls")
  (setq c-default-style "linux" 
        c-basic-offset 4))

;; --- 5. 代码运行器 (Quickrun) ---
(use-package quickrun
  :bind ("<f5>" . quickrun)
  :config
  (quickrun-add-command "c/gcc"
    '((:command . "gcc")
      (:exec    . ("%c -o %e %s" "%e"))
      (:description . "Compile C file with gcc and execute"))
    :default "c"))

   ;; --- 6. Org-Babel 多语言执行 ---
  (with-eval-after-load 'org
    (org-babel-do-load-languages
    'org-babel-load-languages
    '((python . t)
      (shell . t)
      (C . t)))
  (setq org-babel-python-command "/Library/Frameworks/Python.framework/Versions/3.11/bin/python3"))

;; --- 7. 其他小插件 ---
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package undo-tree
  :init (global-undo-tree-mode))

;; Projectile 项目管理
(use-package projectile
  :bind (("C-c p" . projectile-command-map))
  :config
  (setq projectile-track-known-projects-automatically nil)
  (projectile-mode 1))

;; Git 增强
(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  ;; 这里插入你刚才要的 GitHub 绿和可口可乐红配置
  (custom-set-faces
   '(magit-diff-added ((t (:background "#e6ffed" :foreground "#2ea44f"))))
   '(magit-diff-added-highlight ((t (:background "#acf2bd" :foreground "#1a7f37" :weight bold))))
   '(magit-diff-removed ((t (:background "#ffeef0" :foreground "#F40009"))))
   '(magit-diff-removed-highlight ((t (:background "#ffd3d9" :foreground "#d73a49" :weight bold))))))

(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :config
  ;; 1. 关键：在终端模式下使用 margin 模式显示
  (unless (display-graphic-p)
    (diff-hl-margin-mode))
  
  ;; 2. 只有在终端下微调显示字符（可选）
  (unless (display-graphic-p)
    (setq diff-hl-margin-symbols-alist
          '((insert . "┃") (delete . " ") (change . "┃") (unknown . "?") (ignored . "i"))))

  ;; 3. 配置颜色：使用你喜欢的 GitHub 绿和可口可乐红
  (custom-set-faces
   '(diff-hl-insert ((t (:foreground "#2ea44f" :background nil))))
   '(diff-hl-delete ((t (:foreground "#F40009" :background nil))))
   '(diff-hl-change ((t (:foreground "blue" :background nil)))))

  ;; 4. 实时更新（只要打字就更新状态）
  (diff-hl-flydiff-mode t))
;; Treemacs
(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
		(:map treemacs-mode-map
		 ("/" . treemacs-advanced-helpful-hydra))
        ("C-x t M-t" . treemacs-find-tag)))

;; treemacs可以使用tab
(add-hook 'treemacs-mode-hook
          (lambda ()
            (setq-local tab-width 8)))


(provide 'init-program)
