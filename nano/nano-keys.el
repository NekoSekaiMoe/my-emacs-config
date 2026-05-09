;;; nano-keys.el --- Nano 风格快捷键绑定 -*- lexical-binding: t; -*-

;;; Commentary:
;; 全局快捷键、搜索、替换、跳转

;;; Code:

;; ========== 命令别名 ==========

(defalias 'diff 'vc-diff)
(defalias 'log 'vc-print-log)
(defalias 'tab 'switch-to-buffer)
(defalias 'push 'vc-push)
(defalias 'pull 'vc-pull)
(defalias 'edf 'vc-ediff)
(defalias 'fdf 'vc-root-diff)
(defalias 'next 'vc-next-action)
(defalias 'blm 'vc-annotate)
(defalias 'rst 'vc-rollback)
(defalias 'fix 'vc-resolve-conflicts)
(defalias 'crb 'vc-vc-create-branch)
(defalias 'cht 'vc-retrieve-tag)
(defalias 'crt 'vc-create-tag)
(defalias 'flog 'vc-print-log)
(defalias 'plog 'vc-print-root-log)
(defalias 'slog 'vc-log-search)

;; ========== 全局快捷键 ==========

;; ^G - 取消
(global-set-key (kbd "C-g") 'keyboard-quit)

;; C-? - 帮助
(global-set-key (kbd "C-?") (lambda () (interactive) (info "(emacs) Top")))

;; ^O - 保存
(defun nano-write-out ()
  "Nano 风格的保存文件。"
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (progn
          (save-buffer)
          (message "Wrote %s" file))
      (call-interactively 'write-file))))
(global-set-key (kbd "C-o") 'nano-write-out)

;; ^S - 保存（同 ^O）
(global-set-key (kbd "C-s") 'nano-write-out)

;; ^F - 跳转到行
(global-set-key (kbd "C-f") 'goto-line)

;; ^W - 搜索
(global-set-key (kbd "C-w") 'nano-search)

;; ^K - 剪切（有选区时剪切选区，无选区时剪切整行）
(defun nano-kill-line ()
  "有活动选区时剪切选区，否则剪切整行 (Nano 风格)。"
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (kill-whole-line)))
(global-set-key (kbd "C-k") 'nano-kill-line)

;; ^T - 打开文件
(global-set-key (kbd "C-t") 'find-file)

;; ^C - 显示行列位置
(defun nano-location ()
  "显示当前光标位置（行列）。"
  (interactive)
  (message "Line %d, Column %d" (line-number-at-pos) (current-column)))
(global-set-key (kbd "C-c") 'nano-location)

;; ^6 / C-^ - 标记设定/解除
(global-set-key (kbd "C-6") 'set-mark-command)
(global-set-key (kbd "C-^") 'set-mark-command)

;; M-U - 撤销
(global-set-key (kbd "M-u") 'undo)

;; M-E - 重做
(global-set-key (kbd "M-e") 'undo-redo)

;; ^X - 退出（通过 minor mode 覆盖所有 major mode 的局部绑定）
(defun nano-exit ()
  "Nano 风格的退出。"
  (interactive)
  (if (buffer-modified-p)
      (let ((choice (read-char-choice
                     "Save modified buffer? (y/n/C-g) "
                     '(?y ?n ?\C-g))))
        (cond
         ((eq choice ?y)
          (save-buffer)
          (kill-emacs))
         ((eq choice ?n)
          (kill-emacs))
         ((eq choice ?\C-g)
          (message "Cancelled"))))
    (kill-emacs)))

(defvar nano-keymap (make-sparse-keymap) "Nano 全局快捷键映射。")
(define-key nano-keymap (kbd "C-x") 'nano-exit)

(define-minor-mode nano-keys-mode
  "Nano 风格全局快捷键模式，优先级高于所有 major mode。"
  :global t
  :keymap nano-keymap
  :lighter "")

(nano-keys-mode 1)

;; ^R - 读取文件
(global-set-key (kbd "C-r") 'find-file)

;; ^\ - 替换
(defun nano-replace ()
  "Nano 风格的批量替换。"
  (interactive)
  (nano-replace-prompt-search))
(global-set-key (kbd "C-\\") 'nano-replace)

;; ^U - 粘贴
(global-set-key (kbd "C-u") 'yank)

;; ^J - 对齐段落
(global-set-key (kbd "C-j") 'fill-paragraph)

;; ^/ - 跳转到行
(global-set-key (kbd "C-/") 'nano-go-to-line)
(global-set-key (kbd "C-_") 'nano-go-to-line)

;; ========== Go To Line ==========

(defvar nano-go-to-line--original-pos nil "跳转前的原始位置")
(defvar nano-go-to-line--active nil)

(defun nano-go-to-line ()
  "Nano 风格的跳转到指定位置。"
  (interactive)
  (setq nano-go-to-line--original-pos (point))
  (nano-go-to-line-prompt))

(defun nano-go-to-line-prompt ()
  "提示输入跳转位置。"
  ;; 确保 overriding-local-map 不干扰 read-string
  (let ((overriding-local-map nil)
        (input (read-string "Go to line (column): ")))
    (cond
     ((string= input "")
      (message "Cancelled"))
     (t
      (let* ((parts (split-string input ","))
             (line (string-to-number (car parts)))
             (col (if (= (length parts) 2)
                      (string-to-number (cadr parts))
                    0)))
        (goto-char (point-min))
        (forward-line (max 0 (1- line)))
        (move-to-column (max 0 col))
        (recenter)
        (nano-go-to-line-activate-keymap))))))

;; ^/ 跳转模式 - 使用 overriding-local-map 强制覆盖
(defvar nano-go-to-line--original-pos nil)
(defvar nano-go-to-line--active nil)

(defvar nano-go-to-line-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c") #'nano-go-to-line-cancel)
    (define-key map (kbd "C-g") #'nano-go-to-line-cancel)
    (define-key map (kbd "C-o") #'nano-go-to-line-end)
    (define-key map (kbd "M-w") #'nano-go-to-line-start)
    (define-key map (kbd "C-v") #'nano-go-to-line-bottom)
    (define-key map (kbd "C-y") #'nano-go-to-line-top)
    (define-key map (kbd "C-t") #'nano-go-to-line-to-text)
    map)
  "Keymap for nano go-to-line mode")

(defun nano--safe-activate-keymap (keymap active-var on-exit-fn message-text)
  "安全激活临时 keymap，防止多个临时模式冲突。"
  (when overriding-local-map
    (message "Another temporary mode is active, cancel it first"))
  (setq overriding-local-map keymap)
  (funcall active-var t)
  (message message-text))

(defun nano-go-to-line-activate-keymap ()
  "使用 overriding-local-map 激活局部按键映射。"
  (nano--safe-activate-keymap
   nano-go-to-line-keymap
   (lambda (v) (setq nano-go-to-line--active v))
   'nano-go-to-line-deactivate-keymap
   "GoTo: ^C Cancel | ^O End | M-W Start | ^V Bottom | ^Y Top | ^T To Text"))

(defun nano-go-to-line-deactivate-keymap ()
  "停用局部按键映射。"
  (setq nano-go-to-line--active nil)
  (setq overriding-local-map nil))

(defun nano-go-to-line-cancel ()
  "取消跳转。"
  (interactive)
  (goto-char nano-go-to-line--original-pos)
  (nano-go-to-line-deactivate-keymap)
  (message "Cancelled"))

(defun nano-go-to-line-end ()
  "跳转到文件结尾。"
  (interactive)
  (goto-char (point-max))
  (recenter))

(defun nano-go-to-line-start ()
  "跳转到文件开头。"
  (interactive)
  (goto-char (point-min))
  (recenter))

(defun nano-go-to-line-bottom ()
  "跳转到尾行。"
  (interactive)
  (goto-char (point-max))
  (recenter 0))

(defun nano-go-to-line-top ()
  "跳转到首行。"
  (interactive)
  (goto-char (point-min))
  (recenter 0))

(defun nano-go-to-line-to-text ()
  "跳转到指定文字，执行后自动退出跳转模式。"
  (interactive)
  (let ((text (read-string "Go to text: ")))
    (cond
     ((string= text "") (message "Cancelled"))
     ((search-forward text nil t)
      (goto-char (match-beginning 0))
      (recenter)
      (nano-go-to-line-deactivate-keymap))
     (t (message "Not found")))))

;; ========== 搜索 ==========

(defvar nano-search-string nil "当前搜索字符串")
(defvar nano-search-history nil "搜索历史")
(defvar nano-search-case nil "是否区分大小写")
(defvar nano-search-last-match-data nil "上次匹配数据 (start . end)")

(defun nano-search-toggle-case ()
  "切换搜索大小写敏感。"
  (interactive)
  (setq nano-search-case (not nano-search-case))
  (message "Case sensitive: %s" (if nano-search-case "ON" "OFF"))
  (when nano-search-string
    (nano-search-find-first)))
(global-set-key (kbd "M-c") 'nano-search-toggle-case)

(defun nano-search ()
  "Nano 风格搜索：弹出搜索框。"
  (interactive)
  (nano-search-prompt-input))

(defun nano-search-prompt-input ()
  "Nano 风格搜索：弹出搜索框，预填上次搜索字符串。"
  (setq overriding-local-map nil)
  (let* ((history nano-search-history)
         (default-val (car history))
         (prompt (if default-val
                     (concat "Search [" default-val "]: ")
                   "Search: "))
         (input (read-string prompt nil 'nano-search-history)))
    (cond
     ((string= input "")
      (if default-val
          (progn
            (setq nano-search-string default-val)
            (nano-search-find-next))
        (message "Cancelled")))
     ((and default-val (string= input default-val))
      (nano-search-find-next))
     (t
      (setq nano-search-string input)
      (nano-search-find-first)))))

(defun nano-search-find-first ()
  "查找第一个匹配。"
  (let ((case-fold-search (not nano-search-case)))
    (if (search-forward nano-search-string nil t)
        (progn
          (setq nano-search-last-match-data (cons (match-beginning 0) (match-end 0)))
          (goto-char (match-beginning 0))
          (recenter)
          (message "Found"))
      (message "Not found")
      (setq nano-search-string nil))))

(defun nano-search-find-next ()
  "查找下一个匹配，支持 wrap。"
  (let ((case-fold-search (not nano-search-case))
        (found nil)
        (match-start nil)
        (match-end nil))
    (when nano-search-last-match-data
      (goto-char (cdr nano-search-last-match-data))
      (when (search-forward nano-search-string nil t)
        (setq found t
              match-start (match-beginning 0)
              match-end (match-end 0))))
    (if found
        (progn
          (setq nano-search-last-match-data (cons match-start match-end))
          (goto-char match-start)
          (recenter)
          (message "Found"))
      (goto-char (point-min))
      (if (search-forward nano-search-string nil t)
          (progn
            (setq match-start (match-beginning 0)
                  match-end (match-end 0))
            (setq nano-search-last-match-data (cons match-start match-end))
            (goto-char match-start)
            (recenter)
            (message "Search wrapped"))
        (message "Not found")
        (setq nano-search-string nil)))))

;; ========== 批量替换 ==========

(defvar nano-replace-search nil "搜索字符串")
(defvar nano-replace-replace nil "替换字符串")
(defvar nano-replace-case nil "是否区分大小写")
(defvar nano-replace-regex nil "是否使用正则表达式")
(defvar nano-replace-backward nil "是否向后搜索")
(defvar nano-replace-history nil "搜索历史")
(defvar nano-replace--active nil)
(defvar nano-replace-match-start nil)
(defvar nano-replace-match-end nil)
(defvar nano-replace-overlay nil)

(defun nano-replace-prompt-search ()
  "第一步：输入搜索字符串。"
  (nano-replace-deactivate-keymap)
  (let* ((history nano-replace-history)
         (default-val (car history))
         (prompt (if default-val
                     (concat "Search (to replace) [" default-val "]: ")
                   "Search (to replace): "))
         (input (read-string prompt nil 'nano-replace-history default-val)))
    (cond
     ((and (string= input "") default-val)
      (setq nano-replace-search default-val)
      (nano-replace-prompt-replace))
     ((string= input "")
      (message "Cancelled"))
     (t
      (setq nano-replace-search input)
      (nano-replace-prompt-replace)))))

(defun nano-replace-prompt-replace ()
  "第二步：输入替换字符串。"
  (nano-replace-deactivate-keymap)
  (let ((prompt (concat "Replace with [" nano-replace-search "]: ")))
    (setq nano-replace-replace (read-string prompt)))
  (nano-replace-execute))

(defun nano-replace--search-func ()
  "根据正则开关返回搜索函数。"
  (if nano-replace-regex 're-search-forward 'search-forward))

(defun nano-replace-execute ()
  "执行替换，显示第一个匹配并等待用户操作。"
  (condition-case err
      (let ((case-fold-search (not nano-replace-case))
            (search-func (nano-replace--search-func)))
        (if (funcall search-func nano-replace-search nil t)
            (progn
              (setq nano-replace-match-start (match-beginning 0))
              (setq nano-replace-match-end (match-end 0))
              (nano-replace-show-first-match))
          (message "No occurrences found")
          (nano-replace-cleanup)))
    (error
     (message "Replace error: %s" (error-message-string err))
     (nano-replace-deactivate-keymap)
     (nano-replace-cleanup))))

(defun nano-replace-show-first-match ()
  "显示第一个匹配，激活局部按键映射。"
  (condition-case err
      (progn
        (goto-char nano-replace-match-start)
        (recenter)
        (when nano-replace-overlay
          (delete-overlay nano-replace-overlay))
        (setq nano-replace-overlay (make-overlay nano-replace-match-start nano-replace-match-end))
        (overlay-put nano-replace-overlay 'face 'highlight)
        (nano-replace-activate-keymap))
    (error
     (message "Replace error: %s" (error-message-string err))
     (nano-replace-deactivate-keymap)
     (nano-replace-cleanup))))

(defun nano-replace-do-all ()
  "全部替换。"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0)
          (case-fold-search (not nano-replace-case))
          (max-iter 10000))
      (while (and (search-forward nano-replace-search nil t)
                  (< (setq count (1+ count)) max-iter))
        (replace-match nano-replace-replace))
      (if (>= count max-iter)
          (message "Replace stopped after %d (possible infinite loop)" count)
        (message "Replaced %d occurrences" count))))
  (nano-replace-deactivate-keymap)
  (nano-replace-cleanup))

(defun nano-replace-yes ()
  "替换这个匹配。"
  (interactive)
  (nano-replace-this)
  (nano-replace-find-next))

(defun nano-replace-no ()
  "跳过这个匹配。"
  (interactive)
  (nano-replace-find-next))

(defun nano-replace-this ()
  "替换当前匹配。"
  (when nano-replace-overlay
    (delete-overlay nano-replace-overlay)
    (setq nano-replace-overlay nil))
  (goto-char nano-replace-match-start)
  (replace-match nano-replace-replace (not nano-replace-case) nano-replace-regex)
  (setq nano-replace-match-end (point)))

(defun nano-replace--find (direction)
  "根据方向查找匹配。direction 为 'forward 或 'backward。"
  (let* ((case-fold-search (not nano-replace-case))
         (search-func
          (if nano-replace-regex
              (if (eq direction 'forward) 're-search-forward 're-search-backward)
            (if (eq direction 'forward) 'search-forward 'search-backward)))
         (found (funcall search-func nano-replace-search nil t)))
    (when found
      (setq nano-replace-match-start (match-beginning 0)
            nano-replace-match-end (match-end 0))
      (goto-char nano-replace-match-start)
      (recenter)
      (when nano-replace-overlay
        (delete-overlay nano-replace-overlay))
      (setq nano-replace-overlay (make-overlay nano-replace-match-start nano-replace-match-end))
      (overlay-put nano-replace-overlay 'face 'highlight)
      (nano-replace-activate-keymap))
    found))

(defun nano-replace-find-next ()
  "查找下一个匹配。"
  (let ((direction (if nano-replace-backward 'backward 'forward)))
    (unless (nano-replace--find direction)
      (message "No more occurrences")
      (nano-replace-deactivate-keymap)
      (nano-replace-cleanup))))

(defun nano-replace-find-prev ()
  "查找上一个匹配。"
  (let ((direction (if nano-replace-backward 'forward 'backward)))
    (unless (nano-replace--find direction)
      (message "No previous occurrences")
      (nano-replace-activate-keymap))))

(defun nano-replace-cancel ()
  "取消替换。"
  (interactive)
  (nano-replace-deactivate-keymap)
  (nano-replace-cleanup)
  (message "Cancelled"))

(defun nano-replace-toggle-case ()
  "切换区分大小写。"
  (interactive)
  (setq nano-replace-case (not nano-replace-case))
  (message "Case sensitive: %s" (if nano-replace-case "ON" "OFF"))
  (nano-replace-activate-keymap))

(defun nano-replace-toggle-regex ()
  "切换正则表达式。"
  (interactive)
  (setq nano-replace-regex (not nano-replace-regex))
  (message "Regex: %s" (if nano-replace-regex "ON" "OFF"))
  (nano-replace-activate-keymap))

(defun nano-replace-toggle-backward ()
  "切换向后搜索。"
  (interactive)
  (setq nano-replace-backward (not nano-replace-backward))
  (message "Direction: %s" (if nano-replace-backward "BACKWARD" "FORWARD"))
  (nano-replace-activate-keymap))

(defvar nano-replace-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map "y" #'nano-replace-yes)
    (define-key map "Y" #'nano-replace-yes)
    (define-key map " " #'nano-replace-yes)
    (define-key map "\r" #'nano-replace-yes)
    (define-key map "n" #'nano-replace-no)
    (define-key map "N" #'nano-replace-no)
    (define-key map "a" #'nano-replace-do-all)
    (define-key map "A" #'nano-replace-do-all)
    (define-key map (kbd "C-c") #'nano-replace-cancel)
    (define-key map (kbd "C-g") #'nano-replace-cancel)
    (define-key map (kbd "C-p") #'nano-replace-find-prev)
    (define-key map (kbd "C-n") #'nano-replace-find-next)
    (define-key map (kbd "M-c") #'nano-replace-toggle-case)
    (define-key map (kbd "M-r") #'nano-replace-toggle-regex)
    (define-key map (kbd "M-b") #'nano-replace-toggle-backward)
    map)
  "Keymap for nano replace mode")

(defun nano-replace-activate-keymap ()
  "使用 overriding-local-map 激活局部按键映射。"
  (nano--safe-activate-keymap
   nano-replace-keymap
   (lambda (v) (setq nano-replace--active v))
   'nano-replace-deactivate-keymap
   "Replace this? (Y/n/A/^P/^N/M-C/M-R/M-B/^C/^G)"))

(defun nano-replace-deactivate-keymap ()
  "停用局部按键映射。"
  (setq nano-replace--active nil)
  (setq overriding-local-map nil))

(defun nano-replace-cleanup ()
  "清理替换状态。"
  (when nano-replace-overlay
    (delete-overlay nano-replace-overlay)
    (setq nano-replace-overlay nil))
  (setq nano-replace-search nil
        nano-replace-replace nil
        nano-replace-case nil
        nano-replace-regex nil
        nano-replace-backward nil))

(provide 'nano-keys)
;;; nano-keys.el ends here
