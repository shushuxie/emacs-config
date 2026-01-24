;;; lexical-binding 
(setq gc-cons-threshold (* 50 1000 1000)) ;垃圾回收50M启动
;;; 配置文件加载路径
(add-to-list 'load-path "~/.emacs.d/lisp-config")
(setq custom-file "~/.emacs.d/lisp-config/custome.el")
(load custom-file)

(use-package posframe :ensure t)

(setq rime-librime-root "/opt/homebrew")
  ;; 1. 这一行必须放在 :init 块，确保 Emacs 启动时就知道默认输入法
 (setq default-input-method "rime")
 (use-package rime
  :ensure t
  :init
  :config
  ;; 2. 这里的路径必须指向你刚才 cc 编译出来的那个文件
  (setq rime-librime-paths '("/Users/xieshuqiang/.emacs.d/elpa/rime-20251105.1505/librime-emacs.so"))
 ;; 2. 暴力解决：只要进入插入模式，就强行激活 Rime
  (add-hook 'evil-insert-state-entry-hook (lambda () (set-input-method "rime"))) (setq rime-user-data-dir "/Users/xieshuqiang/Library/Rime")
;; 【关键配置】开启 posframe 效果
  (setq rime-show-candidate 'posframe)
;; 可选：美化外观（根据你的喜好调整）
  (setq rime-posframe-properties
        (list :font "PingFang SC-14"    ; 字体和大小
              :internal-border-width 10 ; 边框宽度
              :background-color "#282c34" ; 背景颜色（建议匹配你的主题）
              :foreground-color "#bbc2cf"))
;; --- 修复报错的断言设置 ---
  (setq rime-disable-predicates
        '(;; 1. 只有在 evil 激活且处于 normal 模式时才禁用
          (lambda () 
            (and (fboundp 'evil-normal-state-p) (evil-normal-state-p)))
          ;; 2. 只有在 rime 内部函数存在时才调用它
          (lambda () 
            (and (fboundp 'rime--normal-mode-p) (rime--normal-mode-p)))
          ;; 3. 常见的：如果在代码注释或字符串之外（可选）
          ;; rime--after-ascii-mode-till-prefix-p
          ))

    ;; 自动处理模式切换：从 Normal 进入 Insert 时尝试恢复输入法状态
    (add-hook 'evil-insert-state-entry-hook #'rime-force-enable)
  ;; 3. 强制指定默认方案为自然码
  (setq rime-default-scheme "double_pinyin")) 

(with-eval-after-load 'rime
  ;; 强制将 Tab 键发送给 Rime 处理，而不是留给 Emacs 补全
  (define-key rime-active-mode-map (kbd "TAB") 'rime-send-keybinding)
  (define-key rime-mode-map (kbd "TAB") 'rime-send-keybinding))


(require 'init-packages)
(require 'init-basic2)
(require 'init-ui)       ; 加载 UI 配置
(require 'init-program)
(require 'init-latex)
(require 'init-evil)
(require 'init-org)
(require 'init-function) ;自己编写的函数

(provide 'init)
