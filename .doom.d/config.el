;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "prostoichelovek"
      user-mail-address "i.prostoi.chelovek@yandex.ru")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/projects/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(fset 'evil-visual-update-x-selection 'ignore);; Amazing hack lifted from: http://emacs.stackexchange.com/a/15054/12585

(remove-hook 'tty-setup-hook 'doom-init-clipboard-in-tty-emacs-h)

(after! evil-snipe
  (evil-snipe-mode -1))

(setq org-journal-date-prefix "#+TITLE: "
      org-journal-time-prefix "* "
      org-journal-date-format "%a, %Y-%m-%d"
      org-journal-file-format "%Y-%m-%d.org")

(setq org-roam-directory "~/projects/org"
      org-roam-dailies-directory "daily")

(setq org-highlight-latex-and-related '(latex script entities))

(defun org-export-output-file-name-modified (orig-fun extension &optional subtreep pub-dir)
  (unless pub-dir
    (setq pub-dir "exports")
    (unless (file-directory-p pub-dir)
      (make-directory pub-dir)))
  (apply orig-fun extension subtreep pub-dir nil))
(advice-add 'org-export-output-file-name :around #'org-export-output-file-name-modified)

;; https://d12frosted.io/posts/2021-01-16-task-management-with-roam-vol5.html

(require 'vulpea-buffer)

(defun vulpea-project-p ()
  "Return non-nil if current buffer has any todo entry.

TODO entries marked as done are ignored, meaning the this
function returns nil if current buffer contains only completed
tasks."
  (org-element-map                          ; (2)
       (org-element-parse-buffer 'headline) ; (1)
       'headline
     (lambda (h)
       (eq (org-element-property :todo-type h)
           'todo))
     nil 'first-match))                     ; (3)

(add-hook 'find-file-hook #'vulpea-project-update-tag)
(add-hook 'before-save-hook #'vulpea-project-update-tag)

(defun vulpea-project-update-tag ()
      "Update PROJECT tag in the current buffer."
      (when (and (not (active-minibuffer-window))
                 (vulpea-buffer-p))
        (save-excursion
          (goto-char (point-min))
          (let* ((tags (vulpea-buffer-tags-get))
                 (original-tags tags))
            (if (vulpea-project-p)
                (setq tags (cons "project" tags))
              (setq tags (remove "project" tags)))

            ;; cleanup duplicates
            (setq tags (seq-uniq tags))

            ;; update tags if changed
            (when (or (seq-difference tags original-tags)
                      (seq-difference original-tags tags))
              (apply #'vulpea-buffer-tags-set tags))))))

(defun vulpea-buffer-p ()
  "Return non-nil if the currently visited buffer is a note."
  (and buffer-file-name
       (string-prefix-p
        (expand-file-name (file-name-as-directory org-roam-directory))
        (file-name-directory buffer-file-name))))

(defun vulpea-project-files ()
  "Return a list of note files containing 'project' tag." ;
  (seq-uniq
   (seq-map
    #'car
    (org-roam-db-query
     [:select [nodes:file]
      :from tags
      :left-join nodes
      :on (= tags:node-id nodes:id)
      :where (like tag (quote "%\"project\"%"))]))))

(defun vulpea-agenda-files-update (&rest _)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (vulpea-project-files)))

(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

; (add-hook 'org-mode-hook 'org-fragtog-mode)

; https://org-roam.discourse.group/t/org-roam-major-redesign/1198/193
; fixes 'Unable to resolve link <note id>'
(require 'find-lisp)
(setq org-id-extra-files (find-lisp-find-files org-roam-directory "\.org$"))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(defun center-text-for-reading (&optional arg)
  "Setup margins for reading long texts.
If ARG is supplied, reset margins and fringes to zero."
  (interactive "P")
  ;; Set the margin width to zero first so that the whole window is
  ;; available for text area.
  (set-window-margins (selected-window) 0)
  (let* ((max-text-width (save-excursion
                           (let ((w 0))
                             (goto-char (point-min))
                             (while (not (eobp))
                               (end-of-line)
                               (setq w (max w (current-column)))
                               (forward-line))
                             w)))
         (margin-width (if arg
                           0
                         (/ (max (- (+ (window-width)
                                       left-margin-width
                                       right-margin-width)
                                    max-text-width)
                                 0)
                            2))))
    (setq left-margin-width margin-width)
    (setq right-margin-width margin-width)
    ;; `set-window-margings' does a similar thing but those changes do
    ;; not persist across buffer switches.
    (set-window-buffer nil (current-buffer))))

;;; Basic configuration
(require 'hledger-mode)

;; To open files with .journal extension in hledger-mode
(add-to-list 'auto-mode-alist '("\\.journal\\'" . hledger-mode))

;; Provide the path to you journal file.
;; The default location is too opinionated.
(setq hledger-jfile (concat (file-name-as-directory org-roam-directory) "hledger.journal"))

(add-hook 'hledger-view-mode-hook #'hl-line-mode)
(add-hook 'hledger-view-mode-hook #'center-text-for-reading)

(add-hook 'hledger-view-mode-hook
          (lambda ()
            (run-with-timer 1
                            nil
                            (lambda ()
                              (when (equal hledger-last-run-command
                                           "balancesheet")
                                ;; highlight frequently changing accounts
                                (highlight-regexp "^.*\\(savings\\|cash\\).*$")
                                (highlight-regexp "^.*credit-card.*$"
                                                  'hledger-warning-face))))))

(add-hook 'hledger-mode-hook
          (lambda ()
            (make-local-variable 'company-backends)
            (add-to-list 'company-backends 'hledger-company)))

(add-hook 'hledger-input-post-commit-hook #'hledger-show-new-balances)
(add-hook 'hledger-input-mode-hook #'auto-fill-mode)
(add-hook 'hledger-input-mode-hook
          (lambda ()
            (make-local-variable 'company-idle-delay)
            (setq-local company-idle-delay 0.1)))

(require 'hledger-input)

(defun popup-balance-at-point ()
  "Show balance for account at point in a popup."
  (interactive)
  (if-let ((account (thing-at-point 'hledger-account)))
      (message (hledger-shell-command-to-string (format " balance -N %s "
                                                        account)))
    (message "No account at point")))


(map! :map hledger-input-mode-map
      "C-c C-b" 'popup-balance-at-point)
(map! "C-c e" 'hledger-capture
      "C-c j" 'hledger-run-command)

(setq hledger-input-buffer-height 20)

(require 'align)

(add-to-list 'align-rules-list
               `(hledger-accounts
                 (regexp . ,(rx (+ space)
                             (+? anything)
                             (group-n 1 space (+ space)
                              (? ?-)
                              (+ digit)
                              (? ?.)
                              (* digit))))
                 (group . 1)
                 (spacing . 2)
                 (justify . t)
                 (separate . entire)
                 (modes . '(hledger-mode))))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

(use-package ejira
  :init
  (setq jiralib2-url              "https://pizzabot.atlassian.net"
        jiralib2-auth             'token
        jiralib2-user-login-name  "iam.prostoi.chelovek@gmail.com"
        jiralib2-token            "x905AAhsWNUv0sX5yfj92ADC"

        ejira-org-directory       "~/.jira"
        ejira-projects            '("PB")

        ejira-priorities-alist    '(("Highest" . ?A)
                                    ("High"    . ?B)
                                    ("Medium"  . ?C)
                                    ("Low"     . ?D)
                                    ("Lowest"  . ?E))
        ejira-todo-states-alist   '(("To Do"       . 1)
                                    ("In Progress" . 2)
                                    ("Done"        . 3)))
  :config
  ;; Tries to auto-set custom fields by looking into /editmeta
  ;; of an issue and an epic.
  (add-hook 'jiralib2-post-login-hook #'ejira-guess-epic-sprint-fields)

  ;; They can also be set manually if autoconfigure is not used.
  ;; (setq ejira-sprint-field       'customfield_10001
  ;;       ejira-epic-field         'customfield_10002
  ;;       ejira-epic-summary-field 'customfield_10004)

  (require 'ejira-agenda)

  ;; Make the issues visisble in your agenda by adding `ejira-org-directory'
  ;; into your `org-agenda-files'.
  (add-to-list 'org-agenda-files ejira-org-directory)

  ;; Add an agenda view to browse the issues that
  (org-add-agenda-custom-command
   '("j" "My JIRA issues"
     ((ejira-jql "resolution = unresolved and assignee = currentUser()"
                 ((org-agenda-overriding-header "Assigned to me")))))))
