;;; lisp-config/init-org.el
(defvar org-default-notes-file nil)
;; 禁用 org-element 在非 Org 缓冲区运行时的警告弹出
(add-to-list 'warning-suppress-types '(org-element))
(use-package org
  :ensure nil  ; org 是自带的，不需要 ensure
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  ;; --- 1. 基础变量设置 (解决 Void Variable 的核心) ---
  (setq org-hide-emphasis-markers t
        org-use-fast-tag-selection 'expert
        org-ellipsis " ▾ "
        org-special-ctrl-a/e t
        org-hide-block-startup t
        org-startup-folded 'content
        org-startup-with-inline-images t
        org-startup-with-latex-preview t)

  ;; --- 2. Agenda 与 Capture ---

(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i)" "WAITING(w)" "|" "DONE(d)" "CANCEL(c)")))

;; 设置不同状态的颜色
(setq org-todo-keyword-faces
      '(;; 待办：深红色，带边框感，产生“必须处理”的视觉压力
        ("TODO" . (:foreground "#cc0000" :weight bold))
        
        ;; 进行中：深蓝色，稳重且突出
        ("DOING" . (:foreground "#005cc5" :weight bold))
        
        ;; 等待/挂起：深橙色/棕色，起到提醒作用但不刺眼
        ("WAITING" . (:foreground "#b58900" :weight bold))
        
        ;; 已取消：深灰色，带删除线，弱化视觉
        ("CANCEL" . (:foreground "#777777" :strike-through t))
        
        ;; 已完成：深绿色，代表健康和完成
        ("DONE" . (:foreground "#22863a" :weight bold))))
(setq org-todo-keyword-faces
      '(("TODO" . (:background "#ffeef0" :foreground "#d73a49" :weight bold :box (:line-width 1 :color "#d73a49")))
        ("DOING" . (:background "#e1f5fe" :foreground "#01579b" :weight bold :box (:line-width 1 :color "#01579b")))
        ("DONE" . (:background "#e6ffed" :foreground "#22863a" :weight bold :box (:line-width 1 :color "#22863a")))))


;; 顺便设置默认的笔记文件
(setq org-default-notes-file "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/gtd.org")
  ;; 自动获取 expand-file-name 后的正确路径
(setq org-agenda-files 
      (list (expand-file-name "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/gtd.org")
            (expand-file-name "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/note.org")
            (expand-file-name "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/inbox.org")
            (expand-file-name "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/smallthings.org")
            (expand-file-name "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/journal.org")))
(setq org-capture-templates
      '(;; 【任务类】存入 iCloud/gtd.org
        ("t" "Todo" entry (file+headline "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/gtd.org" "Tasks")
         "* TODO %?\n  建立于: %U\n  来自: %a\n  %i" :prepend t)

        ;; 【每日任务】存入 iCloud/smallthings.org
        ("d" "Daily Task" entry (file+datetree "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/smallthings.org")
        "* TODO %? [0%]\n  - [ ] %i\n  :LOGBOOK:\n  - 捕获时间:%T\n  :END:")

        ;; 【笔记类】存入 iCloud/note.org
        ("n" "Notes" entry (file+datetree "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/note.org")
         "* %?\n  记录于: %U\n  %i")

        ;; 【日志类】存入 iCloud/journal.org
        ("j" "Journal" entry 
         (file+datetree "~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/journal.org")
         "* %?\n  时间: %U\n  链接: %a\n  %i")
        ))

(defun my/org-smart-return ()
  "如果当前在复选框列表里，按回车自动创建新的复选框项。"
  (interactive)
  (if (org-at-item-checkbox-p)
      (org-insert-todo-heading-respect-content) ; 或者用 org-insert-item
    (org-meta-return)))

;; 如果你想覆盖默认的 M-RET 逻辑
(define-key org-mode-map (kbd "M-RET") 
            (lambda () 
              (interactive)
              (if (org-at-item-p)
                  (org-insert-item t) ; t 表示如果是复选框则延续复选框
                (org-meta-return))))
;; 1. 让 Agenda 预览（按 E）时，不要显示抽屉（LOGBOOK、PROPERTIES等）
;; 1. 以后所有的状态修改记录都塞进看不见的抽屉里
(setq org-log-into-drawer t)

