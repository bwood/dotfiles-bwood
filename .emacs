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
 '(markdown-command "/usr/local/bin/markdown")
 '(org-agenda-files (quote ("~/Documents/orgmode/work/projects/ls.org" "/Users/bwood/Documents/orgmode/work/system_maintenance.org" "/Users/bwood/Documents/orgmode/home/home.org" "/Users/bwood/Documents/orgmode/home/music.org" "/Users/bwood/Documents/orgmode/work/20141014.org" "/Users/bwood/Documents/orgmode/work/abatement.org" "/Users/bwood/Documents/orgmode/work/admin.org" "/Users/bwood/Documents/orgmode/work/anki.org" "/Users/bwood/Documents/orgmode/work/berkeley-drops-7_dist.org" "/Users/bwood/Documents/orgmode/work/community.org" "/Users/bwood/Documents/orgmode/work/css.org" "/Users/bwood/Documents/orgmode/work/cts.org" "/Users/bwood/Documents/orgmode/work/drupal.org" "/Users/bwood/Documents/orgmode/work/ets.org" "/Users/bwood/Documents/orgmode/work/foundational.org" "/Users/bwood/Documents/orgmode/work/ideas.org" "/Users/bwood/Documents/orgmode/work/javascript.org" "/Users/bwood/Documents/orgmode/work/journal.org" "/Users/bwood/Documents/orgmode/work/misc.org" "/Users/bwood/Documents/orgmode/work/oc.org" "/Users/bwood/Documents/orgmode/work/open_berkeley.org" "/Users/bwood/Documents/orgmode/work/operations-allsites.org" "/Users/bwood/Documents/orgmode/work/pantheon.org" "/Users/bwood/Documents/orgmode/work/parking.org" "/Users/bwood/Documents/orgmode/work/presales.org" "/Users/bwood/Documents/orgmode/work/professional_development.org" "/Users/bwood/Documents/orgmode/work/rct.org" "/Users/bwood/Documents/orgmode/work/reports.org" "/Users/bwood/Documents/orgmode/work/security.org" "/Users/bwood/Documents/orgmode/work/socrates.org" "/Users/bwood/Documents/orgmode/work/training.org" "/Users/bwood/Documents/orgmode/work/ucb_cas.org" "/Users/bwood/Documents/orgmode/work/ucb_envconf.org" "/Users/bwood/Documents/orgmode/work/projects/asg-charlesjames.org" "/Users/bwood/Documents/orgmode/work/projects/bamboo.org" "/Users/bwood/Documents/orgmode/work/projects/bamboo_acctsvcs.org" "/Users/bwood/Documents/orgmode/work/projects/bamboo_dirt.org" "/Users/bwood/Documents/orgmode/work/projects/box.org" "/Users/bwood/Documents/orgmode/work/projects/calanswers.org" "/Users/bwood/Documents/orgmode/work/projects/caltime.org" "/Users/bwood/Documents/orgmode/work/projects/campuslife.org" "/Users/bwood/Documents/orgmode/work/projects/careercompass.org" "/Users/bwood/Documents/orgmode/work/projects/catsip.org" "/Users/bwood/Documents/orgmode/work/projects/chancellor.org" "/Users/bwood/Documents/orgmode/work/projects/hrweb-ob.org" "/Users/bwood/Documents/orgmode/work/projects/hrweb.org" "/Users/bwood/Documents/orgmode/work/projects/ist-staff.org" "/Users/bwood/Documents/orgmode/work/projects/ocio.org" "/Users/bwood/Documents/orgmode/work/projects/oepo.org" "/Users/bwood/Documents/orgmode/work/projects/optometry.org" "/Users/bwood/Documents/orgmode/work/projects/pmb.org" "/Users/bwood/Documents/orgmode/work/projects/procurment.org" "/Users/bwood/Documents/orgmode/work/projects/public_affairs.org" "/Users/bwood/Documents/orgmode/work/projects/safetrec.org" "/Users/bwood/Documents/orgmode/work/projects/scholar.org" "/Users/bwood/Documents/orgmode/work/projects/security-website.org" "/Users/bwood/Documents/orgmode/work/projects/stafforg.org" "/Users/bwood/Documents/orgmode/work/projects/techcommons.org" "/Users/bwood/Documents/orgmode/work/projects/uhs.org" "/Users/bwood/Documents/orgmode/work/projects/vcaf.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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

;; ========PACKAGE LIST===========
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;; ========ORG MODE ====================

;; -----------------------------------------------------------
;; org-mode

;; (require 'org-install) ;; used elpa on macbook, so not needed.
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/Documents/orgmode/home/"
                             "~/Documents/orgmode/work/"
                             "~/Documents/orgmode/work/projects"))

;; Archive location
;; This allows searching archives, but since this dir is not in set-org-agenda-files
;; it will not be scanned for agenda commands
;; See C-h v org-archive-location
(setq org-archive-location "~/Documents/orgmode/archive/%s_archive.org::")

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
; RESOLVED = done but not archived
; DONE = done and archived

