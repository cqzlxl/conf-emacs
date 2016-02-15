;;-*-coding: utf-8-*-;;

;; 加载更多地常用功能
((lambda (feature-list)
   (dolist (feature feature-list)
     (require feature)))
 '(
   recentf
   ))

;; 是否显示多余空白的手动开关
(defun my-toggle-show-trailing-whitespace ()
  (interactive)
  (setq show-trailing-whitespace (not show-trailing-whitespace)))

;; eshell 清屏命令
(defun eshell/clear ()
  "Clears the shell buffer as Unix's clear or DOS' cls"
  (interactive)
  ;; the shell prompts are read-only, so clear that for the duration
  (let ((inhibit-read-only t))
    ;; simply delete the region
    (delete-region (point-min) (point-max))))

;; 开启众多mode
(my-enable-all-modes
 '(
   ;; 选择性高亮，给力
   global-hi-lock-mode
   ;; 你懂的
   semantic-mode
   ;; modeline显示当前函数名
   which-func-mode
   ;; 最近打开的文件
   recentf-mode
   ;; 智能切换buffer（换ido-mode上吧）
   ;; iswitchb-mode
   ido-mode
   ;; 自动对齐
   electric-indent-mode
   ;; 自动加入一对分隔符
   electric-pair-mode
   ;; 自动插入
   auto-insert-mode
   ;; 高亮显示更改
   ;; global-highlight-changes-mode
   ;; 显示配对的分隔符
   show-paren-mode
   ;; 正确处理驼峰字
   global-subword-mode
   ;; 高亮当前行
   global-hl-line-mode
   ;; 显示Buffer大小
   size-indication-mode
   ;; 显示行号
   global-linum-mode
   ;; 显示列号
   column-number-mode))
;; C-c <RET>打开当前链接
(define-globalized-minor-mode global-goto-address-mode
   goto-address-mode goto-address-mode)
(global-goto-address-mode 1)

;; 也禁用一些mode
(my-disable-all-modes
 '(
   ;; 不要工具栏
   ;; tool-bar-mode
   ;; 不要菜单栏
   menu-bar-mode))

;; 在状态栏显示当前Buffer的行数
(setq-default mode-line-position
              (append mode-line-position
                      '((:eval (format "[%d Lines]"
                                       (count-lines (point-min)
                                                    (point-max)))))))

;; 各种hook
(my-set-conf
 '(
   ;; 当frame被new出来时，先做一些初始化
   (after-make-frame-functions
    (lambda (frame) (with-selected-frame frame
                      (when (display-graphic-p)
                        (tool-bar-mode -1) (scroll-bar-mode -1)))))
   ;; 在所有Window最上方显示一把标尺
   (window-configuration-change-hook (lambda () (ruler-mode 1)))

   ;; 编程相关的mode都开启代码块折叠
   (prog-mode-hook
    (lambda ()
      (with-current-buffer (current-buffer)
        (unless (string= major-mode "web-mode")
          (hs-minor-mode 1)))))

   ;; 保存文件前清除多余空白
   (before-save-hook whitespace-cleanup)
   ;; 保存文件时更新可能存在的tim-stamp
   (before-save-hook time-stamp))
 'add-hook)

;; 按键映射
;; The Emacs Manual says that the combination of C-c followed by a plain
;; letter, and the function keys f5 through f9 are reserved for users.
(my-set-conf
 '(
   ;; C-c C-t 插入当前时间戳， C-u C-c C-t插入更详细的时间戳
   ([?\C-c ?t]        (lambda (prefix-arg) (interactive "P")
                        ((lambda (fmt)
                           (insert (format-time-string fmt (current-time))))
                         (if prefix-arg "[%Z] %Y-%m-%d %H:%M:%S %s"
                           "%Y-%m-%d %H:%M:%S"))))
   ;; 用单引号括起当前word，C-u C-c C-q插入双引号
   ([?\C-c ?q]        (lambda (prefix-arg) (interactive "P")
                        ((lambda (qmark)
                           (save-excursion
                             (skip-syntax-backward "w_")
                             (insert qmark)
                             (skip-syntax-forward "w_")
                             (insert qmark)))
                         (if prefix-arg "\"" "'"))))
   ;; 删除当前buffer，少些无聊的确认
   ([?\C-x ?k]        kill-this-buffer)
   ;; 删至当前行首，相当于C-u 0 C-k
   ([?\M-k]           (lambda () (interactive) (kill-line 0)))
   ;; F7 设定标记
   ([f7]              set-mark-command)
   ;; F8 刷新buffer
   ([f8]              revert-buffer)
   ;; F9 显示/隐藏代码块
   ([f9]              hs-toggle-hiding)
   ([?\C-h]           help-command)
   ([?\C-x ?h]        mark-whole-buffer)
   ([?\C-x ?r ?i]     string-insert-rectangle)
   ([?\C-x ?\C-b]     buffer-menu)
   ([?\M-g ?c]        move-to-column)
   ([?\M-g ?l]        goto-line))
 'global-set-key)

;; 杂项配置
(my-set-conf
 '(
   ;; Emacs Lisp mode for *scratch* buffer
   (initial-major-mode emacs-lisp-mode)
   (initial-scratch-message "")
   ;; 禁止启动画面
   (inhibit-startup-message t)
   ;; 视觉性响铃
   (visible-bell t)
   ;; 禁用备份文件
   (make-backup-files nil)
   ;; 自动保持文件末尾一空行
   (require-final-newline t))
 'set)

(my-set-conf
 '(
   ;; 争取每行的长度都在72字符以内
   (fill-column 72)
   ;; 干掉制表符
   (indent-tabs-mode  nil)
   (tab-width 4)
   ;; kill时彻底删除一行（包括末尾的换行符）
   (kill-whole-line t)
   ;; 显示多余空白
   (show-trailing-whitespace t))
 'set-default)

;; 开启更多默认被禁用的功能
((lambda (feature-list)
   (dolist (feature feature-list)
     (put feature 'disabled nil)))
 '(
   ;; 区域大小写
   downcase-region
   upcase-region
   ;; 开启隐藏、折叠
   narrow-to-region
   narrow-to-page
   ;; 开启横向卷屏
   scroll-left))

;; 使用Ediff替代VC-mode的diff工具
(eval-after-load "vc-hooks"
  '(progn
    (define-key vc-prefix-map "=" 'ediff-revision)
    (setq ediff-split-window-function 'split-window-horizontally)))
(add-hook 'ediff-cleanup-hook
          (lambda () (interactive)
            (delete-window (get-buffer-window ediff-buffer-A))
            (kill-buffer ediff-buffer-A)))
(add-hook 'ediff-prepare-buffer-hook
          (lambda () (interactive)
            (when (eq (current-buffer) ediff-buffer-A)
              (with-current-buffer ediff-buffer-A (toggle-read-only 1)))))

;; y for yes, n for no
(fset 'yes-or-no-p 'y-or-n-p)

;; 增加更多的package库
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))

;; SMTP
(setq user-full-name "Liu,Xiaolin"
      user-mail-address "liuxiaolin@whu.edu.cn"
      mail-user-agent 'message-user-agent
      send-mail-function 'smtpmail-send-it
      message-default-headers "BCC: liuxiaolin@whu.edu.cn\n"
      mail-signature "Sent from my GNU Emacs."
      smtpmail-smtp-server "smtp.whu.edu.cn"
      smtpmail-smtp-service 25)

;; Moves the point to the newly created window after splitting.
(defadvice split-window (after move-point-to-new-window activate)
  (other-window 1))
