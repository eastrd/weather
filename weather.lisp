(load "")
(ql:quickload "drakma")
(ql:quickload "cl-json")
(ql:quickload "alexandria")

(defconstant *api-key* 
  "")

(defun make-url (&key lat lon api-key)
  (format nil 
    "https://api.openweathermap.org/data/2.5/weather?lat=~a&lon=~a&appid=~a" 
    lat lon api-key))

(defun get-weather (url)
  (let* ((resp (drakma:http-request url))
        (str (byte-to-string resp)))
      (with-input-from-string (s str)
        (alexandria:alist-hash-table
          (json:decode-json s)))))

(defun byte-to-string (b)
  (map 'string #'code-char b))

(defun k-to-c (k) (- k 273.15))

(defun weather-broadcast (table)
  (let* ((summary (gethash :weather table))
        (detail (cdr (third (first summary))))
        (surburb (gethash :name table))
        (temps (gethash :main table))
        (temp-high (cdr (third temps)))
        (temp-low (cdr (fourth temps))))
    (format t "Weather at ~a is ~aC-~aC, overall ~a" surburb (k-to-c temp-low) (k-to-c temp-high) detail)))

(get-weather (make-url :lat -37.8863 :lon 145.058725 :api-key *api-key*))


