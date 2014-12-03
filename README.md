This project is an example of how to use `folsom` and `folsom-cowboy` to export metrics from your apps to whatever can collect them using HTTP.

This example starts a single `gen_server`, which periodically increments 3 counters.

Their value can be queried using HTTP:

```
curl http://192.168.x.y:5566/_metrics
["coucou1","coucou2","coucou3"]
```

```
curl http://192.168.x.y:5566/_metrics/coucou1
{"value":10}
```

IP binding and port number is configured in `rel/files/sys.config.`
