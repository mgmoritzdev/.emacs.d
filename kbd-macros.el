(fset 'setup-screens
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 51 24 111 24 right 24 50 21 54 24 S-dead-circumflex 32 24 111 24 right 24 111] 0 "%d")) arg)))

(global-set-key (kbd "C-x 9") 'setup-screens)
