;; 自动补全
(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-minimum-prefix-length 3) ; 只需敲 3 个字母就开始进行自动补全
  (setq company-tooltip-align-annotations t)
  (setq company-idle-delay 1.0)
  (setq company-show-numbers nil) ;; 给选项编号 (按快捷键 M-1、M-2 等等来进行选择).
  (setq company-selection-wrap-around t)
  (setq company-transformers '(company-sort-by-occurrence))) ; 根据选择的频率进行排序，读者如果不喜欢可以去掉

(use-package company-box
  :ensure t
  :if window-system
    :hook (company-mode . company-box-mode))

;;;ysnippt 代码片段补全 startup====================
(use-package yasnippet)
(require 'yasnippet)
(yas-global-mode 1)
;; 代码片段加载地址
;(setq yas-snippet-dirs
      ;'("~/.emacs.d/snippets"                 ;; personal snippets
        ;"/path/to/some/collection/"           ;; foo-mode and bar-mode snippet collection
        ;"/path/to/yasnippet/yasmate/snippets" ;; the yasmate collection
        ;))

(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.
(setq yas-key-sequence '(("<tab>" . nil) ("S-<tab>" . "complete")))

;;;ysnippt 代码片段补全 end========================


(use-package flycheck
  :ensure t
  :config
  (setq truncate-lines nil) ; 如果单行信息很长会自动换行
  :hook
    (prog-mode . flycheck-mode))

;; 安装必要的包
(dolist (package '(lsp-mode lsp-ui ccls))
  (unless (package-installed-p package)
    (package-install package)))

;; 启用Company模式进行代码补全
(add-hook 'after-init-hook 'global-company-mode)

;; 启用Flycheck进行语法检查
(add-hook 'after-init-hook 'global-flycheck-mode)

;; 配置LSP模式
(require 'lsp-mode)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'python-mode-hook #'lsp) ;; 配置Python的LSP服务器
(add-hook 'javascript-mode-hook #'lsp) ;; 配置JavaScript的LSP服务器
(setq lsp-prefer-flymake nil) ;; 使用Flycheck而不是Flymake

(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

;; 设置C语言服务器
(require 'ccls)
(setq lsp-clients-ccls-executable "/opt/homebrew/bin/ccls") ;; 请将路径替换为ccls的实际路径

;; 设置C语言风格
(setq c-default-style "linux" 
      c-basic-offset 4)

;; 安装 quickrun
(unless (package-installed-p 'quickrun)
  (package-refresh-contents)
  (package-install 'quickrun))

;; 加载 quickrun 包
(require 'quickrun)

;; 配置 quickrun 以运行 C 语言代码
(quickrun-add-command "c/gcc"
  '((:command . "gcc")
    (:exec    . ("%c -o %e %s" "%e"))
    ;(:remove  . ("%e"))
    (:description . "Compile C file with gcc and execute"))
  :default "c")

;; 设置快捷键 F5 以运行 quickrun
(global-set-key (kbd "<f5>") 'quickrun)

;; org-bable start多语言编程
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)
   (C .t)))

(setq org-babel-python-command "/Library/Frameworks/Python.framework/Versions/3.11/bin/python3")
;;; org-bable end

(provide 'init-program)
