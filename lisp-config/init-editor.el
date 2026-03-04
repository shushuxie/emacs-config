;; -*- coding: utf-8 -*-


;;; ----------操作习惯设置-------------------
(fset 'yes-or-no-p 'y-or-n-p)         ; 将 yes/no 改为 y/n
(setq confirm-kill-emacs #'yes-or-no-p) ; 退出时确认
(electric-pair-mode t)                ; 自动补全括号
(delete-selection-mode t)             ; 选中后输入可直接替换
(global-auto-revert-mode t)           ; 文件在外部被修改时自动重新加载
(add-hook 'prog-mode-hook #'show-paren-mode) ; 编程模式高亮对应括号
(add-hook 'prog-mode-hook #'hs-minor-mode)   ; 开启代码折叠

;;; ----------持久化与文件记录--------------
(savehist-mode 1)                     ; 保存 Minibuffer 历史
(save-place-mode 1)                   ; 记住上次打开文件时光标的位置
(setq save-place-file (concat user-emacs-directory "places"))
(setq-default save-place t)
(setq create-lockfiles nil) ; 不再产生 .# 开头的临时锁定文件


;;; ----------系统编码-----------------
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

;;; ----------粘贴，剪贴板优化-----------------
;; 建议添加：纯文本粘贴函数
;; 如果遇到极个别顽固的乱码，可以用 M-x my-paste-plain-text 粘贴
(defun my-paste-plain-text ()
  "强制从系统剪贴板以 utf-8 纯文本形式粘贴内容。"
  (interactive)
  (let ((coding-system-for-read 'utf-8))
    (insert (gui-get-selection 'CLIPBOARD 'COMPOUND_TEXT))))

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

;;; ----------系统相关，声音-----------------
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

;;; ----------临时文件---------------------------
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


(global-set-key (kbd "M-/") 'hippie-expand);;自动补全

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

;;; ----------DIRD 配置 文件bgein *---------------------------
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


;;; ----------翻译插件--------------------------

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

;;; ----------buffer管理------------------------------ 
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

;;;; ----------- message 窗口管理-----------
(defun my/quit-window-dwim ()
  (interactive)
  (quit-window t))

(with-eval-after-load 'messages
  (evil-define-key 'normal messages-buffer-mode-map
    (kbd "q") #'my/quit-window-dwim))

;;; ----------输入法配置------------
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
;;;; ----popup 美化-----------------
;; ========== Pyim popup 美化 ==========
 
;;;; --- 智能中英文切换断言修复 ---

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


;;; ----------evil- surround--------------------------
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1)
  
  ;; 为 Org-mode 自定义快捷符号
  (add-hook 'org-mode-hook
            (lambda ()
              (push '(?b . ("*" . "*")) evil-surround-pairs-alist) ; b 代表 bold
              (push '(?k . ("~" . "~")) evil-surround-pairs-alist) ; k 代表 code
              (push '(?v . ("=" . "=")) evil-surround-pairs-alist) ; v 代表 verbatim
              (push '(?s . ("+" . "+")) evil-surround-pairs-alist) ; s 代表 strike
              (push '(?i . ("/" . "/")) evil-surround-pairs-alist) ; i 代表 italic
              (push '(?u . ("_" . "_")) evil-surround-pairs-alist))))

(with-eval-after-load 'org
  ;; 核心函数：带空格检查的包裹
  (defun my-org-smart-wrap (char)
    "在包裹 CHAR 的同时，智能处理中文字符间的空格。"
    (let* ((beg (region-beginning))
           (end (region-end))
           (char-before (char-before beg))
           (char-after (char-after end)))
      ;; 1. 处理结束位置：如果后面紧跟中文或非空白字符，插入空格
      (save-excursion
        (goto-char end)
        (insert char)
        (unless (or (eobp) ;; 文件末尾
                    (memq (char-after) '(?\s ?\t ?\n ?\r)) ;; 已经是空格
                    (memq (char-after) '(?点 ?, ?. ?? ?! ?: ?\; ?\) ?\] ?\}))) ;; 标点
          (insert " ")))
      ;; 2. 处理起始位置：如果前面是中文或非空白字符，插入空格
      (save-excursion
        (goto-char beg)
        (unless (or (bobp) ;; 文件开头
                    (memq (char-before) '(?\s ?\t ?\n ?\r)) ;; 已经是空格
                    (memq (char-before) '(?\( ?\[ ?\{))) ;; 标点
          (insert " "))
        (insert char))
      (deactivate-mark)))

  ;; 绑定快捷键 (使用宏确保字符正确传入)
  (let ((bindings '(("M-b" . "*") ("M-i" . "/") ("M-u" . "_")
                    ("M-s" . "+") ("M-k" . "~") ("M-v" . "="))))
    (dolist (binding bindings)
      (let ((key (car binding))
            (c (cdr binding)))
        (define-key evil-visual-state-map (kbd key)
          `(lambda () (interactive) (my-org-smart-wrap ,c)))
        ;; 插入模式下如果没选区，还是用简单的双写逻辑
        (define-key evil-insert-state-map (kbd key)
          `(lambda () (interactive) (insert ,c ,c) (backward-char 1)))))))


;;; ----------tab配置--------------------------   
;;;; --------test----
;; --- 1. 基础设置 ---
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; --- 2. 插入模式 Smart TAB (优化版) ---
(defun my-smart-tab ()
  "插入模式：Yas > Org Table > Indent/Org-Cycle > Company Select."
  (interactive)
  (let* ((at-indent-pos (looking-back "^\\s-*" nil))
         (is-org (derived-mode-p 'org-mode))
         (company-active (and (bound-and-true-p company-mode) (company--active-p))))
    (cond
     ;; 1. Org 表格跳转
     ((and is-org (org-at-table-p))
      (org-table-next-field))

     ;; 2. Yasnippet 展开/跳转 (如果成功展开则停止)
     ((and (bound-and-true-p yas-minor-mode) (yas-expand)))

     ;; 3. Org 特殊处理：非行首时优先交给 org-cycle (处理抽屉、链接、折叠)
     ((and is-org (not at-indent-pos))
      (org-cycle))

     ;; 4. 缩进处理：行首强制 4 空格
     (at-indent-pos
      (insert-char ?\s 4))

     ;; 5. Company 切换
     (company-active
      (company-select-next))

     ;; 6. 默认缩进
     (t
      (indent-for-tab-command)))))

;; --- 3. 普通模式 TAB (修复抽屉折叠的关键) ---
;; (defun my-evil-normal-tab ()
;;   "普通模式：修复 Org 抽屉、代码块折叠及 Outshine 支持。"
;;   (interactive)
;;   (cond
;;     ;; 1. Treemacs 支持 (展开/折叠节点)
;;    ((derived-mode-p 'treemacs-mode)
;;     (treemacs-TAB-action))

;;    ;; 2. Magit 支持 (展开/折叠 Section)
;;    ((derived-mode-p 'magit-mode)
;;     (magit-section-toggle (magit-current-section)))

;;    ;; Outshine 标题折叠 (用于编程模式)
;;    ((and (bound-and-true-p outshine-mode) (outline-on-heading-p))
;;     (outshine-cycle))

;;    ;; Org-mode 全能折叠 (自动处理标题、抽屉 :PROPERTIES:、代码块 #+BEGIN_SRC)
;;    ((derived-mode-p 'org-mode)
;;     (org-cycle))

;;    ;; 默认执行标准缩进或跳到行首
;;    (t (indent-for-tab-command))))
(defun my-evil-normal-tab ()
  "普通模式：修复 Org 抽屉、代码块折叠及 Outshine 支持。"
  (interactive)
  (cond
   ;; Treemacs 支持
   ((derived-mode-p 'treemacs-mode)
    (treemacs-TAB-action))

   ;; Magit 支持 (只在可折叠 buffer)
   ((and (derived-mode-p 'magit-mode)
         (not buffer-read-only)
         (magit-current-section))
    (magit-section-toggle (magit-current-section)))

   ;; Outshine 标题折叠
   ((and (bound-and-true-p outshine-mode) (outline-on-heading-p))
    (outshine-cycle))

   ;; Org-mode 全能折叠
   ((derived-mode-p 'org-mode)
    (org-cycle))

   ;; 默认执行标准缩进或跳到行首
   (t (indent-for-tab-command))))


;; --- 4. 键位绑定 (针对 Evil 深度覆盖) ---
(with-eval-after-load 'evil
  ;; 插入模式绑定
  (dolist (map (list evil-insert-state-map evil-emacs-state-map))
    (define-key map (kbd "TAB") #'my-smart-tab)
    (define-key map [tab]       #'my-smart-tab)
    (define-key map (kbd "C-i") #'my-smart-tab))

  ;; 普通模式绑定
  (define-key evil-normal-state-map (kbd "TAB") #'my-evil-normal-tab)
  (define-key evil-normal-state-map [tab]       #'my-evil-normal-tab)
  (define-key evil-normal-state-map (kbd "C-i") #'my-evil-normal-tab)

  ;; Company 弹出时保持 TAB 逻辑
  (with-eval-after-load 'company
    (define-key company-active-map (kbd "TAB") #'my-smart-tab)
    (define-key company-active-map [tab]       #'my-smart-tab)
    (define-key company-active-map (kbd "C-i") #'my-smart-tab)))

(use-package evil-collection
  :after (evil magit)
  :config
  (evil-collection-init 'magit))

;; --- 5. 插件与 Hook ---
(add-hook 'prog-mode-hook #'outshine-mode)

(with-eval-after-load 'outshine
  (define-key outshine-mode-map (kbd "<backtab>") #'outshine-cycle-buffer))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "<backtab>") #'org-cycle-global))

;; 解决 Org-mode 本地优先级，确保使用我们的 my-smart-tab
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "TAB") #'my-smart-tab)
            (local-set-key [tab]       #'my-smart-tab)))
;;; ----------hydra 看板配置，快捷键 菜单---------------
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



;;;--------------end explore file----------------
(provide 'init-editor)



