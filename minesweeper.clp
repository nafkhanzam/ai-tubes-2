; is-edge -> dinding
; is-unknown -> belum terbuka
; is-bomb -> flagged oleh clips
; is-{0, 1, 2, 3, 4} -> terbuka
; is-open -> terbuka
; is-safe -> safe cell oleh clips

(defrule new-pos
    (x-pos $?xpos)
    (y-pos $?ypos)
=>
    (assert (new-x-pos nil ?xpos nil))
    (assert (new-y-pos nil ?ypos nil))
)

(defrule check-1-1
  (
    or
      (and
        (new-x-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-y-pos $? ?y ?y1 $?)
      )
      (and
        (new-x-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-y-pos $? ?y ?y1 $?)
      )
      (and
        (new-x-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-y-pos $? ?y1 ?y $?)
      )
      (and
        (new-x-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-y-pos $? ?y1 ?y $?)
      )
      (and
        (new-y-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-x-pos $? ?y ?y1 $?)
      )
      (and
        (new-y-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-x-pos $? ?y ?y1 $?)
      )
      (and
        (new-y-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-x-pos $? ?y1 ?y $?)
      )
      (and
        (new-y-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-x-pos $? ?y1 ?y $?)
      )
  )
  (
    or
      (is-edge ?x ?y)
      (is-open ?x ?y)
      (is-safe ?x ?y)
  )
  (
    or
      (is-edge ?x ?y1)
      (is-open ?x ?y1)
      (is-safe ?x ?y1)
  )
  (is-closed ?x1 ?y)
  (is-closed ?x2 ?y)
  ?f <- (is-unknown ?x3 ?y)
  (is-1 ?x1 ?y1)
  (is-1 ?x2 ?y1)
  (is-open ?x3 ?y1)
=>
  (assert (is-safe ?x3 ?y))
  (retract ?f)
)

; =======================================================

(defrule check-1-2
  (
    or
      (and
        (new-x-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-y-pos $? ?y ?y1 $?)
      )
      (and
        (new-x-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-y-pos $? ?y ?y1 $?)
      )
      (and
        (new-x-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-y-pos $? ?y1 ?y $?)
      )
      (and
        (new-x-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-y-pos $? ?y1 ?y $?)
      )
      (and
        (new-y-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-x-pos $? ?y ?y1 $?)
      )
      (and
        (new-y-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-x-pos $? ?y ?y1 $?)
      )
      (and
        (new-y-pos $? ?x ?x1 ?x2 ?x3 $?)
        (new-x-pos $? ?y1 ?y $?)
      )
      (and
        (new-y-pos $? ?x3 ?x2 ?x1 ?x $?)
        (new-x-pos $? ?y1 ?y $?)
      )
  )
  (is-closed ?x1 ?y)
  (is-closed ?x2 ?y)
  ?f <- (is-unknown ?x3 ?y)
  (is-1 ?x1 ?y1)
  (is-2 ?x2 ?y1)
  (is-open ?x3 ?y1)
=>
  (assert (is-bomb ?x3 ?y))
  (assert (new-bomb ?x3 ?y))
  (retract ?f)
)

(defrule set_to_bomb
  (set_unknown_to_bomb ?x ?y)
  ?f <- (is-unknown ?x ?y)
=>
  (retract ?f)
  (assert (is-bomb ?x ?y))
  (assert (new-bomb ?x ?y))
)

(defrule set_to_safe
  (set_unknown_to_safe ?x ?y)
  ?f <- (is-unknown ?x ?y)
=>
  (retract ?f)
  (assert (is-safe ?x ?y))
)
