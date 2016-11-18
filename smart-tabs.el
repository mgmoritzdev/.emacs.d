(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(smart-tabs-advice js2-indent-line js2-basic-offset)

(add-hook 'c-mode-common-hook
	  (lambda () (setq indent-tabs-mode t)))

(define-key global-map (kbd "RET") 'newline-and-indent)

(smart-tabs-add-language-support c++ c++-mode-hook
      ((c-indent-line . c-basic-offset)
       (c-indent-region . c-basic-offset)))

(smart-tabs-insinuate 'c 'javascript)
