;;-*-coding: utf-8;-*-;;

;; YASnippets
(require 'yasnippet)
(yas-global-mode 1)

;; Auto-Complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             (concat user-emacs-directory "ac-dict/"))
(ac-config-default)
(setq-default ac-sources
              '(ac-source-abbrev
                ac-source-dictionary
                ac-source-features
                ac-source-filename
                ac-source-files-in-current-dir
                ac-source-functions
                ac-source-imenu
                ac-source-semantic
                ac-source-symbols
                ac-source-variables
                ac-source-words-in-same-mode-buffers
                ac-source-yasnippet))

(setq c-default-style "linux"
      c-basic-offset 4)
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq comment-start "//" comment-end "")
            (c-toggle-syntactic-indentation 1)
            (c-toggle-auto-newline 1)
            (c-toggle-hungry-state 1)
            (c-set-offset 'case-label '+)
            (add-to-list 'ac-sources ac-source-semantic)))

(add-hook 'c++-mode-hook
          (lambda ()
            (c-set-offset 'innamespace '0)
            (c-set-offset 'inextern-lang '0)
            (c-set-offset 'inline-open '0)
            (c-set-offset 'label '*)
            (c-set-offset 'access-label '-)
            (setq indent-tabs-mode nil)))

;; Python
(define-skeleton my-ske-python-template
  ""
  nil
  "##-*-coding: utf-8;-*-##"
  \n
  \n
  "import sys"
  \n
  \n
  -
  \n
  "def main(args):"
  \n
  > "pass"
  \n
  \n
  "if __name__ == '__main__':"
  \n
  > "main(sys.argv)"
  \n)
;; 需要先打开auto-insert-mode
(define-auto-insert '("\\.py\\'" . "My Python template")
  'my-ske-python-template)

(defadvice python-calculate-indentation (around outdent-closing-brackets)
  "Python代码中，闭括号的缩进量等于开括号"
  (save-excursion
    (beginning-of-line)
    (let ((syntax (syntax-ppss)))
      (if (and (not (eq 'string (syntax-ppss-context syntax)))
               (python-continuation-line-p)
               (cadr syntax)
               (skip-syntax-forward "-")
               (looking-at "\\s)"))
          (progn
            (forward-char 1)
            (ignore-errors (backward-sexp))
            (setq ad-return-value (current-indentation)))
        ad-do-it))))
(ad-activate 'python-calculate-indentation)

;; Pymacs
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-autoload "pymacs")
;; (pymacs-load "ropemacs" "rope-")
;; (setq ropemacs-enable-autoimport t)


;; WEB development
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ctp$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$" . web-mode))