;; 2. 让 Agenda 预览（按 E）彻底无视这些记录
(setq org-agenda-entry-text-exclude-terminators '("DRAWER" "LOGBOOK"))

;; 2. 限制预览显示的行数（比如只看前 10 行），防止内容太长
(setq org-agenda-add-entry-text-maxlines 10)

;; 3. 确保勾选 [x] 时，百分比 [%] 实时重新计算
(setq org-checkbox-statistics-hook (lambda () (org-update-checkbox-count t)))
(setq org-refile-targets 
      '((nil :maxlevel . 3)  ; 当前打开的文件，支持跳转到 3 级标题
        ("~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/gtd.org" :maxlevel . 2)
        ("~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/note.org" :maxlevel . 2)
        ("~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/smallthings.org" :maxlevel . 2)
        ("~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/journal.org" :maxlevel . 2)
        ("~/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org/inbox.org" :maxlevel . 2)))

;; 强烈建议开启：让 Refile 支持一级级跳转（通过斜杠 / 区分层级）
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-use-outline-path 'file)

;; 让 Refile 路径显示更直观，例如：gtd.org/Tasks/学习项目
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

  ;;=====================agenda美化================================================
  ;; 设置日历显示为中文
(setq calendar-month-name-array
      ["一月" "二月" "三月" "四月" "五月" "六月"
       "七月" "八月" "九月" "十月" "十一月" "十二月"])

(setq calendar-day-name-array
      ["周日" "周一" "周二" "周三" "周四" "周五" "周六"])

;; 强制 Org-mode 在导出或显示时使用这些中文名称
(setq org-agenda-format-date "%Y-%m-%d 星期%a") ; 格式化 Agenda 日期显示
(set-locale-environment "zh_CN.UTF-8")
(setq org-agenda-date-separator-last-day "--------------------------------------------------")

(setq org-archive-location 
      (concat "archives/" (format-time-string "%Y") "_%s_archive::"))

;; 1. 彻底清理前缀，去掉那些烦人的数字
(setq org-agenda-prefix-format
      '((agenda . " %i %?-12t% s")
        (todo   . "  • ") ;; 用一个小圆点代替冗长的文字分类
        (tags   . " %i %-12:c")
        (search . " %i %-12:c")))

;; 2. 重点：关闭 org-super-agenda 的自动数字索引
;; 很多时候你看到的数字是这个插件为了“快捷选择”自动生成的
(setq org-super-agenda-header-prefix " ") ;; 将默认的数字前缀改为空格

(use-package org-super-agenda
  :ensure t
  :after org-agenda
  :config
  ;; 1. 先定义分组逻辑
(setq org-super-agenda-groups
      '(;; 1. 【最优先】过期任务：只要日期早于今天，就先截获
        ;; 在 org-super-agenda-groups 里加入
        (:name "📥 手机收集箱" 
            :file-path "inbox.org"
            :order 0) ; 放在最上面，提醒你及时处理手机上记的东西
        (:name "⚠️ 已经过期" 
               :and (:scheduled past :not (:todo "DONE"))
              ;;:face (:foreground "#cc0000" :weight bold :underline t)
                :face (:foreground "white" :background "#d73a49" :weight bold)
               :order 1)

        ;; 2. 极其重要 (优先级 A)
        (:name "🔥 极其重要" 
               :and (:priority "A" :not (:todo "DONE"))
               :face (:foreground "#cc0000" :weight bold)
               :order 2)

        ;; 3. 今日任务
        (:name "📅 今日任务" 
               :and (:scheduled today :not (:todo "DONE"))
               :face (:foreground "#b58900" :weight bold)
               :order 3)

        ;; 4. 灵感笔记 (来自 note.org)
        (:name "💡 灵感笔记" 
               :and (:file-path "note.org" :todo t) 
               :face (:foreground "#6f42c1" :italic t)
               :order 4)

        ;; 5. 生活琐事 (来自 smallThings.org)
        (:name "🛒 生活琐事" 
               :and (:file-path "smallThings.org" :todo t) 
               :face (:foreground "#22863a")
               :order 5)

        ;; 6. 核心任务 (来自 gtd.org)
        (:name "📋 核心任务" 
               :and (:file-path "gtd.org" :todo t) 
               :face (:foreground "#005cc5")
               :order 6)

        ;; 7. 已完成
        (:name "✅ 已完成" 
               :todo "DONE" 
               :face (:foreground "#999999" :strike-through t)
               :order 9)))
  ;; 2. 再开启模式
  (org-super-agenda-mode 1))
