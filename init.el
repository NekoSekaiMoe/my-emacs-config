;;; init.el --- Nano mode for Emacs -*- lexical-binding: t; -*-

;;; Commentary:
;; 入口文件，加载各模块

;;; Code:

;; ========== 加载路径 ==========

(add-to-list 'load-path (expand-file-name "nano"
  (file-name-directory (or load-file-name buffer-file-name))))

;; ========== 模块加载 ==========

(require 'nano-util)    ; 基本设置、编码、剪贴板、备份、UI
(require 'nano-window)  ; 标题栏、mode-line、GC优化
(require 'nano-keys)    ; 快捷键、搜索、替换、跳转
(require 'nano-lsp)     ; LSP、语言模式、关键字补全
(require 'nano-welcome) ; 欢迎页

;;; init.el ends here
