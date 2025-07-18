(scroll-bar-mode -1)
(set-face-attribute 'default nil :height 220)
(set-face-background 'default "#222222")
(set-face-foreground 'default "#ffffff")

;; Line Number
(set-face-foreground 'line-number-current-line "#ffffff")
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

(tool-bar-mode -1)
(setq-default indent-tabs-mode nil) ; use spaces, not tabs
(setq-default tab-width 4)          ; show tab stops every 4 spaces
(setq-default c-basic-offset 4)     ; C/C++/Java indentation size
(scroll-bar-mode -1)

(require 'package)

;; Add GNU ELPA and MELPA archives
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; Initialize package system
(package-initialize)

;; Refresh package contents if needed
(unless package-archive-contents
  (package-refresh-contents))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ace-window cfrs company dashboard diff-hl doom-modeline go-mode helm
                hydra lsp-pyright lsp-ui magit neotree
                page-break-lines pfuture powerline treemacs tsc
                which-key-posframe)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; lsp-mode
(require 'lsp-mode)

;; C
;; LSP Mode Setup
(eval-when-compile
  (require 'use-package))

(use-package lsp-mode
  :hook ((c-mode c++-mode) . lsp)
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package company
  :config (global-company-mode))
(unless (package-installed-p 'lsp-mode)
  (package-refresh-contents)
  (package-install 'lsp-mode))

(dolist (pkg '(lsp-mode lsp-ui company use-package))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode) . lsp)
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company
  :ensure t
  :config (global-company-mode))

;; Enable lsp-mode automatically in C/C++ buffers
;; (add-hook 'c-mode-hook #'lsp)
;; (add-hook 'c++-mode-hook #'lsp)

;; Optional: Use lsp-ui for better UI
(require 'lsp-ui)
(add-hook 'lsp-mode-hook #'lsp-ui-mode)

;; lsp-mode
(require 'lsp-mode)

;; Register ruff-lsp client
;;(lsp-register-client
;; (make-lsp-client
;;  :new-connection (lsp-stdio-connection "ruff-lsp")
;;  :activation-fn (lsp-activate-on "python")
;;  :priority -1
;;  :server-id 'ruff-lsp))

;; Enable lsp-mode in python buffers
;; (add-hook 'python-mode-hook #'lsp)

;; Pyright
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))  ; or (lsp-deferred)
  )
(with-eval-after-load 'lsp-mode
  ;; Disable Ruff LSP
  (setq lsp-disabled-clients '(ruff-lsp))
)


;; Neotree
(global-set-key (kbd "C-x e") #'neotree-toggle)
(setq neo-smart-open t)
(setq neo-show-hidden-files t)

;; Shell
(setq shell-file-name "/bin/bash")

;; Dash
(require 'dashboard)
(dashboard-setup-startup-hook)

;; Screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; STOP THE BACKUPS
(setq make-backup-files nil)      ; no backups (main.c~)
(setq auto-save-default nil)      ; no auto-saves (#main.c#)

;; Cursor
(setq-default cursor-type '(bar . 2))

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Font
;; (set-face-attribute 'default nil :font "CodeNewRoman Nerd Font Propo")
;; (set-face-attribute 'default nil :font "CodeNewRoman Nerd Font Propo")
(set-face-attribute 'default nil :font "Operator Mono Lig Light Italic")

;; Dashboard
(global-set-key (kbd "C-x d") #'dashboard-open)

;; Calander
(global-set-key (kbd "C-x c") #'calendar)

;; "incline"
(defun my-header-line ()
  "Custom header line similar to incline.nvim."
  (let* ((filename (or (buffer-file-name) (buffer-name)))
         (modified (if (buffer-modified-p) "● " ""))
         (diagnostics
          (when (bound-and-true-p flymake-mode)
            (let ((errors 0) (warnings 0) (notes 0))
              (dolist (diag (flymake-diagnostics (point-min) (point-max)))
                (cl-incf (cl-case (flymake--diag-type diag)
                           (:error errors)
                           (:warning warnings)
                           (:note notes)))
                )
              (format " | ⚠ %d ✎ %d" warnings notes))))
         (header (concat modified (file-name-nondirectory filename)
                         (or diagnostics ""))))
    (concat "  " header)))

(defun enable-incline-style-header ()
  (setq header-line-format '((:eval (my-header-line)))))

(add-hook 'prog-mode-hook #'enable-incline-style-header)

;; JS LSP
(add-hook 'js-mode-hook #'lsp)      ;; for js-mode

;; DIFF-HL
(require 'diff-hl)

;; Enable diff-hl in all programming modes
(add-hook 'prog-mode-hook 'diff-hl-mode)

;; Enable real-time updates in the buffer (optional)
(diff-hl-flydiff-mode)

;; Integrate with Magit to refresh after commits
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

(add-hook 'text-mode-hook 'diff-hl-mode)
(add-hook 'conf-mode-hook 'diff-hl-mode)

;; BASH LSP
(use-package lsp-mode
  :ensure t
  :commands lsp
  :hook ((sh-mode) . lsp))  ;; ← Enable LSP in Bash files

;; Dired REBIND
(global-set-key (kbd "C-x f") #'dired)
(put 'upcase-region 'disabled nil)

;; Go
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
