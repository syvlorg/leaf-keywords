;;; leaf-keywords-defaults.el --- Config collection for :defaults keyword  -*- lexical-binding: t; -*-

;; Copyright (C) 2020-2020 Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Config collection for :defaults keyword.

;; To use this module, add below code to your init.el

;;   ;; reqire this module and initialize dependency.
;;   (require 'leaf-keywords-defaults)
;;   (leaf-keywords-defaults--leaf/leaf-keyword)

;;   ;; load prepared configures you want.
;;   (leaf-keywords-defaults--leaf-defaults/base)
;;   (leaf-keywords-defaults--leaf/ivy)

;;; Code:

(prog1 'emacs
  (eval-and-compile
    (require 'leaf)
    (require 'leaf-keywords)
    (leaf-keywords-init))

  (leaf *leaf-keywords-config
    :preface
    (defun leaf-keywords-defaults--manager nil
      "leaf-manager for leaf-keywords-deafults.el"
      (unless (fboundp 'leaf-manager)
        (autoload #'leaf-manager "leaf-manager" nil t))
      (defvar leaf-manager-recursive-edit)
      (defvar leaf-manager-file)
      (defvar leaf-manager-template-feature-name)
      (defvar leaf-manager-template-summary)
      (defvar leaf-manager-template-commentary)
      (defvar leaf-manager-template-copyright-from)
      (defvar leaf-manager-template-copyright-to)
      (defvar leaf-manager-template-copyright-name)
      (defvar leaf-manager-template-author-name)
      (defvar leaf-manager-template-author-email)
      (declare-function leaf-manager "leaf-manager")
      (require 'leaf-manager)
      (let ((leaf-manager-recursive-edit t)
            (leaf-manager-file (eval-when-compile
                                 (or load-file-name
                                     (bound-and-true-p byte-compile-current-file)
                                     (buffer-file-name))))
            (leaf-manager-template-feature-name "leaf-keywords-defaults")
            (leaf-manager-template-summary "Config collection for :defaults keyword")
            (leaf-manager-template-commentary ";; Config collection for :defaults keyword.")
            (leaf-manager-template-copyright-from "2020")
            (leaf-manager-template-copyright-to nil)
            (leaf-manager-template-copyright-name "Naoya Yamashita")
            (leaf-manager-template-author-name "Naoya Yamashita")
            (leaf-manager-template-author-email "conao3@gmail.com"))
        (call-interactively #'leaf-manager)))

    :config
    (leaf package
      :defvar package-archive-contents
      :commands package-installed-p))

  (defun leaf-keywords-defaults-basic-dependency nil
    "Install leaf-defaults dependency to use prepared configures."
    (leaf blackout
      :ensure t))

  (eval-and-compile
    (defmacro leaf-keywords-defaults--generate (&rest plist)
      "Generate load sexp from ALIST."
      (declare
       (indent 0))
      (let ((plist* (leaf-normalize-plist plist 'merge))
            ret)
        (while plist*
          (let* ((key (leaf-sym-from-keyword (pop plist*)))
                 (val (pop plist*)))
            (push
             `(defun ,(intern
                       (format "leaf-keywords-defaults--leaf-defaults/%s" key)) nil
                ,(format "Autogenerated bundle leaf-keywords-defaults for %s." key)
                ,@(mapcan
                   (lambda (elm)
                     (let ((fn (intern
                                (format "leaf-keywords-defaults--leaf/%s" elm))))
                       `((declare-function ,fn "leaf-keywords-defaults")
                         (,fn))))
                   val))

             ret)))
        `(progn
           ,@(nreverse ret)))))

  (leaf-keywords-defaults--generate
    :base cus-edit cus-start delsel files paren simple startup flycheck company))

(leaf leaf-manager
  :config
  (leaf company
    :convert-defaults t
    :doc "Modular text completion framework"
    :req "emacs-24.3"
    :tag "matching" "convenience" "abbrev" "emacs>=24.3"
    :added "2020-12-05"
    :url "http://company-mode.github.io/"
    :emacs>= 24.3
    :ensure t
    :blackout t
    :leaf-defer nil
    :bind ((company-active-map
            ("M-n")
            ("M-p")
            ("C-s" . company-filter-candidates)
            ("C-n" . company-select-next)
            ("C-p" . company-select-previous)
            ("<tab>" . company-complete-selection))
           (company-search-map
            ("C-n" . company-select-next)
            ("C-p" . company-select-previous)))
    :custom ((company-idle-delay . 0)
             (company-minimum-prefix-length . 1)
             (company-transformers quote
                                   (company-sort-by-occurrence)))
    :global-minor-mode global-company-mode)

  (leaf cus-edit
    :convert-defaults t
    :doc "tools for customizing Emacs and Lisp packages"
    :tag "builtin" "faces" "help"
    :added "2020-12-04"
    :custom `((custom-file \,
                           (locate-user-emacs-file "custom.el"))))

  (leaf cus-start
    :convert-defaults t
    :doc "define customization properties of builtins"
    :tag "builtin" "internal"
    :added "2020-12-04"
    :custom ((create-lockfiles)
             (debug-on-error . t)
             (enable-recursive-minibuffers . t)
             (frame-resize-pixelwise . t)
             (history-delete-duplicates . t)
             (history-length . 1000)
             (init-file-debug . t)
             (mouse-wheel-scroll-amount quote
                                        (1
                                         ((control)
                                          . 5)))
             (ring-bell-function quote ignore)
             (scroll-conservatively . 100)
             (scroll-preserve-screen-position . t)
             (text-quoting-style quote straight)
             (truncate-lines . t)
             (menu-bar-mode . t)
             (use-dialog-box)
             (use-file-dialog)
             (tool-bar-mode)
             (scroll-bar-mode)
             (indent-tabs-mode))
    :config
    (defalias 'yes-or-no-p 'y-or-n-p)
    (keyboard-translate 8 127))

  (leaf ddskk-posframe
    :convert-defaults t
    :doc "Show Henkan tooltip for ddskk via posframe"
    :req "emacs-26.1" "posframe-0.4.3" "ddskk-16.2.50"
    :tag "posframe" "convenience" "tooltip" "emacs>=26.1"
    :added "2020-12-25"
    :url "https://github.com/conao3/ddskk-posframe.el"
    :emacs>= 26.1
    :ensure t
    :after posframe ddskk
    :global-minor-mode t)

  (leaf delsel
    :convert-defaults t
    :doc "delete selection if you insert"
    :tag "builtin"
    :added "2020-12-05"
    :global-minor-mode delete-selection-mode)

  (leaf files
    :convert-defaults t
    :doc "file input and output commands for Emacs"
    :tag "builtin"
    :added "2020-12-05"
    :custom `((auto-save-timeout . 15)
              (auto-save-interval . 60)
              (auto-save-file-name-transforms quote
                                              ((".*" ,(locate-user-emacs-file "backup/")
                                                t)))
              (backup-directory-alist quote
                                      ((".*" \,
                                        (locate-user-emacs-file "backup"))
                                       (,tramp-file-name-regexp)))
              (version-control . t)
              (delete-old-versions . t)))

  (leaf flycheck
    :convert-defaults t
    :doc "On-the-fly syntax checking"
    :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
    :tag "tools" "languages" "convenience" "emacs>=24.3"
    :added "2020-12-05"
    :url "http://www.flycheck.org"
    :emacs>= 24.3
    :ensure t
    :bind (("M-n" . flycheck-next-error)
           ("M-p" . flycheck-previous-error))
    :global-minor-mode global-flycheck-mode)

  (leaf ivy
    :convert-defaults t
    :doc "Incremental Vertical completYon"
    :req "emacs-24.5"
    :tag "matching" "emacs>=24.5"
    :added "2020-12-05"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :leaf-defer nil
    :custom ((ivy-initial-inputs-alist)
             (ivy-re-builders-alist quote
                                    ((t . ivy--regex-fuzzy)
                                     (swiper . ivy--regex-plus)))
             (ivy-use-selectable-prompt . t))
    :global-minor-mode t
    :config
    (leaf swiper
      :doc "Isearch with an overview. Oh, man!"
      :req "emacs-24.5" "ivy-0.13.0"
      :tag "matching" "emacs>=24.5"
      :url "https://github.com/abo-abo/swiper"
      :emacs>= 24.5
      :ensure t
      :bind (("C-S-s" . swiper)))

    (leaf counsel
      :doc "Various completion functions using Ivy"
      :req "emacs-24.5" "swiper-0.13.0"
      :tag "tools" "matching" "convenience" "emacs>=24.5"
      :url "https://github.com/abo-abo/swiper"
      :emacs>= 24.5
      :ensure t
      :blackout t
      :bind (("C-x C-r" . counsel-recentf))
      :custom `((counsel-yank-pop-separator . "
----------
")
                (counsel-find-file-ignore-regexp \,
                                                 (rx-to-string
                                                  '(or "./" "../")
                                                  'no-group)))
      :global-minor-mode t)

    (leaf prescient
      :doc "Better sorting and filtering"
      :req "emacs-25.1"
      :tag "extensions" "emacs>=25.1"
      :url "https://github.com/raxod502/prescient.el"
      :emacs>= 25.1
      :ensure t
      :custom ((prescient-aggressive-file-save . t))
      :global-minor-mode prescient-persist-mode)

    (leaf ivy-prescient
      :doc "prescient.el + Ivy"
      :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
      :tag "extensions" "emacs>=25.1"
      :url "https://github.com/raxod502/prescient.el"
      :emacs>= 25.1
      :ensure t
      :custom ((ivy-prescient-retain-classic-highlighting . t))
      :global-minor-mode t))

  (leaf paren
    :convert-defaults t
    :doc "highlight matching paren"
    :tag "builtin"
    :added "2020-12-05"
    :custom ((show-paren-delay . 0.1))
    :global-minor-mode show-paren-mode)

  (leaf posframe
    :convert-defaults t
    :when window-system
    :doc "Pop a posframe (just a frame) at point"
    :req "emacs-26"
    :tag "tooltip" "convenience" "emacs>=26"
    :added "2020-12-25"
    :url "https://github.com/tumashu/posframe"
    :emacs>= 26
    :ensure t
    :require t)

  (leaf simple
    :convert-defaults t
    :doc "basic editing commands for Emacs"
    :tag "builtin" "internal"
    :added "2020-12-05"
    :custom ((kill-ring-max . 100)
             (kill-read-only-ok . t)
             (kill-whole-line . t)
             (eval-expression-print-length)
             (eval-expression-print-level)))

  (leaf skk
    :convert-defaults t
    :doc "Daredevil SKK (Simple Kana to Kanji conversion program)"
    :tag "out-of-MELPA" "input method" "mule" "japanese"
    :added "2020-12-25"
    :url "https://github.com/skk-dev/ddskk"
    :ensure ddskk
    :custom ((default-input-method . "japanese-skk")))

  (leaf startup
    :convert-defaults t
    :doc "process Emacs shell arguments"
    :tag "builtin" "internal"
    :added "2020-12-05"
    :custom `((auto-save-list-file-prefix \,
                                          (locate-user-emacs-file "backup/.saves-")))))



(provide 'leaf-keywords-defaults)

;; Local Variables:
;; indent-tabs-mode: nil
;; buffer-read-only: t
;; End:

;;; leaf-keywords-defaults.el ends here
