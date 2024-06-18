;;; package management
;; 清华镜像地址
(setq package-archives '(("gnu"    . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))


(use-package counsel
  :ensure t)
(use-package ivy
  :ensure t                          ; 确认安装，如果没有安装过 ivy 就自动安装    
  :init                              ; 在加载插件前执行命令
  (ivy-mode 1)                       ; 启动 ivy-mode
  :custom                            ; 自定义一些变量，相当于赋值语句 (setq xxx yyy)
  (ivy-use-virtual-buffers t)        ; 一些官网提供的固定配置
  (ivy-count-format "(%d/%d) ") 
  :bind                              ; 以下为绑定快捷键
  ("C-s" . 'swiper-isearch)          ; 绑定快捷键 C-s 为 swiper-search，替换原本的搜索功能
  ("M-x" . 'counsel-M-x)             ; 使用 counsel 替换命令输入，给予更多提示
  ("C-x C-f" . 'counsel-find-file)   ; 使用 counsel 做文件打开操作，给予更多提示
  ("M-y" . 'counsel-yank-pop)        ; 使用 counsel 做历史剪贴板粘贴，可以展示历史
  ("C-x b" . 'ivy-switch-buffer)     ; 使用 ivy 做 buffer 切换，给予更多提示
  ("C-c v" . 'ivy-push-view)         ; 记录当前 buffer 的信息
  ("C-c s" . 'ivy-switch-view)       ; 切换到记录过的 buffer 位置
  ("C-c V" . 'ivy-pop-view)          ; 移除 buffer 记录
  ("C-x C-SPC" . 'counsel-mark-ring) ; 使用 counsel 记录 mark 的位置
  ("<f2> f" . 'counsel-describe-function)
  ("<f2> v" . 'counsel-describe-variable)
  ("<f2> i" . 'counsel-info-lookup-symbol))
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(use-package hydra
  :ensure t)

(use-package use-package-hydra
  :ensure t
  :after hydra) 

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

(use-package winum
  :ensure t
  :config
  (winum-mode))

(use-package smart-mode-line
  :ensure t
  :init (sml/setup))

(use-package good-scroll
  :ensure t
  :if window-system          ; 在图形化界面时才使用这个插件
  :init (good-scroll-mode))


(use-package which-key
  :ensure t
  :init (which-key-mode))



(use-package avy
  :ensure t
  :bind
  (("C-j C-SPC" . avy-goto-char-timer)))


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



 (use-package dashboard
  :ensure t
  :config
  (setq dashboard-banner-logo-title "努力进步") ;; 个性签名，随读者喜好设置
  (setq dashboard-projects-backend 'projectile) ;; 读者可以暂时注释掉这一行，等安装了 projectile 后再使用
  (setq dashboard-startup-banner 'official) ;; 也可以自定义图片
  (setq dashboard-items '((recents  . 8)   ;; 显示多少个最近文件
			  (bookmarks . 8)  ;; 显示多少个最近书签
			  (projects . 3))) ;; 显示多少个最近项目
  (dashboard-setup-startup-hook))


(use-package highlight-symbol
  :ensure t
  :init (highlight-symbol-mode)
    :bind ("<f5>" . highlight-symbol)) ;; 按下 F3 键就可高亮当前符号

;; 嵌套括号显示不同颜色
(use-package rainbow-delimiters
  :ensure t
    :hook (prog-mode . rainbow-delimiters-mode))

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

(use-package treemacs
  :ensure t
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


;(require 'treemacs)
(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package magit
    :bind (("C-x g" . magit)))

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom));; 定制符号
;; 定制颜色
(set-face-foreground 'git-gutter:modified "blue")
(set-face-foreground 'git-gutter:added "#00FF00")
(set-face-foreground 'git-gutter:deleted "red")
(global-git-gutter-mode 1) ; 这一行开启了全局模式

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


(use-package doom-themes
  :ensure t
  :config
  ;; Load the doom-one,dracula theme
  (load-theme 'doom-one-light t))


;; 
(provide 'init-packages)
