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
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(use-package hydra
  :ensure t)

(use-package cl);delete*

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

(use-package smart-mode-line
  :ensure t
  :init (sml/setup))

(use-package good-scroll
  :ensure t
  :if window-system          ; 在图形化界面时才使用这个插件
  :init (good-scroll-mode))


;(use-package which-key
  ;:ensure t
  ;:init (which-key-mode))
(require 'which-key)
(which-key-mode)


(global-set-key (kbd "C-j") nil)

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



(use-package multiple-cursors
  :ensure t
  :after hydra
  :bind
  (("C-x C-h m" . hydra-multiple-cursors/body)
   ("C-S-<mouse-1>" . mc/toggle-cursor-on-click))
  :hydra (hydra-multiple-cursors
		  (:hint nil)
		  "
Up^^             Down^^           Miscellaneous           % 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")
------------------------------------------------------------------
 [_p_]   Prev     [_n_]   Next     [_l_] Edit lines  [_0_] Insert numbers
 [_P_]   Skip     [_N_]   Skip     [_a_] Mark all    [_A_] Insert letters
 [_M-p_] Unmark   [_M-n_] Unmark   [_s_] Search      [_q_] Quit
 [_|_] Align with input CHAR       [Click] Cursor at point"
		  ("l" mc/edit-lines :exit t)
		  ("a" mc/mark-all-like-this :exit t)
		  ("n" mc/mark-next-like-this)
		  ("N" mc/skip-to-next-like-this)
		  ("M-n" mc/unmark-next-like-this)
		  ("p" mc/mark-previous-like-this)
		  ("P" mc/skip-to-previous-like-this)
		  ("M-p" mc/unmark-previous-like-this)
		  ("|" mc/vertical-align)
		  ("s" mc/mark-all-in-region-regexp :exit t)
		  ("0" mc/insert-numbers :exit t)
		  ("A" mc/insert-letters :exit t)
		  ("<mouse-1>" mc/add-cursor-on-click)
		  ;; Help with click recognition in this hydra
		  ("<down-mouse-1>" ignore)
		  ("<drag-mouse-1>" ignore)
		  ("q" nil)))


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




;(use-package company
;  :ensure t
;  :init (global-company-mode)
;  :config
;  (setq company-minimum-prefix-length 1) ; 只需敲 1 个字母就开始进行自动补全
;  (setq company-tooltip-align-annotations t)
;  (setq company-idle-delay 0.0)
;  (setq company-show-numbers t) ;; 给选项编号 (按快捷键 M-1、M-2 等等来进行选择).
;  (setq company-selection-wrap-around t)
;  (setq company-transformers '(company-sort-by-occurrence))) ; 根据选择的频率进行排序，读者如果不喜欢可以去掉

;(use-package company-box
;  :ensure t
;  :if window-system
;    :hook (company-mode . company-box-mode))


;; 智能补全
;(use-package company-tabnine
;  :ensure t
;  :init (add-to-list 'company-backends #'company-tabnine))


;; 存储代码片段???
;(use-package yasnippet
  ;:ensure t
  ;:hook
  ;(prog-mode . yas-minor-mode)
  ;:config
  ;(yas-reload-all)
  ;;; add company-yasnippet to company-backends
  ;(defun company-mode/backend-with-yas (backend)
    ;(if (and (listp backend) (member 'company-yasnippet backend))
	;backend
      ;(append (if (consp backend) backend (list backend))
	      ;'(:with company-yasnippet))))
  ;(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
  ;;; unbind <TAB> completion
  ;(define-key yas-minor-mode-map [(tab)]        nil)
  ;(define-key yas-minor-mode-map (kbd "TAB")    nil)
  ;(define-key yas-minor-mode-map (kbd "<tab>")  nil)
  ;:bind
  ;(:map yas-minor-mode-map ("S-<tab>" . yas-expand)))
;
;(use-package yasnippet-snippets
  ;:ensure t
    ;:after yasnippet)


; 文本补全，输入前几个字符补全文档中相似的字符
(global-set-key (kbd "M-/") 'hippie-expand)

(use-package flycheck
  :ensure t
  :config
  (setq truncate-lines nil) ; 如果单行信息很长会自动换行
  :hook
    (prog-mode . flycheck-mode))


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
  ;; Load the doom-one theme
  (load-theme 'leuven t))

;; 
(provide 'init-packages)
