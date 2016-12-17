(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;;(global-set-key (kbd "C-x C-f") 'find-file)
;;(global-unset-key (kbd "C-x C-f"))
(helm-mode 1)
(setq helm-fuzzy-match nil)
;;(require 'ido)
;;(ido-mode t)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; different setting for linux
(setq projectile-indexing-method 'alien)
