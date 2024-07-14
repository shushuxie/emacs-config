;;; basic config include bootstra
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archives '(("gnu"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")
                         ("melpa" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
			 ("popkit" . "http://elpa.popkit.org/packages/")))
(package-initialize)

;; basic config
(setq confirm-kill-emacs #'yes-or-no-p)      ; 在关闭 Emacs 前询问是否确认关闭，防止误触
(electric-pair-mode t)                       ; 自动补全括号
(add-hook 'prog-mode-hook #'show-paren-mode) ; 编程模式下，光标在括号上时高亮另一个括号
(column-number-mode t)                       ; 在 Mode line 上显示列号
(global-auto-revert-mode t)                  ; 当另一程序修改了文件时，让 Emacs 及时刷新 Buffer
(delete-selection-mode t)                    ; 选中文本后输入文本会替换文本（更符合我们习惯了的其它编辑器的逻辑）
(setq inhibit-startup-message t)             ; 关闭启动 Emacs 时的欢迎界面
(setq make-backup-files nil)                 ; 关闭文件自动备份
(add-hook 'prog-mode-hook #'hs-minor-mode)   ; 编程模式下，可以折叠代码块
(global-display-line-numbers-mode 1)         ; 在 Window 显示行号
(tool-bar-mode -1)                           ; （熟练后可选）关闭 Tool bar
(when (display-graphic-p) (toggle-scroll-bar -1)) ; 图形界面时关闭滚动条
(setq custom-safe-themes t) ; 忽略主题加载安全提示

(savehist-mode 1)                            ; （可选）打开 Buffer 历史记录保存
(setq display-line-numbers-type 'relative)   ; （可选）显示相对行号
;(add-to-list 'default-frame-alist '(width . 90))  ; （可选）设定启动图形界面时的初始 Frame 宽度（字符数）
;(add-to-list 'default-frame-alist '(height . 55)) ; （可选）设定启动图形界面时的初始 Frame 高度（字符数）
(require 'org-tempo) ;解决<c无法创建代码块问题
(fset 'yes-or-no-p 'y-or-n-p)

(setq org-confirm-babel-evaluate nil);风险提示关闭
;(set-frame-font "SF Mono 16")
(setq default-frame-alist
      '((font . "SF Mono 16"))) ; 设置整个frame的默认字体为SF Mono Bold，大小为12pt
(setq default-text-scale-factor 1.0) ; 如果需要，可以调整文本缩放比例
(setq dap-lldb-debug-program '("/usr/local/bin/lldb-mi"))

;; 启用保存位置模式
(save-place-mode 1)
;; 配置保存位置的文件路径
(setq save-place-file (concat user-emacs-directory "places"))
;; 确保每个 buffer 都记录位置
(setq-default save-place t)
(global-hl-line-mode t) ;光标所在行高亮

;; 键盘符号替换 start
(defun my-keyboard-translate ()
  (keyboard-translate ?± ?`)
  (keyboard-translate ?§ ?~))
(add-hook 'after-init-hook 'my-keyboard-translate)
;; 键盘符号替换 end


;; 忽略 org-element-cache 警告
(require 'warnings)

;; 忽略 org-element-cache 警告
(add-hook 'after-init-hook
          (lambda ()
            (with-eval-after-load 'org
              (add-to-list 'warning-suppress-types '(org-element-cache)))))
;; 禁用提示音
(defun my-disable-bell-in-org-mode ()
  "Disable bell in Org mode."
  (setq-local ring-bell-function 'ignore))

(add-hook 'org-mode-hook #'my-disable-bell-in-org-mode)

;; globe kbd
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

(global-set-key (kbd "C-j") nil)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-c C-，") 'org-insert-structure-template)
(global-set-key (kbd "C-S-y") 'org-download-clipboard-resize)


;; 配置 Emacs 启动时全屏
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; explore file
(provide 'init-basic)
