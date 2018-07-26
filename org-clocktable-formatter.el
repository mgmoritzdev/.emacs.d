(defun moritz/remove-clocktable-empty-lines ()
  (save-excursion
    (goto-char (point-min))
    (while t
      (search-forward "*0:00*")
      (forward-line -1)
      (kill-line)
      (kill-line)
      (kill-line)
      (kill-line)
      (setq kill-ring (cdr kill-ring))
      (setq kill-ring (cdr kill-ring))
      (setq kill-ring (cdr kill-ring))
      (search-backward "#+CAPTION")
      (org-mark-element)
      (indent-region (region-beginning)
                     (region-end))
      (pop-mark))))

(defun moritz/org-clocktable-write (ipos tables params)
  "Write out a clock table at position IPOS in the current buffer.
TABLES is a list of tables with clocking data as produced by
`org-clock-get-table-data'.  PARAMS is the parameter property list obtained
from the dynamic block definition."
  ;; This function looks quite complicated, mainly because there are a
  ;; lot of options which can add or remove columns.  I have massively
  ;; commented this function, the I hope it is understandable.  If
  ;; someone wants to write their own special formatter, this maybe
  ;; much easier because there can be a fixed format with a
  ;; well-defined number of columns...
  (let* ((lang (or (plist-get params :lang) "en"))
         (multifile (plist-get params :multifile))
         (block (plist-get params :block))
         (sort (plist-get params :sort))
         (header (plist-get params :header))
         (link (plist-get params :link))
         (maxlevel (or (plist-get params :maxlevel) 3))
         (emph (plist-get params :emphasize))
         (compact? (plist-get params :compact))
         (narrow (or (plist-get params :narrow) (and compact? '40!)))
         (level? (and (not compact?) (plist-get params :level)))
         (timestamp (plist-get params :timestamp))
         (properties (plist-get params :properties))
         (time-columns
          (if (or compact? (< maxlevel 2)) 1
            ;; Deepest headline level is a hard limit for the number
            ;; of time columns.
            (let ((levels
                   (cl-mapcan
                    (lambda (table)
                      (pcase table
                        (`(,_ ,(and (pred wholenump) (pred (/= 0))) ,entries)
                         (mapcar #'car entries))))
                    tables)))
              (min maxlevel
                   (or (plist-get params :tcolumns) 100)
                   (if (null levels) 1 (apply #'max levels))))))
         (indent (or compact? (plist-get params :indent)))
         (formula (plist-get params :formula))
         (case-fold-search t)
         (total-time (apply #'+ (mapcar #'cadr tables)))
         recalc narrow-cut-p)

    (when (and narrow (integerp narrow) link)
      ;; We cannot have both integer narrow and link.
      (message "Using hard narrowing in clocktable to allow for links")
      (setq narrow (intern (format "%d!" narrow))))

    (pcase narrow
      ((or `nil (pred integerp)) nil)	;nothing to do
      ((and (pred symbolp)
            (guard (string-match-p "\\`[0-9]+!\\'" (symbol-name narrow))))
       (setq narrow-cut-p t)
       (setq narrow (string-to-number (symbol-name narrow))))
      (_ (error "Invalid value %s of :narrow property in clock table" narrow)))

    ;; Now we need to output this table stuff.
    (goto-char ipos)

    ;; Insert the text *before* the actual table.
    (insert-before-markers
     (or header
         ;; Format the standard header.
         (format "#+CAPTION: %s %s%s\n"
                 (org-clock--translate "Clock summary at" lang)
                 (format-time-string (org-time-stamp-format t t))
                 (if block
                     (let ((range-text
                            (nth 2 (org-clock-special-range
                                    block nil t
                                    (plist-get params :wstart)
                                    (plist-get params :mstart)))))
                       (format ", for %s." range-text))
                   ""))))

    ;; Insert the narrowing line
    (when (and narrow (integerp narrow) (not narrow-cut-p))
      (insert-before-markers
       "|"				;table line starter
       (if multifile "|" "")		;file column, maybe
       (if level? "|" "")		;level column, maybe
       (if timestamp "|" "")		;timestamp column, maybe
       (if properties			;properties columns, maybe
           (make-string (length properties) ?|)
         "")
       (format "<%d>| |\n" narrow)))	;headline and time columns

    ;; Insert the table header line
    (insert-before-markers
     "|"				;table line starter
     (if multifile			;file column, maybe
         (concat (org-clock--translate "File" lang) "|")
       "")
     (if level?				;level column, maybe
         (concat (org-clock--translate "L" lang) "|")
       "")
     (if timestamp			;timestamp column, maybe
         (concat (org-clock--translate "Timestamp" lang) "|")
       "")
     (if properties			;properties columns, maybe
         (concat (mapconcat #'identity properties "|") "|")
       "")
     (concat (org-clock--translate "Headline" lang)"|")
     (concat (org-clock--translate "Time" lang) "|")
     (make-string (max 0 (1- time-columns)) ?|) ;other time columns
     (if (eq formula '%) "%|\n" "\n"))

    ;; Insert the total time in the table
    (insert-before-markers
     "|-\n"				;a hline
     "|"				;table line starter
     (if multifile (format "| %s " (org-clock--translate "ALL" lang)) "")
                                        ;file column, maybe
     (if level? "|" "")			;level column, maybe
     (if timestamp "|" "")		;timestamp column, maybe
     (make-string (length properties) ?|) ;properties columns, maybe
     (concat (format org-clock-total-time-cell-format
                     (org-clock--translate "Total time" lang))
             "| ")
     (format org-clock-total-time-cell-format
             (org-duration-from-minutes (or total-time 0) 'h:mm)) ;time
     "|"
     (make-string (max 0 (1- time-columns)) ?|)
     (cond ((not (eq formula '%)) "")
           ((or (not total-time) (= total-time 0)) "0.0|")
           (t  "100.0|"))
     "\n")

    ;; Now iterate over the tables and insert the data but only if any
    ;; time has been collected.
    (when (and total-time (> total-time 0))
      (pcase-dolist (`(,file-name ,file-time ,entries) tables)
        (when (or (and file-time (> file-time 0))
                  (not (plist-get params :fileskip0)))
          (insert-before-markers "|-\n") ;hline at new file
          ;; First the file time, if we have multiple files.
          (when multifile
            ;; Summarize the time collected from this file.
            (insert-before-markers
             (format (concat "| %s %s | %s%s"
                             (format org-clock-file-time-cell-format
                                     (org-clock--translate "File time" lang))
                             " | *%s*|\n")
                     (file-name-nondirectory file-name)
                     (if level?   "| " "")  ;level column, maybe
                     (if timestamp "| " "") ;timestamp column, maybe
                     (if properties	    ;properties columns, maybe
                         (make-string (length properties) ?|)
                       "")
                     (org-duration-from-minutes file-time 'h:mm)))) ;time

          ;; Get the list of node entries and iterate over it
          (when (> maxlevel 0)
            (pcase-dolist (`(,level ,headline ,ts ,time ,props) entries)
              (when narrow-cut-p
                (setq headline
                      (if (and (string-match
                                (format "\\`%s\\'" org-bracket-link-regexp)
                                headline)
                               (match-end 3))
                          (format "[[%s][%s]]"
                                  (match-string 1 headline)
                                  (org-shorten-string (match-string 3 headline)
                                                      narrow))
                        (org-shorten-string headline narrow))))
              (cl-flet ((format-field (f) (format (cond ((not emph) "%s |")
                                                        ((= level 1) "*%s* |")
                                                        ((= level 2) "/%s/ |")
                                                        (t "%s |"))
                                                  f)))
                (insert-before-markers
                 "|"		       ;start the table line
                 (if multifile "|" "") ;free space for file name column?
                 (if level? (format "%d|" level) "") ;level, maybe
                 (if timestamp (concat ts "|") "")   ;timestamp, maybe
                 (if properties		;properties columns, maybe
                     (concat (mapconcat (lambda (p) (or (cdr (assoc p props)) ""))
                                        properties
                                        "|")
                             "|")
                   "")
                 (if indent		;indentation
                     (org-clocktable-indent-string level)
                   "")
                 (format-field headline)
                 ;; Empty fields for higher levels.
                 (make-string (max 0 (1- (min time-columns level))) ?|)
                 (format-field (org-duration-from-minutes time 'h:mm))
                 (make-string (max 0 (- time-columns level)) ?|)
                 (if (eq formula '%)
                     (format "%.1f |" (* 100 (/ time (float total-time))))
                   "")
                 "\n")))))))
    (delete-char -1)
    (cond
     ;; Possibly rescue old formula?
     ((or (not formula) (eq formula '%))
      (let ((contents (org-string-nw-p (plist-get params :content))))
        (when (and contents (string-match "^\\([ \t]*#\\+tblfm:.*\\)" contents))
          (setq recalc t)
          (insert "\n" (match-string 1 contents))
          (beginning-of-line 0))))
     ;; Insert specified formula line.
     ((stringp formula)
      (insert "\n#+TBLFM: " formula)
      (setq recalc t))
     (t
      (user-error "Invalid :formula parameter in clocktable")))
    ;; Back to beginning, align the table, recalculate if necessary.
    (goto-char ipos)
    (skip-chars-forward "^|")
    (org-table-align)
    (when org-hide-emphasis-markers
      ;; We need to align a second time.
      (org-table-align))
    (when sort
      (save-excursion
        (org-table-goto-line 3)
        (org-table-goto-column (car sort))
        (org-table-sort-lines nil (cdr sort))))
    (when recalc (org-table-recalculate 'all))
    total-time)
  (moritz/remove-clocktable-empty-lines))
