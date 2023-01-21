(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; This is only needed once, near the top of the file
(eval-when-compile
    (require 'use-package))

(use-package auto-compile
  :ensure t
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

(add-to-list 'load-path (concat user-emacs-directory "modes"))

(use-package bind-key
  :ensure t
  :config
  (add-to-list 'same-window-buffer-names "*Personal Keybindings*"))

(use-package projectile
  :ensure t
  :init
  (projectile-mode t)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package mu4e
  :ensure nil
  :config
  (setq mu4e-mu-binary (executable-find "mu"))
  (setq mu4e-maildir "~/Mail")
  (setq mu4e-contexts
	`(
	  ,(make-mu4e-context
	    :name "Gmail"
	    :match-func (lambda (msg)
			  (when msg
			    (mu4e-message-contact-field-matches
			     msg '(:from :to :cc :bcc) "nermax03@gmail.com")))

	    :vars '(
		    (mu4e-trash-folder . "/Gmail/[Gmail].Trash")
		    (mu4e-refile-folder . "/Gmail/[Gmail].Archive")
		    (mu4e-drafts-folder . "/Gmail/[Gmail].Drafts")
		    (mu4e-sent-folder . "/Gmail/[Gmail].Sent Mail")
		    (user-mail-address  . "nermax03@gmail.com")
		    (user-full-name . "Max Nerius")
		    (smtpmail-smtp-user . "nermax03")
		    (smtpmail-local-domain . "gmail.com")
		    (smtpmail-default-smtp-server . "smtp.gmail.com")
		    (smtpmail-smtp-server . "smtp.gmail.com")
		    (smtpmail-smtp-service . 587)))))
  (setq send-mail-function (quote smtpmail-send-it)))

(use-package mu4e-alert
  :ensure t
  :config
  (setq mu4e-alert-interesting-mail-query
	(concat
	 "flag:unread AND maildir:/GmailAccount/INBOX "
	 "OR "
	 "flag:unread AND maildir:/OutlookAccount/INBOX "
	 ))
  (mu4e-alert-set-default-style 'libnotify)
  (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
  (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
  (mu4e-alert-enable-mode-line-display))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(setq frame-inhibit-implied-resize nil)

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-light-medium t))

(set-frame-font "Iosevka Comfy Motion 11")

(setq split-width-threshold nil)
(setq split-height-threshold 0)

(menu-bar-mode 0)

(tool-bar-mode 0)

(toggle-scroll-bar 0)

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 23))

(global-hl-line-mode t)

(set-default 'cursor-type 'bar)

(use-package dashboard
  :ensure t
  :init
  (dashboard-setup-startup-hook)
  :config
  (setq dashboard-projects-backend 'projectile)
  (setq dashboard-items '((recents  . 5)
			  (bookmarks . 5)
			  (projects . 5)))
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-startup-banner "~/Pictures/meditate.png"))

(global-set-key [remap list-buffers] 'ibuffer)

(winner-mode 1)

(global-set-key (kbd "M-o") 'other-window)

(windmove-default-keybindings)

;(sentence-end-double-space nil)

;; Treat text written in CamelCase as distinct words (camel, case)
(subword-mode 1)
;; Treat text written in snake_case as one word (snakecase)
(superword-mode 1)

(global-set-key (kbd "C-M-i") 'imenu)

(global-set-key (kbd "C-c r") 'recompile)

(require 'org-tempo)

(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)
			     (haskell . t)))

(setq org-src-fontify-natively t)

(setq org-log-done 'time)

(custom-set-variables
 '(org-directory "~/.orgfiles/")
 '(org-agenda-files (list (concat org-directory "agenda_files/"))))

(setq org-default-notes-file (concat org-directory "notes.org"))

(setq org-capture-templates
      '(("t" "Todo" entry (file "agenda_files/agenda.org")
	 "* TODO %?\n %i\n")
	("c" "Media recommendation" entry (file "agenda_files/recom.org")
	 "* %?\n %i\n")
	("z" "Quote" entry (file "agenda_files/quotes.org")
	 "* %?\n %i\n")
	("i" "Idee" entry (file "agenda_files/ideen.org")
	 "* %?\n %i\n")))

(global-set-key (kbd "C-c c") 'org-capture)

(add-hook 'auto-save-hook 'org-save-all-org-buffers)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(global-set-key "\C-cl" 'org-store-link)

(global-set-key "\C-ca" 'org-agenda)

(setq org-todo-keywords
'((sequence "TODO(t)" "START(s)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)" "DELEGATED(a)")))

(setq org-ellipsis "⤵")

(setq org-src-fontify-natively t)

(setq org-src-tab-acts-natively t)

(setq org-agenda-include-diary t)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org-roam
  :ensure t
  :after org
  :init (setq org-roam-v2-ack t) ;; Acknowledge V2 upgrade
  :custom
  (org-roam-directory (concat org-directory "second_brain"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n f" . org-roam-node-find)
	 ("C-c n r" . org-roam-node-random)
	 ("M-i" . completion-at-point)
	 (:map org-mode-map
	       (("C-c n i" . org-roam-node-insert)
		("C-c n o" . org-id-get-create)
		("C-c n t" . org-roam-tag-add)
		("C-c n a" . org-roam-alias-add)
		("C-c n l" . org-roam-buffer-toggle)))
	 (:map org-roam-dailies-map
	       (("Y" . org-roam-dailies-capture-yesterday)
		("T" . org-roam-dailies-capture-tomorrow))))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (org-roam-setup)
  (org-roam-db-autosync-mode)
  (require 'org-roam-dailies))

;; (use-package org-roam-protocol
;;   :after org-roam
;;   :ensure t)

;; (use-package org-roam-export
;;   :after org-roam
;;   :ensure t)



(define-key minibuffer-local-completion-map (kbd "SPC") 'self-insert-command)

;; (custom-set-faces
;;   '((org-roam-link org-roam-link-current)
;;     :foreground "#e24888" :underline t))

(use-package org-journal
  :ensure t
  :after org
  :custom
  (org-roam-dailies-directory "journal/"))

(setq org-roam-dailies-capture-templates
      '(("d" "daily" plain (function org-roam-capture--get-point) ""
	 :immediate-finish t 
	 :file-name "dailies/%<%Y-%m-%d>" 
	 :head "#+TITLE: %<%Y-%m-%d>")))

(setq org-pretty-entities t)

(add-hook 'org-mode-hook #'turn-on-org-cdlatex)

(setq org-preview-latex-default-process 'imagemagick)

(with-eval-after-load 'org
  (add-to-list 'org-latex-packages-alist '("" "tcolorbox" t)))

(plist-put org-format-latex-options :scale 1.2)

(setq org-image-actual-width 350)

(setq cdlatex-env-alist
      '(("definition" "\\begin{tcolorbox}[title=Definition]\nAUTOLABEL\n?\n\\end{tcolorbox}\n" nil)
	("hinweis" "\\begin{tcolorbox}[title=Hinweis,colback=yellow!5!white,colframe=yellow!75!black]\nAUTOLABEL\n?\n\\end{tcolorbox}\n" nil)
	("warnung" "\\begin{tcolorbox}[title=Uffbasse!,colback=red!5!white,colframe=red!75!black]\nAUTOLABEL\n?\n\\end{tcolorbox}\n")))

(setq cdlatex-command-alist
      '(("defi" "Insert Definition env"   "" cdlatex-environment ("definition") t nil)
	("hinw" "Insert Hinweis env" "" cdlatex-environment ("hinweis") t nil)
	("warn" "Insert Warnung env" "" cdlatex-environment ("warnung") t nil)))

(setq org-hide-emphasis-markers t)

(setq org-startup-with-inline-images t)
(setq org-startup-with-latex-preview t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;  (use-package savehist
;    :init
;    :ensure t
;    (savehist-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode))

(setq backup-directory-alist
        `(("." . ,(concat user-emacs-directory "backups"))))

(use-package paredit
  :ensure t
  :mode ("\\.lisp?\\'" . paredit-mode))

(use-package company
  :ensure t
  :config
  (company-tng-configure-default))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  ;; disable flashy, distracting noise
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-doc-enable nil))

;  (use-package auctex
;    :ensure t)

(add-hook 'LaTeX-mode-hook 'prettify-symbols-mode)

(use-package elfeed
  :ensure t
  :custom
  (elfeed-search-filter "@2-days-ago +unread")
  (elfeed-search-title-max-width 100)
  (elfeed-search-title-min-width 100)
  (elfeed-feeds
   '(
     ;; programming
     ("https://news.ycombinator.com/rss" hacker)
     ("https://www.heise.de/developer/rss/news-atom.xml" heise)
     ("https://www.reddit.com/r/programming.rss" programming)
     ("https://www.reddit.com/r/emacs.rss" emacs)
     ("https://www.spektrum.de/alias/rss/spektrum-de-rss-feed/996406" spektrum)
     ("https://media.ccc.de/news.atom" ccc)
     )))
