;;-*-coding: utf-8 -*-;;

;; 咱对版本还是有追求的
(if (< emacs-major-version 24)
    (throw 'load-conf-exception '("emacs2old" . t)))

;; 中文环境总是比较蛋疼
(setenv "LANG" "zh_CN.UTF-8")
(setenv "LC_ALL" "zh_CN.UTF-8")
(set-language-environment "UTF-8")
(set-locale-environment)
(prefer-coding-system 'utf-8-unix)

;;
;; 好了，开始！
;;

(package-initialize)
(elpy-enable)

(defun my-set-conf (option-pair-list conf-method)
  (dolist (pair option-pair-list)
    (funcall conf-method (car pair) (nth 1 pair))))


;; 依次加载配置文件列表里的每一项
(defun my-load-conf-file (flist prefix suffix)
  (let ((the-prefix prefix)
        (the-suffix suffix))
    (if (not (stringp the-prefix))
        (setq the-prefix ""))
    (if (not (stringp the-suffix))
        (setq the-suffix ""))
    (dolist (conf-file flist)
      (load (file-truename (concat the-prefix conf-file the-suffix))))))

(defun my-enable-all-modes (mlist &optional value)
  (let ((enable-value value))
    (if (not enable-value)
        (setq enable-value 1))
    (dolist (mode mlist)
      (funcall mode enable-value))))

(defun my-disable-all-modes (mlist &optional value)
  (let ((disable-value value))
    (if (not disable-value)
        (setq disable-value -1))
    (my-enable-all-modes mlist disable-value)))


;; 各种路径
(setq user-emacs-directory "~/.emacs.d/")
(defvar CONF_PATH (concat user-emacs-directory "conf/"))
(defvar PACKAGE_PATH (concat user-emacs-directory "packages/"))

;; MS-Windows相关初始化
(if (string-equal system-type "windows-nt")
    (progn
      (setq default-directory (expand-file-name "~"))
      (require 'server)
      (unless (server-running-p)
        (server-start))))

;; 将自己装的软件包加到load-path中
(dolist (fentry (directory-files PACKAGE_PATH t))
  (when (and (file-directory-p fentry)
             (not (string-match "/\\.\\.$" fentry)))
    (add-to-list 'load-path (file-truename fentry))))


;; 加载更多地配置
(my-load-conf-file
 '(
   ;; 基础配置
   "basic"
   ;; 编程相关
   "program"
   )
 CONF_PATH ".el")

;; 采用一个适合编程开发的主题，不伤眼的。
(custom-set-variables
 '(custom-enabled-themes (quote (wombat))))
