(defn success []
  (print "✔")
  (os/exit 0))

(defn failed [err]
  (print (string "ERROR: " err))
  (os/exit 0))

(defmacro fail [err & body]
  ~(try ,;body ([_] (failed (string ,err)))))
