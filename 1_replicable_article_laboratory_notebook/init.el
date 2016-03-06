(require 'org-install)
(require 'org)

(setq inhibit-splash-screen t)

(setq frame-title-format
  '("Emacs - " (buffer-file-name "%f"
    (dired-directory dired-directory "%b"))))

  (global-font-lock-mode t)
  (custom-set-faces
    '(flyspell-incorrect ((t (:inverse-video t)))))

(line-number-mode 1)
(column-number-mode 1)

(load-library "paren")
(show-paren-mode 1)
(transient-mark-mode t)
(require 'paren)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

    (setq
     ns-command-modifier 'meta         ; Apple/Command key is Meta
	 ns-alternate-modifier nil         ; Option is the Mac Option key
	 ns-use-mac-modifier-symbols  nil  ; display standard Emacs (and not standard Mac) modifier symbols
	 )

(cua-mode t)

(defun jump-mark ()
  (interactive)
  (set-mark-command (point)))
(defun beginning-of-defun-and-mark ()
  (interactive)
  (push-mark (point))
  (beginning-of-defun))
(defun end-of-defun-and-mark ()
  (interactive)
  (push-mark (point))
  (end-of-defun))

(global-set-key "\^c\^b" 'beginning-of-defun-and-mark)
(global-set-key "\^c\^e" 'end-of-defun-and-mark)
(global-set-key "\^c\^j" 'jump-mark)
(global-set-key [S-f6] 'jump-mark)		;; jump from mark to mark

(global-set-key "\M-g" 'goto-line)

(setq select-active-regions nil)
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard t)
(setq mouse-drag-copy-region t)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
;; C-x C-0 restores the default font size

;; Inspired from http://tex.stackexchange.com/questions/166681/changing-language-of-flyspell-emacs-with-a-shortcut
;; (defun spell (choice)
;;    "Switch between language dictionaries."
;;    (interactive "cChoose:  (a) American | (f) Francais")
;;     (cond ((eq choice ?1)
;;            (setq flyspell-default-dictionary "american")
;;            (setq ispell-dictionary "american")
;;            (ispell-kill-ispell))
;;           ((eq choice ?2)
;;            (setq flyspell-default-dictionary "francais")
;;            (setq ispell-dictionary "francais")
;;            (ispell-kill-ispell))
;;           (t (message "No changes have been made."))) )

(define-key global-map (kbd "C-c s a") (lambda () (interactive) (ispell-change-dictionary "american")))
(define-key global-map (kbd "C-c s f") (lambda () (interactive) (ispell-change-dictionary "francais")))
(define-key global-map (kbd "C-c s r") 'flyspell-region)
(define-key global-map (kbd "C-c s b") 'flyspell-buffer)
(define-key global-map (kbd "C-c s s") 'flyspell-mode)

(global-set-key [f5] '(lambda () (interactive) (revert-buffer nil t nil)))

(defun auto-fill-mode-on () (TeX-PDF-mode 1))
(add-hook 'tex-mode-hook 'TeX-PDF-mode-on)
(add-hook 'latex-mode-hook 'TeX-PDF-mode-on)
(setq TeX-PDF-mode t)

(defun auto-fill-mode-on () (auto-fill-mode 1))
(add-hook 'text-mode-hook 'auto-fill-mode-on)
(add-hook 'emacs-lisp-mode 'auto-fill-mode-on)
(add-hook 'tex-mode-hook 'auto-fill-mode-on)
(add-hook 'latex-mode-hook 'auto-fill-mode-on)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq org-directory "~/org/")

(setq org-hide-leading-stars t)
(setq org-alphabetical-lists t)
(setq org-src-fontify-natively t)  ;; you want this to activate coloring in blocks
(setq org-src-tab-acts-natively t) ;; you want this to have completion in blocks
(setq org-hide-emphasis-markers t) ;; to hide the *,=, or / markers
(setq org-pretty-entities t)       ;; to have \alpha, \to and others display as utf8 http://orgmode.org/manual/Special-symbols.html

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-default-notes-file "~/org/notes.org")
     (define-key global-map "\C-cd" 'org-capture)
(setq org-capture-templates (quote (("t" "Todo" entry (file+headline "~/org/liste.org" "Tasks") "* TODO %?
  %i
  %a" :prepend t) ("j" "Journal" entry (file+datetree "~/org/journal.org") "* %?
Entered on %U
  %i
  %a"))))

(setq org-agenda-include-all-todo t)
(setq org-agenda-include-diary t)

;; see http://thread.gmane.org/gmane.emacs.orgmode/42715
(eval-after-load 'org-list
  '(add-hook 'org-checkbox-statistics-hook (function ndk/checkbox-list-complete)))

(defun ndk/checkbox-list-complete ()
  (save-excursion
    (org-back-to-heading t)
    (let ((beg (point)) end)
      (end-of-line)
      (setq end (point))
      (goto-char beg)
      (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]" end t)
            (if (match-end 1)
                (if (equal (match-string 1) "100%")
                    ;; all done - do the state change
                    (org-todo 'done)
                  (org-todo 'todo))
              (if (and (> (match-end 2) (match-beginning 2))
                       (equal (match-string 2) (match-string 3)))
                  (org-todo 'done)
                (org-todo 'todo)))))))

(defun org-cua-dwim-turn-on-org-cua-mode-partial-support ()
  "This turns on org-mode cua-mode partial support; Assumes
shift-selection-mode is available."
  (interactive)
  (set (make-local-variable 'org-support-shift-select) t)
  (cua-mode 1)
  (add-hook 'pre-command-hook 'cua--pre-command-handler nil t)
  (add-hook 'post-command-hook 'cua--post-command-handler nil t)
  (set (make-local-variable 'cua-mode) t)
  (set (make-local-variable 'org-cua-dwim-was-move) nil)
  (set (make-local-variable 'shift-select-mode) nil))

;;;###autoload
(add-hook 'org-mode-hook 'org-cua-dwim-turn-on-org-cua-mode-partial-support)

(defvar org-cua-dwim-was-move nil)
(defvar org-cua-dwim-debug nil)
(defvar org-cua-dwim t)

(defadvice handle-shift-selection (around org-cua-dwim)
  (let ((is-org-mode (and (not (minibufferp))
                          (eq major-mode 'org-mode)))
        (do-it t))
    (setq org-cua-dwim-shift-translated this-command-keys-shift-translated)
    (when (and org-cua-dwim
               is-org-mode this-command-keys-shift-translated
               (not org-cua-dwim-was-move))
      (when org-cua-dwim-debug
        (message "Turn ON shift-select-mode & delete-selection-mode"))
      (delete-selection-mode 1)
      (set (make-local-variable 'org-cua-dwim-was-move) t)
      (set (make-local-variable 'cua--last-region-shifted) t)
      (set (make-local-variable 'cua--explicit-region-start) nil)
      (set (make-local-variable 'shift-select-mode) t)
      (set (make-local-variable 'cua-mode) nil))
    (when (and org-cua-dwim
               is-org-mode (not this-command-keys-shift-translated)
               org-cua-dwim-was-move)
      (when org-cua-dwim-debug
        (message "Turn Off shift-select-mode & delete-selection-mode"))
      (delete-selection-mode -1)
      (set (make-local-variable 'shift-select-mode) nil)
      (set (make-local-variable 'cua-mode) t)
      (set (make-local-variable 'org-cua-dwim-was-move) nil))
    (when do-it
      ad-do-it)
    (when (and org-cua-dwim
               is-org-mode
               mark-active)
      (cua--select-keymaps))))

(defmacro org-cua-dwim-fix-cua-command (cmd)
  "Defines advice for a CUA-command that will turn on CUA mode
before runnind ant hen run the `cua--precommand-handler'"
  `(progn
     (defadvice ,(intern cmd) (around org-cua-dwim)
     "Try to fix the org copy and paste problem."
     (when (and (not (minibufferp)) (not cua-mode)
                (eq major-mode 'org-mode))
       (when org-cua-dwim-debug
         (message "Turn Off shift-select-mode & delete-selection-mode  (CUA command)"))
       (delete-selection-mode -1)
       (set (make-local-variable 'shift-select-mode) nil)
       (set (make-local-variable 'cua-mode) t)
       (set (make-local-variable 'org-cua-dwim-was-move) nil)
       (cua--pre-command-handler))
     ad-do-it)
     (ad-activate ',(intern cmd))))

;; Advise all CUA commands active when selection is active
(org-cua-dwim-fix-cua-command "cua--prefix-override-handler")
(org-cua-dwim-fix-cua-command "cua-repeat-replace-region")
(org-cua-dwim-fix-cua-command "cua--shift-control-c-prefix")
(org-cua-dwim-fix-cua-command "cua--shift-control-x-prefix")
(org-cua-dwim-fix-cua-command "cua-toggle-rectangle-mark")
(org-cua-dwim-fix-cua-command "cua-delete-region")
(org-cua-dwim-fix-cua-command "cua-cut-region")
(org-cua-dwim-fix-cua-command "cua-copy-region")
(org-cua-dwim-fix-cua-command "cua-cancel")
(org-cua-dwim-fix-cua-command "cua-toggle-global-mark")
(org-cua-dwim-fix-cua-command "cua-paste")
(org-cua-dwim-fix-cua-command "cua-exchange-point-and-mark")
(org-cua-dwim-fix-cua-command "cua-scroll-down")
(org-cua-dwim-fix-cua-command "cua-scroll-up")
(org-cua-dwim-fix-cua-command "cua-set-mark")
(org-cua-dwim-fix-cua-command "cua-paste-pop")

(ad-activate 'handle-shift-selection)

(global-set-key (kbd "C-c d") 'insert-date)
(defun insert-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
                   ((not prefix) "** %Y-%m-%d")
                   ((equal prefix '(4)) "[%Y-%m-%d]"))))
      (insert (format-time-string format))))

(global-set-key (kbd "C-c t") 'insert-time-date)
(defun insert-time-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
                   ((not prefix) "[%H:%M:%S; %d.%m.%Y]")
                   ((equal prefix '(4)) "[%H:%M:%S; %Y-%m-%d]"))))
      (insert (format-time-string format))))

(global-set-key (kbd "C-c l") 'org-store-link)

(global-set-key (kbd "C-c <up>") 'outline-up-heading)
(global-set-key (kbd "C-c <left>") 'outline-previous-visible-heading)
(global-set-key (kbd "C-c <right>") 'outline-next-visible-heading)

(setq org-export-babel-evaluate nil)
(setq org-confirm-babel-evaluate nil)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     (sh . t)
     (python . t)
     (R . t)
     (ruby . t)
     (ocaml . t)
     (ditaa . t)
     (dot . t)
     (octave . t)
     (sqlite . t)
     (perl . t)
     (screen . t)
     (plantuml . t)
     (lilypond . t)
     (org . t)
     (makefile . t)
     ))
  (setq org-src-preserve-indentation t)

(add-to-list 'org-structure-template-alist
        '("s" "#+begin_src ?\n\n#+end_src" "<src lang=\"?\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("m" "#+begin_src emacs-lisp :tangle init.el\n\n#+end_src" "<src lang=\"emacs-lisp\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("r" "#+begin_src R :results output :session *R* :exports both\n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("R" "#+begin_src R :results output graphics :file (org-babel-temp-file \"figure\" \".png\") :exports both :width 600 :height 400 :session *R* \n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("RR" "#+begin_src R :results output graphics :file  (org-babel-temp-file (concat (file-name-directory (or load-file-name buffer-file-name)) \"figure-\") \".png\") :exports both :width 600 :height 400 :session *R* \n\n#+end_src" "<src lang=\"R\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("p" "#+begin_src python :results output :exports both\n\n#+end_src" "<src lang=\"python\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("P" "#+begin_src python :results output :session *python* :exports both\n\n#+end_src" "<src lang=\"python\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("b" "#+begin_src sh :results output :exports both\n\n#+end_src" "<src lang=\"sh\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("B" "#+begin_src sh :session foo :results output :exports both \n\n#+end_src" "<src lang=\"sh\">\n\n</src>"))

(add-to-list 'org-structure-template-alist
        '("g" "#+begin_src dot :results output graphics :file \"/tmp/graph.pdf\" :exports both
   digraph G {
      node [color=black,fillcolor=white,shape=rectangle,style=filled,fontname=\"Helvetica\"];
      A[label=\"A\"]
      B[label=\"B\"]
      A->B
   }\n#+end_src" "<src lang=\"dot\">\n\n</src>"))

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images) 
(add-hook 'org-mode-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-babel-result-hide-all)
