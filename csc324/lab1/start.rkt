#lang slideshow
(define c (circle 10))
(define r (rectangle 10 20))

; draw a filled rectangle
(define (square n)
  (filled-rectangle n n))

; draw four pictures combined
; vertically and hrizontally
(define (four p)
  (define two (hc-append p p))
  (vc-append two two))

; draw two pics alternatively
(define (checker a b ac bc)
  (define colored_a (colorize a ac))
  (define colored_b (colorize b bc))
  
  (let ([ab (hc-append colored_a colored_b)]
        [ba (hc-append colored_b colored_a)])

    (vc-append ab ba)))

; draw a large checkerboard with a specified unit
(define (checkerboard p)
  (let* ([c (checker p p "red" "black")]
         [c4 (four c)])
    (four c4)))(checkerboard (square 10))

; return the multiples of 3 from a given list
(define (multiples-of-3 lst)
  (multiples-of-3-helper lst '())
  )

(define (multiples-of-3-helper lst acc)
  (if (empty? lst) acc
      (multiples-of-3-helper (rest lst)
                             (if (equal? 0 (remainder (first lst) 3)) (cons (first lst) acc) acc))
      )
  )