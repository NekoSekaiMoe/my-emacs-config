;;; nano-window.el --- 界面绘制 -*- lexical-binding: t; -*-

;;; Commentary:
;; 标题栏、mode-line、GC 优化

;;; Code:

;; ========== 顶部标题栏 ==========
;; 左: Emacs 版本号，中: 文件名居中（修改后加星号）

(setq-default header-line-format
  '((:eval
     (let* ((left (format " Emacs %s" emacs-version))
            (name (buffer-name))
            (star (if (buffer-modified-p) "*" ""))
            (right "")
            (width (window-width))
            (mid-start (/ (+ (length left) (- width (length name) (length right))) 2))
            (mid-pad (max 0 (- mid-start (length left))))
            (right-pad (max 0 (- width mid-start (length name) (length right)))))
       (propertize
        (concat left
                (make-string mid-pad ?\s)
                name star
                (make-string right-pad ?\s)
                right)
        'face '(:background "grey20" :foreground "white"))))))

;; ========== 底部快捷键栏 ==========
;; 左：快捷键提示，右：状态信息

(setq-default mode-line-format
  '((:eval (propertize " ^G Help | ^O Write Out | ^W Where Is | ^K Cut | ^T Execute | ^C Location | ^6 Mark Set "
                       'face '(:background "grey20" :foreground "white")))
    mode-line-mule-info
    mode-line-modified
    " "
    mode-line-buffer-identification
    " "
    mode-line-position
    " "
    mode-line-modes
    (:eval (propertize " ^X Exit | ^R Read File | ^\\ Replace | ^U Paste | ^J Justify | ^/ Go To Line | M-U Undo "
                       'face '(:background "grey20" :foreground "white")))))

;; ========== 启动优化：减少 GC ==========

(setq gc-cons-threshold (* 256 1024 1024)) ; 256MB
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)))) ; 恢复 16MB

(provide 'nano-window)
;;; nano-window.el ends here
