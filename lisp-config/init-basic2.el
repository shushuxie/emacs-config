;; -*- coding: utf-8 -*-
;;; basic config include bootstra

;; ==========================================
;; 1. 界面与外观设置 (UI)
;; ==========================================
(setq inhibit-startup-message t)      ; 禁用启动闪屏
(tool-bar-mode -1)                    ; 禁用工具栏
(when (display-graphic-p) 
  (toggle-scroll-bar -1))             ; 禁用滚动条
(global-display-line-numbers-mode 1)  ; 显示行号
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
(global-set-key (kbd "C-c g") 'counsel-git)
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
	(:endgroup)

	(:startgroup)
	;; 领域
	("编程" . ?c)
	("emacs" . ?e)
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
  ;; 不要直接 require subtree，改用全局初始化
  (dirvish-peek-mode) ; 开启预览
  ;; 尝试使用这个属性开启 subtree 支持
  (setq dirvish-attributes '(git-msg file-size icons subtree-state))
  
  :bind
  (:map dirvish-mode-map
        ;; 如果那个命令找不到，我们用 Dired 原生的展开替代
        ("TAB" . dired-subtree-toggle) 
        ("h"   . dired-up-directory)
        ("l"   . dired-find-file)))
(with-eval-after-load 'dired
  (require 'dired-x) ; 必须加载这个扩展才能用 omit 功能
  (setq dired-omit-files 
        (concat dired-omit-files "\\|^\\..*$\\|\\.~undo-tree~$")))

(add-hook 'dired-mode-hook #'dired-omit-mode)

;; 3. 强力过滤垃圾文件（undo-tree 等）
(with-eval-after-load 'dired
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..*$\\|\\.~undo-tree~$"))
  (add-hook 'dired-mode-hook #'dired-omit-mode))

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
(with-eval-after-load 'evil
  (with-eval-after-load 'dirvish
    ;; 修复 Enter 键不能打开文件的问题
    (evil-define-key 'normal dirvish-mode-map (kbd "RET") 'dired-find-file)
    (evil-define-key 'normal dirvish-mode-map (kbd "l") 'dired-find-file)
    (evil-define-key 'normal dirvish-mode-map (kbd "h") 'dired-up-directory)))

(with-eval-after-load 'dired
  (require 'dired-x)
  ;; 增加过滤规则：隐藏所有以 . 开头的文件和以 ~ 结尾的文件
  (setq dired-omit-files 
        (concat dired-omit-files "\\|^\\..*$\\|\\.~undo-tree~$")))

;; dird 行号关闭
(add-hook 'dirvish-mode-hook (lambda () (display-line-numbers-mode -1)))

;; ---------------subtree 修饰---------------

(with-eval-after-load 'dired-subtree
  ;; 1. 增加物理缩进：让子目录内容明显右移
  (setq dired-subtree-line-prefix "    ┃ ") 
  
  ;; 2. 这里的重点：强制子目录在插入时也运行过滤钩子
  (setq dired-subtree-use-filter t)
  
  ;; 3. 视觉补救：让子目录的文件名颜色变浅一点，和外层区分开
  (custom-set-faces
   '(dired-subtree-depth-1-face ((t (:foreground "#999999" :background nil))))))

(defun my/clean-subtree-garbage ()
  "强制清理 Subtree 展开后的隐藏文件"
  (dired-omit-mode 1)           ; 确保 Omit 模式是开启的
  (dired-omit-expunge))         ; 立即执行物理隐藏

(add-hook 'dired-subtree-after-insert-hook #'my/clean-subtree-garbage)

;; 增大行间距，这在终端里能显著提升辨认度
(setq-default line-spacing 0.2)

(with-eval-after-load 'dired-subtree
  (custom-set-faces
   ;; 1. 将 Subtree 展开部分的引导线和文件名设为绿色
   ;; :foreground "ForestGreen" 适合白色背景，既清晰又不刺眼
   '(dired-subtree-depth-1-face ((t (:foreground "ForestGreen" :background nil :bold t))))
   '(dired-subtree-depth-2-face ((t (:foreground "DarkGreen" :background nil :bold t))))
   '(dired-subtree-depth-3-face ((t (:foreground "LimeGreen" :background nil :bold t))))
   
   ;; 2. 顺便把引导线颜色也强化一下
   '(dired-subtree-line-prefix-face ((t (:foreground "ForestGreen")))))
  
  ;; 增加一点缩进宽度，让绿色引导线更明显
  (setq dired-subtree-line-prefix "    ┃ "))

;;===========================================================
;;---------* DIRD 配置 文件end*---------------------------
;;===========================================================

;; explore file
(provide 'init-basic2)



