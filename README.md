# satis
php composer的satis docker

### 编译镜像
```
 docker build -t satis ./
```

### 运行docker
```
docker run  --name satis \
-v /Users/lucklrj/docker/satis/disk:/app/satisfy/web/disk/ \
-v /Users/lucklrj/docker/satis/ssh:/root/.ssh \
-v /Users/lucklrj/docker/satis/satis.json:/app/satisfy/satis.json \
-p 80:80 \
-d satis:latest
```

### 在satisfy里添加包
https://xxx.com/admin

###  生成索引
```
/app/satisfy/bin/satis -v -n build /app/satisfy/satis.json /app/satisfy/web/
```

### 坑
- 依赖较多的包，比如laraval要运行很久，基本很难创建索引成功，只有不停的重试，碰运气。
- 包索引文件较多时，php会报错，
```
Fatal error: Allowed memory size of 134217728 bytes exhausted (tried to allocate 4096 bytes)
```
在/app/satisfy/bin/satis 第3行下插入代码：
```
ini_set("memory_limit", -1);
```
- 手动运行创建新的索引脚本，没有像其他docker那样加到crontab里（基本拉起很多重复任务直接造成资源消耗过多。系统卡死）。
- require-dev-dependencies=true时，会解析require-dev的包，有些应用包已经在github.com删除了，会导致建立索引失败，脚本自动退出。
