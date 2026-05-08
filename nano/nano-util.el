;;; nano-util.el --- 基本工具函数与设置 -*- lexical-binding: t; -*-

;;; Commentary:
;; 编码、剪贴板、基本变量等基础配置

;;; Code:

;; ========== 剪贴板集成 ==========

(defun copy-from-osx ()
  "从 macOS 剪贴板复制。"
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  "粘贴到 macOS 剪贴板。"
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(cond
 ((memq window-system '(x))
  (setq x-select-enable-primary t
        x-select-enable-clipboard nil))
 ((memq window-system '(mac ns))
  (setq interprogram-cut-function 'paste-to-osx
        interprogram-paste-function 'copy-from-osx))
 ((memq window-system '(win32 pc))
  (setq select-enable-primary t
        select-enable-clipboard t
        save-interprogram-paste-before-kill t)))

;; ========== 编码设置 ==========

(set-language-environment "utf-8")
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-clipboard-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(prefer-coding-system 'utf-8)
(setq-default pathname-coding-system 'utf-8)
(setq
 default-process-coding-system '(utf-8 . utf-8)
 locale-coding-system 'utf-8
 file-name-coding-system 'utf-8
 default-buffer-file-coding-system 'utf-8
 slime-net-coding-system 'utf-8-unix)

(setenv "LC_CTYPE" "UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LANG" "en_US.UTF-8")

;; ========== 基本设置 ==========

(setq-default
 indicate-buffer-boundaries 'left
 delete-by-moving-to-trash t
 window-combination-resize t
 x-stretch-cursor t
 kill-whole-line t)

(setq-default major-mode 'text-mode)

(setq
 fringes-outside-margins t
 echo-keystrokes 0.1
 system-time-locale "zh_CN"
 indent-tabs-mode t
 font-lock-global-modes '(not shell-mode text-mode)
 mouse-yank-at-point t
 kill-ring-max 200
 default-fill-column 60
 enable-recursive-minibuffers t
 scroll-margin 0
 scroll-conservatively 10000
 select-enable-clipboard t
 track-eol t
 next-line-add-newlines nil
 initial-scratch-message nil
 dired-listing-switches "-vha"
 recentf-max-saved-items 50
 recentf-max-menu-items 15
 show-paren-style 'parenthesis
 undo-limit 80000000
 truncate-string-ellipsis "…"
 uniquify-buffer-name-style 'post-forward-angle-brackets
 inhibit-startup-screen t)

;; ========== 备份文件（Nano 风格 .xxx.swp） ==========
;; ========== 备份设置 ==========
;; 使用 Nano 风格的 .swp 备份（.<filename>.swp），不生成 ~ 后缀备份

(setq make-backup-files nil            ; 不生成 ~ 后缀备份
      create-lockfiles nil             ; 不生成 .# 锁文件
      auto-save-default nil            ; 不生成 #auto-save# 文件
      kept-new-versions 3
      kept-old-versions 2
      version-control t
      vc-make-backup-files t)

;; Nano 风格备份文件名
(defun nano-make-backup-file-name (filename)
  "生成 Nano 风格的 .xxx.swp 备份文件名。"
  (let ((dirname (file-name-directory filename))
        (basename (file-name-nondirectory filename)))
    (expand-file-name (concat "." basename ".swp") dirname)))

(setq make-backup-file-name-function 'nano-make-backup-file-name)

;; 退出时删除 swp 文件
(add-hook 'kill-emacs-hook
          (lambda ()
            (dolist (buf (buffer-list))
              (with-current-buffer buf
                (when buffer-file-name
                  (let ((swp-file (nano-make-backup-file-name buffer-file-name)))
                    (when (file-exists-p swp-file)
                      (delete-file swp-file))))))))

;; ========== UI 元素 ==========

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tab-bar-mode -1)
(when (fboundp 'global-tab-line-mode)
  (global-tab-line-mode -1))
(fset 'yes-or-no-p 'y-or-n-p)
(global-font-lock-mode t)
(show-paren-mode t)
(mouse-avoidance-mode 'animate)
(auto-compression-mode 1)
(global-auto-revert-mode 1)
(blink-cursor-mode -1)
(toggle-truncate-lines t)
;; (column-number-mode t)
;; (line-number-mode t)
;; (global-display-line-numbers-mode t)
(require 'saveplace)
(save-place-mode 1)
(global-subword-mode 1)
(electric-pair-mode 1)
(electric-indent-mode 1)

;; ========== 时间显示 ==========

(display-time-mode 1)
(setq display-time-24hr-format t
      display-time-day-and-date t
      display-time-use-mail-icon t
      display-time-interval 10
      display-time-format "%A %H:%M")

(unless (string-match-p "^Power N/A" (battery))
  (display-battery-mode 1))

(provide 'nano-util)
;;; nano-util.el ends here
