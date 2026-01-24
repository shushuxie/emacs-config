;;; package management
(require 'package)
;; 1. 关键：关闭签名验证，解决 [已过期] 报错
(setq package-check-signature nil)

;;(setq package-archives '(("gnu"    . "https://mirrors.sjtug.sjtu.edu.cn/elpa/gnu/")
                         ;;("nongnu" . "https://mirrors.sjtug.sjtu.edu.cn/elpa/nongnu/")
                         ;;("melpa"  . "https://mirrors.sjtug.sjtu.edu.cn/elpa/melpa/")))
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
;; 运行完上面这段后，务必再次执行：
;; M-x package-refresh-contents

;; 忽略本地过时的缓存，强制从服务器获取最新列表
(setq package-check-signature nil) ; 如果遇到签名错误可以暂时关闭
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


;(require 'use-package)
;(setq use-package-always-ensure t) ; 以后所有的 use-package 默认都会自动下载
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)  ;; 自动安装缺失包

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
(use-package cdlatex)


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


;; 1. 创建专门的缓存目录（名字改掉，避免和旧的冲突）
(let ((my-cache-dir (expand-file-name "emacs-cache/" user-emacs-directory)))
  (unless (file-directory-p my-cache-dir)
    (make-directory my-cache-dir t))

  ;; 2. 关键：确保这些变量指向【具体文件】，而不是【目录】
  (setq savehist-file (expand-file-name "savehist" my-cache-dir))
  (setq recentf-save-file (expand-file-name "recentf" my-cache-dir))
  (setq undo-tree-history-directory-alist `(("." . ,my-cache-dir))))

;; 3. 启用模式
(savehist-mode 1)
(recentf-mode 1)

;; 4. 既然你有 rg，确保 Projectile 这样配置来过滤 elpa
(use-package projectile
  :ensure t
  :config
  (setq projectile-indexing-method 'alien)
  (setq projectile-globally-ignored-directories '("elpa" "emacs-cache" ".git"))
  (projectile-mode +1))

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

(use-package org-download
  :after org
  :config
  (setq org-download-method 'directory)
  (setq org-download-image-dir "images")
  (setq org-download-heading-lvl nil))

(setq org-startup-with-inline-images t)  ; 启动时自动显示图片
(setq org-image-actual-width nil)       ; 允许图片根据窗口大小缩放，不会大得离谱
(setq org-display-remote-inline-images 'cache) ; 如果有远程图片则缓存

;; 
(provide 'init-packages)
