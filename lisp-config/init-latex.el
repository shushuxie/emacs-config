;;; ============latex startup===================
;(setq org-latex-create-formula-image-program 'dvipng)
;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.0)) ; 调整公式的放大倍数
;(setq org-format-latex-options (plist-put org-format-latex-options :foreground "Black")) ; 设置公式的前景色
;(setq org-format-latex-options (plist-put org-format-latex-options :background "Transparent")) ; 设置公式的背景色为透明
;(setq org-format-latex-options (plist-put org-format-latex-options :border 1)) ; 设置公式的边框大小为2个像素
;(setq org-latex-pdf-process
;      '("xelatex -interaction nonstopmode -output-directory %o %f"
;        "xelatex -interaction nonstopmode -output-directory %o %f")) ; 使用 xelatex 生成 DVI 文件
;(setq org-preview-latex-process-alist
;      '((dvipng :programs ("latex" "dvipng")
;                :description "dvi > png"
;                :message "you need to install the programs: latex and dvipng."
;                :image-input-type "dvi"
;                :image-output-type "png"
;                :image-size-adjust (1.0 . 1.0)
;                :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
;                :image-converter ("dvipng -D 300 -T tight -o %O %f")))) ; 使用300 DPI和紧密裁剪
;
;(setq org-preview-latex-image-directory "/tmp/ltximg/") ; 设置缓存目录



;; latex编辑
(add-hook 'org-mode-hook #'turn-on-org-cdlatex)
(add-hook 'org-mode-hook 'prettify-symbols-mode)

;; prettify mode
(setq my/prettify-symbols-alist
      '(("lambda" . ?λ)
        ("->"     . ?→)
        ("mapsto" . ?↦)
        ("/="     . ?≠)
        ("!="     . ?≠)
        ("=="     . ?≡)
        ("<="     . ?≤)
        (">="     . ?≥)
        ("..."    . ?…)
	("\\alpha" . ?α)
        ("\\beta" . ?β)
        ("\\gamma" . ?γ)
        ("\\delta" . ?δ)
        ("\\epsilon" . ?ε)
        ("\\zeta" . ?ζ)
        ("\\eta" . ?η)
        ("\\theta" . ?θ)
        ("\\iota" . ?ι)
        ("\\kappa" . ?κ)
        ("\\lambda" . ?λ)
        ("\\mu" . ?μ)
        ("\\nu" . ?ν)
        ("\\xi" . ?ξ)
        ("\\Pi" . ?π)
        ("\\rho" . ?ρ)
        ("\\sigma" . ?σ)
        ("\\tau" . ?τ)
        ("\\upsilon" . ?υ)
        ("\\phi" . ?φ)
        ("\\chi" . ?χ)
        ("\\psi" . ?ψ)
        ("\\omega" . ?ω)
        ("\\Alpha" . ?Α)
        ("\\Beta" . ?Β)
        ("\\Gamma" . ?Γ)
        ("\\Delta" . ?Δ)
        ("\\Epsilon" . ?Ε)
        ("\\Zeta" . ?Ζ)
        ("\\Eta" . ?Η)
        ("\\Theta" . ?Θ)
        ("\\Iota" . ?Ι)
        ("\\Kappa" . ?Κ)
        ("\\Lambda" . ?Λ)
        ("\\Mu" . ?Μ)
        ("\\Nu" . ?Ν)
        ("\\Xi" . ?Ξ)
        ("\\Pi" . ?Π)
        ("\\Rho" . ?Ρ)
        ("\\Sigma" . ?Σ)
        ("\\Tau" . ?Τ)
        ("\\Upsilon" . ?Υ)
        ("\\Phi" . ?Φ)
        ("\\Chi" . ?Χ)
        ("\\Psi" . ?Ψ)
        ("\\Omega" . ?Ω)
        ("\\sqrt" . ?√)
        ("\\infty" . ?∞)
        ("\\forall" . ?∀)
        ("\\exists" . ?∃)
        ("\\in" . ?∈)
        ("\\notin" . ?∉)
        ("\\subset" . ?⊂)
        ("\\subseteq" . ?⊆)
        ("\\supset" . ?⊃)
        ("\\supseteq" . ?⊇)
        ("\\times" . ?×)
        ("\\div" . ?÷)
        ("\\pm" . ?±)
        ("\\mp" . ?∓)
        ("\\cdot" . ?·)
        ("\\sum" . ?∑)
        ("\\prod" . ?∏)
        ("\\int" . ?∫)
        ("\\cap" . ?∩)
        ("\\cup" . ?∪)
        ("\\setminus" . ?∖)
        ("\\land" . ?∧)
        ("\\lor" . ?∨)
        ("\\neg" . ?¬)
        ("\\langle" . ?⟨)
        ("\\rangle" . ?⟩)
        ("\\ldots" . ?…)
        ("\\cdots" . ?⋯)
	("\\approx" . ?≈) ;; 约等于
;;==============箭头=====================
        ("\\Rightarrow" . ?⇒)
        ;("\\Leftarrow" . ?⇒)
        ("\\Leftrightarrow" . ?⇔)
        ("\\leftarrow" . ?←)
        ("\\rightarrow" . ?→)
        ("\\leftrightarrow" . ?↔)
        ("\\uparrow" . ?↑)
        ("\\downarrow" . ?↓)
        ("\\longrightarrow" . ?⟶)
        ("\\Longrightarrow" . ?⟹)
        ("\\longleftarrow" . ?⟵)
        ("\\Longleftarrow" . ?⟸)
        ("\\longleftrightarrow" . ?⟷)
        ("\\Longleftrightarrow" . ?⟺)
	("\\todo" . ?⬜)             ;; 待办事项
        ("\\done" . ?✅)             ;; 完成("\\dones" . 0x2705)
	))

(defun my/setup-prettify-symbols ()
  (setq prettify-symbols-alist my/prettify-symbols-alist)
  (prettify-symbols-mode 1))
(add-hook 'prog-mode-hook 'my/setup-prettify-symbols)
(add-hook 'org-mode-hook 'my/setup-prettify-symbols)
(setq prettify-symbols-unprettify-at-point t) ;自动展开光标处的替换
;;; ============latex-end =================================

(provide 'init-latex)
;;; latex config end
