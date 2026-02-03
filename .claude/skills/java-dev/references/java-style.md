# Java 开发规范

作者：huangyalong
版本：v1.0.0
日期：2026-01-30
状态：草稿

> **部署位置**: `~/.claude/rules/java-style.md`
> **作用范围**: 所有 Java 项目
> **参考来源**: Google Java Style Guide、阿里巴巴 Java 开发手册、个人/团队约定

---
paths:

- "**/*.java"
- "**/pom.xml"
- "**/build.gradle"
- "**/build.gradle.kts"

---

## 工具链

<!-- [注释] 可根据项目调整，如使用 Checkstyle、SpotBugs 等 -->

- 格式化: IDE 内置格式化（遵循 Google Java Style 或团队规范）
- 静态检查: SpotBugs、PMD、Checkstyle
- 构建工具: Maven 或 Gradle
- 测试: JUnit 5 + Mockito
- Java: 17+（推荐 17 LTS，兼容 Java 8+）

```bash
# Maven 常用命令
mvn clean compile                    # 编译
mvn test                             # 运行测试
mvn verify                           # 运行所有检查
mvn spotbugs:check                   # SpotBugs 检查

# Gradle 常用命令
./gradlew build                      # 构建
./gradlew test                       # 运行测试
./gradlew check                      # 运行所有检查
```

## 命名约定

<!-- [注释] 遵循 Java 社区通用规范 -->

### 包命名

- 全部小写，用域名反转: `com.example.project`
- 单词间不用分隔符

```
// ✅ 好
package com.qiandao.service;
package org.example.util;

// ❌ 差
package com.qianDao.Service;    // 不要用大写
package com.qian_dao.service;   // 不要用下划线
```

### 类命名

- 大驼峰（PascalCase）: `UserService`、`HttpClient`
- 类名应是名词或名词短语
- 接口名可用形容词: `Runnable`、`Comparable`

```
// ✅ 好
public class UserService { }
public class HttpRequestHandler { }
public interface Serializable { }

// ❌ 差
public class userService { }    // 应大写开头
public class Do_Something { }   // 不要用下划线
```

### 方法命名

- 小驼峰（camelCase）: `getUserById`、`isValid`
- 动词或动词短语开头
- 布尔返回值用 `is`/`has`/`can` 前缀

```
// ✅ 好
public User getById(Long id) { }
public boolean isActive() { }
public boolean hasPermission(String role) { }

// ❌ 差
public User FindById(Long id) { }    // 应小写开头
public boolean active() { }          // 布尔值应用 is 前缀
```

### 变量命名

- 小驼峰: `userId`、`orderList`
- 常量全大写下划线分隔: `MAX_RETRY_COUNT`
- 避免单字符命名（循环变量除外）

```
// ✅ 好
private Long userId;
private List<Order> orderList;
public static final int MAX_RETRY_COUNT = 3;

// ❌ 差
private Long UserId;              // 应小写开头
private List<Order> ol;           // 名称不清晰
public static final int maxRetry; // 常量应全大写
```

### 泛型类型参数

- 单个大写字母: `T`（类型）、`E`（元素）、`K`（键）、`V`（值）、`N`（数字）

```
// ✅ 好
public class Box<T> { }
public interface Map<K, V> { }
public <E> List<E> filterList(List<E> list, Predicate<E> predicate) { }
```

## 代码组织

### 类成员顺序

<!-- [注释] 建议顺序，可根据团队习惯调整 -->

```
public class Example {

    // 1. 静态常量
    public static final String CONSTANT = "value";

    // 2. 静态变量
    private static Logger logger = LoggerFactory.getLogger(Example.class);

    // 3. 实例变量（按访问级别：public → protected → package → private）
    private Long id;
    private String name;

    // 4. 构造函数
    public Example() { }

    public Example(Long id) { this.id = id; }

    // 5. 静态方法
    public static Example create() { return new Example(); }

    // 6. 实例方法（公共）
    public void doSomething() { }

    // 7. 实例方法（私有）
    private void helperMethod() { }

    // 8. getter/setter（放最后或使用 Lombok）
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
}
```

### import 规范

- 不使用通配符 `import *`（IDE 自动管理除外）
- 静态导入单独分组
- 按字母顺序排列

```
// ✅ 好
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.qiandao.model.User;

import static org.junit.jupiter.api.Assertions.assertEquals;
```

### 项目结构（Maven 标准）

<!-- [注释] 遵循 Maven 约定优于配置 -->

