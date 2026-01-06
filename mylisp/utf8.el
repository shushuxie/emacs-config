(defun my/force-buffer-utf8 ()
  "强制将当前 Buffer 转换为 UTF-8 编码，并尝试修复非法字符。
当全局自动配置失效，或者打开旧的乱码文件时使用。"
  (interactive)
  (let ((orig-point (point))
        (org-appear-was-enabled (and (boundp 'org-appear-mode) 
                                     (boundp 'org-appear-mode) org-appear-mode)))
    (when org-appear-was-enabled
      (org-appear-mode -1)) 
    (condition-case err
        (progn
          (revert-buffer-with-coding-system 'utf-8-unix)
          (set-buffer-file-coding-system 'utf-8-unix)
          (setq buffer-file-coding-system 'utf-8-unix)
          (goto-char orig-point)
          (message "Buffer 已强制转码为 UTF-8。"))
      (error
       (message "转码失败: %s" (error-message-string err))))
    (when org-appear-was-enabled
      (org-appear-mode 1))))

(provide 'utf8)
