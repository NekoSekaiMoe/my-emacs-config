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

(if (display-graphic-p)
    (progn
      (menu-bar-mode -1)            ;; 取消菜单栏
      (scroll-bar-mode -1)          ;; 取消滚动条（在 Emacs 26 中无效）
      (tool-bar-mode -1)))          ;; 取消工具栏
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

;; ========== Nano 风格保存/退出功能 ==========

;; 文件编码格式选择（模拟 Nano 的 M-M/M-D）
(defvar nano-save-format 'unix "保存文件格式: 'unix, 'dos, 'mac")

(defun nano-write-file-with-format (filename format)
  "以指定 FORMAT 保存文件"
  (let ((coding-system (cond
                         ((eq format 'dos) 'dos)
                         ((eq format 'mac) 'mac)
                         (t 'unix))))
    (set-buffer-file-coding-system coding-system)
    (write-file filename)
    (message "已保存为 %s 格式: %s" 
             (cond ((eq format 'dos) "DOS")
                   ((eq format 'mac) "Mac")
                   (t "Unix"))
             filename)))

;; Nano 风格保存并退出
(defun nano-save-and-exit ()
  "Nano 风格的保存并退出流程"
  (interactive)
  (let ((buf (current-buffer))
        (file (buffer-file-name)))
    (if (buffer-modified-p)
        ;; 文件已修改，询问是否保存
        (let ((choice (nano-y-n-prompt 
                       "Save modified buffer (ANSWERING \"No\" WILL DESTROY CHANGES) ? "
                       '(?y ?n ?\C-g))))
          (cond
           ((eq choice ?y)
            ;; 询问保存选项
            (nano-save-options buf file))
           ((eq choice ?n)
            ;; 不保存直接退出
            (kill-emacs))
           ((eq choice ?\C-g)
            ;; 取消
            (message "Cancelled"))))
      ;; 文件未修改，直接退出
      (kill-emacs))))

(defun nano-save-options (buf file)
  "显示 Nano 风格的保存选项"
  (let* (;; 默认文件名
         (default-name (or file (buffer-name)))
         ;; 读取用户输入的文件名
         (prompt (format "File Name to Write%s: "
                         (if file (format " (default %s)" default-name) "")))
         (filename (read-string prompt nil nil default-name)))
    (if (string= filename "")
        (message "Cancelled")
      ;; 选择保存格式
      (let ((format-choice (nano-save-format-menu)))
        (when format-choice
          (with-current-buffer buf
            (nano-write-file-with-format filename format-choice))
          (kill-emacs))))))

(defun nano-save-format-menu ()
  "显示格式选择菜单"
  (message (concat "Choose format: "
                   "[U]Unix " 
                   (if (eq system-type 'windows-nt) "" "[D]DOS ")
                   (if (eq system-type 'darwin) "" "[M]Mac "))
                   " C-g:Cancel")
  (let ((choice (read-char-exclusive)))
    (cond
     ((memq choice '(?u ?U)) 'unix)
     ((and (memq choice '(?d ?D)) (not (eq system-type 'windows-nt))) 'dos)
     ((and (memq choice '(?m ?M)) (not (eq system-type 'darwin))) 'mac)
     ((eq choice ?\C-g) nil)
     (t (nano-save-format-menu)))))

(defun nano-y-n-prompt (prompt chars)
  "Nano 风格的 y/n 提示"
  (message "%s" prompt)
  (let ((choice (read-char-exclusive)))
    (cond
     ((memq choice chars) choice)
     (t (nano-y-n-prompt prompt chars)))))

;; Nano 风格保存文件（Ctrl+O）
(defun nano-save-buffer ()
  "Nano 风格的保存流程"
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        ;; 已有文件名，直接保存
        (progn
          (save-buffer)
          (message "Wrote %s" file))
      ;; 没有文件名，询问保存位置
      (let* ((default-name (buffer-name))
             (filename (read-string 
                        (format "File Name to Write: ")
                        nil nil default-name)))
        (if (string= filename "")
            (message "Cancelled")
          (let ((format-choice (nano-save-format-menu)))
            (when format-choice
              (nano-write-file-with-format filename format-choice))))))))

;; ========== Nano 风格快捷键 ==========

;; 禁用 C-x 前缀键，使其可以直接使用
(global-unset-key (kbd "C-x"))

;; 退出: Ctrl+X (Nano) -> 自定义 Nano 风格退出
(global-set-key (kbd "C-x") 'nano-save-and-exit)

;; 保存文件: Ctrl+O (Nano) -> nano-save-buffer
(global-set-key (kbd "C-o") 'nano-save-buffer)

;; 搜索: Ctrl+W (Nano) -> isearch-forward
(global-set-key (kbd "C-w") 'isearch-forward)

;; 剪切行: Ctrl+K (Nano) -> kill-whole-line (Nano 风格)
(global-set-key (kbd "C-k") 'kill-whole-line)

;; 粘贴: Ctrl+U (Nano) -> yank
(global-set-key (kbd "C-u") 'yank)

;; 取消/退出: Ctrl+Q (Nano) -> keyboard-quit
(global-set-key (kbd "C-q") 'keyboard-quit)

;; 帮助: Ctrl+G (Nano) -> info
(global-set-key (kbd "C-g") (lambda () (interactive) (info "(emacs) Top")))

;; 显示光标位置: Ctrl+C (Nano) -> what-line / point position
(global-set-key (kbd "C-c") 'what-line)

;; 跳转行: Ctrl+_ (Nano) -> goto-line
(global-set-key (kbd "C-_") 'goto-line)
(global-set-key (kbd "C-/") 'goto-line)  ;; 也绑定 C-/ 作为备选

;; 查找替换: Ctrl+\ (Nano) -> query-replace
(global-set-key (kbd "C-\\") 'query-replace)

;; 撤销: Alt+U (Nano) -> undo (C-/ 已经是默认绑定)
(global-set-key (kbd "M-u") 'undo)

;; 删除整行 (可选: 用 C-S-k 作为 Nano 的 kill-ring 风格剪切)
(global-set-key (kbd "C-S-k") 'kill-ring-save)

;; 开始/结束文件: Home/End 风格 (Nano 用 Ctrl+Q/A)
(global-set-key (kbd "C-a") 'move-beginning-of-line)  ;; 保留原功能
(global-set-key (kbd "C-e") 'move-end-of-line)        ;; 保留原功能

;; 页面滚动: Ctrl+Y/V (Nano) -> scroll-up/down
(global-set-key (kbd "C-y") 'scroll-down-command)     ;; 向上翻页
(global-set-key (kbd "C-v") 'scroll-up-command)       ;; 向下翻页

;; 左右移单词: Ctrl+Left/Right (Nano) -> forward/backward word
(global-set-key (kbd "C-<left>") 'backward-word)
(global-set-key (kbd "C-<right>") 'forward-word)

;; ========== Nano 底部快捷键提示 ==========

;; 自定义 mode-line（顶部状态栏）
(setq-default mode-line-format
  '("%e"
    mode-line-front-space
    mode-line-mule-info
    mode-line-client
    mode-line-modified
    mode-line-remote
    mode-line-frame-identification
    mode-line-buffer-identification
    "   "
    mode-line-position
    "  "
    (vc-mode vc-mode)
    "  "
    mode-line-modes
    mode-line-misc-info
    mode-line-end-spaces))

;; 启动时显示快捷键提示
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "^G Help │ ^O Save │ ^W Find │ ^K Cut │ ^U Paste │ ^X Exit")))

;; Nano 风格底部快捷键栏 - 使用 header-line
(setq-default header-line-format
  (propertize " ^G Help │ ^O Save │ ^W Find │ ^K Cut │ ^U Paste │ ^X Exit "
              'face '(:background "grey20" :foreground "white")))