```
project/                                   # 父模块根目录
├── {module}/                              # 子模块
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/example/project/
│   │   │   │       ├── configs/           # 配置类
│   │   │   │       ├── domain/            # 实体类
│   │   │   │       ├── enums/             # 枚举类
│   │   │   │       ├── request/           # 请求参数 (DTO、BO、Query)
│   │   │   │       ├── response/          # VO
│   │   │   │       ├── service/           # 服务接口
│   │   │   │       │   └── impl/          # 服务实现
│   │   │   │       ├── util/              # 工具类
│   │   │   │       └── web/               # 控制器
│   │   │   └── resources/
│   │   │       ├── application.yml        # 公共配置
│   │   │       ├── application-local.yml  # 本地环境
│   │   │       ├── application-dev.yml    # 开发环境
│   │   │       ├── application-prod.yml   # 生产环境
│   │   │       └── application-*.yml      # 其他环境
│   │   └── test/
│   │       ├── java/
│   │       └── resources/
│   │           └── application-test.yml
│   └── pom.xml                            # 子模块 pom.xml
└── pom.xml                                # 父模块 pom.xml
```

### 常用依赖

> 常用依赖见 `dependencies.md`

## 异常处理

<!-- [注释] 异常处理是 Java 开发的重点 -->

### 基本原则

- 优先使用标准异常
- 不要捕获 `Exception` 或 `Throwable`（除非在最顶层）
- 不要忽略异常（空 catch 块）
- 异常信息要有意义

```
// ✅ 好：捕获具体异常，添加上下文
try {
    var user = userService.getById(id);
} catch (DataAccessException e) {
    throw new ServiceException("Failed to find user: " + id, e);
}

// ✅ 好：资源自动关闭
try (var is = new FileInputStream(file)) {
    // 使用资源
}

// ❌ 差：捕获过宽
try {
    doSomething();
} catch (Exception e) {  // 太宽泛
    e.printStackTrace(); // 不要用 printStackTrace
}

// ❌ 差：忽略异常
try {
    doSomething();
} catch (IOException e) {
    // 空的 catch 块，异常被吞掉
}
```

### 自定义异常

- 业务异常继承 `RuntimeException`
- 必须提供有意义的消息

```
// ✅ 好：使用 Lombok 简化异常类
@Getter
public class BusinessException extends RuntimeException {

    private final Integer errorCode;

    public BusinessException(Integer errorCode,
                             String message) {
        super(message);
        this.errorCode = errorCode;
    }
}
```

## 空值处理

<!-- [注释] NPE 是 Java 最常见的错误，需特别注意 -->

### 基本原则

- 推荐使用 Hutool `Opt` 表示可能为空的返回值
- 推荐使用 Hutool `Validator` 简化校验
- 参数校验放在方法开头

```
// ✅ 好：推荐使用 Hutool Opt 安全的空值处理
var name = Opt.ofNullable(user)
    .map(User::getName)
    .get();

// ✅ 好：使用 Optional
public Optional<User> getById(Long id) {
    return getBaseService()
            .getById(id);
}

// ✅ 好：推荐使用 Hutool Validator 参数校验
public void create(User user) {
    Validator.validateNotNull(user, "user must not be null");
    Validator.validateNotNull(user.getId(), "user.id must not be null");
    // ...
}

// ✅ 好：参数校验
public void update(User user) {
    Objects.requireNonNull(user, "user must not be null");
    Objects.requireNonNull(user.getId(), "user.id must not be null");
    // ...
}

// ✅ 好：安全的空值处理（Java Optional）
var name = Optional.ofNullable(user)
    .map(User::getName)
    .orElse("Unknown");

// ❌ 差：返回 null 表示"没找到"
public User getById(Long id) {
    return getBaseService()
            .getById(id)
            .orElse(null);  // 调用方容易忘记判空
}
```

## 注释规范

<!-- [注释] Javadoc 是 Java 文档的标准方式 -->

### Javadoc

- 所有公共 API 必须有 Javadoc
- 描述"做什么"而非"怎么做"

```
/**
 * Finds a user by their unique identifier.
 *
 * @param id the user's unique identifier, must not be null
 * @return an Optional containing the user if found, empty otherwise
 * @throws IllegalArgumentException if id is null
 */
public Optional<User> getById(Long id) {
    // ...
}
```

### 行内注释

- 解释"为什么"而非"是什么"
- 避免废话注释

```
// ✅ 好：解释原因
// 使用同步块而非 ConcurrentHashMap，因为需要原子地检查并更新多个字段
synchronized (lock) {
    // ...
}

// ❌ 差：废话注释
// 获取用户 ID
var userId = user.getId();  // 代码已经很清楚了
```

## 并发编程

<!-- [注释] Java 并发是复杂话题，以下是基本原则 -->

### 基本原则

