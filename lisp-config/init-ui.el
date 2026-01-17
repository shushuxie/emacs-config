;;; lisp-config/init-ui.el
;; 放在 init-ui.el 的最前面
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
  (setq ivy-heig 20)
  :bind
  ("C-s" . swiper-isearch)
  ("C-x b" . ivy-switch-buffer))

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
;; GUI mode-line 更高 + 更舒服
(with-eval-after-load 'doom-themes
  (set-face-attribute 'mode-line nil :height 1.2)
  (set-face-attribute 'mode-line-inactive nil :height 1.2))

(provide 'init-ui)
