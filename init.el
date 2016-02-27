(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-elpa)
(require 'init-basic)

(require 'init-autocomplete)
(require 'init-autopair)

;;themes
(require 'init-themes)

(require 'init-javascript)
(require 'init-smex)
(require 'init-window)
(require 'init-touchpad)
(require 'init-w3m)
