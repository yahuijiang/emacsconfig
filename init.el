
;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

(let ((minver "23.3"))
  (when (version<= emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version<= emacs-version "24")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "emacs-js" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Temporarily reduce garbage collection during startup
;;----------------------------------------------------------------------------
(defconst sanityinc/initial-gc-cons-threshold gc-cons-threshold
  "Initial value of `gc-cons-threshold' at start-up time.")
(setq gc-cons-threshold (* 128 1024 1024))
(add-hook 'after-init-hook
          (lambda () (setq gc-cons-threshold sanityinc/initial-gc-cons-threshold)))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-preload-local.el"
;;----------------------------------------------------------------------------
(require 'init-preload-local nil t)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------
;;(require 'package) ;; You might already have this line
;;(add-to-list 'package-archives
;;              '("melpa" . "https://melpa.org/packages/"))
;;(package-initialize)
;;(add-to-list 'load-path (expand-file-name "golangconfig" user-emacs-directory))
;;(require 'go-mode-autoloads)

(require-package 'wgrep)
(require-package 'project-local-variables)
(require-package 'diminish)
(require-package 'scratch)
(require-package 'mwe-log-commands)

(require 'init-frame-hooks)
(require 'init-xterm)
(require 'init-themes)
(require 'init-osx-keys)
(require 'init-gui-frames)
(require 'init-dired)
(require 'init-isearch)
(require 'init-grep)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flycheck)

(require 'init-recentf)
(require 'init-smex)
;; If you really prefer ido to ivy, change the comments below. I will
;; likely remove the ido config in due course, though.
;; (require 'init-ido)
(require 'init-ivy)
(require 'init-hippie-expand)
;;(require 'init-company)
(require 'init-windows)
(require 'init-sessions)
(require 'init-fonts)
(require 'init-mmm)

(require 'init-editing-utils)
(require 'init-whitespace)
(require 'init-fci)

(require 'init-vc)
(require 'init-darcs)
(require 'init-git)
(require 'init-github)

(require 'init-projectile)

(require 'init-compile)
(require 'init-crontab)
(require 'init-textile)
(require 'init-markdown)
(require 'init-csv)
(require 'init-erlang)
;;(require 'init-javascript)
(require 'init-php)
(require 'init-org)
(require 'init-nxml)
(require 'init-html)
(require 'init-css)
(require 'init-haml)
(require 'init-python-mode)
(unless (version<= emacs-version "24.3")
  (require 'init-haskell))
(require 'init-elm)
(require 'init-ruby-mode)
(require 'init-rails)
(require 'init-sql)

(require 'init-paredit)
(require 'init-lisp)
(require 'init-slime)
(unless (version<= emacs-version "24.2")
  (require 'init-clojure)
  (require 'init-clojure-cider))
(require 'init-common-lisp)

(when *spell-check-support-enabled*
  (require 'init-spelling))

(require 'init-misc)
(require 'init-golang)

(require 'emacs-js)
(require 'init-folding)
(require 'init-dash)
(require 'init-ledger)
;; Extra packages which don't require any configuration

(require-package 'gnuplot)
(require-package 'lua-mode)
(require-package 'htmlize)
(require-package 'dsvn)
(when *is-a-mac*
  (require-package 'osx-location))
(require-package 'regex-tool)

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(require 'server)
(unless (server-running-p)
  (server-start))

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file)
  (load custom-file))


;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
(require 'init-local nil t)


;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
(require 'init-locales)

;;----------------------------------------------------------------------------
;;add by Yahui Jiang
;;----------------------------------------------------------------------------
(global-linum-mode 1) 
(require 'sr-speedbar)
;;默认显示所有文件
;;(custom-set-variables
;;  '(speedbar-show-unknown-files t)
;;)
;;sr-speedbar-right-side 把speedbar放在左侧位置
;;sr-speedbar-skip-other-window-p 多窗口切换时跳过speedbar窗口
;;sr-speedbar-max-width与sr-speedbar-width-x 设置宽度
;;(custom-set-variables '(sr-speedbar-right-side nil) '(sr-speedbar-skip-other-window-p t) '(sr-speedbar-max-width 20) '(sr-speedbar-width-x 10))
;; 绑定快捷键
;;(global-set-key (kbd "M-S") 'sr-speedbar-toggle)
;;(global-set-key (kbd "M-R") 'sr-speedbar-refresh-toggle)
;; 打开
;;(sr-speedbar-open)

(setq speedbar-show-unknown-files t)
(setq speedbar-use-images nil)
(setq sr-speedbar-width 20)
(setq sr-speedbar-right-side nil)
(defun select-next-window ()
  (other-window 1))
 
(defun my-sr-speedbar-open-hook ()
   (add-hook 'speedbar-before-visiting-file-hook 'select-next-window t)
  (add-hook 'speedbar-before-visiting-tag-hook 'select-next-window t)
)
 
(advice-add 'sr-speedbar-open :after #'my-sr-speedbar-open-hook)
(require 'speedbar-extension)



(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
