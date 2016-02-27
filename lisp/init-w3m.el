(require-package 'w3m)
(setq w3m-coding-system 'utf-8
      w3m-file-coding-system 'utf-8
      w3m-file-name-coding-system 'utf-8
      w3m-input-coding-system 'utf-8
      w3m-output-coding-system 'utf-8
      ;; emacs-w3m will test the imagick's support for png32
      ;; and create files named "png32:-" everywhere
      w3m-imagick-convert-program nil
      w3m-terminal-coding-system 'utf-8
      w3m-use-cookies t
      w3m-cookie-accept-bad-cookies t
      w3m-home-page "http://www.google.com"
      w3m-command-arguments       '("-F" "-cookie")
      w3m-mailto-url-function     'compose-mail
      browse-url-browser-function 'w3m
      mm-text-html-renderer       'w3m
      w3m-use-toolbar t
      ;; show images in the browser
      ;; setq w3m-default-display-inline-images t
      ;; w3m-use-tab     nil
      w3m-confirm-leaving-secure-page nil
      w3m-search-default-engine "g"
      w3m-key-binding 'info)

(defun w3m-get-url-from-search-engine-alist (k l)
  (let (rlt)
    (if (listp l)
      (if (string= k (caar l))
          (setq rlt (nth 1 (car l)))
        (setq rlt (w3m-get-url-from-search-engine-alist k (cdr l)))))
    rlt))

;; C-u S g RET <search term> RET in w3m
(setq w3m-search-engine-alist
      '(("g" "http://www.google.com/search?q=%s" utf-8)
        ;; stackoverflow search
        ("q" "http://www.google.com/search?q=%s+site:stackoverflow.com" utf-8)
        ;; wikipedia
        ("w" "http://en.wikipedia.org/wiki/Special:Search?search=%s" utf-8)

(defun w3m-set-url-from-search-engine-alist (k l url)
    (if (listp l)
      (if (string= k (caar l))
          (setcdr (car l) (list url))
        (w3m-set-url-from-search-engine-alist k (cdr l) url))))

(defvar w3m-global-keyword nil
  "`w3m-display-hook' must search current buffer with this keyword twice if not nil")

(defun w3m-guess-keyword ()
  (unless (featurep 'w3m) (require 'w3m))
  (w3m-url-encode-string
   (setq w3m-global-keyword
         (if (region-active-p)
             (buffer-substring-no-properties (region-beginning) (region-end))
           (read-string "Enter keyword:")))))

(defun w3m-customized-search-api (search-engine)
  (unless (featurep 'w3m) (require 'w3m))
  (w3m-search search-engine (w3m-guess-keyword)))

(defun w3m-stackoverflow-search ()
  (interactive)
  (unless (featurep 'w3m) (require 'w3m))
  (w3m-customized-search-api "q"))

(defun w3m-google-search ()
  "Google search keyword"
  (interactive)
  (unless (featurep 'w3m) (require 'w3m))
  (w3m-customized-search-api "g"))

(defun w3m-mode-hook-setup ()
  (w3m-lnum-mode 1))

(add-hook 'w3m-mode-hook 'w3m-mode-hook-setup)

; {{ Search using external browser
(setq browse-url-generic-program
      (cond
       (*is-a-mac* "open")
       (*linux* (executable-find "firefox"))
       ))
(setq browse-url-browser-function 'browse-url-generic)

(defun w3mext-open-link-or-image-or-url ()
  "Opens the current link or image or current page's uri or any url-like text under cursor in firefox."
  (interactive)
  (let (url)
    (when (or (string= major-mode "w3m-mode") (string= major-mode "gnus-article-mode"))
      (setq url (w3m-anchor))
      (if (or (not url) (string= url "buffer://"))
          (setq url (or (w3m-image) w3m-current-url))))
    (browse-url-generic (if url url (car (browse-url-interactive-arg "URL: "))))
    ))

(defun w3mext-subject-to-target-filename ()
  (let (rlt str)
    (save-excursion
      (goto-char (point-min))
      ;; first line in email could be some hidden line containing NO to field
      (setq str (buffer-substring-no-properties (point-min) (point-max))))
    ;; (message "str=%s" str)
    (if (string-match "^Subject: \\(.+\\)" str)
        (setq rlt (match-string 1 str)))
    ;; clean the timestamp at the end of subject
    (setq rlt (replace-regexp-in-string "[ 0-9_.'/-]+$" "" rlt))
    (setq rlt (replace-regexp-in-string "'s " " " rlt))
    (setq rlt (replace-regexp-in-string "[ ,_'/-]+" "-" rlt))
    rlt))

(eval-after-load 'w3m
  '(progn
     (define-key w3m-mode-map (kbd "C-c b") 'w3mext-open-link-or-image-or-url)
     (add-hook 'w3m-display-hook
               (lambda (url)
                 (let ((title (or w3m-current-title url)))
                   (message "url=%s title=%s w3m-current-title=%s" url title w3m-current-title)
                   (when w3m-global-keyword
                     ;; search keyword twice, first is url, second is your input,
                     ;; third is actual result
                     (goto-char (point-min))
                     (search-forward-regexp (replace-regexp-in-string " " ".*" w3m-global-keyword)  (point-max) t 3)
                     ;; move the cursor to the beginning of word
                     (backward-char (length w3m-global-keyword))
                     ;; cleanup for next search
                     (setq w3m-global-keyword nil))
                   ;; rename w3m buffer
                   (rename-buffer
                    (format "*w3m: %s*"
                            (substring title 0 (min 50 (length title)))) t))))))
(provide 'init-w3m)
