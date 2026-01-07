;;; package management
;; 清华镜像地址
(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(require 'use-package)
(setq use-package-always-ensure t) ; 以后所有的 use-package 默认都会自动下载

;; 列表开始...
;; 基础工具
(use-package amx)
(use-package ace-window)
(use-package mwim)
(use-package winum)
(use-package which-key)
(use-package avy)
(use-package undo-tree)
(use-package hydra)
(use-package use-package-hydra)

;; 搜索与 UI
(use-package ivy)
(use-package counsel)
(use-package swiper)
(use-package marginalia)
(use-package dashboard)
(use-package rainbow-delimiters)
(use-package highlight-symbol)
(use-package doom-themes)
(use-package diff-hl)
(use-package ivy-posframe)

;; 项目与 Git
(use-package projectile)
(use-package counsel-projectile)
(use-package magit)
(use-package git-gutter)
(use-package git-gutter-fringe)

;; Treemacs 系列
(use-package treemacs)
(use-package treemacs-icons-dired)
(use-package treemacs-magit)
(use-package treemacs-projectile)

;; 其他
(use-package good-scroll)
(use-package org-bullets)
;; 在 init-packages.el 中添加这些
(use-package company)
(use-package company-box)
(use-package yasnippet)
(use-package flycheck)
(use-package lsp-mode)
(use-package lsp-ui)
(use-package ccls)
(use-package quickrun)



; 记录输入命令的频率，优先显示
(use-package amx
  :ensure t
  :init (amx-mode))

(use-package ace-window
  :ensure t
  :bind (("C-x o" . 'ace-window)))

(use-package mwim
  :ensure t
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

(use-package smart-mode-line
  :ensure t
  :init (sml/setup))

(use-package good-scroll
  :ensure t
  :if window-system          ; 在图形化界面时才使用这个插件
  :init (good-scroll-mode))

(use-package marginalia
  :ensure t
  :init (marginalia-mode)
  :bind (:map minibuffer-local-map
			  ("M-A" . marginalia-cycle)))

(use-package undo-tree
  :ensure t
  :init (global-undo-tree-mode)
  :after hydra
  :bind ("C-x C-h u" . hydra-undo-tree/body)
  :hydra (hydra-undo-tree (:hint nil)
  "
  _p_: undo  _n_: redo _s_: save _l_: load   "
  ("p"   undo-tree-undo)
  ("n"   undo-tree-redo)
  ("s"   undo-tree-save-history)
  ("l"   undo-tree-load-history)
  ("u"   undo-tree-visualize "visualize" :color blue)
  ("q"   nil "quit" :color blue)))

(use-package highlight-symbol
  :ensure t
  :init (highlight-symbol-mode)
    :bind ("<f5>" . highlight-symbol)) ;; 按下 F3 键就可高亮当前符号

(use-package projectile
  :ensure t
  :bind (("C-c p" . projectile-command-map))
  :config
  (setq projectile-mode-line "Projectile")
  (setq projectile-track-known-projects-automatically nil))

(use-package counsel-projectile
  :ensure t
  :after (projectile)
    :init (counsel-projectile-mode))


;(require 'treemacs)
(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)


(use-package treemacs-magit
  :after (treemacs magit)
    :ensure t)

(use-package treemacs-projectile
  :ensure t
  :after (treemacs projectile)
  :config
  (require 'treemacs-projectile))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; 
(provide 'init-packages)
