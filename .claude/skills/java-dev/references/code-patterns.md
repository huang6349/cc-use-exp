# 代码模式与重构

> 消除 if/else 嵌套，提高代码可读性

---

## 卫语句（Guard Clause）

提前处理异常/边界情况并 return，减少嵌套层级。

```
// ❌ 嵌套过深
public void process(User user) {
    if (user != null) {
        if (user.isActive()) {
            if (user.hasPermission()) {
                // 业务逻辑...
            }
        }
    }
}

// ✅ 卫语句：提前 return
public void process(User user) {
    if (user == null) return;
    if (!user.isActive()) return;
    if (!user.hasPermission()) return;

    // 业务逻辑...
}
```

**适用场景**：参数校验、权限检查、状态判断

---

## 枚举替代多分支

用枚举封装 code 与 message 的映射关系。

```
// ❌ 冗长的 if/else
public String getMessage(int code) {
    if (code == 1) return "成功";
    else if (code == -1) return "失败";
    else if (code == -2) return "超时";
    else return "未知";
}

// ✅ 枚举封装
public enum ResultCode {
    SUCCESS(1, "成功"),
    FAIL(-1, "失败"),
    TIMEOUT(-2, "超时");

    private final int code;
    private final String message;

    ResultCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public static String getMessage(int code) {
        return Arrays.stream(values())
            .filter(e -> e.code == code)
            .findFirst()
            .map(e -> e.message)
            .orElse("未知");
    }
}
```

**适用场景**：状态码、错误码、类型映射

---

## 策略 + 工厂模式

消除业务分支，支持扩展。

```
// 1. 定义策略接口
public interface PayStrategy {
    
    void pay();
}

// 2. 实现具体策略（每个类自注册）
@Service
public class AliPay implements PayStrategy {
    
    @PostConstruct
    public void init() {
        PayFactory.register("ali", this);
    }

    @Override
    public void pay() {
        System.out.println("支付宝支付");
    }
}

// 3. 工厂类
public class PayFactory {
    
    private static final Map<String, PayStrategy> STRATEGIES = new HashMap<>();

    public static void register(String code, PayStrategy strategy) {
        STRATEGIES.put(code, strategy);
    }

    public static PayStrategy get(String code) {
        return STRATEGIES.get(code);
    }
}

// 4. 调用
PayFactory.get("ali").pay();
```

**适用场景**：支付方式、消息处理、导出格式等多实现场景

---

## Random 重用

避免每次创建新实例。

```
// ❌ 每次创建新实例
public void doSomething() {
    val rand = new Random();  // 低效，可能非随机
    val value = rand.nextInt();
}

// ✅ 重用实例
private static final Random RANDOM = new SecureRandom();

public void doSomething() {
    val value = RANDOM.nextInt();
}

// ✅ 多线程场景
val value = ThreadLocalRandom.current().nextInt();
```

| 场景 | 推荐 |
|------|------|
| 单线程 | `SecureRandom` 实例重用 |
| 多线程 | `ThreadLocalRandom.current()` |

---

## 选择原则

```
简单分支（2-3个）？
├─ 是 → 保持 if/else 或三目运算符
└─ 否 → 分支有业务含义？
         ├─ 是（如状态码）→ 枚举
         └─ 否（如策略选择）→ 策略+工厂
```

**警惕过度设计**：简单的 if/else 不需要设计模式。

---

## 规则溯源

```
> 📋 本回复遵循：`java-dev/code-patterns.md` - [具体章节]
```
