(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
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

;; 中文显示
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
(setenv "LANG" "en_US.UTF-8")                           ; Iterate through CamelCase words

;; 基本设置
(setq-default
 indicate-buffer-boundaries 'left ;; 在窗口边缘上显示一个小箭头指示当前 buffer 的边界
 delete-by-moving-to-trash t                      ;; 删除文件移动到垃圾箱
 window-combination-resize t                      ;; 新窗口平均其他左右窗口
 x-stretch-cursor t                               ;; 将光标拉伸到字形宽度
 kill-whole-line t)  ;; C-k时,同时删除该行

;; 默认使用 text-mode（编辑模式），而非 fundamental-mode
(setq-default major-mode 'text-mode)

(setq
 fringes-outside-margins t   ;; fringe 放在外面
 echo-keystrokes 0.1         ;; 尽快显示按键序列
 system-time-locale "zh_CN"  ;; 设置系统时间显示格式
 tab-always-indent 'complete ;; Tab 键优先格式化再补全
 font-lock-global-modes '(not shell-mode text-mode) ;; 设置语法高亮.除shell-mode和text-mode之外的模式
 mouse-yank-at-point t       ;; 不在鼠标点击的地方插入剪贴板内容
 kill-ring-max 200           ;; 设置 kill ring 个数
 default-fill-column 60      ;; 把fill-column设为60.让文字更好读
 enable-recursive-minibuffers t  ;; 递归的使用minibuffer
 scroll-margin 3             ;; 在靠近屏幕边沿 3 行时就开始滚动,可很好看到上下文
 scroll-conservatively 10000 ;; 防止页面滚动时跳动
 select-enable-clipboard t   ;; 允许emacs和外部程序进行粘贴
 track-eol t                 ;; 当光标在行尾上下移动的时候,始终保持在行尾
 next-line-add-newlines nil  ;; 按C-n或down时不添加新行
 ;; emacs启动时显示的内容可以通过变量initial-scratch-message来设置
 initial-scratch-message nil
 dired-listing-switches "-vha" ;;  dired 列出文件的参数（man ls）
 show-paren-style 'parenthesis ;; 括号匹配时高亮显示另一边的括号，而不是跳到另一个括号处
 undo-limit 80000000           ;; 提升撤销限制
 truncate-string-ellipsis "…"  ;; Unicode ellispis are nicer than "...", and also save /precious/ space
 ;; 当寻找一个同名的文件,改变两个buffer的名字,前面加上目录名
 uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Nano 风格的备份文件 (.xxx.swp)
(setq make-backup-files t                    ;; 启用备份
      backup-by-copying t                    ;; 复制备份
      backup-directory-alist '(("." . "."))   ;; 备份文件放在原文件目录
      delete-old-versions t                  ;; 删除旧版本
      kept-new-versions 3                    ;; 保留3个新版本
      kept-old-versions 2                    ;; 保留2个旧版本
      version-control t                      ;; 版本控制
      vc-make-backup-files t)                ;; VC 文件也备份

;; 生成 .xxx.swp 格式的备份文件
(setq backup-directory-alist nil)  ;; 备份文件与原文件同目录

(defun nano-make-backup-file-name (filename)
  "生成 Nano 风格的 .xxx.swp 备份文件名"
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

;; 禁用所有 UI 元素
(menu-bar-mode -1)                ;; 取消菜单栏
(tool-bar-mode -1)                ;; 取消工具栏
(scroll-bar-mode -1)              ;; 取消滚动条
(tab-bar-mode -1)                 ;; 取消标签栏
(when (fboundp 'global-tab-line-mode)
  (global-tab-line-mode -1))      ;; 取消全局 tab-line
(fset 'yes-or-no-p 'y-or-n-p) ;; 按y或space表示yes,n表示no
(global-font-lock-mode t)     ;; 语法高亮
(show-paren-mode t)           ;; 打开括号匹配显示模式
(mouse-avoidance-mode 'animate) ;; 鼠标靠近光标指针时,让鼠标自动让开
(auto-compression-mode 1) ;; 打开压缩文件时自动解压缩
(global-auto-revert-mode 1)       ;; 自动重载更改的文件
(blink-cursor-mode -1)            ;; 指针不要闪
(toggle-truncate-lines t)         ;; 当一行文字太长时,不自动换行
(column-number-mode t)            ;; 在minibuffer上面的状态栏显示文件的行号,列号
(line-number-mode t)              ;;设定显示文件的参数,以版本/人性化的显示,就是ls的参数
(global-display-line-numbers-mode t) ;; 显示行号
(require 'saveplace)
(save-place-mode 1)               ;; 记住上次打开文件光标的位置
(global-subword-mode 1)           ;; 拆分连字符：oneWord 会被当作两个单词处理

;; 时间显示设置
(display-time-mode 1)   ;; 启用时间显示设置,在minibuffer上面的那个杠上
(setq display-time-24hr-format t   ;; 时间使用24小时制
      display-time-day-and-date t   ;; 时间显示包括日期和具体时间
      display-time-use-mail-icon t   ;; 时间栏旁边启用邮件设置
      display-time-interval 10   ;; 时间的变化频率
      display-time-format "%A %H:%M")   ;; 显示时间的格式

(unless (string-match-p "^Power N/A" (battery))   ; 笔记本上显示电量
  (display-battery-mode 1))

;; ========== Nano 风格快捷键 ==========

;; 禁用 C-x 前缀键
(global-unset-key (kbd "C-x"))

;; ^G - 恢复为键盘中断（Emacs 最基本的中断能力）
(global-set-key (kbd "C-g") 'keyboard-quit)

;; 帮助绑定到 C-?
(global-set-key (kbd "C-?") (lambda () (interactive) (info "(emacs) Top")))

;; ^O - Write Out (保存)
(defun nano-write-out ()
  "Nano 风格的保存文件"
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (progn
          (save-buffer)
          (message "Wrote %s" file))
      (call-interactively 'write-file))))
(global-set-key (kbd "C-o") 'nano-write-out)

;; ^S - Save (保存，同 ^O)
(global-set-key (kbd "C-s") 'nano-write-out)

;; ^F - Where Is (搜索) - 注意：Nano 中 ^W 是搜索
(global-set-key (kbd "C-f") 'goto-line)

;; ^W - Where Is (Nano 风格搜索)
(global-set-key (kbd "C-w") 'nano-search)

;; ^K - Cut (剪切行)
(global-set-key (kbd "C-k") 'kill-whole-line)

;; ^T - Execute (执行命令/打开文件)
(global-set-key (kbd "C-t") 'find-file)

;; ^C - Location (显示行列位置) / 编辑状态下显示已读
(defun nano-location ()
  "显示当前光标位置（行列）"
  (interactive)
  (message "Line %d, Column %d" (line-number-at-pos) (current-column)))
(global-set-key (kbd "C-c") 'nano-location)

;; ^6 - 标记设定/解除 (使用原生 set-mark-command，支持区域高亮)
(global-set-key (kbd "C-6") 'set-mark-command)

;; M-U - Undo
(global-set-key (kbd "M-u") 'undo)

;; M-E - Redo (Emacs 28+ 内置 undo-redo)
(global-set-key (kbd "M-e") 'undo-redo)

;; ^X - Exit (退出)
(defun nano-exit ()
  "Nano 风格的退出"
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
(global-set-key (kbd "C-x") 'nano-exit)

;; ^R - Read File (打开文件)
(global-set-key (kbd "C-r") 'find-file)

;; ^\ - Replace (Nano 风格批量替换)
(defun nano-replace ()
  "Nano 风格的批量替换"
  (interactive)
  (nano-replace-prompt-search))
(global-set-key (kbd "C-\\") 'nano-replace)

;; ^U - Paste (粘贴)
(global-set-key (kbd "C-u") 'yank)

;; ^J - Justify (对齐)
(global-set-key (kbd "C-j") 'fill-paragraph)

;; ^/ - Go To Line (Nano 风格跳转)
(defvar nano-go-to-line--original-pos nil "跳转前的原始位置")

(defun nano-go-to-line ()
  "Nano 风格的跳转到指定位置"
  (interactive)
  (setq nano-go-to-line--original-pos (point))
  (nano-go-to-line-prompt))

(defun nano-go-to-line-prompt ()
  "提示输入跳转位置"
  (let ((input (read-string "Go to line (column): ")))
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
        (forward-line (1- line))
        (move-to-column col)
        (recenter)
        (nano-go-to-line-activate-keymap))))))

;; ^/ 跳转模式 - 使用 overriding-local-map 强制覆盖
(defvar nano-go-to-line--original-pos nil)
(defvar nano-go-to-line--active nil)

(defvar nano-go-to-line-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c") #'nano-go-to-line-cancel)
    (define-key map (kbd "C-g") #'nano-go-to-line-help)
    (define-key map (kbd "C-o") #'nano-go-to-line-end)
    (define-key map (kbd "C-w") #'nano-go-to-line-start)
    (define-key map (kbd "C-v") #'nano-go-to-line-bottom)
    (define-key map (kbd "C-y") #'nano-go-to-line-top)
    (define-key map (kbd "C-t") #'nano-go-to-line-to-text)
    map)
  "Keymap for nano go-to-line mode")

(defun nano--safe-activate-keymap (keymap active-var on-exit-fn message-text)
  "安全激活临时 keymap，防止多个临时模式冲突"
  (when overriding-local-map
    (message "Another temporary mode is active, cancel it first"))
  (setq overriding-local-map keymap)
  (funcall active-var t)
  (message message-text))

(defun nano-go-to-line-activate-keymap ()
  "使用 overriding-local-map 激活局部按键映射"
  (nano--safe-activate-keymap
   nano-go-to-line-keymap
   (lambda (v) (setq nano-go-to-line--active v))
   'nano-go-to-line-deactivate-keymap
   "^G Help | ^O End | ^W Start | ^V Bottom | ^Y Top | ^T To Text | ^C Cancel"))

(defun nano-go-to-line-deactivate-keymap ()
  "停用局部按键映射"
  (setq nano-go-to-line--active nil)
  (setq overriding-local-map nil))

(defun nano-go-to-line-cancel ()
  "取消跳转"
  (interactive)
  (goto-char nano-go-to-line--original-pos)
  (nano-go-to-line-deactivate-keymap)
  (message "Cancelled"))

(defun nano-go-to-line-help ()
  "显示帮助"
  (interactive)
  (message "GoTo: ^C Cancel, ^O End, ^W Start, ^V Bottom, ^Y Top, ^T To text"))

(defun nano-go-to-line-end ()
  "跳转到文件结尾"
  (interactive)
  (goto-char (point-max))
  (recenter))

(defun nano-go-to-line-start ()
  "跳转到文件开头"
  (interactive)
  (goto-char (point-min))
  (recenter))

(defun nano-go-to-line-bottom ()
  "跳转到尾行"
  (interactive)
  (goto-char (point-max))
  (recenter 0))

(defun nano-go-to-line-top ()
  "跳转到首行"
  (interactive)
  (goto-char (point-min))
  (recenter 0))

(defun nano-go-to-line-to-text ()
  "跳转到指定文字，执行后自动退出跳转模式"
  (interactive)
  (let ((text (read-string "Go to text: ")))
    (cond
     ((string= text "") (message "Cancelled"))
     ((search-forward text nil t)
      (goto-char (match-beginning 0))
      (recenter)
      (nano-go-to-line-deactivate-keymap))
     (t (message "Not found")))))

(global-set-key (kbd "C-/") 'nano-go-to-line)
(global-set-key (kbd "C-_") 'nano-go-to-line)

;; ========== Nano 风格搜索 ==========

;; 搜索状态变量
(defvar nano-search-string nil "当前搜索字符串")
(defvar nano-search-history nil "搜索历史")
(defvar nano-search-case nil "是否区分大小写")
(defvar nano-search-last-match-data nil "上次匹配数据 (start . end)")

;; 搜索大小写切换
(defun nano-search-toggle-case ()
  "切换搜索大小写敏感"
  (interactive)
  (setq nano-search-case (not nano-search-case))
  (message "Case sensitive: %s" (if nano-search-case "ON" "OFF"))
  (when nano-search-string
    (nano-search-find-first)))
(global-set-key (kbd "M-c") 'nano-search-toggle-case)

(defun nano-search ()
  "Nano 风格的搜索"
  (interactive)
  (if nano-search-string
      ;; 如果已有搜索字符串，直接搜索下一个
      (nano-search-find-next)
    ;; 首次搜索，提示输入字符串
    (nano-search-prompt-input)))

(defun nano-search-prompt-input ()
  "首次搜索：提示输入搜索字符串"
  (let* ((history nano-search-history)
         (default-val (car history))
         (prompt (if default-val
                     (format "Search [%s]: " default-val)
                   "Search: "))
         (input (read-string prompt nil 'nano-search-history default-val)))
    (cond
     ((string= input "")
      (if default-val
          (progn
            (setq nano-search-string default-val)
            (nano-search-find-first))
        (message "Cancelled")))
     (t
      (setq nano-search-string input)
      (nano-search-find-first)))))

(defun nano-search-find-first ()
  "查找第一个匹配"
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
  "查找下一个匹配，支持 wrap"
  (let ((case-fold-search (not nano-search-case))
        (found nil))
    ;; 从上次匹配结束位置之后开始搜索
    (when nano-search-last-match-data
      (goto-char (cdr nano-search-last-match-data))
      (setq found (search-forward nano-search-string nil t)))
    (if found
        (progn
          (setq nano-search-last-match-data (cons (match-beginning 0) (match-end 0)))
          (goto-char (match-beginning 0))
          (recenter)
          (message "Found"))
      ;; 没找到，从头开始搜索（wrap）
      (goto-char (point-min))
      (if (search-forward nano-search-string nil t)
          (progn
            (setq nano-search-last-match-data (cons (match-beginning 0) (match-end 0)))
            (goto-char (match-beginning 0))
            (recenter)
            (message "Search wrapped"))
        (message "Not found")
        (setq nano-search-string nil)))))



;; ========== Nano 风格批量替换 ==========

;; 替换状态变量
(defvar nano-replace-search nil "搜索字符串")
(defvar nano-replace-replace nil "替换字符串")
(defvar nano-replace-case nil "是否区分大小写")
(defvar nano-replace-regex nil "是否使用正则表达式")
(defvar nano-replace-backward nil "是否向后搜索")
(defvar nano-replace-history nil "搜索历史")

(defun nano-replace-prompt-search ()
  "第一步：输入搜索字符串"
  (let* ((history nano-replace-history)
         (default-val (car history))
         (prompt (if default-val
                     (format "Search (to replace) [%s]: " default-val)
                   "Search (to replace): "))
         (input (read-string prompt nil 'nano-replace-history default-val)))
    (if (string= input "")
        (when default-val
          (setq nano-replace-search default-val)
          (nano-replace-prompt-replace))
      (setq nano-replace-search input)
      (nano-replace-prompt-replace))))

(defun nano-replace-prompt-replace ()
  "第二步：输入替换字符串"
  (let ((prompt (format "Replace with [%s]: " nano-replace-search)))
    (setq nano-replace-replace (read-string prompt)))
  (nano-replace-execute))

(defun nano-replace--search-func ()
  "根据正则开关返回搜索函数"
  (if nano-replace-regex 're-search-forward 'search-forward))

(defun nano-replace-execute ()
  "执行替换，显示第一个匹配并等待用户操作"
  (let ((case-fold-search (not nano-replace-case))
        (search-func (nano-replace--search-func)))
    (if (funcall search-func nano-replace-search nil t)
        (progn
          (setq nano-replace-match-start (match-beginning 0))
          (setq nano-replace-match-end (match-end 0))
          (nano-replace-show-first-match))
      (message "No occurrences found")
      (nano-replace-cleanup))))

(defun nano-replace-show-first-match ()
  "显示第一个匹配，激活局部按键映射"
  (goto-char nano-replace-match-start)
  (recenter)
  (when nano-replace-overlay
    (delete-overlay nano-replace-overlay))
  (setq nano-replace-overlay (make-overlay nano-replace-match-start nano-replace-match-end))
  (overlay-put nano-replace-overlay 'face 'highlight)
  (nano-replace-activate-keymap))

;; ^\ 替换模式 - 使用 overriding-local-map
(defvar nano-replace--active nil)

;; 先定义所有被 keymap 引用的函数，再定义 keymap（defvar 只初始化一次）

(defun nano-replace-do-all ()
  "全部替换"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0)
          (case-fold-search (not nano-replace-case)))
      (while (search-forward nano-replace-search nil t)
        (replace-match nano-replace-replace)
        (setq count (1+ count)))
      (message "Replaced %d occurrences" count)))
  (nano-replace-deactivate-keymap)
  (nano-replace-cleanup))

(defun nano-replace-yes ()
  "替换这个匹配"
  (interactive)
  (nano-replace-this)
  (nano-replace-find-next))

(defun nano-replace-no ()
  "跳过这个匹配"
  (interactive)
  (nano-replace-find-next))

(defun nano-replace-this ()
  "替换当前匹配，使用 replace-match 避免位置错误"
  (when nano-replace-overlay
    (delete-overlay nano-replace-overlay)
    (setq nano-replace-overlay nil))
  (goto-char nano-replace-match-start)
  (replace-match nano-replace-replace (not nano-replace-case) nano-replace-regex)
  (setq nano-replace-match-end (point)))

(defun nano-replace--find (direction)
  "根据方向查找匹配，支持正则。direction 为 'forward 或 'backward"
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
  "查找下一个匹配"
  (let ((direction (if nano-replace-backward 'backward 'forward)))
    (unless (nano-replace--find direction)
      (message "No more occurrences")
      (nano-replace-deactivate-keymap)
      (nano-replace-cleanup))))

(defun nano-replace-find-prev ()
  "查找上一个匹配"
  (let ((direction (if nano-replace-backward 'forward 'backward)))
    (unless (nano-replace--find direction)
      (message "No previous occurrences")
      (nano-replace-activate-keymap))))

(defun nano-replace-cancel ()
  "取消替换"
  (interactive)
  (nano-replace-deactivate-keymap)
  (nano-replace-cleanup)
  (message "Cancelled"))

(defun nano-replace-toggle-case ()
  "切换区分大小写"
  (interactive)
  (setq nano-replace-case (not nano-replace-case))
  (message "Case sensitive: %s" (if nano-replace-case "ON" "OFF"))
  (nano-replace-activate-keymap))

(defun nano-replace-toggle-regex ()
  "切换正则表达式"
  (interactive)
  (setq nano-replace-regex (not nano-replace-regex))
  (message "Regex: %s" (if nano-replace-regex "ON" "OFF"))
  (nano-replace-activate-keymap))

(defun nano-replace-toggle-backward ()
  "切换向后搜索"
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
  "使用 overriding-local-map 激活局部按键映射"
  (nano--safe-activate-keymap
   nano-replace-keymap
   (lambda (v) (setq nano-replace--active v))
   'nano-replace-deactivate-keymap
   "Replace this? (Y/n/A/^P/^N/M-C/M-R/M-B/^C/^G)"))

(defun nano-replace-deactivate-keymap ()
  "停用局部按键映射"
  (setq nano-replace--active nil)
  (setq overriding-local-map nil))

(defun nano-replace-cleanup ()
  "清理替换状态"
  (when nano-replace-overlay
    (delete-overlay nano-replace-overlay)
    (setq nano-replace-overlay nil))
  (setq nano-replace-search nil
        nano-replace-replace nil
        nano-replace-case nil
        nano-replace-regex nil
        nano-replace-backward nil))

;; 匹配位置变量
(defvar nano-replace-match-start nil)
(defvar nano-replace-match-end nil)
(defvar nano-replace-overlay nil)

;; ========== Nano 风格界面 ==========

;; 顶部标题栏 - 左: Emacs 版本号，中: 文件名居中（修改后加星号）
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

;; ========== 自动补全与语法检查 ==========

(require 'package)
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory)
      package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless (package-installed-p 'company)
  (package-refresh-contents)
  (package-install 'company))
(unless (package-installed-p 'flycheck)
  (package-refresh-contents)
  (package-install 'flycheck))
(unless (package-installed-p 'yasnippet)
  (package-refresh-contents)
  (package-install 'yasnippet))

;; 语言模式
(unless (package-installed-p 'go-mode)
  (package-refresh-contents)
  (package-install 'go-mode))
(unless (package-installed-p 'rustic)
  (package-refresh-contents)
  (package-install 'rustic))
(unless (package-installed-p 'python-mode)
  (package-refresh-contents)
  (package-install 'python-mode))
(unless (package-installed-p 'js2-mode)
  (package-refresh-contents)
  (package-install 'js2-mode))
(unless (package-installed-p 'typescript-mode)
  (package-refresh-contents)
  (package-install 'typescript-mode))
(unless (package-installed-p 'yaml-mode)
  (package-refresh-contents)
  (package-install 'yaml-mode))
(unless (package-installed-p 'toml-mode)
  (package-refresh-contents)
  (package-install 'toml-mode))
(unless (package-installed-p 'markdown-mode)
  (package-refresh-contents)
  (package-install 'markdown-mode))
(unless (package-installed-p 'json-mode)
  (package-refresh-contents)
  (package-install 'json-mode))
(unless (package-installed-p 'dockerfile-mode)
  (package-refresh-contents)
  (package-install 'dockerfile-mode))
(unless (package-installed-p 'lua-mode)
  (package-refresh-contents)
  (package-install 'lua-mode))

;; company 自动补全
(require 'company)
(setq company-minimum-prefix-length 1
      company-idle-delay 0.1
      company-tooltip-align-annotations t
      company-tooltip-limit 14
      company-require-match nil
      company-dabbrev-other-buffers t)
(global-company-mode 1)

;; 补全导航
(define-key company-active-map (kbd "C-n") #'company-select-next)
(define-key company-active-map (kbd "C-p") #'company-select-previous)
(define-key company-active-map (kbd "C-j") #'company-complete-selection)
(define-key company-active-map (kbd "TAB") #'company-complete-common-or-cycle)

;; flycheck 语法检查
(require 'flycheck)
(global-flycheck-mode)
(setq flycheck-check-syntax-automatically '(save mode-enabled)
      flycheck-display-errors-delay 0.3)

;; yasnippet 代码片段
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))

;; ========== LSP (eglot) ==========

(require 'eglot)

;; 抑制 "Searching for program" 警告：找不到 LSP 服务器时静默失败
(setq eglot-events-buffer-size 0)

(defun nano-eglot-ensure ()
  "仅在 LSP 服务器已安装时才启动 eglot。"
  (condition-case nil
      (when (nano--lsp-server-p major-mode)
        (eglot-ensure))
    (error nil)))

(defun nano--lsp-server-p (mode)
  "检查 MODE 对应的 LSP 服务器是否已安装。"
  (let ((servers (cdr (assoc mode nano--lsp-servers))))
    (and servers (cl-some #'executable-find servers))))

;; mode → 可能的 LSP 服务器可执行文件名列表
(defconst nano--lsp-servers
  '((go-mode          . ("gopls"))
    (rustic-mode      . ("rust-analyzer"))
    (rust-mode        . ("rust-analyzer"))
    (python-mode      . ("pylsp" "pyright-langserver" "jedi-language-server" "ruff"))
    (python-ts-mode   . ("pylsp" "pyright-langserver" "jedi-language-server" "ruff"))
    (js2-mode         . ("typescript-language-server" "vscode-html-language-server"))
    (js-mode          . ("typescript-language-server" "vscode-html-language-server"))
    (typescript-mode  . ("typescript-language-server"))
    (typescript-ts-mode . ("typescript-language-server"))
    (yaml-mode        . ("yaml-language-server"))
    (json-mode        . ("vscode-json-language-server" "json-languageserver"))
    (json-ts-mode     . ("vscode-json-language-server" "json-languageserver"))
    (markdown-mode    . ("marksman" "vscode-markdown-language-server"))
    (dockerfile-mode  . ("docker-langserver"))
    (lua-mode         . ("lua-language-server" "lua-lsp")))
  "各 major-mode 对应的 LSP 服务器候选名。")

;; 自动启动 LSP（仅在服务器已安装时）
(add-hook 'go-mode-hook #'nano-eglot-ensure)
(add-hook 'rustic-mode-hook #'nano-eglot-ensure)
(add-hook 'python-mode-hook #'nano-eglot-ensure)
(add-hook 'js2-mode-hook #'nano-eglot-ensure)
(add-hook 'typescript-mode-hook #'nano-eglot-ensure)

;; eglot 补全接入 company
(with-eval-after-load 'company
  (setq company-backends
        '((company-capf :with company-yasnippet)
          company-dabbrev-code
          company-dabbrev)))

;; ========== 语言模式 ==========

;; Go
(require 'go-mode)
(define-key go-mode-map (kbd "C-x") 'nano-exit)

;; Rust
(require 'rustic)
(setq rustic-lsp-client 'eglot)
(define-key rustic-mode-map (kbd "C-x") 'nano-exit)

;; Python
(require 'python-mode)
(define-key python-mode-map (kbd "C-x") 'nano-exit)

;; JavaScript / TypeScript
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js2-mode))
(define-key js2-mode-map (kbd "C-x") 'nano-exit)

(require 'typescript-mode)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-mode))
(define-key typescript-mode-map (kbd "C-x") 'nano-exit)

;; YAML
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(define-key yaml-mode-map (kbd "C-x") 'nano-exit)

;; TOML
(require 'toml-mode)
(add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-mode))
(define-key toml-mode-map (kbd "C-x") 'nano-exit)

;; JSON
(require 'json-mode)
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
(define-key json-mode-map (kbd "C-x") 'nano-exit)

;; Markdown
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(define-key markdown-mode-map (kbd "C-x") 'nano-exit)

;; Dockerfile
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
(define-key dockerfile-mode-map (kbd "C-x") 'nano-exit)

;; Lua
(require 'lua-mode)
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))
(define-key lua-mode-map (kbd "C-x") 'nano-exit)

;; 底部快捷键栏（左：快捷键提示，右：状态信息）
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

;; 启动时显示快捷键提示
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Press ^G for Help")))
