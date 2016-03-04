(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq *is-a-mac* (eq system-type 'darwin))
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )

(require 'init-elpa)
(require 'init-basic)

(require 'init-autocomplete)
(require 'init-autopair)

;;themes
(require 'init-themes)

(require 'init-javascript)
(require 'init-smex)
(require 'init-window)
;(require 'init-touchpad)
(require 'init-w3m)
(require 'init-git)
