(declare-project
  :name "todo"
  :description ""
  :dependencies ["https://github.com/janet-lang/sqlite3"
                 "https://github.com/joy-framework/http"
                 "https://github.com/janet-lang/json"
                 "https://github.com/dghaehre/janet-utils"]
  :author ""
  :license ""
  :url ""
  :repo "https://github.com/dghaehre/todo")

(phony "dev" []
  (os/shell "janet ./main.janet"))

(phony "sync" []
  (os/shell "janet ./main.janet sync"))

(phony "count" []
  (os/shell "janet ./main.janet count completed"))

(phony "tui" []
  (os/shell "janet ./main.janet"))

(declare-executable
  :name "todo"
  :entry "./main.janet")
