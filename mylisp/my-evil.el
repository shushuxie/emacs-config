(defun evil-select-brackets-content ()
    "Select the content within the brackets on the current line in evil mode."
    (interactive)
    (evil-normal-state)
    (search-backward "(" (line-beginning-position) t)
    (evil-visual-char)
    (evil-jump-item))

;;=======================================搜索配置========== 
;; 添加全局文件搜索😸 支持排序，拼音模糊
;;======================================================     

(defun my-project-search-all-files ()
  "扫描所有项目，按最近修改时间排序，并显示清爽的相对路径。"
  (interactive)
  (require 'cl-lib)
  (let* ((all-candidates nil)
         (raw-projects (or projectile-known-projects '("~/.emacs.d/" "~/Documents/typora/")))
         ;; 1. 简化列表：只要包含这些字符，就剔除
         (ignore-keywords '("\\.git/" 
                            "elpa/" 
                            "[^/]*cache/"      ; 核心修改：过滤任何以 cache 结尾的文件夹 (如 .ccls-cache/)
                            "eshell/" 
                            "ltximg/" 
                            "images/" 
                            "image/" 
                            "transient" 
                            "amx-items" 
                            "history" 
                            "bookmarks" 
                            "places" 
                            "tramp" 
                            "recentf" 
                            "OS-homework/" 
                            "rime/" 
                            "\\.idea/" 
                            "snippets/" 
                            "straight/" 
                            "node_modules/" 
                            "\\.sample$"))) ;; 过滤掉你截图里的 .sample 钩子文件
    
    (dolist (proj-path raw-projects)
      (let* ((expanded-proj (expand-file-name proj-path))
             (proj-name (file-name-nondirectory (directory-file-name expanded-proj))))
        (when (file-directory-p expanded-proj)
          (let* ((files (directory-files-recursively expanded-proj "^[^.]"))
                 ;; 1. 过滤垃圾文件
                 (filtered-files (cl-remove-if 
                                  (lambda (f) (cl-some (lambda (kw) (string-match-p kw f)) ignore-keywords))
                                  files))
                 ;; 2. 按修改时间排序 (最近修改的在前)
                 (sorted-files (sort filtered-files
                                     (lambda (a b)
                                       (time-less-p (file-attribute-modification-time (file-attributes b))
                                                    (file-attribute-modification-time (file-attributes a)))))))
            
            ;; 3. 构建显示字符串
            (dolist (file sorted-files)
              (let ((relative-path (file-relative-name file expanded-proj)))
                (push (cons (format "%-10s | %s" (concat "[" proj-name "]") relative-path) file) 
                      all-candidates)))))))

    ;; 4. 最终汇总后再整体排一次序（确保不同项目间的最近文件也能混排在最前）
    (setq all-candidates (sort all-candidates
                               (lambda (a b)
                                 (time-less-p (file-attribute-modification-time (file-attributes (cdr b)))
                                              (file-attribute-modification-time (file-attributes (cdr a)))))))

    (if all-candidates
        (ivy-read "Search Files (Recent First): " all-candidates
                  :action (lambda (x) (find-file (cdr x)))
                  :caller 'my-project-search-all-files)
      (message "没有找到文件！"))))

;; 别忘了拼音支持
(add-to-list 'ivy-re-builders-alist '(my-project-search-all-files . my-ivy-re-builder-pinyin))

(provide 'my-evil)

