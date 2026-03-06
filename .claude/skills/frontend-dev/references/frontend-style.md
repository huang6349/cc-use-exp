---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/*.vue"
  - "**/*.ts"
  - "**/*.js"
  - "**/*.css"
  - "**/*.scss"
  - "**/*.less"
  - "**/*.html"
  - "**/package.json"
---

# 前端开发与 UI 风格规范

作者：huangyalong
版本：v1.1.0
日期：2026-02-07
状态：草稿

> **部署位置**: `~/.claude/rules/frontend-style.md`
> **作用范围**: 前端/界面相关代码
> **参考来源**: React 官方风格指南、Ant Design 最佳实践、个人/团队约定

## 0. 适用原则

<!-- [注释] 仅在涉及前端/界面开发时遵循本规则 -->

- **仅在涉及前端/界面开发时遵循**本规则
- **默认使用框架/组件库的脚手架风格**: 不做"AI 设计稿"，不做大改主题色
- **技术栈优先级**: React > Vue；**业务代码默认 JS**，通用组件使用 TS

---

## 1. UI 视觉风格

<!-- [注释] 这是最重要的约束，防止 AI 生成"炫酷科技风" -->

### 1.1 严格禁止（常见 AI 风格）

- ❌ 蓝紫色霓虹渐变背景、发光描边、玻璃拟态（glassmorphism）
- ❌ 大面积渐变、过多装饰性几何图形、无意义的动效堆叠
- ❌ 随机生成的"科技感"插画/图标，或多套图标混用
- ❌ UI 文案中使用 emoji（除非产品明确要求）
- ❌ 赛博风、暗黑科技风、AI 风格 UI

### 1.2 后台/管理系统（默认风格）

<!-- [注释] 大多数情况下都是后台系统 -->

**目标**: "像一个成熟企业后台"，而不是宣传页

| 要素 | 要求 |
|------|------|
| 主题 | 使用组件库默认主题 + 默认布局 |
| 配色 | 黑白灰为主 + 1 个主色点缀，避免渐变 |
| 信息密度 | 适中，表格、筛选、分页、表单用标准组件 |
| 动效 | 克制，仅保留必要的交互反馈（hover/focus/loading） |

**可选风格**（保持一致，不要混搭）：

- Ant Design 默认风格（推荐）
- Element Plus 风格
- Naive UI 风格

### 1.3 前台宣传/官网（如需要）

**目标**: "简约、大气、留白足、排版高级"

- ✅ 大留白 + 清晰栅格 + 强排版层级
- ✅ 颜色克制: 白/浅灰背景 + 深色文字 + 少量强调色
- ✅ 轻量动效: 小范围的渐显/滚动过渡即可

### 1.4 不确定时先问

如果需求不明确，必须先问清楚：

1. 这是 **后台管理** 还是 **前台宣传**？
2. 期望风格是 **默认脚手架/企业后台/Apple 官网** 哪一种？
3. 是否已有品牌色/组件库/参考站点/设计稿？

---

## 2. 技术栈默认选择

<!-- [注释] 可根据实际项目调整 -->

### 2.1 React 技术栈（首选）

| 层级 | 选择 |
|------|------|
| 框架 | React 18 + TS/JS |
| 构建 | Umi |
| 路由 | React Router 6 |
| 状态管理 | Valtio |
| UI 组件库 | Ant Design |
| 数据请求 | Alova + Axios |

### 2.2 Vue 技术栈（备选）

| 层级 | 选择 |
|------|------|
| 框架 | Vue 3 + TS/JS |
| 构建 | Vite |
| 路由 | Vue Router 4 |
| 状态管理 | Pinia |
| UI 组件库 | Element Plus |
| 数据请求 | Alova + Axios |

---

## 3. React 编码规范

<!-- [注释] React Hooks 风格 -->

### 3.1 JS 优先原则

> **业务代码优先使用 `.js` 而非 `.jsx`**

| 类型 | 文件 | 说明 |
|------|------|------|
| 业务代码 | `.js` | 优先，更轻量，无需 Babel 转换配置 |
| 业务代码 | `.jsx` | ❌ 不推荐 |
| 通用组件 | `.tsx` | 需要类型定义，供其他模块复用 |

**原因**：

