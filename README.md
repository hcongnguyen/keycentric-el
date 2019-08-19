
# Table of Contents

1.  [keycentric.el &#x2014 Define keys for **all** keymaps all at once](#org85fcd19)
2.  [Examples](#org29bae9c)
3.  [References](#orgeebdcb1)



<a id="org85fcd19"></a>

# keycentric.el &#x2014 Define keys for **all** keymaps all at once

In my Emacs keymapping, a single key usually does the same thing in several mode-specific maps, yet it is defined all over the place (under each mode-specific settings). I also love to s(eval-when-compile (eval-when-compile ((((  ))))ort my key mapping (to avoid duplicate keymaps which has got me some times).

I change my key frequently which requires me to visit different places just to change 1 single key, not to mention sorting the keys and all that. This is annoying, and I found in John Wiegly's \`bind-key' package the ideas of centralizing key definitions into one form, and using eval-after-load for late-loading packages. However the package facilitates binding several keys to a keymap, while my need is the opposite hence this package.

The disadvantage of this approach is the repetition of the keymap names for each key, due to the 1-many mapping of each key to multiple maps.

I have not tested the code on older Emacs versions yet, hence the required Emacs version specified above is 26.2 (my current version), where the code runs alright.


<a id="org29bae9c"></a>

# Examples

    (when (require 'keycentric nil t)
      (keycentric
       `(("<C-M-S-up>" (nil (global-map . backward-up-list)))
         ("<f5> b" (nil (global-map . (lambda () (interactive)
                                            (and (revert-buffer nil t)
                                            (message "buffer reverted."))))))
         ("<C-S-s>" (nil (global-map . isearch-forward-regexp))
                    (isearch (isearch-mode-map . isearch-repeat-forward))))))

I hope you may find this program useful.


<a id="orgeebdcb1"></a>

# References

[bind-key (linked to use-package github page)](https://github.com/jwiegley/use-package)

