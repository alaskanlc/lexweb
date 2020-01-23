;; Modes

;; 1. Open grammar file
;; 2. C-x C-f  mode file
;; 3. M-x eval-buffer
;; 4. C-x b  to grammar
;; 5. M-x grammar-mode (refreshes too)

(define-generic-mode 'lexware-grammar-mode
  '("#") ; comment char
  '("1-to-many" "0-to-1" "0-to-many" "exactly-1")
  '(("<[^>]*>" . 'font-lock-function-name-face)
    ("TEXT" . 'diff-added)
    ("[|=]" . 'font-lock-constant-face))
  '("\\.grammar$")
  nil
  "Major mode for editing grammars")

;; (define-generic-mode 'grammar-mode
;;   '("#") ; comment char
;;   '("(1-to-many)" "0-or-1" "0-to-many" "exactly-1" "1-or-more")
;;   '(("<[^>]*>" . 'font-lock-builtin-face)
;;     ("^\\ *[^ ]+" . 'font-lock-function-name-face)
;;     ("[|=]" . 'font-lock-constant-face))
;;   '("\\.grammar$")
;;   nil
;;   "Major mode for editing grammars")

;; M-x list-faces-display  to see faces

