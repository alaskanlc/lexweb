;; Modes

;; 1. Open grammar file
;; 2. C-x C-f  mode file
;; 3. M-x eval-buffer
;; 4. C-x b  to grammar
;; 5. M-x grammar-mode (refreshes too)

(define-generic-mode 'lexware-mode
  'nil
  'nil
  '(
    ("^#.*$" . 'font-lock-comment-face)
    ("^\\.[^ .]+" . 'custom-face-tag)
    ("^\\.\\.?\\.?[^ ]+" . 'font-lock-function-name-face)
    ("^[^ ]+" . 'font-lock-keyword-face)
    )
  '(".*\\.lexware$" ".*\\.lw$")
  nil
  "Major mode for editing Lexware text")

