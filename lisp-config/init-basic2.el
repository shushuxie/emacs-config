;; -*- coding: utf-8 -*-
;;; basic config include bootstra

;; ==========================================
;; 1. 界面与外观设置 (UI)
;; ==========================================
(setq inhibit-startup-message t)      ; 禁用启动闪屏
(tool-bar-mode -1)                    ; 禁用工具栏
(when (display-graphic-p) 
  (toggle-scroll-bar -1))             ; 禁用滚动条
(global-display-line-numbers-mode -1)  ; 显示行号
(setq display-line-numbers-type 'relative) ; 使用相对行号 (Evil用户必备)
(column-number-mode t)                ; 在状态栏显示列号
(global-hl-line-mode -1)              ; 禁用当前行高亮 (需要时设为 1)

;; 字体设置
;;(set-face-attribute 'minibuffer-prompt nil :height 180) ; 提示符稍微大一点即可
(when (display-graphic-p)
  (defun my/minibuffer-font ()
    (set-face-attribute 'default nil :height 150)
    (set-face-attribute 'minibuffer-prompt nil :height 150))
  (add-hook 'minibuffer-setup-hook #'my/minibuffer-font))

;; ==========================================
;; 2. 操作习惯设置 (Editing Behavior)
;; ==========================================
(fset 'yes-or-no-p 'y-or-n-p)         ; 将 yes/no 改为 y/n
(setq confirm-kill-emacs #'yes-or-no-p) ; 退出时确认
(electric-pair-mode t)                ; 自动补全括号
(delete-selection-mode t)             ; 选中后输入可直接替换
(global-auto-revert-mode t)           ; 文件在外部被修改时自动重新加载
(add-hook 'prog-mode-hook #'show-paren-mode) ; 编程模式高亮对应括号
(add-hook 'prog-mode-hook #'hs-minor-mode)   ; 开启代码折叠

;; ==========================================
;; 3. 持久化与文件记录 (Persistence)
;; ==========================================
(savehist-mode 1)                     ; 保存 Minibuffer 历史
(save-place-mode 1)                   ; 记住上次打开文件时光标的位置
(setq save-place-file (concat user-emacs-directory "places"))
(setq-default save-place t)
(setq create-lockfiles nil) ; 不再产生 .# 开头的临时锁定文件

;; ==========================================
;; 4. Org-mode 与 插件基础配置
;; ==========================================
(require 'org-tempo)                  ; 开启 <s Tab 快速插入代码块
(setq org-confirm-babel-evaluate nil) ; 运行 Org 代码块时不询问确认
(setq custom-safe-themes t)           ; 信任所有已安装的主题

;; ==========================================
;; 5. 系统编码
;; ==========================================
;; 1. 语言环境设置
(set-language-environment "UTF-8")
;; 2. 强制编码优先级，让 UTF-8 成为绝对首选
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)
;; 3. 关键：禁止在保存时针对非法字符弹窗 ;; 这会让 Emacs 自动选择最合适的编码存储，而不是停下来拦截你
(setq coding-system-for-write 'utf-8)
(setq-default coding-system-for-write 'utf-8)
(setq select-safe-coding-system-accept-default-p t) ; 自动接受默认编码，不弹窗提示

;; 针对 macOS 剪贴板的编码优化
(when (eq system-type 'darwin)
  (setq selection-coding-system 'utf-8)
  ;; 确保粘贴时尝试以 utf-8 解码内容
  (setq-default selection-coding-system 'utf-8))

;; 建议添加：纯文本粘贴函数
;; 如果遇到极个别顽固的乱码，可以用 M-x my-paste-plain-text 粘贴
(defun my-paste-plain-text ()
  "强制从系统剪贴板以 utf-8 纯文本形式粘贴内容。"
  (interactive)
  (let ((coding-system-for-read 'utf-8))
    (insert (gui-get-selection 'CLIPBOARD 'COMPOUND_TEXT))))

;; ==========================================
;; 6. 调试与开发
;; ==========================================
(setq dap-lldb-debug-program '("/usr/local/bin/lldb-mi"))

;; ==========================================
;; 6. 系统相关
;; ==========================================
;; 提示音
(require 'warnings)
(add-hook 'after-init-hook
          (lambda ()
            (with-eval-after-load 'org
              (add-to-list 'warning-suppress-types '(org-element-cache)))))
;; 操作提示音关闭      
(defun my-disable-bell-in-org-mode ()
  "Disable bell in Org mode."
  (setq-local ring-bell-function 'ignore))
(add-hook 'org-mode-hook #'my-disable-bell-in-org-mode)

;; 不要在当前目录生成 *~ 备份文件
(setq make-backup-files nil)

;; 不要在当前目录生成 #autosave# 交换文件
(setq auto-save-default nil)

;; 如果一定要备份，统一把它们丢进系统的临时文件夹
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; 禁用 undo-tree 的自动保存历史功能（防止生成那些巨大的 .~undo-tree~ 文件）
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))

;;-----------------剪贴板，复制----------------
(use-package osx-clipboard
  :ensure t
  :config
  (osx-clipboard-mode 1))

;; 确保 Evil 知道要把东西发给剪贴板
(with-eval-after-load 'evil
  (setq evil-send-yank-to-clipboard t))

;; 基础剪贴板设置
(setq select-enable-clipboard t)
(setq select-enable-primary t)

;; ==========================================
;; 7. 全局快捷
;; ==========================================
(global-set-key (kbd "M-/") 'hippie-expand);;自动补全
(global-unset-key (kbd "C-j")) ; 释放 C-j，使其可以作为前缀键使用

;; ===============================
;; TAG标签功能
;; ===============================
(setq org-tag-alist
      '(
	(:startgroup)
	;; 内容性质
	("记录" . ?j)
	("思考" . ?t)
	("总结" . ?z)
	("社会" . ?s)
	(:endgroup)

	(:startgroup)
	;; 领域
	("编程" . ?c)
	("算法" . ?a)
	("工具" . ?g)
	("阅读" . ?r)
	(:endgroup)

	(:startgroup)
	;; 状态/价值
	("待整理" . ?d)
	("重要" . ?i)
	("长期" . ?l)
	("个人" . ?p)
	("情绪" . ?q)
	(:endgroup)
	))


;; ==========================================
;; mode line
;; ==========================================
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

;;    Emacs      
(add-to-list 'initial-frame-alist '(fullscreen . maximized))


;; 保存桌面start
(use-package desktop
  :init
  (desktop-save-mode 1)
  :config
  (setq desktop-path '("~/.emacs.d/desktop/")
        desktop-dirname "~/.emacs.d/desktop/"
        desktop-base-file-name "emacs-desktop"
        desktop-base-lock-name "emacs-desktop.lock"
        desktop-save 'if-exists
        desktop-load-locked-desktop t
        desktop-auto-save-timeout 30))

(use-package winner
  :ensure t
  :config
  (winner-mode 1))
;; 保存桌面end
(with-eval-after-load 'evil
  ;; 强制 Treemacs 始终以 Emacs 状态打开，不使用 Evil 键位
  (evil-set-initial-state 'treemacs-mode 'emacs))
;; treemacs tab键位
(with-eval-after-load 'treemacs
  ;; 针对终端环境的特殊绑定
  ;; 在终端里 TAB 往往被识别为 [tab] 或 (kbd "TAB") 或 "TAB"
  (define-key treemacs-mode-map (kbd "<tab>") #'treemacs-TAB-action)
  (define-key treemacs-mode-map (kbd "TAB") #'treemacs-TAB-action)
  (define-key treemacs-mode-map (kbd "C-i") #'treemacs-TAB-action))

;; 1. 确保 history 文件夹存在
(let ((history-dir (expand-file-name "emacs-cache/" user-emacs-directory)))
  (unless (file-directory-p history-dir)
    (make-directory history-dir t))

  ;; 2. 这里的变量必须指向【具体的文件】，不能只写到文件夹
  (setq recentf-save-file (expand-file-name "recentf" history-dir))
  (setq savehist-file (expand-file-name "savehist" history-dir))
  (setq custom-file (expand-file-name "custom.el" history-dir))
  
  ;; 3. 这里的变量指向的是【文件夹】（它们本来就支持目录映射）
  (setq undo-tree-history-directory-alist `(("." . ,history-dir)))
  (setq backup-directory-alist `(("." . ,history-dir)))
  (setq auto-save-file-name-transforms `((".*" ,history-dir t))))

;; 4. 立即加载刚才定义的 custom-file 防止报错（如果文件不存在就创建一个空的）
(unless (file-exists-p custom-file)
  (with-temp-buffer (write-file custom-file)))
(load custom-file)

;; 5. 启动模式
(savehist-mode 1)
(recentf-mode 1)


(let ((history-dir (expand-file-name "history/" user-emacs-directory)))
  (unless (file-directory-p history-dir)
    (make-directory history-dir t))
  
  ;; 1. 修复 savehist 报错：指定具体文件而不是文件夹
  (setq savehist-file (expand-file-name "savehist" history-dir))
  
  ;; 2. 其他路径保持不变
  (setq undo-tree-history-directory-alist `(("." . ,history-dir)))
  (setq backup-directory-alist `(("." . ,history-dir)))
  (setq auto-save-file-name-transforms `((".*" ,history-dir t))))

(savehist-mode 1)

;;===========================================================
;;---------* DIRD 配置 文件bgein *---------------------------
;;===========================================================
(use-package dirvish
  :ensure t
  :config
  (dirvish-override-dired-mode)
  :bind
   (:map dirvish-mode-map
         ;; 如果那个命令找不到，我们用 Dired 原生的展开替代
        ("TAB" . dired-subtree-toggle) 
       ("h"   . dired-up-directory)
      ("l"   . dired-find-file))
)
(with-eval-after-load 'dired
  (require 'dired-x) ; 必须加载这个扩展才能用 omit 功能
  (setq dired-omit-files 
        (concat dired-omit-files "\\|^\\..*$\\|\\.~undo-tree~$")))

(add-hook 'dired-mode-hook #'dired-omit-mode)

(add-hook 'dirvish-mode-hook (lambda () (display-line-numbers-mode -1)))

(with-eval-after-load 'dired
  (require 'dired-x) ; 必须加载 dired-x 才能使用 omit 功能
  ;; 设置要隐藏的文件正则表达式：包括 . 开头的文件、# 开头的临时文件、以及 undo-tree 文件
  (setq dired-omit-files 
        (concat dired-omit-files "\\|^\\..*$\\|^#.*#$\\|\\.~undo-tree~$")))

;; 自动在所有 Dired 缓冲区开启隐藏模式
(add-hook 'dired-mode-hook 'dired-omit-mode)

(with-eval-after-load 'dirvish
  ;; 无论在什么状态下，回车键必须是打开文件
  (define-key dirvish-mode-map (kbd "RET") 'dired-find-file)
  ;; 针对 Evil 模式用户的特殊加固
  (evil-make-overriding-map dirvish-mode-map 'normal)
  (evil-define-key 'normal dirvish-mode-map (kbd "RET") 'dired-find-file))

;; 确保在 evil 加载后再进行按键绑定
;; 确保在 evil 加载后再进行按键绑定
(with-eval-after-load 'evil
  (with-eval-after-load 'dirvish
    ;; 修复 Enter 键不能打开文件的问题
    (evil-define-key 'normal dirvish-mode-map (kbd "RET") 'dired-find-file)
    (evil-define-key 'normal dirvish-mode-map (kbd "l") 'dired-find-file)
    (evil-define-key 'normal dirvish-mode-map (kbd "h") 'dired-up-directory)
    ;; 添加 jk 映射为上下
    (evil-define-key 'normal dirvish-mode-map (kbd "j") 'dired-next-line)
    (evil-define-key 'normal dirvish-mode-map (kbd "k") 'dired-previous-line)))

(setq dirvish-reuse-session t) ; 尽量重用 session
(setq dirvish-use-dedicated-window nil) ; 禁用专用窗口（如果版本支持此变量）

(with-eval-after-load 'dirvish
  (define-key dirvish-mode-map (kbd "RET") 'dired-find-file)
  ;; 如果是在 Evil 模式下，强制使用这个：
  (evil-define-key 'normal dirvish-mode-map (kbd "RET") 
    (lambda () (interactive) (set-window-dedicated-p (selected-window) nil) (dired-find-file))))

(with-eval-after-load 'dired
  (require 'dired-x)
  ;; 增加过滤规则：隐藏所有以 . 开头的文件和以 ~ 结尾的文件
  (setq dired-omit-files 
        (concat dired-omit-files "\\|^\\..*$\\|\\.~undo-tree~$")))

;; dird 行号关闭
(add-hook 'dirvish-mode-hook (lambda () (display-line-numbers-mode -1)))


;;;====================================================
;;---------------翻译插件--------------------------
;;;====================================================

(use-package fanyi
  :ensure t
  :bind ("C-c t" . fanyi-dwim)
  :config
  ;; 1. 强制在 Evil 的 normal 和 motion 状态下都把 q 给 fanyi 用
  (with-eval-after-load 'evil
    (evil-define-key 'normal fanyi-mode-map (kbd "q") 'quit-window)
    (evil-define-key 'motion fanyi-mode-map (kbd "q") 'quit-window)
    ;; 强制 fanyi-mode 启动时使用 motion 状态（更适合只读页面）
    (evil-set-initial-state 'fanyi-mode 'motion))

  ;; 2. 普通绑定作为兜底
  (define-key fanyi-mode-map (kbd "q") 'quit-window)

  ;; 3. 自动跳转：翻译完后光标自动跳到翻译窗口
  (defun my-fanyi-jump-to-window ()
    (let ((win (get-buffer-window "*fanyi*")))
      (when win 
        (select-window win)
        ;; 确保跳转过去后真的是 motion 状态，双重保险
        (when (fboundp 'evil-motion-state)
          (evil-motion-state)))))
  
  (add-hook 'fanyi-show-fontification-hook #'my-fanyi-jump-to-window))

;;==================buffer 管理============================== 
(use-package shackle
  :ensure t
  :init
  (setq shackle-rules
        '(
          ;; 使用 :regexp t 确保正则生效
          ("\\*fanyi\\*" :regexp t :select t :align 'bottom :size 0.4 :autoclose t)
          ("\\*Help\\*" :regexp t :select t :align 'right :size 0.4)
          ("\\*Warnings\\*" :regexp t :select nil :align 'bottom :size 0.3)
          ("*Messages*" :select nil :align 'bottom :size 0.25) ; 固定名字可不用正则
          ("\\*Compile-Log\\*" :regexp t :align 'bottom :size 0.3)
          ("\\*Async Shell Command\\*" :regexp t :align 'bottom :size 0.3)
          ))
  :config
  (shackle-mode 1))



(use-package popup
  :ensure t)

(use-package pyim
  :ensure t
  :demand t
  :bind
  (("M-j" . toggle-input-method)
   ("C-;" . pyim-delete-word-from-personal-buffer))
  :init
  ;; 1. 在初始化阶段就声明默认输入法
  (setq default-input-method "pyim")
  :config
  ;; 2. 核心：必须在 config 内部确保方案名称正确
  (setq pyim-default-scheme 'ziranma-shuangpin)

  ;; 3. 强制开启词库
  (use-package pyim-basedict
    :ensure t
    :config (pyim-basedict-enable))

  ;; 4. 终端显示方案
  (require 'popup)
  (setq pyim-page-tooltip 'popup)

  ;; 5. 改进的自动切换：使用 lambda 并显式指定 "pyim"
  ;; 我们添加一个延迟，确保 evil 已经完全切换进 insert 状态
  (add-hook 'evil-insert-state-entry-hook 
            (lambda () 
              (set-input-method "pyim") ; 这一步比 activate-input-method 更直接
              (setq pyim-default-scheme 'ziranma-shuangpin))) ; 再次确认方案

  (add-hook 'evil-insert-state-exit-hook #'deactivate-input-method)

  ;; 6. 断言逻辑
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-program-mode
                  pyim-probe-after-code
                  pyim-probe-isearch-mode)))
 
;; --- 智能中英文切换断言修复 ---

(defun my-pyim-probe-dashboard-scope ()
  "如果处于 Dashboard 模式，强制英文。"
  (derived-mode-p 'dashboard-mode))

(defun my-pyim-probe-elisp-comment-start ()
  "在 Elisp 模式下，如果光标在行首的分号上，强制英文。
防止 ;;; 变成 ；；；"
  (when (derived-mode-p 'emacs-lisp-mode)
    (save-excursion
      (skip-chars-backward ";")
      (bolp))))

(setq-default pyim-english-input-switch-functions
              '(my-pyim-probe-dashboard-scope        ; 1. Dashboard 强制英文
                my-pyim-probe-elisp-comment-start    ; 2. 防止分号标题变中文
                pyim-probe-program-mode              ; 3. 编程模式默认英文
                pyim-probe-isearch-mode              ; 4. 搜索默认英文
                ;; 如果你希望在注释里打中文，保留下面这个，
                ;; 但由于有了上面的 elisp-comment-start，它不会在行首触发
                pyim-probe-after-code))

;; =========================================================
;; --------------hydra 看板配置，快捷键 菜单---------------
;; =========================================================
(defhydra hydra-surround (:color blue :hint nil)
  "
  Surround 助手:
  _d_ 删除包裹    _c_ 修改包裹   
  _p_ 加括号 ()   _s_ 加中括号 []  _q_ 加引号 \"\"
  "
  ("d" (call-interactively 'evil-surround-delete))
  ("c" (call-interactively 'evil-surround-change))
  ;; 常用成对符号
  ("p" (my-org-smart-wrap "("))
  ("s" (my-org-smart-wrap "["))
  ("a" (my-org-smart-wrap "{"))
  ("q" nil "退出" :exit t))

;; 绑定一个启动键，比如 M-o
(global-set-key (kbd "M-o") 'hydra-surround/body)

;; 支持鼠标

;; 在 terminal Emacs (-nw) 中启用鼠标
(xterm-mouse-mode 1)
(mouse-wheel-mode 1)



;; explore file
(provide 'init-basic2)



