# 响应结构

> 个人/团队约定的响应结构

---

## 快速参考

```
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

    @JsonIgnore
    @Schema(description = "是否执行默认操作", hidden = true)
    private Boolean defExec;

    public static <T> ApiResponse<T> okDef() {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .defExec(Boolean.TRUE)
                .build();
    }

    public static <T> ApiResponse<T> okDef(T data) {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .data(data)
                .defExec(Boolean.TRUE)
                .build();
    }

    public static <T> ApiResponse<T> okDef(T data,
                                           String message) {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .data(data)
                .message(message)
                .showType(WARN_MESSAGE)
                .defExec(Boolean.TRUE)
                .build();
    }

    public static <T> ApiResponse<T> okDef(T data,
                                           String message,
                                           ShowType showType) {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .data(data)
                .message(message)
                .showType(showType)
                .defExec(Boolean.TRUE)
                .build();
    }

    public static <T> ApiResponse<T> ok() {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .defExec(Boolean.FALSE)
                .build();
    }

    public static <T> ApiResponse<T> ok(T data) {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .data(data)
                .defExec(Boolean.FALSE)
                .build();
    }

    public static <T> ApiResponse<T> ok(T data,
                                        String message) {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .data(data)
                .message(message)
                .showType(WARN_MESSAGE)
                .defExec(Boolean.FALSE)
                .build();
    }

    public static <T> ApiResponse<T> ok(T data,
                                        String message,
                                        ShowType showType) {
        return ApiResponse.<T>builder()
                .success(Boolean.TRUE)
                .data(data)
                .message(message)
                .showType(showType)
                .defExec(Boolean.FALSE)
                .build();
    }

    public static <T> ApiResponse<T> fail(String message,
                                          Integer code,
                                          String e) {
        return ApiResponse.<T>builder()
                .success(Boolean.FALSE)
                .message(message)
                .code(code)
                .showType(ERROR_MESSAGE)
                .e(e)
                .defExec(Boolean.FALSE)
                .build();
    }

    public static <T> ApiResponse<T> fail(String message,
                                          Integer code,
                                          String e,
                                          ShowType showType) {
        return ApiResponse.<T>builder()
                .success(Boolean.FALSE)
                .message(message)
                .code(code)
                .showType(showType)
                .e(e)
                .defExec(Boolean.FALSE)
                .build();
    }

    public static <T> ApiResponse<T> fail(String message,
                                          Integer code,
                                          String e,
                                          String traceId,
                                          String host) {
        return ApiResponse.<T>builder()
                .success(Boolean.FALSE)
                .message(message)
                .code(code)
                .showType(ERROR_MESSAGE)
                .e(e)
                .traceId(traceId)
                .host(host)
                .defExec(Boolean.FALSE)
                .build();
    }

    public static <T> ApiResponse<T> fail(String message,
                                          Integer code,
                                          String e,
                                          ShowType showType,
                                          String traceId,
                                          String host) {
        return ApiResponse.<T>builder()
                .success(Boolean.FALSE)
                .message(message)
                .code(code)
                .showType(showType)
                .e(e)
                .traceId(traceId)
                .host(host)
                .defExec(Boolean.FALSE)
                .build();
    }
}
```

---

## 使用示例

```
public ApiResponse<QueryWrapper> handlerQuery(UserQueries queries) {
    var data = getBaseService()
        .getQueryWrapper(queries);
    return ApiResponse.ok(data);
}

public ApiResponse<Mono<Boolean>> handlerSave(UserBO userBO) {
    var data = getBaseService()
        .add(userBO);
    return ApiResponse.ok(data);
}

public ApiResponse<Mono<Boolean>> handlerUpdate(UserBO userBO) {
    var data = getBaseService()
        .update(userBO);
    return ApiResponse.ok(data);
}

public ApiResponse<Mono<Boolean>> handlerDelete(Long id) {
    var data = getBaseService()
        .delete(id);
    return ApiResponse.ok(data);
}
```

---

## 规则溯源

```
> 📋 本回复遵循：`java-dev/response.md` - [具体章节]
```
