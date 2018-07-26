(package-initialize)

(load "~/.emacs.d/archives")
(load-library "find-lisp")

(require 'org)
(defvar completion-engine "ivy")
(org-babel-load-file (concat user-emacs-directory "config.org"))
(org-babel-load-file (concat user-emacs-directory "helm.org"))
(org-babel-load-file (concat user-emacs-directory "ivy.org"))
(when
    (file-exists-p (concat user-emacs-directory "local.org"))
  (org-babel-load-file (concat user-emacs-directory "local.org")))

;; (setq disabled-command-function nil) or maybe only downcase-region
(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(sql-ms-program "sqlcmd"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-file "~/.emacs.d/org-clocktable-formatter.el")

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
