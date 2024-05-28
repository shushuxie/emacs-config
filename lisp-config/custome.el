
(setq custome-file (expand-file-name "file-dir"))
(load custome-file 'no-error 'no-message)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3d54650e34fa27561eb81fc3ceed504970cc553cfd37f46e8a80ec32254a3ec3" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "c5ded9320a346146bbc2ead692f0c63be512747963257f18cc8518c5254b7bf5" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "b186688fbec5e00ee8683b9f2588523abdf2db40562839b2c5458fcfb322c8a4" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "f91395598d4cb3e2ae6a2db8527ceb83fed79dbaf007f435de3e91e5bda485fb" "5784d048e5a985627520beb8a101561b502a191b52fa401139f4dd20acb07607" "850bb46cc41d8a28669f78b98db04a46053eca663db71a001b40288a9b36796c" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "6c98bc9f39e8f8fd6da5b9c74a624cbb3782b4be8abae8fd84cbc43053d7c175" "613aedadd3b9e2554f39afe760708fc3285bf594f6447822dd29f947f0775d6c" "246a9596178bb806c5f41e5b571546bb6e0f4bd41a9da0df5dfbca7ec6e2250c" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "0ab2aa38f12640ecde12e01c4221d24f034807929c1f859cbca444f7b0a98b3a" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))
 '(org-agenda-files
   '("~/Documents/typora/emacs/gtd管理日程.org" "/Users/xieshuqiang/Documents/typora/emacs/emacs使用技巧.org" "/Users/xieshuqiang/Documents/capture/gtd.org" "/Users/xieshuqiang/Documents/capture/smallThings.org" "/Users/xieshuqiang/Documents/capture/note.org" "/Users/xieshuqiang/Documents/capture/journal.org"))
 '(package-selected-packages
   '(doom-themes treemacs-magit treemacs-icons-dired treemacs-evil treemacs-projectile which-key pyim org-appear pangu-spacing cal-china-x dracula-theme org-bullets modus-themes valign yasnippet-snippets yasnippet rainbow-delimiters highlight-symbol dashboard multiple-cursors undo-tree marginalia good-scroll mwim ace-jump-mode ace-window amx ztree use-package magit lsp-ui lsp-ivy flycheck-pkg-config evil dap-mode counsel-projectile company-tabnine))
 '(setq org-default-notes-file t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-document-title ((t (:height 1.2))))
 '(outline-1 ((t (:weight extra-bold :height 1.25))))
 '(outline-2 ((t (:weight bold :height 1.15))))
 '(outline-3 ((t (:weight bold :height 1.12))))
 '(outline-4 ((t (:weight semi-bold :height 1.09))))
 '(outline-5 ((t (:weight semi-bold :height 1.06))))
 '(outline-6 ((t (:weight semi-bold :height 1.03))))
 '(outline-8 ((t (:weight semi-bold))))
 '(outline-9 ((t (:weight semi-bold)))))


(provide 'custome)
