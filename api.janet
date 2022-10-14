(import http)
(import utils)
(use ./utils)
(import json)
(import spork/misc :as spork)

(defn set-token [token]
  (setdyn :todoist/token token))

(defn- token []
  (dyn :todoist/token))

# TODO: a lot of macro possibilities here..
# TODO: return sync token
(defn get-completed-items
  `Get completed tasks`
  []
  (var offset 0)
  (var items @[])
  (while true
    (let [t       (string "Bearer " (token))
          headers {"Authorization" t "Accept" "application/json"}
          res     (-> (http/post (string "https://api.todoist.com/sync/v9/completed/get_all?limit=200&offset=" offset) nil :headers headers)
                      (get :body)
                      (json/decode)
                      (get "items"))]
      (array/concat items res) 
      (set offset (+ offset 200))
      (if (not= (length res) 200)
        (break))))
  items)

# TODO: handle error
# http/post doesnt fail on 400
(defn quick-add [desc]
  (let [t       (string "Bearer " (token))
        headers {"Authorization" t "Accept" "application/json" "Content-Type" "application/x-www-form-urlencoded"}]
    (-> (http/post "https://api.todoist.com/sync/v9/quick/add" (string "text=" desc) :headers headers)
        (json/decode))))