- 推荐使用 Hutool `ThreadUtil` 简化线程操作
- 使用高层并发工具（`ExecutorService`、`CompletableFuture`）
- 避免直接使用 `Thread`、`wait/notify`
- 使用线程安全的集合（`ConcurrentHashMap`、`CopyOnWriteArrayList`）

```
// ✅ 好：推荐使用 Hutool ThreadUtil
var executor = ThreadUtil.newExecutor(10);
var future = executor.submit(() -> doWork());

// ✅ 好：使用 Hutool 异步执行
ThreadUtil.execAsync(() -> doWork());

// ✅ 好：使用 ExecutorService
var executor = Executors.newFixedThreadPool(10);
var future = executor.submit(() -> doWork());

// ✅ 好：使用 CompletableFuture
var future = CompletableFuture
    .supplyAsync(() -> findUser(id))
    .thenApply(user -> enrichUser(user));

// ❌ 差：直接创建线程
new Thread(() -> doWork()).start();  // 没有生命周期管理
```

### 线程安全

- 优先使用不可变对象
- 使用 `@ThreadSafe`、`@NotThreadSafe` 注解标记（如果项目引入了 JSR-305）

```
// ✅ 不可变对象是线程安全的（Java 17 推荐使用 record）
public record User(Long id, String name) { }

// ❌ 差：传统 POJO 需要手动保证不可变性
@Data
public class User {

    private final Long id;

    private final String name;
}
```

## 测试规范

<!-- [注释] 使用 JUnit 5 + Mockito -->

### 测试方法命名

- 描述测试场景和预期结果
- 使用 `@DisplayName` 提供可读描述

```
record User(Long id, String name) { }

class UserServiceTest {

    @Test
    @DisplayName("根据编号查找用户 - 用户存在时返回用户")
    void getById_whenUserExists_returnsUser() {
        // given
        var userId = 1L;
        var expected = new User(userId, "test");
        when(userService.getById(userId)).thenReturn(Optional.of(expected));

        // when
        var result = userService.getById(userId);

        // then
        assertThat(result).isPresent();
        assertThat(result.get().name()).isEqualTo("test");
    }

    @Test
    @DisplayName("根据编号查找用户 - 用户不存在时返回空")
    void getById_whenUserNotExists_returnsEmpty() {
        // given
        when(userService.getById(anyLong())).thenReturn(Optional.empty());

        // when
        var result = userService.getById(999L);

        // then
        assertThat(result).isEmpty();
    }
}
```

### 测试结构

- 使用 Given-When-Then 或 Arrange-Act-Assert 模式
- 每个测试只验证一个行为

```
@Test
void createOrder_withValidData_createsAndReturnsOrder() {
    // Given (Arrange)
    var request = new OrderRequest(/* ... */);
    when(productService.checkStock(anyLong())).thenReturn(true);

    // When (Act)
    var result = orderService.createOrder(request);

    // Then (Assert)
    assertThat(result).isNotNull();
    assertThat(result.getStatus()).isEqualTo(OrderStatus.CREATED);
    verify(orderService).save(any(Order.class));
}
```

## 日志规范

<!-- [注释] 使用 Hutool StaticLog + Logback/Log4j2 -->

### 基本原则

- 使用 Hutool `StaticLog` 简化日志调用（底层基于 SLF4J）
- 使用参数化日志，避免字符串拼接
- 选择合适的日志级别

```
// ✅ 好：推荐使用 Hutool StaticLog 参数化日志
StaticLog.debug("Finding user by id: {}", userId);
StaticLog.info("User {} logged in successfully", username);
StaticLog.warn("Failed to send email to {}, will retry", email);
StaticLog.error("Failed to process order {}", orderId, exception);

// ❌ 差：字符串拼接（即使不输出也会执行拼接）
StaticLog.debug("Finding user by id: " + userId);
```

### 日志级别

- `ERROR`: 系统错误，需要立即关注
- `WARN`: 警告，可能的问题
- `INFO`: 重要业务事件
- `DEBUG`: 调试信息
- `TRACE`: 详细追踪信息

## Spring 相关规范

<!-- [注释] 如果项目使用 Spring，以下是补充规范 -->

### 依赖注入

- 优先使用字段注入，简洁直观（团队偏好）
- 需要时使用 `@Autowired`
- 需要时使用 Lombok `@RequiredArgsConstructor` 简化

```
// ✅ 好：字段注入
@Getter
@Service
public class UserService {

    @Autowired
    private EmailService emailService;
}

// ✅ 好：构造函数注入
@Service
@RequiredArgsConstructor
public class UserService {

    private final EmailService emailService;

    // 不需要 @Autowired，Spring 4.3+ 自动注入
}
```

### REST Controller

- 使用 `@RestController` 而非 `@Controller` + `@ResponseBody`
- 路径使用小写和斜杠: `/api/user/profiles`

