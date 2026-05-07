;;; nano-welcome.el --- 欢迎页 -*- lexical-binding: t; -*-

;;; Commentary:
;; 启动欢迎页，显示快捷键和最近文件

;;; Code:

(require 'recentf)
(recentf-mode 1)

(defconst nano-welcome-buffer-name "*Welcome*"
  "欢迎页 buffer 名称。")

(defun nano-welcome-render ()
  "渲染欢迎页内容。"
  (let ((inhibit-read-only t))
    (erase-buffer)
    (insert (propertize "Emacs Nano\n" 'face '(:height 2.0 :weight bold)))
    (insert (propertize (make-string 40 ?─) 'face '(:foreground "grey50")))
    (insert "\n\n")
    (insert (propertize "快捷键\n" 'face '(:weight bold :height 1.2)))
    (insert "  ^O 保存    ^W 搜索    ^K 剪切    ^X 退出\n")
    (insert "  ^T 打开    ^R 读取    ^\\ 替换    ^U 粘贴\n")
    (insert "  ^/ 跳转行  ^J 对齐    M-U 撤销   M-E 重做\n")
    (insert "\n")
    (insert (propertize (make-string 40 ?─) 'face '(:foreground "grey50")))
    (insert "\n\n")
    (insert (propertize "最近文件\n" 'face '(:weight bold :height 1.2)))
    (let ((files (seq-take recentf-list 10)))
      (if files
          (dolist (file files)
            (let ((key (format "  [%d] " (1- (cl-position file files :test 'equal)))))
              (insert (propertize key 'face '(:foreground "cyan")))
              (insert (propertize file 'face '(:foreground "grey80")))
              (insert "\n")))
        (insert (propertize "  (暂无最近文件)\n" 'face '(:foreground "grey50")))))
    (insert "\n")
    (insert (propertize (make-string 40 ?─) 'face '(:foreground "grey50")))
    (insert "\n")
    (insert (propertize "按数字键 1-0 打开对应文件，^O 打开其他文件\n"
                        'face '(:foreground "grey50")))
    (insert "\n")
    (insert (propertize "GoTo 子命令: ^O End | M-W Start | ^V Bottom | ^Y Top | ^T To Text | ^C Cancel\n"
                        'face '(:foreground "grey50")))))

(defun nano-welcome-open-file (n)
  "打开最近文件中第 N 个（1-indexed）。"
  (interactive "p")
  (let ((files (seq-take recentf-list 10)))
    (when (> n (length files))
      (user-error "没有第 %d 个最近文件" n))
    (find-file (nth (1- n) files))
    (message "已打开 %s" (nth (1- n) files))))

(defun nano-welcome-refresh ()
  "刷新欢迎页。"
  (interactive)
  (nano-welcome-render))

(defun nano-welcome-page ()
  "显示 Nano 欢迎页。"
  (interactive)
  (let ((buf (get-buffer-create nano-welcome-buffer-name)))
    (with-current-buffer buf
      (nano-welcome-render)
      (dotimes (i 9)
        (local-set-key (kbd (number-to-string (1+ i)))
                       `(lambda () (interactive) (nano-welcome-open-file ,(1+ i)))))
      (local-set-key (kbd "0") (lambda () (interactive) (nano-welcome-open-file 10)))
      (local-set-key (kbd "C-o") 'find-file)
      (local-set-key (kbd "C-r") 'nano-welcome-refresh)
      (local-set-key (kbd "C-x") #'kill-emacs)
      (setq-local buffer-read-only t)
      (setq-local cursor-type nil)
      (goto-char (point-min))
      (set-buffer-modified-p nil))
    (switch-to-buffer buf)))

(add-hook 'emacs-startup-hook
          (lambda ()
            (unless (or (cdr command-line-args)
                        (frame-parameter nil 'client))
              (nano-welcome-page))))

(provide 'nano-welcome)
;;; nano-welcome.el ends here
