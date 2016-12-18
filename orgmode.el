(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-default-notes-file (concat "~/.emacs.d/org" "/notes.org"))


;; Org bullets, doesn't fit well in windows
(when linux-p
  (require 'org-bullets)
  (set-fontset-font "fontset-default"
                    'greek (font-spec :family "Fira Mono") nil 'prepend)
  (set-fontset-font "fontset-default" '(#x1f601 . #x1f567) "Symbola")

  (setq org-bullets-face-name "Inconsolata-12")
  (setq org-bullets-bullet-list
        '("◉" "◎" "⚫" "○" "►" "◇"))

  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
