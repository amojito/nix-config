;; Set this before loading evil and evil-collection
(setq evil-want-integration t)
(setq evil-want-keybinding nil)

(require 'evil)
(evil-mode 1)

;; Enable evil-collection for better integration
(when (require 'evil-collection nil t)
  (evil-collection-init))