- `.js` 更轻量，无需额外配置
- `.jsx` 需要 Babel 转换，增加构建复杂度
- 通用组件需要类型定义，使用 `.tsx` 便于复用

### 3.2 组件基础

**必须使用 Hooks**:

```
// UserCard/index.tsx
import type { User } from '@/types';
import type { UserCardProps } from './types';
import { withResponse } from '@/hofs';
import { modal } from '@/hocs';
import { Button } from 'antd';
import { Card } from 'antd';
import { Spin } from 'antd';
import { useMemo } from 'react';
import { useRequest } from 'alova/client';
import { useSnapshot } from 'valtio';
import service from './service';
import state from './state';
import styles from './index.scss';

/**
 * 用户卡片组件
 * @description 展示用户信息并提供删除功能
 */
const UserCard = (
  props: UserCardProps,
) => {
  // 1. Props 解构
  const {
    userId,
    title,
    onDelete,
  } = props;

  // 2. 内部状态
  const {
    user,
  } = useSnapshot(state);

  // 3. 查询请求
  const {
    loading,
  } = useRequest(() => (
    service.queryById(userId)
  ), {
    immediate: !0,
  }).onSuccess(withResponse((data: User) => (
    state.user = data
  )));

  // 4. 删除请求
  const {
    send: removeById,
  } = useRequest(() => (
    service.removeById(userId)
  ), {
    immediate: !1,
  }).onSuccess(withResponse(() => (
    onDelete?.(userId)
  )));

  // 5. 事件处理函数
  const handleDelete = () => {
    modal?.confirm({
      content: '您确认要执行删除操作吗',
      title: '删除提示',
      onOk: () => {
        removeById();
      },
    });
  };

  // 6. 计算属性（useMemo）
  const displayName = useMemo(() => (
    user?.name ?? '未知用户'
  ), [user?.name]);

  // 7. 状态守卫（loading → 空状态 → 内容）
  if (loading) return <Spin />;
  return (<Card
    className={styles['card']}
    title={title}>
    <h3>{displayName}</h3>
    <Button onClick={handleDelete}>删除</Button>
  </Card>);
};

// 默认属性
UserCard.defaultProps = {
  title: '用户信息',
};

export default UserCard;

// UserCard/index.scss
// 使用 CSS Modules + :global 穿透 Ant Design 组件样式
.card:global(.ant-card) {
  padding: 16px;
}

// UserCard/service.ts
import type { User } from '@/types';
import { safeRequest } from '@/utils';

/** 根据编号查询用户 */
export const queryById = (id: string) => id ? (
  safeRequest.Get<User>(`/api/user/${id}`)
) : null;

/** 根据编号删除用户 */
export const removeById = (id: string) => id ? (
  safeRequest.Delete<boolean>(`/api/user/${id}`)
) : null;

/** 统一导出 */
export default {
  queryById,
  removeById,
};

// UserCard/state.ts
import { proxy } from 'valtio';

export type STATE = Record<string, any>;

export default proxy<STATE>({
  user: null,
});

// UserCard/types.ts
/** 用户卡片组件 Props */
export type UserCardProps = {
  /** 用户编号（必填） */
  userId: string;
  /** 卡片标题（可选，有默认值） */
  title?: string;
  /** 删除回调（可选） */
  onDelete?: (id: string) => void;
};
```

### 3.3 命名约定

| 类型 | 约定 | 示例 |
|------|------|------|
| 组件目录 | 可复用放 `components/`，页面放 `pages/xxx/components/` | |
| 组件文件 | `ComponentName/index.tsx` | `UserCard/index.tsx` |
| 样式文件 | `ComponentName/index.scss` | `UserCard/index.scss` |
| 请求文件 | `ComponentName/service.ts` | `UserCard/service.ts` |
| 状态文件 | `ComponentName/state.ts` | `UserCard/state.ts` |
| 类型文件 | `ComponentName/types.ts` | `UserCard/types.ts` |

### 3.4 组件组织

