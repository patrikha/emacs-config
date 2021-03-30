;; .emacs --- dot emace file
;;; Commentary:
;;; Created by Patrik Hartlén

;;; Code:

;; -------------------------------------------------------- [ general settings ]

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(windmove-default-keybindings 'shift)
(show-paren-mode t)
(tool-bar-mode -1)
(column-number-mode t)
(global-display-line-numbers-mode t)
(setq ring-bell-function 'ignore
      inhibit-splash-screen t
      initial-scratch-message nil
      visible-bell nil
      mac-right-option-modifier nil
      backup-inhibited t
      auto-save-default nil
      tab-width 4)
(add-to-list 'load-path "~/.emacs.d/lisp/")
(defalias 'yes-or-no-p 'y-or-n-p)

(set-face-attribute 'default nil
                    :family "Hack"
                    :height 110
                    :weight 'regular
                    :width 'normal)


(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; --------------------------------------------------------- [ package manager ]
(load "general-packages.el")

;; ------------------------------------------------------------ [ color themes ]
(load-theme 'sanityinc-tomorrow-blue t)

;; -------------------------------------------------------- [ setup shell macOS]
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; ---------------------------------------------------------- [ doom-mode line ]
;; M-x all-the-icons-install-fonts
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;; ------------------------------------------------------------ [ ibuffer mode ]
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)
(require 'uniquify)

;; -------------------------------------------------------- [ ivy counsel smex ]
(use-package ivy
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "))

(use-package counsel
  :ensure t
  :config
  (use-package smex
    :ensure t)
  (use-package flx
    :ensure t)
  (ivy-mode 1)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t      . ivy--regex-fuzzy))))

(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; -------------------------------------------------------------- [ move lines ]
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(control shift up)]  'move-line-up)
(global-set-key [(control shift down)]  'move-line-down)

;; ------------------------------------------------------------ [ mode mapping ]
(add-to-list 'auto-mode-alist '("\\.msbuild\\'" . xml-mode))

;; ----------------------------------------------------------- [ general modes ]
(use-package magit
  :ensure t
  :bind (:map magit-mode-map
              ("e" . 'vdiff-magit-dwim)
              ("E" . 'vdiff-magit-popup))
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

;; https://magit.vc/manual/forge/Token-Creation.html#Token-Creation and store in .
(use-package forge
  :ensure t
  :after magit)
(with-eval-after-load 'forge
  (push '("github.schneider-electric.com" "github.schneider-electric.com/api/v3" "github.schneider-electric.com" forge-github-repository) forge-alist)
  )

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

(use-package browse-kill-ring+
  :load-path "~/.emacs.d/vendor"
  :bind
  ("M-y" . browse-kill-ring))

;; enable smartparens in programming buffers
(use-package smartparens
  :init (add-hook 'prog-mode-hook 'smartparens-mode)
  :bind
  ("M-<right>" . sp-forward-sexp)
  ("M-<left>" . sp-backward-sexp))

;; enable rainbow delimiters in all prgramming modes
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; enable bookmarks
(use-package bm)

;; enable golden ratio
(use-package golden-ratio
  :config
  (golden-ratio-mode 1))

;; enable color-moocur
(use-package color-moccur
  :ensure t
  :commands (isearch-moccur isearch-all)
  :bind (("M-s O" . moccur)
         :map isearch-mode-map
         ("M-o" . isearch-moccur)
         ("M-O" . isearch-moccur-all))
  :init
  (setq isearch-lazy-highlight t)
  :config
  (use-package moccur-edit))

;; enable code folding
(use-package origami)

;; autostart smerge
(autoload 'smerge-mode "smerge-mode" nil t)

;; (defun sm-try-smerge ()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (when (re-search-forward "^<<<<<<< " nil t)
;;       (vc-resolve-conflicts))))
;; (add-hook 'find-file-hook 'sm-try-smerge t)

;; ----------------------------------------------------- [ company & lsp modes ]
(use-package projectile
  :ensure t
  :config
  (setq projectile-completion-system 'ivy))

(use-package lsp-mode
  :config
  (add-hook 'prog-mode-hook #'lsp)
  :commands lsp
  :init
  (setq js-indent-level 2)
  (setq-default indent-tabs-mode nil)
  (setq lsp-enable-snippet nil))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  )
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

;; use icons for company-mode
(use-package company-box
  :hook (company-mode . company-box-mode))

;; in case you are using client which is available as part of lsp refer to the
;; table bellow for the clients that are distributed as part of lsp-mode.el
;; (require 'lsp-clients)
;; (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
;; (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)

;; --------------------------------------------------------------- [ debugging ]
(dap-mode 1)
(dap-ui-mode 1)

;; ---------------------------------------------------------------- [ plantuml ]
;; M-x plantuml-download-jar<RET>
;; sudo pacman -S graphviz
(use-package plantuml-mode
  :init
  (setq plantuml-default-exec-mode 'jar)
  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode)))

;; -------------------------------------------------------------------- [ bash ]
;; sudo npm i -g bash-language-server

;; ---------------------------------------------------------------- [ markdown ]
;; sudo pacman -S discount

;; ------------------------------------------------------------------ [ python ]
;; sudo pacman -S python-language-server
;; pip install python-language-server[all] ptvsd (debugging)
(require 'dap-python)

(defun my-python-flycheck-setup ()
  (add-to-list 'flycheck-checkers 'lsp)
  (flycheck-add-next-checker 'lsp 'python-pylint))

(with-eval-after-load 'lsp
  (with-eval-after-load 'flycheck
    (add-hook 'python-mode-hook 'flycheck-mode)
    (add-hook 'python-mode-hook 'my-python-flycheck-setup)))
(setq py-shell-name "ipython"
      py-python-command-args '("-i")
      python-shell-interpreter "ipython")

;; -------------------------------------------------------------------- [ java ]
(use-package lsp-java
  :ensure t
  :config
  (add-hook 'java-mode-hook
	    (lambda ()
	      (setq-local company-backends (list 'company-lsp))))

  (add-hook 'java-mode-hook 'lsp-java-enable)
  (add-hook 'java-mode-hook 'flycheck-mode)
  (add-hook 'java-mode-hook 'company-mode)
  (add-hook 'java-mode-hook 'lsp-ui-mode))

;; -------------------------------------------------------------------- [ web ]
;; npm i -g javascript-typescript-langserver
;; npm i -g vscode-css-languageserver-bin
;; npm i -g vscode-html-languageserver-bin
;; npm i -g jsonlint

;; ------------------------------------------------------------- [ typescript ]
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; ------------------------------------------------------------------ [ c/c++ ]
;; clangd

;; ------------------------------------------------------------------- [ rust ]
;; rustup component add rls rust-src clippy
;; pacman -S rust-analyser
(use-package toml-mode)
(use-package cargo
  :hook (rust-mode . cargo-minor-mode))
(setq lsp-rust-server 'rust-analyzer)

;; --------------------------------------------------------------------- [ c# ]
(eval-after-load
  'company
  '(add-to-list 'company-backends #'company-omnisharp))

(defun my-csharp-mode-setup ()
  (omnisharp-mode)
  (company-mode)
  (flycheck-mode)

  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq truncate-lines t)
  (setq tab-width 4)
  (setq evil-shift-width 4)

  ;csharp-mode README.md recommends this too
  ;(electric-pair-mode 1)       ;; Emacs 24
  ;(electric-pair-local-mode 1) ;; Emacs 25

  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile))

(add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)

;; ----------------------------------------------------------------- [ docker ]
;; sudo npm install -g dockerfile-language-server-nodejs

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(elixir-mode forge c-c-combo nsis-mode yasnippet yaml-mode vdiff-magit use-package thrift smex smartparens rust-mode rainbow-delimiters pyvenv projectile origami omnisharp lsp-ui lsp-java htmlize golden-ratio fringe-helper flx find-file-in-repository exec-path-from-shell doom-modeline dockerfile-mode dap-mode counsel company-lsp color-theme-sanityinc-tomorrow color-theme color-moccur browse-kill-ring bm ace-jump-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
