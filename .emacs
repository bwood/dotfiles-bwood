;; ========PACKAGE LIST===========
;; Enable https for melpa
;; https://emacs.stackexchange.com/a/35953
;; TODO should this be an add to list?
;;(add-to-list 'gnutls-trustfiles "/private/etc/ssl/cert.pem")
;;;;(setq gnutls-trustfiles "/private/etc/ssl/cert.pem")

(require 'package)
(setq package-archives '(("melpa-stable" . "http://stable.melpa.org/packages/")
       	                 ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package org
  :config
  (setq org-startup-indented t)
  (setq org-agenda-start-with-follow-mode t)
  ;; http://orgmode.org/manual/Clocking-work-time.html#Clocking-work-time
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  (setq org-clock-into-drawer t))


; --- Workstation specific config ---
;; --- Window size and position ---
;; emacs 23:
;;(add-to-list 'default-frame-alist '(left . 1920))
;;(add-to-list 'default-frame-alist '(top . 0))
(add-to-list 'default-frame-alist '(height . 160))
(add-to-list 'default-frame-alist '(width . 140))

;; ==== Cursor color ====
(add-to-list 'default-frame-alist '(cursor-color . "spring green"))

;; Better highlighting for mode line
(set-face-attribute  'mode-line
                 nil 
                 :foreground "black"
                 :background "spring green" 
                 :box '(:line-width 1 :style released-button)
)
(set-face-attribute  'mode-line-inactive
                 nil 
                 :foreground "black"
                 :background "light gray"
                 :box '(:line-width 1 :style released-button)
)
;; See (set-face-attribute 'org-todo nil in the orgmode section below.

;; highlight the cursor line
(global-hl-line-mode 1)


(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-enable-flex-matching t)
 '(markdown-command "/usr/local/bin/markdown")
 '(org-agenda-files nil)
<<<<<<< HEAD
 '(package-selected-packages (quote (use-package org-clock-csv org))))
=======
 '(org-startup-indented t)
 '(package-selected-packages (quote (org-clock-csv org))))
>>>>>>> a0879eb6922e81e627f8f5e9bc067acecde5c702
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; turn on visible bell
(setq visible-bell t)

;; ========== MacOS Shit ==========
;; Mac Option Key as Meta
;; this makes it alt on the northgate ext. keyboard
;; would be nice to keep it as Cmd on MacBook keyboard...
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

(setq inhibit-splash-screen t)



;; ========== Place Backup Files in Specific Directory ==========
;; Enable backup files.
(setq make-backup-files t)

;; Enable versioning with default values (keep five last versions, I think!)
(setq version-control t)
;; just delete old backups, don't ask
(setq delete-old-versions t)
;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; iSpell
(setq ispell-program-name "/usr/local/bin/ispell")

;; ========ORG MODE ====================

;; -----------------------------------------------------------
;; org-mode
;; format string used when creating CLOCKSUM lines and when generating a
;; time duration (avoid showing days)
(setq org-duration-format (quote h:mm))

;; (require 'org-install) ;; used elpa on macbook, so not needed.
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "/Volumes/GoogleDrive/My Drive/Documents/orgmode/home/"
                             "/Volumes/GoogleDrive/My Drive/Documents/orgmode/work/"
                             "/Volumes/GoogleDrive/My Drive/Documents/orgmode/work/projects"))

;; Archive location
;; This allows searching archives, but since this dir is not in set-org-agenda-files
;; it will not be scanned for agenda commands
;; See C-h v org-archive-location
(setq org-archive-location "/Volumes/GoogleDrive/My Drive/Documents/orgmode/archive/%s_archive.org::")

;; Question at http://stackoverflow.com/questions/20979553/how-to-override-override-modeline-customization-from-org-faces-el
;; prevent org clock from using the same background as 'mode-line
;; (require 'org-faces)
;;(org-copy-face 'mode-line-inactive 'org-mode-line-clock
;;  "Face used for clock display in mode line."
;;  :background: "blue")
;;(provide 'org-faces)

;;(set-face-attribute 'org-todo nil
;;                    :weight 'bold :box '(:line-width 1 :color "#D8ABA7")
;;                    :foreground "black" :background "blue")
;;(require 'org-faces)

;; Emacs/Orgmode windows and frames
(setq org-agenda-window-frame-fractions '(0.5 . 0.5))

;; todo keywords
(setq org-todo-keywords
       '((sequence "TODO" "INPROG" "TESTING" "WAITING" "BLOCKED" "|" "DONE" "WONTFIX" ))) 

;;http://orgmode.org/manual/Faces-for-TODO-keywords.html
;;http://raebear.net/comp/emacscolors.html
(setq org-todo-keyword-faces
           '(("TODO" . org-warning) ("INPROG" . (:foreground "medium aquamarine" :weight bold))  ("DONE" . (:foreground "green" :weight bold)) ("WAITING" . (:foreground "dark khaki" :weight bold)) ("TESTING" . (:foreground "dark goldenrod" :weight bold)) ("WONTFIX" . (:foreground "DarkOliveGreen" :weight bold)) ("BLOCKED" . (:foreground "DarkOrange" :weight bold))))

;; Auto-archive DONE tasks
; http://stackoverflow.com/a/27043756
; not working?
;(defun org-archive-done-tasks ()
;  (interactive)
;  (org-map-entries
;   (lambda ()
;     (org-archive-subtree)
;     (setq org-map-continue-from (outline-previous-heading)))
;   "/DONE" 'tree))

;; Default properties
(setq org-global-properties
              '(("Effort_ALL". 
"1:00 
2:00 
3:00 
4:00 
5:00 
6:00 
7:00 
8:00
12:00
16:00"
                ) 
;; WPS = Web Platform Services.  Time tracking for Google Sheet begun with CalTime Migration
                ("wps_ALL". 
"Administration
American-Cultures-Web
APBears-Drupal
ASG-Consulting
bConnected-Consulting
bConnected-Website
BGC-Website
CalNet-Website
CATSIP-Website
Chanc-Office-Website
Chanc-RiskSvc-Website
Chemistry-Website
Disability-Compl-Website
Drupal-Community
Drupal-Ops-Managed
DSP-Website
EIS-Website
Enterprise-SOA
ERIT
ETS-Website
Gustafson-Website
Haas-Consulting
Holiday
HR-Web
IST-Staff-Drupal
IT-Service-Catalog-Drupal
Leave-Taken
Library-Bindery
LS-Web
OCIO-Service-Catalog
OCIO-Technology-Website
OFEW-Website
OFEW-FamilyEdge-Website
Open-Berkeley
Optometry-Website
ORIAS-Website
Pantheon-Admin
PCSSC-Website
PMB-Drupal
Private-Pages-Features
Procurement-Drupal
Professional-Developmt
Real-Estate-Website
RetirementCtr-Website
Research-Hub-Transition
SafeTREC-Website
Security-Website
Service-Now-Website
Software-Central-Website
Staff-Org-Website-OB
STC-Website
STFC-Website
StudentBilling-Web
Telecom-Website
Travel-Website
UCPD-Website
UCSF-PIVOT
UHS-OptoHub-Features
UHS-Policy-Website
UPP-Website
VCUE
Web-Accessibility
Web-Platform-Services
Website-Abatement-Proj
WPS-Console
"
                )
                ("tms_ALL". 
"Administration
Open_Berkeley--General
Open_Berkeley--Development
Open_Berkeley--Consulting
Open_Berkeley--Meetings
Open_Berkeley--Planning
Open_Berkeley--Monitor_Control_Uptime
Business_Development/Presales
Drupal_Community
Drupal_Ops_all_sites
Pantheon_Admin
bConnected_Ops_Work
UHS_Policy_Website
BAS_Parking_&_Transportation_Website
HR_Web
PMB_Drupal
iNews_DrupalTeam_Migration
IST_Staff_Drupal
Bamboo_Account_Services
APBears_Drupal
ASG_Consulting
ASG_Open_Berkeley_Sandbox
BAS_Business_Contracts
BAS_Library_Bindery
BAS_Office
BAS_Property_Management
BMAP_Drupal
BRCOE2_New_Website
Berkeley_Operating_Principles
Box.net
CATSIP_Drupal
CFO_Websites
CFO_Websites_OPA
Cal_Answers_Student_Financials
CalAnswers_Student_Curriculum
CalNet_Directory_Google_Contacts_integration_project
Campus_Life_Drupal
Career_Compass_Enhancements
Chancellor_GCR
Connected_Corridors_Drupal
Controller_Budget
Controller_Office
Controller_eBill
D-Lab
DOCS_Server_Transition
Direct_Bill_Travel_System
Gustafson_Website
IT_Service_Catalog_Drupal
IURD_Community_Portal
Kuali_Ready_Web_Access
LS
LS_Web
Matterhorn_Web_Access_Project
Mooclab
Night_Safety_PT
Night_Safety_UCPD
OCIO_Technology_Website
OE_Advising_Council
OE_CalTime
OE_MyPower
OE_Program_Office
OE_TSS
OE_bConn_Website
OE_bConnected_Project_Website
Office_of_the_Chancellor_Website
PATH_Drupal
Physics_Upgrade
Pinnacle-ServiceNow_Analysis
Procurement_Drupal
Public_Affairs_Chancellor_Website
SafeTrec_Drupal
Shared_Services_Drupal
Software_Central_Transition
Software_Central_Website
Staff_Org_Website
Student_Information_Systems_Project
Sustainability_Website
Telecom_Catalog_Website
UC_Family_Edge
UCPD_Website
UCSF_PIVOT
UREL_Access_upgrade
VCAF_Website
VPTLAPF_Web
Web_Accessibility
Web_Solutions_Website
Webform_CAS
")))

(define-key global-map (kbd "s-<right>") 'org-property-next-allowed-value)
(define-key global-map (kbd "s-<left>") 'org-property-previous-allowed-value)


;; Column view for effort estimates
; %5TAGS
(setq org-columns-default-format "%10CATEGORY %1PRIORITY %70ITEM(Task) %5Effort(Effort){:} %6CLOCKSUM")

(setq org-clock-modeline-total 'today)

;; Priorities: A-E. Default priority=E
(setq org-enable-priority-commands t)
(setq org-default-priority ?E)
(setq org-lowest-priority ?E)

;; Default dealine warning number of days
(setq org-deadline-warning-days 7)

(setq org-agenda-custom-commands
      '(("c" . "Priority views")
        ("cA" "#A" agenda "Show only priority A"
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#A\\]"))))
        ("ca" "#A, #B, #C" agenda "Show only priorities A and B"
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#[ABC]\\]"))))
        ("cb" "#B" agenda "Show only priority B"
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#B\\]"))))
        ("cc" "#C and below" agenda "Show only priorities C and below"
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#[CDE]\\]"))))

        ("cC" "#C" agenda "Show only priority C"
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#C\\]"))))
        ("cD" "#D" agenda "Show only priority D"
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#D\\]"))))
        ("cE" "#E" agenda "Show only priority E"
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#E\\]"))))

        ;; Agenda queries.  Allow searching archives
        ("Q" . "Custom queries") ;; gives label to "Q" 
        ("Qa" "Search *just* archive files" search ""
         ((org-agenda-files (file-expand-wildcards "/Volumes/GoogleDrive/My Drive/Documents/orgmode/archive/*.org")))) 
        ("QA" "Search archive *in addition* to non-archive files" search ""
         ((org-agenda-text-search-extra-files (file-expand-wildcards "/Volumes/GoogleDrive/My Drive/Documents/orgmode/archive/*.org"))))
        ;; ...other commands here
        ))

;; load agenda
; list agenda with unfiltered priorities
;(org-agenda-list)
; list agenda with my default priority filtering
(org-agenda nil "ca")

;; http://orgmode.org/guide/Setting-up-a-capture-location.html#Setting-up-a-capture-location

;; refiling
(setq org-outline-path-complete-in-steps t)
;(setq org-refile-use-outline-path t)
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 10))))
(setq org-reverse-note-order t)



;; wrap long lines
;; http://lists.gnu.org/archive/html/emacs-orgmode/2011-01/msg00290.html
(add-hook 'org-mode-hook
          '(lambda ()
	     (auto-fill-mode nil)
	     (visual-line-mode t)))

;; Capture
;; Notes
(setq org-default-notes-file (concat org-directory "/Volumes/GoogleDrive/My Drive/Documents/orgmode/capture.org")) 
(define-key global-map "\C-cc" 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
;; http://doc.norang.ca/org-mode.html#Capture
;; Journal
;; http://sachachua.com/blog/2014/11/using-org-mode-keep-process-journal/
(setq org-capture-templates
      (quote (("t" "todo" entry (file "/Volumes/GoogleDrive/My Drive/Documents/orgmode/capture.org")
               "* TODO %?\n%U\n%a\n  %i" :clock-in t :clock-resume t)
;This stores a link to the currently-clocked task and to whatever context I was looking at when I started the journal entry. It also copies the active region (if any), then positions my cursor after that text. 
;              ("j" "Journal entry" plain (file+datetree+prompt "/Volumes/GoogleDrive/My Drive/Documents/orgmode/work/journal.org")
;               "%K - %a\n%i\n%?\n")
; I want a headline
              ("j" "Journal entry" entry (file+datetree "/Volumes/GoogleDrive/My Drive/Documents/orgmode/work/journal.org")
               "* %? \n%K\n\n")
              ("n" "note" entry (file "/Volumes/GoogleDrive/My Drive/Documents/orgmode/capture.org")
               "* %? :NOTE:\n%U\n%a\n  %i" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "/Volumes/GoogleDrive/My Drive/Documents/orgmode/capture.org")
               "* TODO Review %c\n%U\n  %i" :immediate-finish t)
              ("i" "Interruption" entry (file "/Volumes/GoogleDrive/My Drive/Documents/orgmode/capture.org")
               "* Interruption %?\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "/Volumes/GoogleDrive/My Drive/Documents/orgmode/capture.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n  %i"))))

;; Markdown mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(add-hook 'markdown-mode-hook
        (lambda ()
          (when buffer-file-name
            (add-hook 'after-save-hook
                      'check-parens
                      nil t))))

;; ido-mode
;; https://www.emacswiki.org/emacs/InteractivelyDoThings#toc1
(require 'ido)
(ido-mode t)

;;;;;;;;;;;;;;;;
;; mu4e email ;;
;;;;;;;;;;;;;;;;

;;(add-to-list 'load-path (expand-file-name "/usr/local/share/emacs/site-lisp/mu/mu4e"))
;;
;;; make sure emacs finds applications in /usr/local/bin
;;(setq exec-path (cons "/usr/local/bin" exec-path))
;;
;;; require mu4e
;;(require 'mu4e)
;;
;;(setq mu4e-mu-binary "/usr/local/bin/mu")
;;
;;; tell mu4e to use w3m for html rendering
;;(setq mu4e-html2text-command "/usr/local/bin/w3m -T text/html")
;;
;;;;location of my maildir
;;(setq mu4e-maildir (expand-file-name "~/Maildir/mbsync"))
;;
;;; tell mu4e how to sync email
;;(setq mu4e-get-mail-command "/usr/local/bin/mbsync -a"
;;      mu4e-update-interval 150)
;;
;;;;rename files when moving
;;;;NEEDED FOR MBSYNC
;;(setq mu4e-change-filenames-when-moving t)
;;
;;;; The header field used for sorting is indicated by nicer symbols
;;(setq mu4e-use-fancy-chars t)
;;
;;(setq mu4e-contexts
;;    `( ,(make-mu4e-context
;;          :name "Home"
;;          :enter-func (lambda () (mu4e-message "Entering HOME context"))
;;          :leave-func (lambda () (mu4e-message "Leaving HOME context"))
;;          ;; we match based on the contact-fields of the message
;;          :match-func (lambda (msg)
;;                        (when msg 
;;                          (mu4e-message-contact-field-matches msg 
;;                            :to "bri@nwood.org")))
;;          :vars '( ( user-mail-address      . "bri@nwood.org"  )
;;                   ( user-full-name         . "Brian Wood" )
;;                   ( mu4e-compose-signature . "-Brian\n")
;;                   ;; Smart refiling http://www.djcbsoftware.nl/code/mu/mu4e/Other-dynamic-folders.html#Other-dynamic-folders
;;                   ( mu4e-sent-folder . "/home/[Gmail].Sent Mail")
;;                   ( mu4e-drafts-folder . "/home/[Gmail].Drafts")
;;                   ( mu4e-trash-folder .  "/home/[Gmail].Trash"))
;;       ,(make-mu4e-context
;;          :name "Work"
;;          :enter-func (lambda () (mu4e-message "Entering WORK context"))
;;          :leave-func (lambda () (mu4e-message "Leaving WORK context"))
;;          ;; no leave-func
;;          ;; we match based on the maildir of the message
;;          ;; this matches maildir /Arkham and its sub-directories
;;          :match-func (lambda (msg)
;;                        (when msg
;;                          (string-match-p "^/work" (mu4e-message-field msg :maildir))))
;;          :vars '( ( user-mail-address       . "bwood@berkeley.edu" )
;;                   ( user-full-name          . "Brian Wood" )
;;                   ( mu4e-compose-signature  .
;;                     (concat
;;                       "Brian Wood\n"
;;                       "Programmer Analyst\n"
;;		       "UC Berkeley - IST Web Platform Services\n"
;;                       "https://web.berkeley.edu\n")))
;;                   ;; Smart refiling http://www.djcbsoftware.nl/code/mu/mu4e/Other-dynamic-folders.html#Other-dynamic-folders
;;                   ( mu4e-sent-folder . "/work/[Gmail].Sent Mail")
;;                   ( mu4e-drafts-folder . "/work/[Gmail].Drafts")
;;                   ( mu4e-trash-folder . "/work/[Gmail].Trash")))))
;;;; enable inline images
;;(setq mu4e-view-show-images t)
;;;; use imagemagick, if available
;;(when (fboundp 'imagemagick-register-types)
;;  (imagemagick-register-types))
;;

