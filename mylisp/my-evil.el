(defun evil-select-brackets-content ()
    "Select the content within the brackets on the current line in evil mode."
    (interactive)
    (evil-normal-state)
    (search-backward "(" (line-beginning-position) t)
    (evil-visual-char)
    (evil-jump-item))


(provide 'my-evil)

