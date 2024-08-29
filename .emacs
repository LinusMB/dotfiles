(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(unless package--initialized (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(use-package shell-command+
  :bind ("M-!" . shell-command+))
(use-package expand-region
  :bind ("C-q" . er/expand-region)
  :config
  (setq expand-region-fast-keys-enabled nil))
(use-package undo-fu
  :bind (("C-z" . undo-fu-only-undo)
	 ("C-S-z" . undo-fu-only-redo)))
(use-package drag-stuff
  :diminish drag-stuff-mode
  :bind (("M-p" . drag-stuff-up)
	 ("M-n" . drag-stuff-down))
  :config
  (drag-stuff-global-mode 1))
(use-package crux
  :bind (("C-a" . crux-move-beginning-of-line)
	 ("C-k" . crux-smart-kill-line)
	 ("C-j" . crux-top-join-line)
	 ("C-x 4 t" . crux-transpose-windows)))
(use-package format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters '(("JavaScript" (prettier "--tab-width" "4"))
                                        ("TypeScript" (prettier "--tab-width" "4"))
					("Python" (black))
					("Shell" (shfmt "4"))
					("C" (clang-format "--style" "{BasedOnStyle: GNU, IndentWidth: 4}")))))
(use-package go-mode
  :hook (go-mode . rc/go-mode-hook)
  :config
  (defun rc/go-mode-hook ()
    (setq tab-width 4 indent-tabs-mode 1)
    (when (executable-find "goimports")
      (setq gofmt-command "goimports"))
    (add-hook 'before-save-hook 'gofmt-before-save)))

(progn
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1)
  (delete-selection-mode 1)
  (global-auto-revert-mode 1)
  (savehist-mode 1)
  (recentf-mode 1)
  (show-paren-mode 1)
  (ido-mode 1)
  (ido-everywhere 1)
  (setq ido-enable-flex-matching nil)
  (setq inhibit-startup-screen t)
  (setq initial-scratch-message "")
  (setq-default frame-title-format '("%b"))
  (setq-default truncate-lines t)
  (setq ring-bell-function 'ignore)
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq use-dialog-box nil)
  (add-hook 'before-save-hook
	    'delete-trailing-whitespace)
  (add-to-list 'auto-mode-alist '("\\.[tT]e[xX]\\'" . fundamental-mode))
  (setq select-enable-clipboard t)
  (setq custom-file (make-temp-file "emacs-custom"))
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq create-lockfiles nil)
  (setq scroll-margin 1)
  (setq scroll-step 1)
  (setq scroll-conservatively 10000)
  (setq hscroll-margin 5)
  (setq hscroll-step 1)
  (setq scroll-preserve-screen-position 1))

(defun rc/comment-toggle ()
  (interactive)
  (if (region-active-p)
      (call-interactively 'comment-or-uncomment-region)
    (call-interactively 'comment-line)))

(defun rc/switchwindow ()
  (interactive)
  (cond ((= (count-windows) 2) (other-window 1))
	((> (count-windows) 2)
	 (let ((dir (read-char)))
	   (cond ((eq dir ?h) (windmove-left))
		 ((eq dir ?j) (windmove-down))
		 ((eq dir ?k) (windmove-up))
		 ((eq dir ?l) (windmove-right)))))))

(defun rc/insert-match ()
  (interactive)
  (let* ((c1 (read-char))
	 (c2 (cond ((eq c1 ?\() ?\))
		   ((eq c1 ?\[) ?\])
		   ((eq c1 ?\{) ?\})
		   ((eq c1 ?\<) ?\>)
		   (t c1))))
    (if (region-active-p)
	(save-excursion
	  (let ((start (region-beginning))
		(end (+ 1 (region-end))))
	    (goto-char start)
	    (insert c1)
	    (goto-char end)
	    (insert c2)))
      (insert c1 c2)
      (backward-char))))

(progn
  (keyboard-translate ?\C-h ?\C-?)
  (keyboard-translate ?\C-i ?\H-i)
  (global-set-key [mouse-3] 'mouse-popup-menubar-stuff)
  (global-unset-key (kbd "M-l"))
  (global-unset-key (kbd "M-u"))
  (global-unset-key (kbd "M-c"))
  (global-set-key (kbd "C-c l") 'downcase-word)
  (global-set-key (kbd "C-c u") 'upcase-word)
  (global-set-key (kbd "C-c c") 'capitalize-word)
  (global-set-key (kbd "C-.") 'dired-jump)
  (global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop)
  (global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)
  (global-set-key (kbd "M-z") 'zap-up-to-char)
  (global-set-key (kbd "M-Z") 'zap-to-char)
  (global-set-key (kbd "M-o") 'rc/switchwindow)
  (global-set-key (kbd "M-l") 'rc/insert-match)
  (global-set-key (kbd "M-c") 'rc/comment-toggle)
  (global-set-key [?\H-i] 'crux-duplicate-current-line-or-region)
  (global-set-key (kbd "C-x k") '(lambda () (interactive) (kill-buffer (current-buffer))))
  (global-set-key (kbd "C-o") '(lambda () (interactive) (scroll-down-command 2)))
  (global-set-key (kbd "C-v") '(lambda () (interactive) (scroll-up-command 2)))
  (global-set-key (kbd "C-x C-b") 'ibuffer)
  (global-set-key (kbd "C-x C-z") 'suspend-emacs))

; https://github.com/daylerees/colour-schemes/blob/master/emacs/github-theme.el
(custom-set-faces
  '(default ((t (:family "Inconsolata"
                 :foundry "unknown"
                 :width normal
                 :height 140
                 :weight normal
                 :slant normal
                 :underline nil
                 :overline nil
                 :strike-through nil
                 :box nil
                 :inverse-video nil
                 :foreground "#555555"
                 :background "#ffffff"
                 :stipple nil
                 :inherit nil))))
'(cursor ((t (:background "#444444"))))
'(fixed-pitch ((t (:family "Monospace"))))
'(variable-pitch ((t (:family "Sans Serif"))))
'(escape-glyph ((t (:foreground "brown"))))
'(minibuffer-prompt ((t (:foreground "#445588"))))
'(highlight ((t (:background "#ffe792" :foreground "#000000"))))
'(region ((t (:background "#008080"
              :foreground "#ffffff"))))
'(shadow ((t (:foreground "#3b3a32"))))
'(secondary-selection ((t (:background "#008080"))))
'(font-lock-builtin-face ((t (:foreground "#445588"))))
'(font-lock-comment-delimiter-face ((default (:inherit (font-lock-comment-face)))))
'(font-lock-comment-face ((t (:foreground "#b8b6b1"))))
'(font-lock-constant-face ((t (:foreground "#008080"))))
'(font-lock-doc-face ((t (:foreground "#7f7e7a"))))
'(font-lock-function-name-face ((t (:foreground "#DD1144"))))
'(font-lock-keyword-face ((t (:foreground "#445588"))))
'(font-lock-negation-char-face ((t nil)))
'(font-lock-preprocessor-face ((t (:foreground "#445588"))))
'(font-lock-regexp-grouping-backslash ((t (:inherit (bold)))))
'(font-lock-regexp-grouping-construct ((t (:inherit (bold)))))
'(font-lock-string-face ((t (:foreground "#DD1144"))))
'(font-lock-type-face ((t (:inherit 'default))))
'(font-lock-variable-name-face ((t (:foreground "#445588"))))
'(font-lock-warning-face ((t (:background "#00a8c6" :foreground "#f8f8f0"))))
'(button ((t (:inherit (link)))))
'(link ((((class color) (min-colors 88) (background light)) (:underline (:color foreground-color :style line) :foreground "RoyalBlue3")) (((class color) (background light)) (:underline (:color foreground-color :style line) :foreground "blue")) (((class color) (min-colors 88) (background dark)) (:underline (:color foreground-color :style line) :foreground "cyan1")) (((class color) (background dark)) (:underline (:color foreground-color :style line) :foreground "cyan")) (t (:inherit (underline)))))
'(link-visited ((default (:inherit (link))) (((class color) (background light)) (:foreground "magenta4")) (((class color) (background dark)) (:foreground "violet"))))
'(fringe ((((class color) (background light)) (:background "grey95")) (((class color) (background dark)) (:background "grey10")) (t (:background "gray"))))
'(header-line ((default (:inherit (mode-line))) (((type tty)) (:underline (:color foreground-color :style line) :inverse-video nil)) (((class color grayscale) (background light)) (:box nil :foreground "grey20" :background "grey90")) (((class color grayscale) (background dark)) (:box nil :foreground "grey90" :background "grey20")) (((class mono) (background light)) (:underline (:color foreground-color :style line) :box nil :inverse-video nil :foreground "black" :background "white")) (((class mono) (background dark)) (:underline (:color foreground-color :style line) :box nil :inverse-video nil :foreground "white" :background "black"))))
'(tooltip ((((class color)) (:inherit (variable-pitch) :foreground "black" :background "lightyellow")) (t (:inherit (variable-pitch)))))
'(mode-line ((((class color) (min-colors 88)) (:foreground "black" :background "grey75" :box (:line-width -1 :color nil :style released-button))) (t (:inverse-video t))))
'(mode-line-buffer-id ((t (:weight bold))))
'(mode-line-emphasis ((t (:weight bold))))
'(mode-line-highlight ((((class color) (min-colors 88)) (:box (:line-width 2 :color "grey40" :style released-button))) (t (:inherit (highlight)))))
'(mode-line-inactive ((default (:inherit (mode-line))) (((class color) (min-colors 88) (background light)) (:background "grey90" :foreground "grey20" :box (:line-width -1 :color "grey75" :style nil) :weight light)) (((class color) (min-colors 88) (background dark)) (:background "grey30" :foreground "grey80" :box (:line-width -1 :color "grey40" :style nil) :weight light))))
'(isearch ((t (:background "#ffe792" :foreground "#000000"))))
'(isearch-fail ((t (:background "#00a8c6" :foreground "#f8f8f0"))))
'(lazy-highlight ((t (:background "#ffe792" :foreground "#000000"))))
'(match ((t (:background "#ffe792" :foreground "#000000"))))
'(next-error ((t (:inherit (region)))))
'(query-replace ((t (:inherit (isearch))))))
