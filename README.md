# check release versions
* https://github.com/redis/redis/releases

# build image

```bash
export $(cat .env | xargs)
# build without cache to test new build parameters
docker build --no-cache --build-arg REDIS_VERSION=$REDIS_VERSION -t redis .
# build with cache
docker build --build-arg REDIS_VERSION=$REDIS_VERSION -t redis .

docker run --name redis --rm -p 6379:6379 -p 9121:9121 -v ./data:/data -v ./redis.conf:/etc/redis.conf redis
```

# image
```
REPOSITORY         TAG       IMAGE ID       CREATED             SIZE
redis              latest    f66e558e611f   4 seconds ago       52.1MB
```

# revs
* https://redis.io/docs/latest/operate/oss_and_stack/install/build-stack/debian-bookworm/

# non static build run errors
```
/usr/local/bin/redis-server: /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.32' not found (required by /usr/local/bin/redis-server)
/usr/local/bin/redis-server: /lib/x86_64-linux-gnu/libm.so.6: version `GLIBC_2.38' not found (required by /usr/local/bin/redis-server)
/usr/local/bin/redis-server: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.38' not found (required by /usr/local/bin/redis-server)
```

# non systemd-dev build run errors
```
/usr/local/bin/redis-server: error while loading shared libraries: libsystemd.so.0: cannot open shared object file: No such file or directory
```