```
// 1. 导入：类别顺序 type → hofs → hocs → components → hooks → service → state → style
//         每类内部顺序：React → 第三方 → 项目内部
//         每个 import 只导入一个内容
// ComponentName/index.tsx
import type { User } from '@/types';
import type { UserCardProps } from './types';
import { withResponse } from '@/hofs';
import { modal } from '@/hocs';
import { Button } from 'antd';
import { Card } from 'antd';
import { Spin } from 'antd';
import { useMemo } from 'react';
import { useRequest } from 'alova/client';
import { useSnapshot } from 'valtio';
import service from './service';
import state from './state';
import styles from './index.scss';

// 2. 组件定义
const UserCard = (
  props: UserCardProps,
) => {
  // 3. Props 解构
  const {
    ...
  } = props;

  // 4. State & Hooks
  const {
    role,
    ...
  } = useSnapshot(state);

  const [data, setData] = useState<User>();

  // 5. 数据交互
  const {
    ...
  } = useRequest((...)) => (
    service.xxx(...)
  ), {
    ...
  }).onSuccess(withResponse((data: User) => {
    setData(data);
    ...
  }));

  // 6. 事件处理
  const handleDelete = () => {...};

  // 7. 计算属性（useMemo）
  const isAdmin = useMemo(() => (
    role === 'admin'
  ), [role]);

  // 8. 渲染输出
  return (<Card className={styles['card']}>
    ...
  </Card>);
};

// 9. 默认属性
UserCard.defaultProps = {
  ...
};

// 10. 统一导出
export default UserCard;
```

### 3.5 导入规范

```
// ✅ 好：每个 import 只导入一个内容
import { Button } from 'antd';
import { useMemo } from 'react';

// ❌ 差：一个 import 导入多个内容
import { Button, Card, Spin } from 'antd';
```

### 3.6 Props 规范

```
// ✅ 好：使用 TS 类型定义
// ComponentName/types.ts
export type UserCardProps = {
  /** 用户编号（必填） */
  userId: string;
  /** 卡片标题（可选，有默认值） */
  title?: string;
  /** 删除回调（可选） */
  onDelete?: (id: string) => void;
};

// ✅ 好：需要默认值时使用 defaultProps
// ComponentName/index.tsx
UserCard.defaultProps = {
  title: '用户信息',
};

// ❌ 差：避免使用解构默认值（除非有复杂逻辑处理）
// ComponentName/index.tsx
const {
  userId,
  title = '用户信息',
  onDelete,
} = props;
```

### 3.7 布尔值表示

```
// ✅ 好：使用 !0 / !1 表示 true / false
const config = {
  immediate: !0,     // 立即执行
  disabled: !1,      // 禁用
};

// ❌ 差：直接使用 true / false
const config = {
  immediate: true,
  disabled: false,
};
```

### 3.8 样式规范

```
// ✅ 好：使用 CSS Modules 防止样式污染
// ComponentName/index.tsx
import { Card } from 'antd';
import styles from './index.scss';

<Card className={styles['card']}>
  ...
</Card>

// ✅ 好：需要穿透组件库样式时
// ComponentName/index.scss
.card:global(.ant-card) {
  padding: 16px;
}

// ❌ 差：全局样式（除非确实需要）
// ComponentName/index.tsx
import './index.scss';
```

---

## 4. 状态管理（Valtio）

<!-- [注释] React 推荐使用 Valtio -->

### 4.1 State 定义

```
// ComponentName/state.ts
import { proxy } from 'valtio';

export type STATE = Record<string, any>;

export default proxy<STATE>({
  user: null,
});
```

### 4.2 在组件中使用

```
// ComponentName/index.tsx
import type { User } from '@/types';
import type { UserCardProps } from './types';
import { withResponse } from '@/hofs';
import { useRequest } from 'alova/client';
import { useSnapshot } from 'valtio';
import service from './service';
import state from './state';

const UserCard = (
  props: UserCardProps,
) => {
  // 1. State & Hooks
  const {
    ...
  } = useSnapshot(state);

  // 2. 数据请求
  const {
    ...
  } = useRequest((...)) => (
    service.xxx(...)
  ), {
    ...
  }).onSuccess(withResponse((data: User) => {
    state.user = data;
  }));
};
```

---

## 5. API 请求规范

<!-- [注释] 统一的 API 调用方式 -->

### 5.1 API 模块组织

```
// ComponentName/service.ts
import type { User } from '@/types';
import { safeRequest } from '@/utils';

/** 根据编号查询用户 */
export const queryById = (id: string) => id ? (
  safeRequest.Get<User>(`/api/user/${id}`)
) : null;

/** 根据编号删除用户 */
export const removeById = (id: string) => id ? (
  safeRequest.Delete<boolean>(`/api/user/${id}`)
) : null;

/** 统一导出 */
export default {
  queryById,
  removeById,
};
```

