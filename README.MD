# SpringBoot 测试样板工程

## 用途

- Docker环境测试
- CICD测试
- Java环境测试
- 端口、端口转发测试



## 用法

默认暴露端口：8080

健康检查路径：`/actuator/beans`、`/actuator/info`

**请求样例**

```
 GET http://localhost:8080/actuator/info
```

返回结果

```json
{
    "app": {
        "author": "F嘉阳",
        "encoding": "UTF-8"
    }
}
```



## 样例接口

**请求URL：**

```
GET/POST/PUT/DELETE  http://localhost:8080/print/{content}
```

**参数：** 

| 参数名  | 类型 | 必选 | 内容 | 说明     |
| :------ | ---- | :--- | :--- | -------- |
| content | 字符 | 否   | info | 输出内容 |

**请求样例**

```
http://localhost:8080/print/info
```



**返回示例**

```json
hello , info
```

