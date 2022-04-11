# caddy-docker with webdav

```
https://www.example.com {
    webdav {
        root /path
    }
    tls /path/ssl.crt /path/ssl.key
    
    # caddy hash-password
    basicauth {
        bai ......
    }
}
```

