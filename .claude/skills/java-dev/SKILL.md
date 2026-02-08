---
name: java-dev
description: Java 开发规范，包含命名约定、异常处理、Spring Boot 最佳实践等
version: v1.0.0
paths:
  - "**/*.java"
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
---

# Java 开发规范

> 参考来源: Google Java Style Guide、阿里巴巴 Java 开发手册、个人/团队约定

**技术栈推荐**: Java 17 + Spring Boot 2.x（兼容 Java 8+）

---

## 工具链

```
# Maven
mvn clean compile                    # 编译
mvn test                             # 运行测试
mvn verify                           # 运行所有检查

# Gradle
./gradlew build                      # 构建
./gradlew test                       # 运行测试
```

---

## 命名约定

| 类型 | 规则 | 示例 |
|------|------|------|
| 包名 | 全小写，域名反转 | `com.example.project` |
| 类名 | 大驼峰，名词/名词短语 | `UserService`, `HttpClient` |
| 方法名 | 小驼峰，动词开头 | `findById`, `isValid` |
| 常量 | 全大写下划线分隔 | `MAX_RETRY_COUNT` |
| 布尔返回值 | is/has/can 前缀 | `isActive()`, `hasPermission()` |

---

## 类成员顺序

```
public class Example {

    // 1. 静态常量
    public static final String CONSTANT = "value";

    // 2. 静态变量
    private static Logger logger = LoggerFactory.getLogger(Example.class);

    // 3. 实例变量
    private Long id;

    // 4. 构造函数
    public Example() { }

    // 5. 静态方法
    public static Example create() { return new Example(); }

    // 6. 实例方法（公共）
    public void doSomething() { }

    // 7. 实例方法（私有）
    private void helperMethod() { }

    // 8. getter/setter（或使用 Lombok）
}
```

---

## 异常处理

```
// ✅ 好：捕获具体异常，添加上下文
try {
    user = userRepository.findById(id);
} catch (DataAccessException e) {
    throw new ServiceException("Failed to find user: " + id, e);
}

// ✅ 好：资源自动关闭
try (InputStream is = new FileInputStream(file)) {
    // 使用资源
}

// ❌ 差：捕获过宽
catch (Exception e) { e.printStackTrace(); }
```

---

## 空值处理

```
// ✅ 好：使用 Optional
public Optional<User> getById(Long id) {
    return getBaseService()
        .getById(id);
}

// ✅ 好：推荐使用 Hutool Validator 参数校验
public void update(User user) {
    Validator.validateNotNull(user, "user must not be null");
}

// ✅ 好：推荐使用 Hutool Opt 安全的空值处理
String name = Opt.ofNullable(user)
    .map(User::getName)
    .orElse("Unknown");
```

---

## 并发编程

```
// ✅ 好：推荐使用 Hutool ThreadUtil
ExecutorService executor = ThreadUtil.newExecutor(10);
Future<Result> future = executor.submit(() -> doWork());

// ✅ 好：使用 CompletableFuture
CompletableFuture<User> future = CompletableFuture
    .supplyAsync(() -> findUser(id))
    .thenApply(user -> enrichUser(user));

// ❌ 差：直接创建线程
new Thread(() -> doWork()).start();
```

---

## 测试规范 (JUnit 5)

```
record User(Long id, String name) { }

class UserServiceTest {

    @Test
    @DisplayName("根据编号查找用户 - 用户存在时返回用户")
    void getById_whenUserExists_returnsUser() {
        // given
        when(userService.getById(1L)).thenReturn(Optional.of(expected));

        // when
        Optional<User> result = userService.getById(1L);

        // then
        assertThat(result).isPresent();
        assertThat(result.get().name()).isEqualTo("test");
    }
}
```

---

## Spring Boot 规范

```
// ✅ 好：字段注入
@Getter
@Service
public class UserService {

    @Autowired
    private EmailService emailService;
}

// ✅ REST Controller
@Getter
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getById(@PathVariable Long id) {
        return getUserService()
            .getById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
}
```

---

## 性能优化

| 陷阱 | 解决方案 |
|------|------|
| N+1 查询 | 使用 JOIN FETCH 或批量查询 |
| 循环拼接字符串 | 使用 `StringBuilder` |
| 频繁装箱拆箱 | 使用原始类型流 |
| 未指定集合初始容量 | `new ArrayList<>(size)` |

---

## 日志规范

```
// ✅ 好：推荐使用 Hutool StaticLog 参数化日志
StaticLog.debug("Finding user by id: {}", userId);
StaticLog.info("User {} logged in successfully", username);
StaticLog.error("Failed to process order {}", orderId, exception);

// ❌ 差：字符串拼接
StaticLog.debug("Finding user by id: " + userId);
```

---

## 错误码规范

```
// ✅ 好：统一错误码枚举
throw new BusinessException(NOT_FOUND);
```

---

## 详细参考

| 文件 | 内容 |
|------|------|
| `references/java-style.md` | 命名约定、异常处理、Spring Boot、测试规范 |
| `references/dependencies.md` | 常用依赖（Hutool 等） |
| `references/error-code.md` | 错误码枚举（通用错误、请求错误、业务错误） |
| `references/collections.md` | 不可变集合（Guava）、字符串分割 |
| `references/concurrency.md` | 线程池配置、CompletableFuture 超时 |
| `references/code-patterns.md` | 卫语句、枚举优化、策略工厂模式 |

---

> 📋 本回复遵循：`java-dev` - [具体章节]
