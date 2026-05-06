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
 auto-save-default t           ;; 打开自动保存
 truncate-string-ellipsis "…"  ;; Unicode ellispis are nicer than "...", and also save /precious/ space
 ;; 当寻找一个同名的文件,改变两个buffer的名字,前面加上目录名
 uniquify-buffer-name-style 'post-forward-angle-brackets)

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

;; 标记状态变量
(defvar nano-mark-active nil "标记是否激活")

;; ^G - Help
(global-set-key (kbd "C-g") (lambda () (interactive) (info "(emacs) Top")))

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

;; ^W - Where Is (搜索)
(global-set-key (kbd "C-w") 'isearch-forward)

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

;; ^6 - 标记设定/解除 (Mark Set/Clear)
(defun nano-mark-toggle ()
  "切换标记状态：按一次设定标记，再按一次解除"
  (interactive)
  (if nano-mark-active
      (progn
        (setq nano-mark-active nil)
        (deactivate-mark)
        (message "Mark cleared"))
    (progn
      (setq nano-mark-active t)
      (set-mark (point))
      (message "Mark set"))))
(global-set-key (kbd "C-6") 'nano-mark-toggle)

;; M-U - Undo
(global-set-key (kbd "M-u") 'undo)

;; M-E - Redo (使用 undo-tree 或内置 undo)
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

;; ^\ - Replace (查找替换)
(global-set-key (kbd "C-\\") 'query-replace)

;; ^U - Paste (粘贴)
(global-set-key (kbd "C-u") 'yank)

;; ^J - Justify (对齐)
(global-set-key (kbd "C-j") 'fill-paragraph)

;; ^/ - Go To Line (跳转到指定行和列)
(defun nano-go-to-line ()
  "跳转到指定行和列（格式：行,列 或 仅行）"
  (interactive)
  (let* ((input (read-string "Go to line (column): "))
         (parts (split-string input ",")))
    (if (= (length parts) 2)
        (progn
          (goto-char (point-min))
          (forward-line (1- (string-to-number (car parts))))
          (move-to-column (string-to-number (cadr parts))))
      (goto-line (string-to-number (car parts))))))
(global-set-key (kbd "C-/") 'nano-go-to-line)

;; ========== Nano 风格界面 ==========

;; 顶部标题栏 - 显示 "Emacs" 和缓冲区名称，修改后显示星号
(setq-default header-line-format
  '((:eval
     (let ((name (buffer-name))
           (modified (if (buffer-modified-p) " *" " ")))
       (propertize (format " Emacs  %s%s" name modified)
                   'face '(:background "grey20" :foreground "white"))))))

;; 底部快捷键栏
(setq-default mode-line-format
  '((:eval (propertize " ^G Help │ ^O Write Out │ ^W Where Is │ ^K Cut │ ^T Execute │ ^C Location │ ^6 Mark Set "
                       'face '(:background "grey20" :foreground "white")))
    (:eval (propertize " " 'display (raise 0.3)))
    (:eval (propertize " ^X Exit │ ^R Read File │ ^\\ Replace │ ^U Paste │ ^J Justify │ ^/ Go To Line │ M-U Undo "
                       'face '(:background "grey20" :foreground "white")))))

;; 启动时显示快捷键提示
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Press ^G for Help")))
