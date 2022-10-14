(import sqlite3 :as sql)

(defn query [sql &opt params]
  (default params @{})
  (sql/eval (dyn :db/connection) (string sql ";") params))

# TODO: Handle migrations
(defn- setup []
  (query
`create table if not exists completed (
 id integer primary key,
 taskid integer,
 projectid text,
 content text
 )`))

(defn disconnect []
  (sql/close (dyn :db/connection))
  (setdyn :db/connection nil))

(defn connect []
  (try (disconnect) ([_] ()))
  (setdyn :db/connection (sql/open "/home/dghaehre/.cache/todo.db"))
  (sql/eval (dyn :db/connection) "PRAGMA foreign_keys=1")
  (setup))

(defn- clean
  `Delete database and setup a connection for the new one`
  []
  (try (sql/close (dyn :db/connection)) ([_] ()))
  (os/shell "rm ~/.cache/todo.db && touch ~/.cache/todo.db")
  (connect))

# TODO use sync token
(defn insert-completed [items]
  (loop [item :in items]
    (query `insert or ignore into completed (id, projectid, content, taskid)
            values (:id, :projectid, :content, :taskid)` {:id        (get item "id")
                                                          :projectid (get item "project_id") 
                                                          :taskid    (get item "task_id")
                                                          :content   (get item "content")})))

(defn count [table-name]
  (-> (query (string "select count(*) from " table-name))
      (get 0)
      (get (keyword "count(*)"))))
