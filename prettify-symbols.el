;;; prettify-symbols --- Pretty symbols substitution configuration
;;; Commentary:

;;; Code:
(defun js2-pretty-symbols ()
  "Make some word or string show as pretty Unicode symbols for \"js2-mode\"."
  (setq prettify-symbols-alist
        '(
          ("lambda" . 955)   ; λ
          ("->" . 8594)      ; →
          ("=>" . 8658)      ; ⇒
          ("function" . 402) ; ƒ
          ))
  (prettify-symbols-mode))

(defun python-pretty-symbols ()
  "Make some word or string show as pretty Unicode symbols for \"python-mode\"."
  (setq prettify-symbols-alist
        '(
          ("lambda" . 955)   ; λ
          ("->" . 8594)      ; →
          ))
  (prettify-symbols-mode))


(defun emacs-lisp-pretty-symbols ()
  "Make some word or string show as pretty Unicode symbols for \"emacs-lisp-mode\"."
  (setq prettify-symbols-alist
        '(
          ("lambda" . 955)   ; λ
          ))
  (prettify-symbols-mode))

(defun org-pretty-symbols ()
  "Make some word or string show as pretty Unicode symbols for \"org-mode\"."
  (setq prettify-symbols-alist
        '(
          ("#+BEGIN_SRC" . 160)   ; nbsp
          ("#+begin_src" . 160)   ; nbsp
          ("#+END_SRC" . 160)   ; nbsp
          ("#+end_src" . 160)   ; nbsp
          ))
  (prettify-symbols-mode))


(add-hook 'js2-mode-hook 'js2-pretty-symbols)
(add-hook 'python-mode-hook 'python-pretty-symbols)
(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-pretty-symbols)
(add-hook 'org-mode-hook 'org-pretty-symbols)


;;; prettify-symbols.el ends here

