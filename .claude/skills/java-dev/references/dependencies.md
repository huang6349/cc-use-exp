# 常用依赖

> 个人/团队约定的常用依赖配置

## 快速参考

```
<properties>
    <mybatis-flex.version>1.11.x</mybatis-flex.version>
    <hutool.version>5.8.x</hutool.version>
    <guava.version>32.1.x-jre</guava.version>
</properties>
```

| 依赖 | 版本 | 引入方式 |
|------|------|----------|
| MyBatis-Flex | 1.11.x | BOM + `mybatis-flex-spring-boot-starter` |
| Hutool | 5.8.x | BOM + `hutool-all` 或按需模块 |
| Guava | 32.1.2-jre | `guava` 或按需模块 |

---

## 引入方式

**BOM（推荐）** - 统一版本管理

```
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.xxx</groupId>
            <artifactId>xxx-bom</artifactId>
            <version>${xxx.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

**直接引入** - 无 BOM 时需指定版本

```
<dependency>
    <groupId>com.xxx</groupId>
    <artifactId>xxx-lib</artifactId>
</dependency>
```
