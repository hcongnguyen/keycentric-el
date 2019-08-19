;;;; keycentric.el --- Define keys for *all* keymaps all at once  -*- lexical-binding: t; fill-column: 80 -*-
;;
;; Copyright (C) 2019  Hai Nguyen
;;
;; Author: Hai Nguyen <hainguyenuniverse@gmail.com>
;; Created: 2019-08-19
;; Version: 0.0.1
;; Package-Requires: ((emacs "26.2") (cl-macs "2.02"))
;; Keywords: dotemacs startup keymap
;; URL: https://github.com/haicnguyen/keycentric-el
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;;
;;; Commentary:
;;
;;
;; In my Emacs keymapping, a single key usually does the same thing in several mode-specific maps, yet it is defined all over the place (under each mode-specific settings). I also love to s(eval-when-compile (eval-when-compile ((((  ))))ort my key mapping (to avoid duplicate keymaps which has got me some times).
;;
;;
;; I change my key frequently which requires me to visit different places just to change 1 single key, not to mention sorting the keys and all that. This is annoying, and I found in John Wiegly's `bind-key' package the ideas of centralizing key definitions into one form, and using eval-after-load for late-loading packages. However the package facilitates binding several keys to a keymap, while my need is the opposite hence this package.
;;
;;
;; The disadvantage of this approach is the repetition of the keymap names for each key, due to the 1-many mapping of each key to multiple maps.
;;
;;
;; I have not tested the code on older Emacs versions yet, hence the required Emacs version specified above is 26.2 (my current version), where the code runs alright.
;;
;;
;; Reference:
;;
;; [[https://github.com/jwiegley/use-package][bind-key (linked to use-package github page)]]
;;
;;; Code:


(eval-when-compile (require 'cl-macs))


(defun keycentric (mapping-list)
  "MAPPING-LIST a list of forms, each form takes the same arguments as below:

KEY: either a vector of key sequence or a string (which will be fed to the `kbd' function).
FUN: the function symbol/lambda form to be mapped to the key."
  (let (key-arg
        key
        form
        package-form
        binding-form
        map-symbol
        map
        package-symbol
        fun-symbol)
      (while (car mapping-list)
        (setf form (pop mapping-list)
              key-arg (pop form)
              key (cond ((vectorp key-arg) key-arg)
                        ((stringp key-arg) (kbd key-arg))
                        (t (user-error "Wrong argument's datatype: KEY (%s) is of type `%s' instead of type vector or string!" key-arg (type-of key-arg))))
              )
          (while (car form)
            (setf package-form (pop form)
                  package-symbol (pop package-form))
            (while (car package-form)
              (setf binding-form (pop package-form)
                    map-symbol (pop binding-form)
                    fun-symbol binding-form
                    map (when (boundp map-symbol)
                          (symbol-value map-symbol)))
              (cond
               ((keymapp map) (define-key map key fun-symbol))
               ((null (featurep package-symbol))
                (eval-after-load package-symbol
                  `(let ((map (when (boundp ',map-symbol) (symbol-value ',map-symbol))))
                    (if (keymapp map)
                        (define-key map ,key ',fun-symbol)
                      (user-error "feature loaded but no such keymap: `%s'" ',map-symbol)))))
               (t (user-error "Package `%s' has already been loaded but no such keymap `%s'!" ,package-symbol map))))))))


(provide 'keycentric)
;;; keycentric.el ends here
