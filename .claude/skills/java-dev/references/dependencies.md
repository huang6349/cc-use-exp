# 常用依赖

> 个人/团队约定的常用依赖配置

---

## 依赖配置模板

```
<!-- BOM 统一版本管理（推荐） -->
<properties>
    <xxx-lib.version>1.0.0</xxx-lib.version>
</properties>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.example</groupId>
            <artifactId>xxx-bom</artifactId>
            <version>${xxx-lib.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<dependencies>
    <dependency>
        <groupId>com.example</groupId>
        <artifactId>xxx-core</artifactId>  <!-- 无需指定版本 -->
    </dependency>
</dependencies>

<!-- 单模块引入（无 BOM 情况，需指定版本） -->
<dependency>
    <groupId>com.example</groupId>
    <artifactId>xxx-lib</artifactId>
    <version>1.0.0</version>
</dependency>
```

---

## Hutool（工具类库）

```
<dependency>
    <groupId>cn.hutool</groupId>
    <artifactId>hutool-all</artifactId>  <!-- 或按需引入 hutool-core、hutool-http 等 -->
</dependency>
```

**常用模块**：

| 模块 | 用途 |
|------|------|
| `hutool-core` | 核心工具（字符串、集合、日期、类型转换等） |
| `hutool-http` | HTTP 客户端（HttpRequest/HttpResponse） |
| `hutool-cron` | 定时任务（CronUtil） |
| `hutool-json` | JSON 解析（JSONUtil） |
| `hutool-crypto` | 加密解密（对称/非对称加密、摘要等） |
| `hutool-extra` | 扩展（模板引擎、邮件、Excel等） |
