;;; org-auctex-keys.el --- Support of many AUCTeX key bindings for Org documents

;; Copyright (C) 2013 Fabrice Niessen

;;; Commentary:

;;; Code:

;;---------------------------------------------------------------------------
;; user-configurable variables


;;---------------------------------------------------------------------------
;; internal variables

(defvar org-auctex-keys-minor-mode nil
  "Non-nil if using \"Org AUCTeX Keys\" mode as a minor mode of some other mode.
Use the command `org-auctex-keys-minor-mode' to toggle or set this variable.")

(defvar org-auctex-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-s") 'org-insert-heading)
    (define-key map (kbd "C-c C-f") 'org-auckeys-font)
    (define-key map (kbd "C-c C-e") 'org-auckeys-environment)
    map)
  "Keymap for Org AUCTeX Keys minor mode.")

(easy-menu-define org-auctex-keys-minor-mode-menu org-auctex-keys-minor-mode-map
  "Menu used when Org AUCTeX Keys minor mode is active."
  '("AUCKeys"
    ("Insert Font"
     ["Bold"       (org-auckeys-font nil ?\C-b) :keys "C-c C-f C-b"]
     ["Typewriter" (org-auckeys-font nil ?\C-t) :keys "C-c C-f C-t"]
     ["Italic"     (org-auckeys-font nil ?\C-i) :keys "C-c C-f C-i"])
    ["Insert list item" org-auckeys-environment]
    ))

(defvar org-auckeys-font-list
  '((?\C-b "*" "*")
    (?\C-i "/" "/")
    (?\C-t "=" "="))
  "Font commands used with org-auckeys.")

(defvar org-auckeys-mode-text " AUCKeys")

;;---------------------------------------------------------------------------
;; commands

;;;###autoload
(define-minor-mode org-auctex-keys-minor-mode
  "Minor mode to keep you efficient editing Org mode documents with AUCTeX key bindings."
  :group 'org-auctex-keys
  :lighter org-auckeys-mode-text
  :keymap org-auctex-keys-minor-mode-map
  (if org-auctex-keys-minor-mode
      (message "Org AUCTeX Keys minor mode ENABLED")
    (message "Org AUCTeX Keys minor mode DISABLED")))

;;;###autoload
(defun turn-off-org-auctex-keys ()
  (interactive)
  "Unconditionally turn off `org-auctex-keys-minor-mode'."
  (org-auctex-keys-minor-mode -1))

;;;###autoload
(defun turn-on-org-auctex-keys ()
  "Unconditionally turn off `org-auctex-keys-minor-mode'."
  (org-auctex-keys-minor-mode 1))

(defun org-auckeys-describe-font-entry (entry)
  "A textual description of an ENTRY in `org-auckeys-font-list'."
  (concat (format "%16s  " (key-description (char-to-string (nth 0 entry))))
          (format "%8s %4s"
                  (nth 1 entry)
                  (nth 2 entry))))

(defun org-auckeys-font (replace what)
  "Insert template for font change command.
If REPLACE is not nil, replace current font.  WHAT determines the font
to use, as specified by `org-auckeys-font-list'."
  (interactive "*P\nc")
  (let* ((entry (assoc what org-auckeys-font-list))
         (before (nth 1 entry))
         (after (nth 2 entry)))
    (cond ((null entry)
           (let ((help (concat
                        "Font list:   "
                        "KEY        TEXTFONT\n\n"
                        (mapconcat 'org-auckeys-describe-font-entry
                                   org-auckeys-font-list "\n"))))
             (with-output-to-temp-buffer "*Help*"
               (set-buffer "*Help*")
               (insert help))))
          ;; (replace
          ;;  (funcall org-auckeys-font-replace-function before after))
          ((region-active-p)
           (save-excursion
             (cond ((> (mark) (point))
                    (insert before)
                    (goto-char (mark))
                    (insert after))
                   (t
                    (insert after)
                    (goto-char (mark))
                    (insert before)))))
          (t
           (insert before)
           (save-excursion
             (insert after))))))

(defun org-auckeys-environment ()
  "Insert list item syntax at point."
  (interactive)
  (insert "- "))

;;---------------------------------------------------------------------------
;; that's it

(provide 'org-auctex-keys)

;;; org-auctex-keys.el ends here