(with-eval-after-load 'org-super-agenda
  (dolist (face '(org-super-agenda-header org-super-agenda-header-face))
    (when (facep face)
      (set-face-attribute face nil 
                          :height 1.15
                          :weight 'bold 
                          :foreground "#333333"      ; 标题文字用深灰色
                          :background "#f0f0f0"      ; 加上浅灰色背景
                          :extend t                  ; 让背景延伸到行尾
                          :overline "#dddddd"))))    ; 顶部加一条细线

;; 在每个分组标题上方加一个空行，让排版有呼吸感
;;(setq org-super-agenda-header-prefix "\n")
(setq org-agenda-show-log t)
(setq org-agenda-todo-keyword-format "%-8s") ;; 给 TODO 状态留出固定宽度
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))
;; 在 Emacs 启动后运行，确保图形环境已就绪
(add-hook 'window-setup-hook #'my-setup-fonts)
(defun my-setup-fonts ()
  (when (display-graphic-p)
    ;; 设置基础英文字体
    (set-face-attribute 'default nil :font "Menlo 13")
    ;; 设置中文字体 (苹方)
    (set-fontset-font t 'han (font-spec :family "PingFang SC"))
    ;; 比例缩放，解决对齐问题
    (setq face-font-rescale-alist '(("PingFang SC" . 1.2)))))

(add-hook 'window-setup-hook #'my-setup-fonts)
;; 禁用 Agenda 视图中的行号显示
(add-hook 'org-agenda-mode-hook (lambda () (display-line-numbers-mode -1)))
;; 设置：在当前窗口打开 Agenda，但不破坏其他分屏
;;(setq org-agenda-window-setup 'current-window)
;; 强烈建议开启：按 q 退出 Agenda 时，自动恢复之前的窗口布局
(setq org-agenda-restore-windows-after-quit t)

(with-eval-after-load 'org-agenda
  (add-hook 'org-agenda-finalize-hook
            (lambda ()
              (let ((inhibit-read-only t))
                (save-excursion
                  (goto-char (point-min))
                  ;; 1. 翻译包含 ALL 的主标题
                  (when (re-search-forward "Global list of TODO items of type: ALL" nil t)
                    (replace-match "快捷键 ,-权重 t-todo状态修改 k-capture"))
                  
                  (goto-char (point-min))
                  ;; 2. 翻译操作提示
                  (when (re-search-forward "Press ‘N r’ (e.g. ‘0 r’) to search again:" nil t)
                    (replace-match "快捷操作：按下「数字 + r」进行过滤："))
                  
                  (goto-char (point-min))
                  ;; 3. 翻译过滤选项中的 (0)[ALL]
                  (while (re-search-forward "(0)\\[ALL\\]" nil t) 
                    (replace-match "(0)[全部]"))

                  ;; 4. 翻译其他状态按钮
                  (goto-char (point-min))
                  (while (re-search-forward "(1)CANCEL" nil t) (replace-match "(1)已取消"))
                  (goto-char (point-min))
                  (while (re-search-forward "(2)DONE" nil t) (replace-match "(2)已完成"))
                  (goto-char (point-min))
                  (while (re-search-forward "(3)WAITING" nil t) (replace-match "(3)等待中"))
                  (goto-char (point-min))
                  (while (re-search-forward "(4)DOING" nil t) (replace-match "(4)进行中"))
                  (goto-char (point-min))
                  (while (re-search-forward "(5)TODO" nil t) (replace-match "(5)待办")))))))

(with-eval-after-load 'org-agenda
  ;; 使用 face-spec-set 是一种更兼容的写法
  (face-spec-set 'org-agenda-structure
                 '((((class color) (min-colors 88) (background light))
                    :foreground "#555555" 
                    :background "#f0f0f0" ; 稍微深一点的灰色，确保白底可见
                    :weight bold)
                   (t :weight bold))))
;;===========================orgagenda 美化 end============================

  ;; --- 3. 样式与面孔 (Faces) ---
  (defface org-bold
    '((t :foreground "#d2268b" :background "#fefefe" :weight bold :underline t :overline t))
    "Face for org-mode bold.")

  (setq org-emphasis-alist
        '(("*" org-bold) ("/" italic) ("_" underline) ("=" org-verbatim verbatim)
          ("~" org-code verbatim) ("+" (:strike-through t))))

  (custom-set-faces
   '(outline-1 ((t (:weight extra-bold :height 1.25))))
   '(outline-2 ((t (:weight bold :height 1.15))))
   '(org-document-title ((t (:height 1.2)))))
   

  ;; --- 4. 模板与钩子 ---
  (add-to-list 'org-structure-template-alist '("x" . "latex"))
  (add-hook 'org-mode-hook (lambda () (setq line-spacing 0.25))))

;; --- 5. Org 扩展插件 (独立出来) ---
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil))

(use-package valign
  :hook (org-mode . valign-mode)
  :config (setq valign-fancy-bar t))

(use-package org-download
  :bind (:map org-mode-map
              ("C-S-y" . org-download-screenshot)
              ("C-S-p" . org-download-clipboard))
  :config
  (setq org-download-link-format "[[file:%s]]")
  (add-hook 'org-mode-hook (lambda () (setq org-download-image-dir "./images"))))

(provide 'init-org)
