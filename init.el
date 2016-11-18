(load-theme 'wombat)
(column-number-mode)

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/")
	     t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade.org/packages/")
	     t)

(package-initialize)
(require 'iso-transl)

(setq inhibit-splash-screen t)

(prefer-coding-system 'utf-8)
(require 'yasnippet)
(yas-global-mode 1)
(setq x-select-enable-clipboard-manager nil)


;;(define-key key-translation-map [dead-tilde] "~")
(load "~/.emacs.d/ac")
(load "~/.emacs.d/js2")
(load "~/.emacs.d/nodejs-repl-eval")
(load "~/.emacs.d/smart-tabs")
(load "~/.emacs.d/multiple-cursors")
(load "~/.emacs.d/kbd-macros")
(load "~/.emacs.d/bookmark")
