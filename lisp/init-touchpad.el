(defun turn-off-mouse (&optional frame)
  (interactive)
  (let ((inhibit-message t) (default-directory "~"))
    (shell-command "synclient TouchpadOff=1")))

(defun turn-on-mouse (&optional frame)
  (interactive)
  (let ((inhibit-message t) (default-directory "~"))
    (shell-command "synclient TouchpadOff=0")))

(if (eq *linux* t)
    (progn 
     (add-hook 'focus-in-hook #'turn-off-mouse)
     (add-hook 'focus-out-hook #'turn-on-mouse)
     (add-hook 'delete-frame-functions #'turn-on-mouse)
     (add-hook 'kill-emacs-hook #'turn-on-mouse)
     )
)

(provide 'init-touchpad)
