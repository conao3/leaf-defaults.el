;;; leaf-defaults.el --- Awesome leaf config collections  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Version: 0.0.1
;; Keywords: convenience
;; Package-Requires: ((emacs "26.1") (leaf "4.1") (leaf-keywords "1.1"))
;; URL: https://github.com/conao3/leaf-defaults.el

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

;; Awesome leaf config collections.


;;; Code:

(require 'cl-lib)
(require 'leaf)
(require 'leaf-keywords)

(defgroup leaf-defaults nil
  "Awesome leaf config collections."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/leaf-defaults.el"))

(defcustom leaf-defaults-before-protection
  (leaf-list
   :convert-defaults `((defun ,(car leaf--value) () ,(cdr leaf--value) ,@leaf--body)))
  "Additional `leaf-keywords' before protection.
:disabled <this place> :leaf-protect"
  :set #'leaf-keywords-set-keywords
  :type 'sexp
  :group 'leaf-defaults)

(defcustom leaf-defaults-after-conditions
  (leaf-list
   :defaults   `(,@(mapcar (lambda (elm) `(,elm)) leaf--value) ,@leaf--body))
  "Additional `leaf-keywords' after conditional branching.
:when :unless :if ... :ensure <this place> :after"
  :set #'leaf-keywords-set-keywords
  :type 'sexp
  :group 'leaf-defaults)

(defcustom leaf-defaults-normalize
  '(((memq leaf--key '(:defaults))
     (let ((ret (leaf-flatten leaf--value)))
       (if (eq nil (car ret))
           nil
         (mapcar
          (lambda (elm)
            (intern (format "leaf-keywords-defaults--%s/%s" (if (eq t elm) "leaf" elm) leaf--name)))
          (delete-dups ret)))))

    ((memq leaf--key '(:convert-defaults))
     (let* ((key (car leaf--value))
            (sym (intern (format "%s/%s" (if (eq t key) "leaf" key) leaf--name))))
       `(,(intern (format "leaf-keywords-defaults--%s" sym))
         . ,(format "Default config for %s." sym)))))
  "Additional `leaf-normalize'."
  :set #'leaf-keywords-set-normalize
  :type 'sexp
  :group 'leaf-defaults)

(defvar leaf-defaults-init-frg nil)

(defun leaf-defaults-init (&optional force)
  "Initialize leaf-defaults, add :defaults, :convert-defaults for `leaf.'.
If FORCE is non-nil, append our element without any conditions."
  (when (or force (not leaf-defaults-init-frg))
    (setq leaf-keywords-after-conditions
          (append leaf-defaults-before-protection leaf-keywords-after-conditions)))

  (when (or force (not leaf-defaults-init-frg))
    (setq leaf-keywords-after-conditions
          (append leaf-defaults-before-protection leaf-keywords-after-conditions)))

  (when (or force (not leaf-defaults-init-frg))
    (setq leaf-defaults-normalize
          (append leaf-defaults-normalize leaf-keywords-normalize)))

  (when (or force (not leaf-defaults-init-frg))
    (leaf-keywords-init))

  (setq leaf-defaults-init-frg t))

(provide 'leaf-defaults)

;;; leaf-defaults.el ends here
