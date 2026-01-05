;; -*- coding: utf-8 -*-
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
    (evil-mode 1))

(use-package evil-escape  
  :ensure t  
  :init  
  (setq evil-escape-key-sequence "jk"  
        evil-escape-delay 0.15)  
  :config  
  (define-key evil-normal-state-map (kbd "C-a") 'mwim-beginning-of-code-or-line)
  (define-key evil-normal-state-map (kbd "C-e") 'mwim-end-of-code-or-line)
  (define-key evil-insert-state-map (kbd "C-a") 'mwim-beginning-of-code-or-line)
  (define-key evil-insert-state-map (kbd "C-e") 'mwim-end-of-code-or-line)
  (evil-escape-mode 1))

;; 确保 Evil 模式已安装并启用
(require 'evil)
(evil-mode 1)
;; 解决tevil函数报错
(fset 'evil-redirect-digit-argument 'ignore) ;; before evil-org loaded
;; evil 使tab失效
(add-hook 'org-mode-hook 'my-org-evil-setup)
(defun my-org-evil-setup ()
  (define-key evil-normal-state-map (kbd "TAB") 'org-cycle))

(use-package evil-leader
  :ensure t
  :after evil
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")
  (evil-leader/set-key
    ;; 文件操作
    "ff" 'counsel-find-file              ;; 打开文件
    "fs" 'save-buffer                    ;; 保存当前缓冲区
    "fr" 'recentf-open-files             ;; 最近打开的文件

    ;; 缓冲区操作
    "bb" 'ivy-switch-buffer               ;; 切换缓冲区
    "bd" 'kill-this-buffer               ;; 关闭当前缓冲区
    "bn" 'next-buffer                    ;; 下一个缓冲区
    "bp" 'previous-buffer                ;; 上一个缓冲区
    "bl" 'list-buffers                   ;; 列出所有缓冲区

    ;; org-structure
    "<" 'org-insert-structure-template   ;; 插入模版
    "'" 'org-edit-special                ;; 特殊编辑
    "|" 'org-table-create                ;; 插入table
    "," 'evil-jump-item                  ;; 括号跳转
    "kk" 'evil-select-brackets-content   ;; 选中括号中的内容

    ;; 窗口操作
    "wv" 'split-window-right             ;; 垂直分割窗口
    "ws" 'split-window-below             ;; 水平分割窗口
    "wd" 'delete-window                  ;; 关闭窗口
    "oo" 'delete-other-windows           ;; 只保留当前窗口
    "wm" 'maximize-window                ;; 最大化窗口
    "aw" 'ace-swap-window
    "af" 'ace-maximize-window
    "wu" 'winner-undo                    ;; 撤销窗口布局变化
    "wr" 'winner-redo                    ;; 重做窗口布局变化
    "wh" 'evil-window-decrease-width     ;; 宽度变窄
    "wk" 'evil-window-decrease-height
    "wl" 'evil-window-increase-width
    "wj" 'evil-window-increase-height

    ;; 窗口选择
    "0" 'winum-select-window-0-or-10
    "1" 'winum-select-window-1
    "2" 'winum-select-window-2
    "3" 'winum-select-window-3
    "4" 'winum-select-window-4
    "5" 'winum-select-window-5
    "6" 'winum-select-window-6
    "7" 'winum-select-window-7
    "8" 'winum-select-window-8
    "9" 'winum-select-window-9

    ;; treemacs操作
    "tt" 'treemacs                       ;; 打开 Treemacs
    "tn" 'tab-new                        ;; 新建tab页，emacs功能
    "ts" 'tab-previous                   ;; tab切换
    "tc" 'tab-close                      ;; tab 关闭
    "tf" 'treemacs-find-file             ;; 在 Treemacs 中找到当前文件
    "tp" 'treemacs-projectile            ;; 打开 Treemacs Projectile
    "to" 'treemacs-display-current-project-exclusively ;; 仅显示当前项目
    ;;添加tag标签
    "tg" 'org-set-tags-command           ;; 在 Treemacs 中找到当前文件

    ;; Treemacs 标签操作
    "ta" 'treemacs-add-project-to-workspace           ;; 添加项目到工作区
    "td" 'treemacs-remove-project-from-workspace      ;; 从工作区中移除项目
    "aa" 'clipboard-kill-ring-save ; used frequently
    "pp" 'clipboard-yank ; used frequently

    ;; 项目管理
    "pf" 'projectile-find-file           ;; 在项目中查找文件
    "pd" 'projectile-dired            ;; 在项目中查找目录
    "pr" 'projectile-recentf             ;; 最近项目文件
    "pg" 'projectile-grep                ;; grep搜索项目文件

    ;; 代码导航
    "gd" 'xref-find-definitions          ;; 跳转到定义
    "gr" 'xref-find-references           ;; 查找引用
    "gb" 'xref-pop-marker-stack          ;; 返回上一个位置

    "ll" 'org-preview-latex-fragment     ;; latex公式预览

    ;; 搜索
    "ss" 'swiper                         ;; Swiper 搜索
    "sg" 'projectile-grep                ;; 在项目中进行正则搜索
    "si" 'yas-insert-snippet             ;; 插入对应的模板


    ;; Org mode
    "nw" 'widen                          ;;展开折叠
    "ns" 'org-narrow-to-subtree             ;;只显示子树
    "nb" 'org-narrow-to-block
    "ne" 'org-narrow-to-element
    "hh" 'evil-window-left
    "ca" 'org-agenda                     ;; 打开 Org agenda
    "cc" 'org-capture                    ;; 打开 Org capture
    "cl" 'org-store-link                 ;; 存储链接
    "ci" 'org-insert-link                ;; 插入链接
    "co" 'org-open-at-point              ;; 打开链接
    "cn" 'org-next-visible-heading       ;; next headline
    "cp" 'org-previous-visible-heading   ;; 上一个可见标题
    "cf" 'org-forward-heading-same-level ;; 下一个同级标题
    "cb" 'org-backward-heading-same-level;; 前一个同级标题 
    "ck" 'org-kill-note-or-show-branches ;; 折叠当前等级headline
    "c<" 'org-do-promote ; `C-c C-<'
    "c>" 'org-do-demote ; `C-c C->'
    "cxi" 'org-clock-in ; `C-c C-x C-i'
    "cxo" 'org-clock-out ; `C-c C-x C-o'
    "cxr" 'org-clock-report ; `C-c C-x C-r'
    ;; 其他常用操作
    "at" 'ansi-term                      ;; 打开终端
    "am" 'eshell                         ;; 打开 Eshell
    "ag" 'magit-status                   ;; 打开 Magit
    ;; latex
    "lt" 'org-cdlatex-environment-indent ;; 插入latex环境
    "dd" 'org-download-clipboard         ;; 插入剪贴板文件
    "vv" 'org-toggle-inline-images       ;; 链接和图片切换
    "ee" 'eval-last-sexp                 ;; 执行elisp
    "zz" 'repeat                         ;; 重复操作,按z可以一直重复

    ;; 书签
    "bm" 'bookmark-set                   ;; 设置书签
    "bj" 'bookmark-jump                  ;; 跳转到书签

    ;; 帮助
    "hk" 'describe-key                   ;; 显示键的描1
    "hf" 'describe-function              ;; 显示函数的描述
    "hv" 'describe-variable              ;; 显示变量的描述
    "hm" 'describe-mode                  ;; 显示当前模式的描述
    ))


;; Bind in normal mode
(define-key evil-normal-state-map (kbd "M-<tab>") 'my-search-and-tab)
(define-key evil-insert-state-map (kbd "M-<tab>") 'my-search-and-tab)

(with-eval-after-load 'org
  ;; 1. 确保在 Org 模式的正文中，Tab 不会强制按�~纲缩进
  (setq org-adapt-indentation nil)

  ;; 2. 定义 Evil 插入模式下的 TAB 行为
  ;; 在 Insert 模式下，强制�~行插入空格（或缩进）的操作，而不是折叠
  (define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
  
  ;; 3. 设定缩进的宽度为 4 个空格
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode nil) ; �~�终使用空格代替 Tab 字符
  
  ;; 4. (可选) 如果你希望在 Insert 模式下遇到�~纲标题依然能折叠，可以用这个：
  ;; (define-key evil-insert-state-map (kbd "TAB") 
  ;;             (lambda () (interactive)
  ;;               (if (org-at-heading-p) 
  ;;                   (org-cycle) 
  ;;                 (tab-to-tab-stop))))
)


(provide 'init-evil)
