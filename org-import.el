(defun org-import--guess-mode-by-filename (filename)
  "根据FILENAME猜测major mode"
  (with-temp-buffer
    (insert-file-contents filename)
    (let ((buffer-file-name filename))
      (normal-mode)
      major-mode)))

(defun org-import-file (file &optional buf)
  (interactive "f")
  (let* ((buf (or buf (current-buffer)))
         (mode (org-import--guess-mode-by-filename file))
         (mode (symbol-name mode))
         (mode (replace-regexp-in-string "-mode$" "" mode)))
    (with-current-buffer buf
      (goto-char (point-max))
      (insert (format "#+begin_src %s :tangle \"%s\"\n" mode file))
      (newline)
      (insert "#+end_src\n")
      (forward-line -1)
      (org-edit-src-code)
      (insert-file-contents file)
      (org-edit-src-exit))))
