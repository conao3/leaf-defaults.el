;;; leaf-defaults-tests.el --- Test definitions for leaf-defaults  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
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

;; Test definitions for `leaf-defaults'.


;;; Code:

(require 'cort)
(require 'leaf)
(require 'leaf-keywords)
(require 'leaf-defaults)

(setq leaf-expand-minimally t)
(leaf-defaults-init)

(cort-deftest-generate leaf/defaults :macroexpand
  '(((leaf helm
       :ensure t
       :defaults t)
     (prog1 'helm
       (leaf-handler-package helm helm nil)
       (leaf-keywords-defaults--leaf/helm)))

    ((leaf helm
       :when nil
       :ensure t
       :defaults t)
     (prog1 'helm
       (when nil
         (leaf-handler-package helm helm nil)
         (leaf-keywords-defaults--leaf/helm))))

    ((leaf helm
       :ensure t
       :defaults conao3)
     (prog1 'helm
       (leaf-handler-package helm helm nil)
       (leaf-keywords-defaults--conao3/helm)))

    ((leaf helm
       :ensure t
       :defaults conao3 garario3)
     (prog1 'helm
       (leaf-handler-package helm helm nil)
       (leaf-keywords-defaults--conao3/helm)
       (leaf-keywords-defaults--garario3/helm)))

    ((leaf helm
       :ensure t
       :defaults conao3
       :defaults garario3)
     (prog1 'helm
       (leaf-handler-package helm helm nil)
       (leaf-keywords-defaults--conao3/helm)
       (leaf-keywords-defaults--garario3/helm)))

    ((leaf helm
       :ensure t
       :defaults nil
       :defaults conao3
       :defaults garario3)
     (prog1 'helm
       (leaf-handler-package helm helm nil)))))

(cort-deftest-generate leaf/convert-defaults :macroexpand
  '(((leaf leaf
       :convert-defaults t
       :preface
       (leaf-pre-init)
       (leaf-pre-init-after)
       :when (some-condition)
       :require t
       :init (package-preconfig)
       :config (package-init))
     (prog1 'leaf
       (defun leaf-keywords-defaults--leaf/leaf ()
         "Default config for leaf/leaf."
         (leaf-pre-init)
         (leaf-pre-init-after)
         (when
             (some-condition)
           (package-preconfig)
           (require 'leaf)
           (package-init)))))))

;; (provide 'leaf-defaults-tests)

;;; leaf-defaults-tests.el ends here
