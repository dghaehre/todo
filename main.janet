(import sh)
(import ./db)
(import ./api)
(import ./tui)
(use utils)
(use ./utils)

(defn read-from-file [file-path]
  (let [f         (file/open file-path :r)
        content   (file/read f :all)]
    (file/close f)
    content))

# TODO: handle error
# TODO: handle homedir
(defn read-token []
  (let [path  (string (os/getenv "HOME") "/.todoist.token")
        token (fail ("Could not find todoist api token at " path)
                (-> (read-from-file path) (string/trim)))]
    (api/set-token token)))

# Sync completed
(defn sync []
  (-> (api/get-completed-items)
      (db/insert-completed))
  (success))

(defn count [table-name]
  (case (keyword table-name)
    :completed ()
    (failed (string table-name " is not a table name")))
  (-> (db/count table-name)
      (pp)))

(defn quick-add [desc]
  (api/quick-add desc)
  (success))
        
(defn main [& args]
  (db/connect)
  (read-token)
  (defer (db/disconnect)
    (let [list (tail args)]
      (case (keyword (get list 0))
        :sync   (sync)
        :count  (count (get list 1)) 
        :add    (-> (get list 1) (quick-add))
        (tui/run)))))
