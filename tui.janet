(import spork/rawterm)

(defn set-size [rows cols]
  (setdyn :size/rows rows)
  (setdyn :size/cols cols))

(defn size [s]
  (case s
    :cols (dyn :size/cols)
    :rows (dyn :size/rows)
    (error "expects :cols or :rows")))

(defn header [model]
  "All tasks | completed")

(defn layout [model]
  (print (header nil))
  (for _ 0 (- (size :rows) 3)
    (print ""))
  (print "hey"))

(defn run []
  (print "press q to quit")
  (defer (rawterm/end)
    (rawterm/begin set-size)
    (set-size ;(rawterm/size))
    (forever
      (def [c] (rawterm/getch))
      (case c
        (chr "a") (print "Got an A an for Alan!")
        (chr "b") (pp (size :cols))
        (chr "c") (layout nil)
        (chr "]") (layout nil)
        (chr "[") (layout nil)
        (chr "q") (do (print "quitting...") (break))
        (printf "got a %c for something..." c)))))
