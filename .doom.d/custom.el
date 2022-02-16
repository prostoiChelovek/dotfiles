(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-default-author "Андрей Люнгрин")
 '(org-agenda-files
   '("~/projects/org/journal/2022-01-26.org" "/home/chelovek/.jira/PB.org" "/home/chelovek/projects/org/journal.org"))
 '(org-latex-compiler "xelatex")
 '(org-roam-capture-templates
   '(("d" "default" plain "%?" :target
      (file+head "${slug}.org" "#+title: ${title}
")
      :unnarrowed t)))
 '(projectile-project-search-path '("/home/chelovek/projects"))
 '(telega-server-libs-prefix "/usr"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
