;;(define-key global-map (kbd "RET") 'newline-and-indent)
(setq-default tab-width 2)

;; disable tabs globally and reactivate for CC Mode
(setq-default indent-tabs-mode nil)
(add-hook 'c-mode-common-hook
	  (lambda () (setq indent-tabs-mode t)))

(smart-tabs-add-language-support c++ c++-mode-hook
      ((c-indent-line . c-basic-offset)
       (c-indent-region . c-basic-offset)))

(setq js-indent-level 2)
(smart-tabs-advice js2-indent-line js2-basic-offset)
(smart-tabs-insinuate 'c 'javascript)
