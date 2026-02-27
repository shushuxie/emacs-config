;;; 一些关于ui的配置


;;; --------界面与外观设置 (UI)-------------
(setq inhibit-startup-message t)      ; 禁用启动闪屏
(tool-bar-mode -1)                    ; 禁用工具栏
(when (display-graphic-p) 
  (toggle-scroll-bar -1))             ; 禁用滚动条
(global-display-line-numbers-mode -1)  ; 显示行号
(setq display-line-numbers-type 'relative) ; 使用相对行号 (Evil用户必备)
(column-number-mode t)                ; 在状态栏显示列号
(global-hl-line-mode -1)              ; 禁用当前行高亮 (需要时设为 1)

;;; --------minibuffer 设置----------------
;;(set-face-attribute 'minibuffer-prompt nil :height 180) ; 提示符稍微大一点即可
(when (display-graphic-p)
  (defun my/minibuffer-font ()
    (set-face-attribute 'default nil :height 150)
    (set-face-attribute 'minibuffer-prompt nil :height 150))
  (add-hook 'minibuffer-setup-hook #'my/minibuffer-font))

;;; --------字体设置--------------------------------
(condition-case err
    (set-face-attribute 'default nil :font "Hack Nerd Font Mono"
                        :height 160)
  (error
   (message "字体设置失败: %s" (error-message-string err))))

;; 基础 UI 优化，增加容错
(setq inhibit-startup-message t) ; 关闭启动画面

;; 安全地关闭图形组ht件
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;; --------主题配置--------------------
 (use-package doom-themes
   :ensure t
   :config
   ;(load-theme 'doom-one-light t))
   ;(load-theme 'dracula t))
   (load-theme 'leuven t))
   ;; (load-theme 'modus-vivendi t)) ; 深色
    ;(load-theme 'modus-operandi t)) ; 浅色
    ;; (load-theme 'doom-monokai-classic t)) ; 浅色
   ;(load-theme 'tsdh-light t))
   ; (load-theme 'doom-tomorrow-day t))
   ;(load-theme 'tsdh-dark t))

(setq custom-safe-themes t)           ; 信任所有已安装的主题


;;; --------mode line配置---------------
;; ------------------------------------------
;; 1. 暴力清理状态栏中的插件名 (Minor Mode Lighters)
;; ------------------------------------------
(defun my/clean-minor-mode-lighters ()
  "强制删除状态栏中显示的所有 Minor Mode 缩写。"
  (let ((quiet-modes '(yas-minor-mode 
                       ivy-mode 
                       company-mode 
                       undo-tree-mode 
                       flycheck-mode 
                       git-gutter-mode 
                       hs-minor-mode 
                       projectile-mode
                       eldoc-mode
                       which-key-mode)))
    (dolist (m quiet-modes)
      (setq minor-mode-alist (assq-delete-all m minor-mode-alist)))))

(add-hook 'after-init-hook #'my/clean-minor-mode-lighters)
;; ------------------------------------------
;; 2. 时间日期设置
;; ------------------------------------------
(setq display-time-format " %H:%M ")         ; 只显示 00:22 这种格式，因为后面已经有日期了
(setq display-time-default-load-average nil) ; 禁用负载显示
(setq display-time-day-and-date nil)         ; 禁用默认的日期（因为我们要自己排版）
(display-time-mode 1)

;; ------------------------------------------
;; 3. 自定义状态栏布局 (极简版)
;; ------------------------------------------
(setq-default mode-line-format
      '("%e"
        mode-line-front-space
        ;; 1. 状态与编码
        " "
        mode-line-mule-info
        mode-line-modified
        " "

        ;; 2. 文件名与位置
        mode-line-buffer-identification
        "  "
        mode-line-position

        ;; 3. 模式信息 (例如 [ELisp/d])
        "  [" (:eval (format-mode-line mode-name)) "] "

        ;; 4. 弹簧：将后面的内容推向最右边
        ;; 注意：如果你的 Git 分支名很长，可以把 35 这个数字调大一点
        (:propertize " " display (space :align-to (- right 35)))

        ;; 5. Git 信息 (VC Mode) - 动态颜色显示
        (:eval (when vc-mode
                 (let ((state-color (if (buffer-modified-p) 
                                        "#F40009"   ; 已修改显示为暖红色
                                      "#2ea44f")))  ; 干净状态显示为草绿色
                   (propertize (format-mode-line vc-mode) 
                               'face `(:foreground ,state-color :weight bold)))))
        ;; 6. 日期时间 (年份放最后)
        "  "
        (:eval (format-time-string "%H:%M %Y-%m-%d"))
        mode-line-end-spaces))

;;; --------Ivy/Counsel 交互配置-------------
;; 2. 增强后的 Ivy 配置
(use-package ivy
  :ensure t
  :init (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  (ivy-height 20)
  :config
  ;; --- 1. 定义拼音逻辑 (保持不变) ---
  (defun my-ivy-cregexp-helper (str)
    (if (string-match-p "^[[:ascii:]]+$" str)
        (let ((regexp (pinyinlib-build-regexp-string str)))
          (if (stringp regexp) regexp (ivy--regex-plus str)))
      (ivy--regex-plus str)))

  (defun my-ivy-re-builder-pinyin (str)
    (or (my-ivy-cregexp-helper str) (ivy--regex-plus str)))

  ;; --- 2. 核心：大一统匹配规则 ---
  ;; 把所有相关的函数名全部塞进去
  (setq ivy-re-builders-alist
        '((counsel-projectile-find-file . my-ivy-re-builder-pinyin)
          (counsel-projectile-find-dir . my-ivy-re-builder-pinyin)
          (counsel-projectile-switch-project . my-ivy-re-builder-pinyin)
          (projectile-find-file . my-ivy-re-builder-pinyin)
          (read-file-name-internal . my-ivy-re-builder-pinyin)
          (ivy-switch-buffer . my-ivy-re-builder-pinyin)
          (swiper . my-ivy-re-builder-pinyin)
          (counsel-find-file . my-ivy-re-builder-pinyin) ;; 顺便把普通的 find-file 也加了
          (t . ivy--regex-plus))) ; 默认

  :bind
  ("C-s" . swiper-isearch)
  ("C-x b" . ivy-switch-buffer))

(use-package counsel-projectile
  :ensure t
  :after (projectile ivy)
  :config
  (counsel-projectile-mode 1))

(use-package counsel
  :config (counsel-mode 1)
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("M-y" . counsel-yank-pop))

;;=========================== 基础交互工具
(use-package ace-pinyin
  :ensure t
  :config
  (setq ace-pinyin-use-avy t)
  (ace-pinyin-global-mode t))

(use-package pinyinlib :ensure t :demand t)
(use-package avy :ensure t)

(defun my-avy-pinyin-timer-perfect ()
  "完美的拼音跳转：输入时自动匹配，停顿 0.5 秒自动触发。"
  (interactive)
  (require 'pinyinlib)
  (let ((input "")
        (char nil)
        (timeout 0.5)) ;; 按照你的要求设置 0.5 秒延迟
    ;; 循环读取字符，直到超时或按下回车/空格
    (while (setq char (read-event (format "Pinyin Search: %s" input) nil timeout))
      (cond
       ;; 如果按下退格键 (Backspace / DEL)
       ((member char '(?\177 ?\b))
        (when (> (length input) 0)
          (setq input (substring input 0 -1))))
       ;; 如果按下回车或空格，立即结束输入并跳转
       ((member char '(?\s ?\r ?\n))
        (setq char nil))
       ;; 如果输入的是普通字符，累加到 input
       ((numberp char)
        (setq input (concat input (char-to-string char))))
       ;; 其它情况跳出
       (t (setq char nil))))
    
    (if (string-empty-p input)
        (message "Cancelled")
      (avy-with my-avy-pinyin-timer-perfect
        ;; 核心：使用 avy-process 避开所有新版 Avy 的参数报错坑
        (avy-process (avy--regex-candidates (pinyinlib-build-regexp-string input)))))))

;; --- 快捷键绑定 ---
(with-eval-after-load 'evil
  ;; 绑定 Normal 和 Operator 模式
  (evil-define-key 'normal 'global (kbd "s") #'my-avy-pinyin-timer-perfect)
  (evil-define-key 'operator 'global (kbd "s") #'my-avy-pinyin-timer-perfect)
  
  ;; f 键保持原生的单字符跳转（跳英文/标点极快）
  (evil-define-key 'normal 'global (kbd "f") 'avy-goto-char))

;; --- Avy 基础视觉设置 ---
(setq avy-background t)
(setq avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)) ;; 左手主行编码

;;; --------switch buffer 支持拼音---------------
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
(defun completion--regex-pinyin (str)
  "把输入的 STR 转换为拼音正则表达式。"
  (orderless-regexp (pinyinlib-build-regexp-string str)))

(add-to-list 'orderless-matching-styles 'completion--regex-pinyin)


;;; --------代码补全弹出框-------------------------
;; 1. 安装基础底层库
(use-package posframe
  :ensure t)

(with-eval-after-load 'posframe
  ;; 隐藏子帧的边缘线条，看起来更像原生浮窗
  (setq posframe-arghandler
        (lambda (buffer-or-name arg-name value)
          (let ((info '(:internal-border-width 2 :left-fringe 0 :right-fringe 0)))
            (or (plist-get info arg-name) value)))))

(use-package ivy-posframe
  :init
  (ivy-posframe-mode 1)
  :config
  ;; 设置弹出框的参数
  (setq ivy-posframe-display-functions-alist
        '((complete-symbol . ivy-posframe-display-at-point) ; 补全代码时在光标处
          (swiper          . ivy-posframe-display-at-point) ; 搜索文本时在光标处
          (t               . ivy-posframe-display-at-frame-center))) ; 其他（M-x等）一律居中

  ;; 设置弹出框的大小和内边距，让它看起来更精致
  (setq ivy-posframe-parameters
        '((left-fringe . 8)
          (right-fringe . 8)))
  (setq ivy-posframe-width 80)      ; 宽度
  (setq ivy-posframe-height 15)     ; 最大高度
  (setq ivy-posframe-min-height 10) ; 最小高度
  
  ;; 设置弹出框的边框颜色（比如用你的 GitHub 绿）
  (set-face-background 'ivy-posframe-border "#2ea44f")
  (setq ivy-posframe-border-width 2))


;;; --------dashbord 启动页-----------------
(use-package dashboard
  :ensure t
  :config
  ;; --- 1. 基础设置 ---
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents  . 12)
                          (agenda   . 5)))
    ;; --- 3. 排除 bookmarks ---
  ;; 注意：一定要在 recentf 层面排除，dashboard 才会消失
  (with-eval-after-load 'recentf
    (add-to-list 'recentf-exclude (expand-file-name "bookmarks" user-emacs-directory)))
  
  ;; --- 2. 核心：只截取文件名（不改任何间距） ---
  (advice-add 'dashboard-insert-recents :around
              (lambda (orig-fun list-size)
                (cl-letf (((symbol-function 'dashboard-extract-key-path-alist)
                           (lambda (el alist)
                             (file-name-nondirectory (dashboard-expand-path-alist el alist)))))
                  (funcall orig-fun list-size))))

  ;; --- 3. 视觉强化：针对白色背景调色 ---
  (custom-set-faces
   ;; 文件名：纯黑、加粗、字号放大
   '(dashboard-items-face ((t (:inherit widget-button 
                               :weight bold 
                               :height 1.3 
                               :foreground "#228B22"))))
   ;; 标题：深蓝色、加粗
   '(dashboard-heading ((t (:inherit font-lock-keyword-face 
                                     :weight extra-bold 
                                     :height 1.5 
                                     :foreground "#0052cc")))))

  (dashboard-setup-startup-hook))

;; 彻底移除 note: 等前缀，让 Agenda 变干净
(setq dashboard-org-agenda-categories nil)


;;; --------其他 UI 增强---------------------------------
(use-package winum :config (winum-mode 1))
(use-package which-key :init (which-key-mode 1))
;; 嵌套括号显示不同的颜色
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))
;; GUI mode-line 更高 + 更舒服
(with-eval-after-load 'doom-themes
  (set-face-attribute 'mode-line nil :height 1.2)
  (set-face-attribute 'mode-line-inactive nil :height 1.2))

;;; --------安全折叠 + Org-element 稳定配置 ------------------

(use-package outshine
  :ensure t
  :hook ((emacs-lisp-mode lisp-mode scheme-mode) . outshine-mode)
  :bind (:map outshine-mode-map
              ;; 直接在 outshine 自己的 map 里绑定，优先级最高
              ("<tab>" . outshine-cycle)
              ("TAB" . outshine-cycle))
  :config
  ;; 核心修复：强制设置简单的正则，防止旧版 Org 引擎在解析时崩溃
  (setq outshine-regexp ";; [;]+ ")
  
  ;; 启用快捷命令
  (setq outshine-use-speed-commands t)
  
  ;; 定义一个更安全的判断函数，不依赖 outshine-on-heading-p
  (defun my-safe-outshine-check ()
    (and (bound-and-true-p outshine-mode)
         (looking-at-p (or outshine-regexp outline-regexp "^;;;+ "))))

  ;; 修复 my-tab-handler (如果你还在用自定义的 TAB 处理函数)
  (defun my-tab-handler ()
    (interactive)
    (cond
     ((and (bound-and-true-p yas-minor-mode) (yas-expand)) t)
     ;; 使用我们自己定义的 my-safe-outshine-check
     ((my-safe-outshine-check) (outshine-cycle))
     ((derived-mode-p 'org-mode) (org-cycle))
     (t (indent-for-tab-command)))))

;; (with-eval-after-load 'outshine         
;;   (defun my-force-outshine-tab ()
;;     "在代码模式下强行执行折叠"
;;     (interactive)
;;     (if (outline-on-heading-p)
;;         (outshine-cycle)
;;       (indent-for-tab-command)))

;;   ;; --- 针对 macOS GUI 的全键位覆盖 ---
;;   (with-eval-after-load 'evil
;;     ;; 覆盖 Normal 模式 (最关键)
;;     (define-key evil-normal-state-map (kbd "TAB") #'my-force-outshine-tab)
;;     (define-key evil-normal-state-map [tab] #'my-force-outshine-tab)
    
;;     ;; 覆盖 Insert 模式 (确保输入时也能折叠)
;;     (define-key evil-insert-state-map (kbd "TAB") #'my-force-outshine-tab)
;;     (define-key evil-insert-state-map [tab] #'my-force-outshine-tab)

;;     ;; 覆盖 Motion 模式 (Evil 在某些特殊 Buffer 用的模式)
;;     (define-key evil-motion-state-map (kbd "TAB") #'my-force-outshine-tab)
;;     (define-key evil-motion-state-map [tab] #'my-force-outshine-tab)))


(provide 'init-ui)
