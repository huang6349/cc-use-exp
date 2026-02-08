# [项目名称] 项目配置

作者：huangyalong
版本：v1.0.0
日期：[当前日期]

<!--
使用说明：
1. 复制此文件到项目的 .claude/CLAUDE.md
2. 替换 [方括号] 中的内容
3. 删除不需要的章节
4. 删除所有注释
-->

---

## 项目概述

<!-- 一句话描述项目用途 -->

[项目名称] 是一个 [项目描述]。

---

## 技术栈

<!-- 根据实际技术栈修改 -->

| 层级 | 技术 | 版本 |
|------|------|------|
| 后端 | Java | x.x+ |
| Web 框架 | Spring Boot | x.x+ |
| ORM | MyBatis-Flex | x.x+ |
| 数据库 | MySQL/PostgreSQL | x.x |
| 前端框架 | React/Vue | x.x+ |
| 前端语言 | TS/JS | x.x+ |
| UI 组件库 | Ant Design/Element Plus | x.x+ |
| 构建工具 | Umi/Vite | x.x+ |

---

## 项目定制

<!-- 这是项目特定的约定，必须遵守 -->

### 开发约定

| 约定 | 说明 |
|------|------|
| 数据库迁移 | MyBatis-Flex/Flyway/手动 SQL |
| 注释风格 | 不使用行尾注释，注释单独成行 |
| 作者署名 | 所有文档和代码署名使用 huangyalong |

<!-- 添加其他项目特定约定 -->

### API 规范

<!-- 如果是后端项目，定义 API 规范 -->

**统一响应格式**：

```
// Java 示例
@Data
@Builder
@Schema(name = "响应信息")
public class ApiResponse<T> implements Serializable {

    @Schema(description = "响应状态")
    private Boolean success;

    @Schema(description = "响应数据")
    private T data;

    @Schema(description = "响应信息")
    private String message;

    @Schema(description = "响应代码")
    private Integer code;

    @Schema(description = "响应方式")
    private ShowType showType;

    @Schema(description = "异常描述")
    private String e;

    @Schema(description = "异常编号")
    private String traceId;

    @Schema(description = "主机地址")
    private String host;
}
```

**HTTP 状态码**：

| 状态码 | 说明 |
|------|------|
| 400 | 错误的请求 |
| 401 | 未授权 |
| 403 | 没有访问权限 |
| 404 | 没有获取到数据 |
| 500 | 服务器内部错误 |

**业务错误码**：

| 错误码 | 说明 |
|------|------|
| -1 | 操作失败 |
| 1001 | 系统繁忙 |
| 10000 | 业务异常 |
| 20000 | 参数错误 |

### 前端规范

<!-- 如果有前端，定义前端规范 -->

| 约定 | 说明 |
|------|------|
| UI 风格 | [Ant Design/Element Plus] 默认主题 |
| 设计原则 | 降低用户操作费力度，信息密度适中 |
| 避免 | 花哨装饰、渐变背景、复杂动效 |

---

## 与 Claude Code 协作

### 期望你主动做的

- ✅ 发现代码中的类型错误和潜在 Bug
- ✅ 提示更优雅的写法
- ✅ 补充缺失的异常处理和日志

### 不希望你做的

- ❌ 不要过度重构已经工作的代码
- ❌ 不要添加未要求的功能
- ❌ 不要主动创建文档文件（除非明确要求）

### 禁止事项

<!-- 根据项目情况添加 -->

- ❌ 不要直接操作生产数据库
- ❌ 不要在代码中硬编码敏感信息
