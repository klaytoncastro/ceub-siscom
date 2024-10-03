$TTL 86400
@   IN  SOA ns1.exemplo.com. admin.exemplo.com. (
        2024093001  ; Serial
        3600        ; Refresh
        1800        ; Retry
        1209600     ; Expire
        86400 )     ; Minimum TTL

@   IN  NS  ns1.exemplo.com.
@   IN  A   192.168.0.2
www IN  A   192.168.0.3
ns1 IN  A   192.168.0.2
