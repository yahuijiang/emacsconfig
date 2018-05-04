;;; Basic go setup
(require-package 'go-mode)
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))
(setenv "GOPATH" "/Users/admin/workspace/golang")

(add-to-list 'exec-path "/Users/admin/workspace/golang/bin")
(defun my-go-mode-hook ()
                                        ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
                                        ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
                                        ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go generate && go build -v && go test -v && go vet"))
                                        ; Go oracle
  ;;(load-file "$GOPATH/src/golang.org/x/tools/cmd/oracle/oracle.el")
                                        ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-,") 'pop-tag-mark)
  (local-set-key (kbd "M-c M-c") 'comment-region)
  (local-set-key (kbd "M-c M-u") 'uncomment-region)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)




(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(defun auto-complete-for-go ()
 (auto-complete-mode 1))
 (add-hook 'go-mode-hook 'auto-complete-for-go)
(with-eval-after-load 'go-mode
    (require 'go-autocomplete))

(add-hook 'go-mode-hook 'my-go-mode-hook)
(provide 'init-golang)
