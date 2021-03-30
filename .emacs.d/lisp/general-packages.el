;;; general-packages.el --- my standard packages file
;;; Commentary:
;;; Created by Patrik Hartlén

;;; Code:

(eval-when-compile (require 'cl))
(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

(defvar required-packages
  '(
    use-package
    counsel
    swiper
    ivy
    flx
    smex
    ace-jump-mode
    color-theme
    color-theme-sanityinc-tomorrow
    auto-complete
    smartparens
    flycheck
    exec-path-from-shell
    find-file-in-repository
    doom-modeline
    fringe-helper
    bm
    rainbow-delimiters
    golden-ratio
    browse-kill-ring
    color-moccur
    htmlize
    origami
    ;; base lang
    vdiff
    vdiff-magit
    magit
    forge
    lsp-mode
    lsp-ui
    company
    company-box
    projectile
    yasnippet
    plantuml-mode
    ;; debugging
    dap-mode
    ;; Simple langs
    yaml-mode
    nsis-mode
    ;; macOS
    exec-path-from-shell
    ;; Start of lang sections
    ;; Python lang
    pyvenv
    ;; Rust
    rust-mode
    toml-mode
    cargo
    ;; Java
    lsp-java
    ;; Web lang
    tide
    ;; C/C++ lang
    ;; C#
    csharp-mode
    omnisharp
    ;; Thrift
    thrift
    ;; Docker lang
    dockerfile-mode
    ;;
    ;; End of lang sections
    ) "A list of packages to ensure are installed at launch.")

(defun packages-installed-p ()
  "Check that all packages are installed."
  (loop for p in required-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

; if not all packages are installed, check one by one and install the missing ones.
(unless (packages-installed-p)
  ; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))

;;; general-packages.el ends here