(setq org-todo-keywords
       '((sequence "TODO" "INPROG" "|" "WONTFIX" "RESOLVED" "DONE" ))) 
;  "BLOCKED" "CANCELED"

;;http://orgmode.org/manual/Faces-for-TODO-keywords.html
;;http://raebear.net/comp/emacscolors.html
(setq org-todo-keyword-faces
           '(("TODO" . org-warning) ("INPROG" . (:foreground "medium aquamarine" :weight bold)) ("BLOCKED" . (:foreground "magenta" :weight bold)) ("DONE" . (:foreground "green" :weight bold)) ("WONTFIX" . (:foreground "dark olive green" :weight bold)) ("RESOLVED" . (:foreground "dim gray" :weight bold))))

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
"0:30
1:00 
2:00 
3:00 
4:00 
6:00 
7:00 
8:00"
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
Holiday
HR-Web
IST-Staff-Drupal
IT-Service-Catalog-Drupal
Leave-Taken
Library-Bindery
LS-Web
OCIO-Technology-Website
OFEW-Website
OFEW-FamilyEdge-Website
Open-Berkeley
Optometry-Website
ORIAS-Website
Pantheon-Admin
PCSSC-Website
PMB-Drupal
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
UHS-Policy-Website
UPP-Website
VCUE
Web-Accessibility
Web-Platform-Services
Website-Abatement-Proj
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
(setq org-columns-default-format "%10CATEGORY %70ITEM(Task) %2PRIORITY %10TAGS %5Effort(Effort){:} %5CLOCKSUM")

(setq org-clock-modeline-total 'today)

;; Priorities: A-E. Default priority=E
(setq org-enable-priority-commands t)
(setq org-default-priority ?E)
(setq org-lowest-priority ?E)

;; Customize Agenda menu
;                        (quote ((agenda time-up tag-up priority-down) )))
(setq org-agenda-custom-commands

      '(
        ("A" "Weekly Action List"
           (
           (agenda "" ((org-agenda-ndays 14)
                       (org-agenda-sorting-strategy
                        (quote ((agenda time-up priority-down) )))
                       (org-deadline-warning-days 7)
                       ))))
        ("D" "Daily Action List"
           (
           (agenda "" ((org-agenda-ndays 1)
                       (org-agenda-sorting-strategy
                        (quote ((agenda time-up tag-up priority-down) )))
                       (org-deadline-warning-days 0)
                       ))))
        ;; Agenda queries.  Allow searching archives
        ("Q" . "Custom queries") ;; gives label to "Q" 
        ("Qa" "Archive search" search ""
         ((org-agenda-files (file-expand-wildcards "~/Documents/orgmode/archive/*.org")))) 
        ("Qb" "Projects and Archive" search ""
         ((org-agenda-text-search-extra-files (file-expand-wildcards "~/Documents/orgmode/archive/*.org"))))
                ;; searches both projects and archive directories
        ("QA" "Archive tags search" org-tags-view "" 
         ((org-agenda-files (file-expand-wildcards "~/Documents/orgmode/archive/*.org"))))
        ;; ...other commands here
         ))

;; Filter agenda on priority
(setq org-agenda-custom-commands
      '(("c" . "Priority views")
        ("ca" "#A" agenda ""
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#A\\]"))))
        ("cb" "#B" agenda ""
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#B\\]"))))
        ("cc" "#C" agenda ""
         ((org-agenda-entry-types '(:scheduled))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp 
"\\[#C\\]"))))
        ;; ...other commands here
        ))


(setq org-agenda-start-with-follow-mode t)
;; http://orgmode.org/manual/Clocking-work-time.html#Clocking-work-time
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-clock-into-drawer t)

;; http://orgmode.org/guide/Setting-up-a-capture-location.html#Setting-up-a-capture-location

;; refiling
(setq org-outline-path-complete-in-steps t)
;(setq org-refile-use-outline-path t)
(setq org-refile-use-outline-path 'file)
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 10))))
(setq org-reverse-note-order t)

;; use indentation (hide ***)
(setq org-startup-indented t)

;; wrap long lines
;; http://lists.gnu.org/archive/html/emacs-orgmode/2011-01/msg00290.html
(add-hook 'org-mode-hook
          '(lambda ()
	     (auto-fill-mode nil)
	     (visual-line-mode t)))

;; load agenda
(org-agenda-list)


;; -----------------------------------------------------------
;; Mobile Org
;; Set to the location of your Org files on your local system
(setq org-directory "~/Documents/orgmode")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Documents/orgmode/capture.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/")

;; pull and push on startup
;; (org-mobile-pull)
;; (org-mobile-push)

;; -----------------------------------------------------------
;; Capture

;; Notes
(setq org-default-notes-file (concat org-directory "Documents/orgmode/capture.org")) 
(define-key global-map "\C-cc" 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, and org-protocol
;; http://doc.norang.ca/org-mode.html#Capture
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/Documents/orgmode/capture.org")
               "* TODO %?\n%U\n%a\n  %i" :clock-in t :clock-resume t)
              ("n" "note" entry (file "~/Documents/orgmode/capture.org")
               "* %? :NOTE:\n%U\n%a\n  %i" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/Documents/orgmode/work/journal.org")
               "* %?\n%U\n  %i" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/Documents/orgmode/capture.org")
               "* TODO Review %c\n%U\n  %i" :immediate-finish t)
              ("i" "Interruption" entry (file "~/Documents/orgmode/capture.org")
               "* Interruption %?\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/Documents/orgmode/capture.org")
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
