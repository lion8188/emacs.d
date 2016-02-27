;;user
(setq user-full-name "adai")
(setq user-mail-address "adaiagain@gmail.com")

;;splash screen
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;;bars
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;;disable backup
(setq make-backup-files nil)

;;yes and no
(defalias 'yes-or-no-p 'y-or-n-p)

;;key bindings

;;misc
(setq echo-keystrokes 0.1
      visible-bell t)
(show-paren-mode t)
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
(setq column-number-mode t)

;;disable temp files
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;;disable mac right alt key
(setq mac-right-option-modifier nil)

;; always show line numbers in all programming modes
(add-hook 'prog-mode-hook 'linum-mode)

(provide 'init-basic)