### 5.2 请求封装

```
// utils/safeRequest.ts
import { createAlova } from 'alova';
import { axiosRequestAdapter } from '@alova/adapter-axios';
import ReactHook from 'alova/react';
import { notification } from '@/components';
import { message } from '@/components';
import { delay } from '@/utils';
import { safeToken } from '@/utils';
import { TOKEN_NAME } from '@/constants';

const ERROR_MSG_NETWORK = '请求没有得到响应，请检查网络设置';

const safeRequest = createAlova({
  requestAdapter: axiosRequestAdapter(),
  statesHook: ReactHook,
  shareRequest: !1,
  cacheFor: null,
  timeout: 5000,
  async beforeRequest(method) {
    method.config.headers[TOKEN_NAME] = await safeToken.get();
  },
  responded: {
    async onSuccess(response) {
      try {
        const {
          headers,
          // @ts-ignore
          data: res,
        } = response;
        await delay(350);
        const token = headers?.[TOKEN_NAME];
        token && await safeToken.set(token);
        if (res?.code === 401)
          await safeToken.remove();
        if (!res?.success)
          errorThrower(res);
        const contentType = headers?.['content-type'];
        if (contentType?.includes?.('application/octet-stream'))
          downloadFile(headers, res);
        return res;
      } catch (error) {
        const {
          // @ts-ignore
          data: res,
        } = response;
        await errorHandler(error);
        return res;
      }
    },
    onError() {
      message?.error(ERROR_MSG_NETWORK);
    },
  },
});

const downloadFile = (headers: Record<string, any>, data: Blob) => {
  const contentDisposition = headers?.['content-disposition'];
  if (contentDisposition?.includes?.('filename=')) {
    // 提取文件名
    const filename = contentDisposition
      .split('filename=')[1]
      .split(';')[0]
      .replace(/['"]/g, '');
    if (!filename) return;
    // 创建下载链接
    const elink = document.createElement('a');
    elink.download = decodeURIComponent(filename); // 解码文件名
    elink.style.display = 'none';
    elink.href = URL.createObjectURL(data);
    document.body.appendChild(elink);
    elink.click();
    URL.revokeObjectURL(elink.href); // 释放 URL 对象
    document.body.removeChild(elink);
  }
};

enum ErrorShowType {
  SILENT = 0,
  WARN_MESSAGE = 1,
  ERROR_MESSAGE = 2,
  NOTIFICATION = 3,
  REDIRECT = 9,
}

const errorHandler = async (error: any) => {
  if (error.name === 'BizError') {
    if (error.info) {
      const {
        errorMessage,
        errorCode,
        showType,
      } = error.info;
      switch (showType) {
        case ErrorShowType.SILENT:
          break;
        case ErrorShowType.WARN_MESSAGE:
          message?.warning(errorMessage);
          break;
        case ErrorShowType.ERROR_MESSAGE:
          message?.error(errorMessage);
          break;
        case ErrorShowType.REDIRECT:
          break;
        case ErrorShowType.NOTIFICATION:
          notification?.error({
            description: errorMessage,
            message: errorCode,
          });
          break;
        default:
          message?.error(errorMessage);
      }
    }
  } else {
    message?.error(ERROR_MSG_NETWORK);
  }
};

const errorThrower = (res: any) => {
  const {
    success,
    data,
    message: errorMessage,
    code: errorCode,
    showType,
  } = res;
  if (success) return;
  const error: any = new Error(errorMessage);
  error.name = 'BizError';
  error.info = {
    data,
    errorMessage,
    errorCode,
    showType,
  };
  throw error;
};

export default safeRequest;
```

---

<!-- [注释] 业务代码用 JS，通用组件用 TS -->

### 6.1 语言选择原则

- 业务页面/组件：用 **JS**（快速开发，减少类型声明噪音）
- 通用组件：用 **TS**（强类型确保复用安全）
- 自定义 Hooks：用 **TS**（类型导出便于复用）
- 工具函数：用 **TS**（类型导出便于消费方）
- 使用 **TS** 时，禁止大范围使用 `any`

### 6.2 JS 业务代码示例

