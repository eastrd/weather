(load "")
(ql:quickload "drakma")
(ql:quickload "cl-json")

(defconstant *api-key* 
  "")

(defun make-url (lat lon api-key)
  (format nil "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=~a&lon=~a&appid=~a" lat lon api-key))

(defun get-weather (url)
  (let* ((resp (drakma:http-request url))
        (str (byte-to-string resp)))
      (with-input-from-string (s str)
        (json:decode-json s))))

(defun byte-to-string (b)
  (map 'string #'code-char b))

(get-weather (make-url -37.8863 145.058725 *api-key*))