In my Emacs keymapping, a single key usually does the same thing in several mode-specific maps, yet it is defined all over the place (under each mode-specific settings). I also love to s(eval-when-compile (eval-when-compile ((((  ))))ort my key mapping (to avoid duplicate keymaps which has got me some times).

I change my key frequently which requires me to visit different places just to change 1 single key, not to mention sorting the keys and all that. This is annoying, and I found in John Wiegly's \`bind-key' package the ideas of centralizing key definitions into one form, and using eval-after-load for late-loading packages. However the package facilitates binding several keys to a keymap, while my need is the opposite hence this package.

The disadvantage of this approach is the repetition of the keymap names for each key, due to the 1-many mapping of each key to multiple maps.

I have not tested the code on older Emacs versions yet, hence the required Emacs version specified above is 26.2 (my current version), where the code runs alright.

I hope you may find this program useful.

Reference:

[bind-key (linked to use-package github page)](https://github.com/jwiegley/use-package)

