
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;(package-initialize)

(load "~/.emacs.d/archives")

(load-theme 'wombat)
(column-number-mode)

(require 'iso-transl)

(setq inhibit-splash-screen t)

(prefer-coding-system 'utf-8)
(require 'yasnippet)
(yas-global-mode 1)
(setq x-select-enable-clipboard-manager nil)


;;(define-key key-translation-map [dead-tilde] "~")
(load "~/.emacs.d/babel")
(load "~/.emacs.d/dired")
(load "~/.emacs.d/smart-tabs")
(load "~/.emacs.d/ac")
(load "~/.emacs.d/js2")
(load "~/.emacs.d/kbd-macros")
(load "~/.emacs.d/bookmark")
(load "~/.emacs.d/orgmode")
(load "~/.emacs.d/comint")
(load "~/.emacs.d/nodejs-repl-eval")

(when (<= 26 emacs-major-version)
  (load "~/.emacs.d/multiple-cursors"))

(when (<= 25 emacs-major-version)
  (load "~/.emacs.d/mini-buffer"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (ac-emmet babel helm yasnippet smart-tabs-mode nodejs-repl multiple-cursors auto-complete ac-js2))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