```
@Getter
@RestController
@RequestMapping("/api/user/profiles")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public ResponseEntity<UserDto> getById(@PathVariable Long id) {
        return getUserService()
            .getById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<UserDto> create(@Valid @RequestBody CreateUserRequest request) {
        var created = getUserService().create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}
```

## 性能考虑

<!-- [注释] 先写正确的代码，再优化性能 -->

### 核心原则

| 原则 | 说明 |
|------|------|
| **先正确后优化** | 先确保功能正确，再考虑性能 |
| **先测量后优化** | 用 JProfiler/VisualVM 定位瓶颈 |
| **避免过早优化** | 可读性优先，除非有明确的性能需求 |

### 数据库查询优化

```
// ✅ 好：使用 JOIN FETCH 或 Relations 注解
@Select("SELECT u FROM User u LEFT JOIN FETCH u.orders")
List<User> getAllWithOrders();

// ✅ 好：使用 Relations 注解
var users = userService.getMapper()
    .selectAllWithRelations();

// ✅ 好：批量查询
var userIds = users.stream()
    .map(User::getId)
    .toList();
var orders = orderService.getByUserIdIn(userIds);
var orderMap = orders.stream().collect(Collectors.groupingBy(Order::getUserId));

// ❌ 差：N+1 查询问题
var users = userService.list();
for (var user : users) {
    var query = new QueryWrapper();
    query.where(USER.ID.eq(user.getId()));
    var orders = orderService.list(query);
}
```

### 集合与 Stream 优化

```
// ✅ 选择合适的集合类型
var users = new ArrayList<User>(expectedSize);   // 预分配容量
var unique = new HashSet<String>(expectedSize);  // O(1) 查找
var userMap = new HashMap<Long, User>(expectedSize);

// ❌ 差：多次遍历
var count = list.stream().filter(x -> x > 0).count();
var filtered = list.stream().filter(x -> x > 0).toList();

// ✅ 好：单次遍历收集多个结果
record Stats(long count, List<Integer> filtered) {}
var stats = list.stream()
    .filter(x -> x > 0)
    .collect(Collectors.teeing(
        Collectors.counting(),
        Collectors.toList(),
        Stats::new
    ));

// ❌ 差：频繁装箱拆箱
var numbers = ...;
var sum = numbers.stream()
        .mapToInt(Integer::intValue)
        .sum();

// ✅ 好：使用原始类型流
var numbers = ...;
var sum = Arrays.stream(numbers).sum();
```

### 字符串处理

```
// ✅ 好：使用 推荐 Hutool StrUtil
var result = StrUtil.join(",", strings);

// ✅ 好：使用 StringBuilder
var sb = new StringBuilder(estimatedSize);
for (var s : strings) {
    sb.append(s);
}
var result = sb.toString();

// ✅ 好：使用 String.join 或 Collectors.joining
var result = String.join(",", strings);
var result = strings.stream().collect(Collectors.joining(","));

// ❌ 差：循环拼接字符串
var result = "";
for (var s : strings) {
    result += s;  // 每次创建新对象
}
```

### 连接池配置

```yaml
# HikariCP 推荐配置
spring.datasource:
  hikari:
    maximum-pool-size: 10          # CPU 核心数 * 2
    minimum-idle: 5
    idle-timeout: 300000           # 5 分钟
    connection-timeout: 20000      # 20 秒
    max-lifetime: 1200000          # 20 分钟
```

### 避免常见陷阱

| 陷阱 | 解决方案 |
|------|----------|
| N+1 查询 | 使用 JOIN FETCH 或批量查询 |
| 循环中拼接字符串 | 使用 `StringBuilder` |
| 频繁装箱拆箱 | 使用原始类型或原始类型流 |
| 未指定集合初始容量 | `new ArrayList<>(size)` |
| 同步方法粒度过大 | 缩小同步块范围 |
| 未关闭资源 | 使用 try-with-resources |

### 性能分析工具

```bash
# JVM 参数（开发环境）
-XX:+PrintGCDetails -XX:+PrintGCTimeStamps

# 使用 VisualVM 或 JProfiler 进行分析
# 或使用 async-profiler
./profiler.sh -d 30 -f profile.html <pid>
```

## 规则溯源要求

当回复明确受到本规则约束时，在回复末尾声明：

```
> 📋 本回复遵循规则：`java-style.md` - [具体章节]
```

---

## 参考资料

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [阿里巴巴 Java 开发手册](https://github.com/alibaba/p3c)
- [Effective Java (3rd Edition)](https://www.oreilly.com/library/view/effective-java/9780134686097/)
- [Spring Boot Best Practices](https://docs.spring.io/spring-boot/docs/current/reference/html/)
