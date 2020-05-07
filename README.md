# satis
php composer的satis docker

### 编译镜像
```
 docker build -t satis ./
```

### 运行docker
```
docker run  --name satis \
-v /your_satis_path/disk:/app/satis/web/disk/ \
-v /your_satis_path/config:/app/config/ \
--privileged=true \
-d satis
```

### 在satis里添加包(添加require部分)：
```
# 该功能是将项目composer.json中的require部分合并到satis.json里，需要指定satis.json,composer.json的位置
/app/composer-satis-builder/bin/merge-requirements 

vi /app/composer-satis-builder/bin/merge-requirements 

#! /bin/bash
php composer-satis-builder build ./satis.json ./composer.json --merge-requirements

#建议将satis.json,composer.json都放放在/app/config里
```

### 在satis里添加库(添加repositories部分，目前只支持git)：

```
/app/composer-satis-builder/bin/merge-requirements git||http://your-gitlab/xx/yy.git

# 同样需要指定satis.json,composer.json的位置
#! /bin/bash
php composer-satis-builder buil ./satis.json  --merge-repositories=$1
~
```



###  生成索引
```
/app/config/reBuildIndex
# 同样需要指定satis.json,composer.json的位置
```

### 其他
- 部分回源到github，可能需要输入账号密码，建议将id_rsa传到doker里~/.ssh下
- 依赖较多的包，比如laraval要运行很久，这是正常现象。
- 包索引文件较多时，php会报错，
```
Fatal error: Allowed memory size of 134217728 bytes exhausted (tried to allocate 4096 bytes)
```
在/app/satis/bin/satis 第3行下插入代码：
```
ini_set("memory_limit", -1);# docker里已经默认加上了这一步，如果被操作系统Killed,需要调小，一般2G比较合适
```
- 手动运行创建新的索引脚本，没有像其他docker那样加到crontab里。
- require-dev-dependencies=true时，会解析require-dev的包，有些应用包已经在github.com删除了，会导致建立索引失败，脚本自动退出（阿里云，腾讯云也有404的包)。