```
// pages/user/index.js
import { useRef } from 'react';
import { eq } from 'lodash-es';
import qs from 'query-string';
import { Divider } from 'antd';
import { TableDropdown } from '@ant-design/pro-components';
import { useAccess } from '@umijs/max';
import { useRequest } from 'alova/client';
import { history } from '@umijs/max';
import { withResponse } from '@/hofs';
import { withAuth } from '@/hocs';
import { modal } from '@/hocs';
import { SysContainer } from '@/components';
import { SysProTable } from '@/components';
import { SysButton } from '@/components';
import service from './service';
import columns from './columns';

const IndexPage = withAuth(() => {
  // State & Hooks
  const actionRef = useRef();
  const formRef = useRef();
  const access = useAccess();

  // 数据交互
  const {
    send: removeById,
  } = useRequest((id) => (
    service.removeById(id)
  ), {
    immediate: !1,
  }).onSuccess(withResponse(() => (
    actionRef?.current?.reload()
  )));

  // 事件处理
  const handleView = (record) => {
    history.push({
      pathname: `/system/user/view`,
      search: qs.stringify({
        id: record?.id,
      }),
    });
  };

  const handleCreate = () => (() => {
    history.push({
      pathname: `/system/user/create`,
      search: qs.stringify({}),
    });
  });

  const handleUpdate = (record) => (() => {
    history.push({
      pathname: `/system/user/update`,
      search: qs.stringify({
        id: record?.id,
      }),
    });
  });

  const handleDelete = (record) => (() => {
    modal?.confirm({
      content: '您确认要执行删除操作吗',
      title: '删除提示',
      onOk: () => (
        removeById(record?.id)
      ),
    });
  });

  // 渲染输出
  return (<SysContainer>
    <SysProTable
      rowKey='id'
      name='用户信息'
      request={service.dataPage()}
      scroll={{ x: 1300 }}
      cardBordered={!0}
      actionRef={actionRef}
      formRef={formRef}
      rowSelection={{}}
      columns={columns({
        title: '操作',
        width: 138,
        dataIndex: 'option',
        fixed: 'right',
        valueType: 'option',
        search: !1,
        hideInTable: !1,
        hideInDescriptions: !1,
        render: (_, record) => [
          <SysButton
            key='editable'
            type='link'
            onClick={handleUpdate(record)}
            disabled={!access?.$user$update}>
            编辑
          </SysButton>,
          <SysButton
            key='delete'
            type='link'
            onClick={handleDelete(record)}
            disabled={!access?.$user$delete}>
            删除
          </SysButton>,
          <Divider
            key='divider'
            type='vertical' />,
          <TableDropdown
            key={'action'}
            onSelect={(key) => {
              eq(key, 'view') && handleView(record);
            }}
            menus={[{
              key: 'view',
              name: '详情',
              disabled: !access?.$user$query,
            }]}
          />,
        ],
      })}
      toolBarRender={() => [
        <SysButton
          key='create'
          type='primary'
          onClick={handleCreate()}
          invisible={!access?.$user$create}>
          新建
        </SysButton>,
      ]} />
  </SysContainer>);
});

export default IndexPage;
```

### 6.3 TS 通用组件示例

```
// components/SysButton/index.tsx
import type { SysButtonProps } from './types';
import { isFunction } from 'lodash-es';
import { Button } from 'antd';
import { useMemo } from 'react';

// 组件定义
const SysButton = (
  props: SysButtonProps,
) => {
  // Props 解构
  const {
    className,
    invisible,
    ...buttonProps
  } = props;

  // 计算属性
  const hidden = useMemo(() => {
    if (isFunction(invisible)) {
      return invisible();
    } else return invisible;
  }, [invisible]);

  // 渲染输出
  if (hidden)
    return null;
  return (<Button
    className={className}
    {...buttonProps}
  />);
};

// 默认属性
SysButton.defaultProps = {
  invisible: !1,
};

// 统一导出
export default SysButton;

// components/SysButton/types.ts
import type { ComponentProps } from 'react';
import { Button } from 'antd';

export type SysButtonProps = ComponentProps<typeof Button> & {
  invisible?: boolean | (() => boolean);
};
```

### 6.4 类型定义位置

```
src/
├── components/
│   └── ComponentName/
│       └── types.ts    # 组件专用类型
├── types/
│   ├── index.ts        # 统一导出
│   ├── user.ts         # 用户相关类型
│   └── site.ts         # 站点相关类型
```

