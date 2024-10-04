**Basic Response Check**

```cmd
curl -I https://example.com
```

**Measure Time Taken for the Request**

```cmd
curl -I -o /dev/null -s -w "Response Code: %{http_code}\nTime Taken: %{time_total} seconds\n" https://example.com
```

```cmd
curl -v https://example.com
```
