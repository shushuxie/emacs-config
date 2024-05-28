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
    "ff" 'find-file                      ;; 打开文件
    "fs" 'save-buffer                    ;; 保存当前缓冲区
    "fr" 'recentf-open-files             ;; 最近打开的文件

    ;; 缓冲区操作
    "bb" 'switch-to-buffer               ;; 切换缓冲区
    "bd" 'kill-this-buffer               ;; 关闭当前缓冲区
    "bn" 'next-buffer                    ;; 下一个缓冲区
    "bp" 'previous-buffer                ;; 上一个缓冲区
    "bl" 'list-buffers                   ;; 列出所有缓冲区

    ;; 窗口操作
    "wv" 'split-window-right             ;; 垂直分割窗口
    "ws" 'split-window-below             ;; 水平分割窗口
    "wd" 'delete-window                  ;; 关闭窗口
    "wo" 'delete-other-windows           ;; 只保留当前窗口
    "wm" 'maximize-window                ;; 最大化窗口
    "wu" 'winner-undo                    ;; 撤销窗口布局变化
    "wr" 'winner-redo                    ;; 重做窗口布局变化

    ;; treemacs操作
    "tt" 'treemacs                       ;; 打开 Treemacs
    "tf" 'treemacs-find-file             ;; 在 Treemacs 中找到当前文件
    "tr" 'treemacs-refresh               ;; 刷新 Treemacs
    "tp" 'treemacs-projectile            ;; 打开 Treemacs Projectile
    "to" 'treemacs-display-current-project-exclusively ;; 仅显示当前项目

    ;; Treemacs 标签操作
    "ta" 'treemacs-add-project-to-workspace           ;; 添加项目到工作区
    "td" 'treemacs-remove-project-from-workspace      ;; 从工作区中移除项目
    "tn" 'treemacs-create-workspace                   ;; 创建新的工作区
    ;;"trw" 'treemacs-rename-workspace                  ;; 重命名工作区
    "ts" 'treemacs-switch-workspace                   ;; 切换工作区
    "tw" 'treemacs-toggle-show-dotfiles               ;; 显示/隐藏隐藏文件
    "tl" 'treemacs-toggle-fixed-width                 ;; 切换 Treemacs 窗口宽度
    "tb" 'treemacs-visit-node-horizontal-split        ;; 水平分割窗口中访问节点
    "tv" 'treemacs-visit-node-vertical-split          ;; 垂直分割窗口中访问节点




    ;; 项目管理
    "pf" 'projectile-find-file           ;; 在项目中查找文件
    "pp" 'projectile-switch-project      ;; 切换项目,
    "pd" 'projectile-find-dir            ;; 在项目中查找目录
    "pr" 'projectile-recentf             ;; 最近项目文件
    "pg" 'projectile-grep                ;; grep搜索项目文件

    ;; 代码导航
    "gd" 'xref-find-definitions          ;; 跳转到定义
    "gr" 'xref-find-references           ;; 查找引用
    "gb" 'xref-pop-marker-stack          ;; 返回上一个位置

    ;; 代码编辑
    "ci" 'evilnc-comment-or-uncomment-lines ;; 注释或取消注释行
    "cc" 'comment-line                   ;; 注释行
    "cu" 'uncomment-region               ;; 取消注释区域

    ;; 搜索
    "ss" 'swiper                         ;; Swiper 搜索
    "sg" 'rgrep                          ;; 在项目中进行正则搜索

    ;; Org mode
    "oa" 'org-agenda                     ;; 打开 Org agenda
    "oc" 'org-capture                    ;; 打开 Org capture

    ;; 其他常用操作
    "at" 'ansi-term                      ;; 打开终端
    "am" 'eshell                         ;; 打开 Eshell
    "ag" 'magit-status                   ;; 打开 Magit
    "ar" 'ranger                         ;; 打开 Ranger 文件管理器

    ;; 书签
    "bm" 'bookmark-set                   ;; 设置书签
    "bj" 'bookmark-jump                  ;; 跳转到书签

    ;; 帮助
    "hk" 'describe-key                   ;; 显示键的描述
    "hf" 'describe-function              ;; 显示函数的描述
    "hv" 'describe-variable              ;; 显示变量的描述
    "hm" 'describe-mode                  ;; 显示当前模式的描述
    ))

;; Bind in normal mode
(define-key evil-normal-state-map (kbd "M-<tab>") 'my-search-and-tab)

;; Bind in insert mode
(define-key evil-insert-state-map (kbd "M-<tab>") 'my-search-and-tab)


;; vim输入法切换
;(defun my-evil-insert-state-input-method ()
    ;"Switch to Chinese input method in insert state."
    ;(set-input-method "chinese-py"))
;
;(defun my-evil-normal-state-input-method ()
    ;"Switch back to default (usually English) input method in normal state."
    ;(set-input-method nil))
;
;(add-hook 'evil-insert-state-exit-hook 'my-evil-normal-state-input-method)


(provide 'init-evil)
