(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-default-author "Андрей Люнгрин")
 '(org-agenda-files
   '("~/projects/org/journal/2022-01-26.org" "/home/chelovek/.jira/PB.org" "/home/chelovek/projects/org/journal.org"))
 '(org-latex-compiler "xelatex")
 '(org-preview-latex-process-alist
   '((dvipng :programs
             ("xelatex" "dvipng")
             :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
             (1.0 . 1.0)
             :latex-compiler
             ("xelatex -interaction nonstopmode -output-directory %o %f")
             :image-converter
             ("dvipng -D %D -T tight -o %O %f")
             :transparent-image-converter
             ("dvipng -D %D -T tight -bg Transparent -o %O %f"))
     (dvisvgm :programs
              ("latex" "dvisvgm")
              :description "dvi > svg" :message "you need to install the programs: latex and dvisvgm." :image-input-type "dvi" :image-output-type "svg" :image-size-adjust
              (1.7 . 1.5)
              :latex-compiler
              ("latex -interaction nonstopmode -output-directory %o %f")
              :image-converter
              ("dvisvgm %f -n -b min -c %S -o %O"))
     (imagemagick :programs
                  ("latex" "convert")
                  :description "pdf > png" :message "you need to install the programs: latex and imagemagick." :image-input-type "pdf" :image-output-type "png" :image-size-adjust
                  (1.0 . 1.0)
                  :latex-compiler
                  ("pdflatex -interaction nonstopmode -output-directory %o %f")
                  :image-converter
                  ("convert -density %D -trim -antialias %f -quality 100 %O"))))
 '(org-roam-capture-templates
   '(("d" "default" plain "%?" :target
      (file+head "${slug}.org" "#+title: ${title}
")
      :unnarrowed t)))
 '(org-startup-with-latex-preview t)
 '(projectile-project-search-path '("/home/chelovek/projects"))
 '(telega-server-libs-prefix "/usr"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