### 6.5 类型定义示例

```
// components/SysButton/types.ts
import type { ComponentProps } from 'react';
import { Button } from 'antd';

export type SysButtonProps = ComponentProps<typeof Button> & {
  invisible?: boolean | (() => boolean);
};

// components/UserCard/types.ts
/** 用户卡片组件 Props */
export type UserCardProps = {
  /** 用户编号（必填） */
  userId: string;
  /** 卡片标题（可选，有默认值） */
  title?: string;
  /** 删除回调（可选） */
  onDelete?: (id: string) => void;
};
```

---

## 7. 目录结构

```
web/
├── config/                     # 项目配置
├── dist/                       # 构建产物
├── mock/                       # Mock
├── src/
│   ├── assets/                 # 静态资源
│   ├── components/             # 通用组件
│   │   ├── index.ts
│   │   ├── SysProTable/        # 业务通用表格
│   │   └── SysForm/            # 业务通用表单
│   ├── constants/              # 常量
│   ├── hocs/                   # 高阶组件
│   │   ├── index.ts
│   │   ├── withAuth.tsx        # 权限控制
│   │   └── withApp.tsx         # 应用级注入
│   ├── hofs/                   # 高阶函数
│   │   ├── index.ts
│   │   ├── withTable.ts        # 表格增强
│   │   └── withResponse.ts     # 响应处理
│   ├── hooks/                  # Hooks
│   │   ├── index.ts
│   │   └── useAsyncEffect.ts
│   ├── layouts/                # 布局组件
│   ├── models/                 # Valtio
│   ├── pages/                  # 页面
│   │   ├── index.js
│   │   ├── login/
│   │   └── system/
│   ├── services/               # 服务层
│   │   ├── index.js
│   │   ├── user.js
│   │   └── dict.js
│   ├── utils/                  # 工具函数
│   │   ├── index.ts            # 统一导出
│   │   ├── safeToken.ts        # Token
│   │   └── safeRequest.ts      # 统一请求
│   ├── access.js               # 权限配置
│   ├── app.js                  # 应用配置
│   ├── global.scss             # 全局样式
│   └── overrides.scss          # 样式覆盖
├── .env
├── jsconfig.json
├── package.json
├── tsconfig.json
└── typings.d.ts
```

---

## 8. 性能优化

<!-- [注释] 先写正确的代码，再优化性能 -->

### 核心原则

| 原则 | 说明 |
|------|------|
| **先正确后优化** | 先确保功能正确，再考虑性能 |
| **先测量后优化** | 用 DevTools 定位瓶颈 |
| **用户感知优先** | 优化用户能感知到的性能问题 |

### 组件渲染优化

```
import { memo } from 'react';
import { useMemo } from 'react';

// ✅ 好：使用 useMemo 缓存计算结果
const filteredList = useMemo(() => (
  list.filter(item => item?.active)
), [list]);

// ✅ 好：使用 memo 避免重渲染
const ExpensiveComponent = ({ data }) => {
  // ...
};

export default memo(ExpensiveComponent);
```

### 懒加载

```
// ✅ 好：条件懒加载（仅在需要时加载）
{showHeavy && <HeavyComponent />}
```

### 避免常见陷阱

| 陷阱 | 解决方案 |
|------|------|
| 大列表直接渲染 | 使用虚拟滚动 |
| 频繁触发重计算 | 精简依赖数组 |
| 未使用 key 或 key 不稳定 | 使用唯一稳定的 key |
| 依赖对象/数组引用 | 提取具体属性作为依赖 |
| 未取消的请求/定时器 | 在 `useEffect` 中清理 |

### 性能分析工具

```
# Chrome DevTools
- Performance 面板：录制运行时性能
- Lighthouse：整体性能评分
- React DevTools：组件渲染性能
```

---

## 参考资料

- [React 官方文档](https://react.dev/)
- [React Hooks](https://react.dev/reference/react/hooks/)
- [Ant Design](https://ant.design/)
- [Valtio](https://valtio.dev/)
- [TS 官方文档](https://www.typescriptlang.org/)

---

## 规则溯源

```
> 📋 本回复遵循：`frontend-dev/frontend-style.md` - [具体章节]
```
