(when mswindows-p
  (set-face-attribute 'default nil
                      :family "Consolas" :height 100))
(when linux-p
  (set-face-attribute 'default nil
                      :family "Ubuntu Mono" :height 130))
