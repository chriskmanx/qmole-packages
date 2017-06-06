;; Avoid slow start-up
;; Also added Chriss-Ipad to /etc/hosts
(require 'cl)

(require 'server)
(unless (server-running-p) (server-start))

;;------------------------
;; Package mangement first
;; Sets relevant paths
;;------------------------
(require 'package)
  ;; Add the original Emacs Lisp Package Archive
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
  ;; Add the user-contributed repository
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;----------
;; Load path
;;----------
(add-to-list 'load-path "~/.emacs.d/includes")
(add-to-list 'image-load-path "~/.emacs.d/icons")


;;---------------------------------------------------------
;; Set default font; unit is 1/10th pt, e.g. 100->10pt font
;; Display ruler:
;;123456789A123456789B123456789C123456789D123456789E123456789F123456789G123456789H123456789J12345
;;
;; default font -> display stretch on ruler: G4
;; font size 10 -> display stretch on ruler: H4
;; font size 9 ->  display stretch on ruler: J5
;; step size appears to be 10
;;---------------------------------------------------------
(set-face-attribute 'default nil :height 110)

(defun large-font()
  (interactive)
  (set-face-attribute 'default nil :height 110)
)

(defun medium-font()
  (interactive)
  (set-face-attribute 'default nil :height 100)
)

(defun small-font()
  (interactive)
  (set-face-attribute 'default nil :height 90)
)

(defun tiny-font()
  (interactive)
  (set-face-attribute 'default nil :height 80)
)

(defun micro-font()
  (interactive)
  (set-face-attribute 'default nil :height 70)
)

(define-key-after global-map [menu-bar fontmenu]
  (cons "Font" (make-sparse-keymap "fontmenu")))

(define-key global-map [menu-bar fontmenu large-font]
  '(menu-item "Large" large-font
             :help "Size 11 font"))
(define-key global-map [menu-bar fontmenu medium-font]
  '(menu-item "Medium" medium-font
             :help "Size 10 font"))
(define-key global-map [menu-bar fontmenu small-font]
  '(menu-item "Small" small-font
             :help "Size 9 font"))
(define-key global-map [menu-bar fontmenu tiny-font]
  '(menu-item "Tiny" tiny-font
             :help "Size 8 font"))
(define-key global-map [menu-bar fontmenu micro-font]
  '(menu-item "Micro" micro-font
             :help "Size 7 font"))

;;----------------------------
;; Manage Hide & Show Keyboard
;;----------------------------
(defun show-keyboard ()
  (interactive)
  (shell-command "herbstclient pad 0 0 0 265")
  (message "Show Keyboard")
)

(defun hide-keyboard ()
  (interactive)
  (shell-command "herbstclient pad 0 0 0 0")
  (message "Hide Keyboard")
)

(define-key-after global-map [menu-bar keyboardmenu]
  (cons "Keyboard"  (make-sparse-keymap "keyboardmenu")))

(define-key global-map [menu-bar keyboardmenu show-keyboard]
  '(menu-item "Show Virtual Keybord Space" show-keyboard
             :help "Use to Show Virtual Keyboard"))

(define-key global-map [menu-bar keyboardmenu hide-keyboard]
  '(menu-item "Hide Virtual Keyboard Space" hide-keyboard
             :help "Use to Hide Virtual Keyboard"))

;;--------------------------------
;; Sensible scrolling 
;; Also CTRL-<up> and CTRL-<down>
;; scrolls by paragraph
;;--------------------------------
(setq scroll-step 1)
 
;;-----------------------------------------------------------
;; Don't prompt about deleting excessive backups, just do it
;;-----------------------------------------------------------
(setq delete-old-versions t)

;;-------------------------------
;; Enable setting mark with C-Spc
;; This must be set to t
;;-------------------------------
(setq transient-mark-mode t)

;;----------------------
;; Silence silly prompts
;;----------------------
(fset 'yes-or-no-p 'y-or-n-p)

;;-----------------------------------
;; Make echo area feedback responsive
;;-----------------------------------
(setq echo-keystrokes 0.02)


;;--------------------------------------------------
;; Extended M-x and C-g for Apple Keyboard under X11
;;--------------------------------------------------
(defun myexitminibuffer()
  (interactive)
  (if (eq (current-buffer) (window-buffer (minibuffer-window))) 
    (progn
       (abort-recursive-edit)
       (exit-minibuffer)
    )
    (keyboard-quit)
  )
) 

;;----------------------------------------------------------
;; My shortcuts
;; CTRL-e (for execute) as M-x
;; CTRL-b (for buffer) for switch to buffer
;; CTRL-f (for file) for find-file
;; CTRL-Space sets marker, then shift <arrow> to mark region
;;----------------------------------------------------------        
(global-set-key "\C-e" 'execute-extended-command)
(global-set-key "\C-b" 'switch-to-buffer)
(global-set-key "\C-f" 'find-file)
(global-set-key "\C-o" 'other-window)
(global-set-key "\C-c\C-c" 'myexitminibuffer)

;;------------------
;; Toolbar functions
;;------------------
(defun run-metax()
  "Meta-X Input"
  (interactive)
  (execute-extended-command 1)
)

(defun cmd  ()
  (interactive)
  (multi-term)
)

;;----------------------------
;; X11 specific initialization
;;---------------------------- 
(when window-system
  (message "Configuring for X11 emacs")
  (scroll-bar-mode -1)
  (setq use-dialog-box nil)
  (tool-bar-add-item "run" 'run-metax 'run-metax 
    :help "Meta-X"
    :visible '(eq (active-minibuffer-window) nil)
  )
  (tool-bar-add-item "no" 'myexitminibuffer 'myexitminibuffer 
    :help "C-g"
    :visible '(active-minibuffer-window)
  )
  (tool-bar-add-item "computer" 'multi-term 'multi-term 
    :help "Run shell"
  )
  (tool-bar-add-item "exit" 'save-buffers-kill-emacs 'save-buffers-kill-emacs
    :help "Exit Emacs"
  )

)

;;-------------------------------- 
;; Console specific initialization
;;--------------------------------
(unless window-system
  (message "Configuring for text mode Emacs")
  (require 'mouse)
  (xterm-mouse-mode)
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  (menu-bar-mode 0)
)

(setq emacs-images (concatenate 'string "/home/chris/.emacs.d/" "icons"))


;;---------------
;; Cut copy paste
;;---------------
(defun copy-text()
  (interactive)
  (copy-region-as-kill 1)
  )

(defun cut-text()
  (interactive)
  (kill-region 1)
  )

(defun paste-text()
  (interactive)
  (yank)
  )

;;-------------------
;; Allow erase buffer
;;-------------------
(put 'erase-buffer 'disabled nil)


;;-----------------
;; Custom variables
;;-----------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(recentf-mode t)
 '(tool-bar-position (quote left))
 '(tool-bar-style (quote image))
 '(which-func-mode t))

;;--------------
;; Custome fonts
;;--------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tabbar-default ((t (:inherit variable-pitch :background "gray75" :foreground "gray50" :height 1.2)))))

