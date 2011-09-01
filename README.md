internet_tracer
===============

Let's suppose your internet connection is very unstable.
Likely, after losing the connection you want to be notified when back online. Just run internet_tracer and do something without digress!


Usage examples
--------------

Using public some public IP resolution service: `internet-trace -u http://www.myip.ru/get_ip.php?loc=`.
By default, you will be notified when the first IP address found on a page is non-equal to `0.0.0.0`.

It can also be used with DD-WRT router status page: `internet-trace -u http://192.168.0.1 -w`.


It is very easy to customize, just use `internet-trace -h`.
Tip: I highly recommend using `--debug` option until you finished with params configuration.
