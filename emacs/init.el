;; -*- lexical-binding: t -*-
(blink-cursor-mode 0)
(column-number-mode t)
(global-hl-line-mode)
(load-theme 'tsdh-dark)
(setq custom-file "~/.config/emacs/custom.el") (if (file-readable-p custom-file) (load custom-file))
(setq delete-auto-save-files t)
(setq history-delete-duplicates t)
(setq history-length 500)
(setq make-backup-files nil)
(setq-default display-line-numbers 'relative)
(setq-default show-trailing-whitespace t)
(define-key global-map (kbd "C-h") 'delete-backward-char)
(define-key global-map (kbd "M-h") 'help-command)
(define-key global-map (kbd "M-h M-h") 'help-for-help)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
;; (package-refresh-contents)
(defun install-unless-present (name) (unless (package-installed-p name) (package-install name)))
(install-unless-present 'evil)
(install-unless-present 'evil-surround)
(install-unless-present 'evil-collection)
(install-unless-present 'evil-commentary)
(install-unless-present 'eglot)
(install-unless-present 'format-all)

(setq evil-toggle-key "")
(setq evil-want-C-u-delete t)
(setq evil-want-C-u-scroll t)
(setq evil-want-Y-yank-to-eol t)
(setq evil-search-module 'evil-search)
(setq evil-search-wrap nil)
(setq evil-split-window-below t)
(setq evil-vsplit-window-right t)
(setq evil-undo-system 'undo-redo)
(setq evil-backspace-join-lines nil)
(setq evil-kill-on-visual-paste nil)
(setq evil-want-keybinding nil)
(evil-mode 1)
(define-key evil-motion-state-map (kbd "<RET>") nil)
(define-key evil-motion-state-map (kbd "<SPC>") nil)

(global-evil-surround-mode)
(evil-commentary-mode)

(setq evil-collection-setup-minibuffer t)
(evil-collection-init)

(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'rust-mode-hook 'eglot-ensure)

(defmacro define-and-bind-quoted-text-object (name key start-regex end-regex)
  (let ((inner-name (make-symbol (concat "evil-inner-" name)))
	(outer-name (make-symbol (concat "evil-a-" name))))
    `(progn
       (evil-define-text-object ,inner-name (count &optional beg end type)
	 (evil-select-paren ,start-regex ,end-regex beg end type count nil))
       (evil-define-text-object ,outer-name (count &optional beg end type)
	 (evil-select-paren ,start-regex ,end-regex beg end type count t))
       (define-key evil-inner-text-objects-map ,key #',inner-name)
       (define-key evil-outer-text-objects-map ,key #',outer-name))))
(define-and-bind-quoted-text-object "pipe" "|" "|" "|")
(define-and-bind-quoted-text-object "slash" "/" "/" "/")
(define-and-bind-quoted-text-object "asterisk" "*" "*" "*")
(define-and-bind-quoted-text-object "dollar" "$" "\\$" "\\$")
