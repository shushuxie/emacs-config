;;; lisp-config/init-ui.el
;; 放在 init-ui.el 的最前面
(condition-case err
    (set-face-attribute 'default nil :font "SF Mono-16")
  (error
   (message "字体设置失败: %s" (error-message-string err))))

;; 基础 UI 优化，增加容错
(setq inhibit-startup-message t) ; 关闭启动画面

;; 安全地关闭图形组件
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;; 主题配置
(use-package doom-themes
  :ensure t
  :config
  ;(load-theme 'doom-one-light t))
  ;(load-theme 'dracula t))
  (load-theme 'leuven t))
  ;(load-theme 'tango t))
  ;(load-theme 'tsdh-light t))
  ;(load-theme 'tsdh-dark t))

;; Ivy / Counsel 交互配置
(use-package ivy
  :init (ivy-mode 1)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  (setq ivy-height 20)
  :bind
  ("C-s" . swiper-isearch)
  ("C-x b" . ivy-switch-buffer))

(use-package counsel
  :config (counsel-mode 1)
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("M-y" . counsel-yank-pop))

;; 基础交互工具
(use-package avy
  :ensure t
  :bind (("M-g s" . avy-goto-char-timer)  ; 推荐用这个键，避免 C-j 冲突
         ("C-c j" . avy-goto-char-timer))
  :config
  ;; 设置输入中断后的等待时间（秒）
  (setq avy-timeout-seconds 0.5)
  ;; 如果你想让跳转标签显示在行首或其他自定义设置，可以加在这里
  )

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


;; 启动页
(use-package dashboard
  :config
  (setq dashboard-banner-logo-title "努力进步")
  (setq dashboard-items '((recents . 8) (projects . 3)))
  (dashboard-setup-startup-hook))

;; 其他 UI 增强
(use-package winum :config (winum-mode 1))
(use-package which-key :init (which-key-mode 1))
;; 嵌套括号显示不同的颜色
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))

(provide 'init-ui)
