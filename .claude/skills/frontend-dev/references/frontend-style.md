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
  - "**/vite.config.*"
---

# 前端开发与 UI 风格规范

作者：huangyalong
版本：v1.0.0
日期：2026-02-06
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
|---|---|
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
|---|---|
| 框架 | React 18 + TS/JS |
| 构建 | Umi |
| 路由 | React Router 6 |
| 状态管理 | Valtio |
| UI 组件库 | Ant Design |
| 数据请求 | Alova + Axios |

### 2.2 Vue 技术栈（备选）

| 层级 | 选择 |
|---|---|
| 框架 | Vue 3 + TS/JS |
| 构建 | Vite |
| 路由 | Vue Router 4 |
| 状态管理 | Pinia |
| UI 组件库 | Element Plus |
| 数据请求 | Alova + Axios |

---

## 3. React 编码规范

<!-- [注释] React Hooks 风格 -->

### 3.1 组件基础

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

### 3.2 命名约定

| 类型 | 约定 | 示例 |
|---|---|---|
| 组件目录 | 可复用放 `components/`，页面放 `pages/xxx/components/` | |
| 组件文件 | `ComponentName/index.tsx` | `UserCard/index.tsx` |
| 样式文件 | `ComponentName/index.scss` | `UserCard/index.scss` |
| 请求文件 | `ComponentName/service.ts` | `UserCard/service.ts` |
| 状态文件 | `ComponentName/state.ts` | `UserCard/state.ts` |
| 类型文件 | `ComponentName/types.ts` | `UserCard/types.ts` |

### 3.3 组件组织

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

### 3.4 Props 规范

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

### 3.5 样式规范

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
  // 1. Props 解构
  const {
    ...
  } = props;

  // 2. State & Hooks
  const {
    role,
    ...
  } = useSnapshot(state);

  // 3. 数据请求
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

### 4.2 在组件中使用

```
import { userState, login, logout } from '@/stores/userStore'
import { useSnapshot } from 'valtio'

function UserInfo() {
  // ✅ 好：使用 useSnapshot 订阅状态
  const snap = useSnapshot(userState)

  // ✅ 好：直接访问状态
  const { user, isLoggedIn } = snap
}
```

---

## 5. API 请求规范

<!-- [注释] 统一的 API 调用方式 -->

### 5.1 API 模块组织

```
// api/index.ts - 统一导出
export * from './user'
export * from './site'

// api/user.ts - 用户相关 API
import request from '@/utils/request'
import type { User, LoginParams, LoginResult } from '@/types'

export function login(params: LoginParams): Promise<LoginResult> {
  return request.post('/api/v1/login', params)
}

export function getUserInfo(): Promise<User> {
  return request.get('/api/v1/user/info')
}

export function updateUser(id: number, data: Partial<User>): Promise<User> {
  return request.put(`/api/v1/users/${id}`, data)
}
```

### 5.2 请求封装

```
// utils/request.ts
import axios from 'axios'
import { message } from 'antd'
import { userState } from '@/stores/userStore'

const request = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  timeout: 10000
})

// 请求拦截
request.interceptors.request.use(config => {
  if (userState.token) {
    config.headers.Authorization = `Bearer ${userState.token}`
  }
  return config
})

// 响应拦截
request.interceptors.response.use(
  response => {
    const { code, message: msg, data } = response.data
    if (code === 0) {
      return data
    }
    message.error(msg || '请求失败')
    return Promise.reject(new Error(msg))
  },
  error => {
    message.error(error.message || '网络错误')
    return Promise.reject(error)
  }
)

export default request
```

---

## 6. 交互状态规范

<!-- [注释] 完整的交互状态是用户体验的基础 -->

### 6.1 必须处理的状态

| 状态 | 说明 | 示例 |
|---|---|---|
| loading | 加载中 | Spin、Skeleton |
| empty | 空数据 | Empty 组件 |
| error | 错误 | Result + 重试按钮 |
| disabled | 禁用 | Button disabled |
| submitting | 提交中 | Button loading + 防重复 |

### 6.2 示例实现

```
function UserList() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [list, setList] = useState<Item[]>([])

  async function fetchData() {
    setLoading(true)
    setError('')
    try {
      const data = await api.getList()
      setList(data)
    } catch (e) {
      setError(e.message || '加载失败')
    } finally {
      setLoading(false)
    }
  }

  // 加载状态
  if (loading) return <Spin />

  // 错误状态
  if (error) return (
    <Result
      status="error"
      title={error}
      extra={<Button onClick={fetchData}>重试</Button>}
    />
  )

  // 空状态
  if (list.length === 0) return <Empty description="暂无数据" />

  // 正常内容
  return (
    <List
      dataSource={list}
      renderItem={item => <List.Item>{item.name}</List.Item>}
    />
  )
}
```

---

## 7. JS 和 TS 使用规范

<!-- [注释] 业务代码用 JS，通用组件用 TS -->

### 7.1 语言选择原则

| 场景 | 语言 | 说明 |
|---|---|---|
| 业务页面/组件 | **JS** | 快速开发，减少类型声明噪音 |
| 通用组件/Hooks | **TS** | 强类型确保复用安全 |
| 工具函数库 | TS | 类型导出便于消费方 |

### 7.2 JS 业务代码示例

```
// pages/user/UserList.js
import { useState, useEffect } from 'react'
import { Table, Button, message } from 'antd'

export function UserList() {
  const [loading, setLoading] = useState(false)
  const [users, setUsers] = useState([])

  const loadUsers = async () => {
    setLoading(true)
    try {
      const data = await api.getUsers()
      setUsers(data)
    } catch (e) {
      message.error('加载失败')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadUsers()
  }, [])

  return (
    <Table
      loading={loading}
      dataSource={users}
      columns={[
        { title: '姓名', dataIndex: 'name' },
        { title: '邮箱', dataIndex: 'email' },
      ]}
    />
  )
}
```

### 7.3 TS 通用组件示例

```
// components/Form/BaseForm.tsx
import { useCallback } from 'react'
import type { FormProps } from 'antd'

interface BaseFormProps<T = Record<string, unknown>> {
  initialValues?: T
  onSubmit: (values: T) => Promise<void>
}

export function BaseForm<T extends Record<string, unknown>>({
  initialValues,
  onSubmit,
}: BaseFormProps<T>) {
  const handleSubmit = useCallback(async (values: T) => {
    await onSubmit(values)
  }, [onSubmit])

  return <Form initialValues={initialValues} onFinish={handleSubmit} />
}
```

### 7.4 类型定义位置

```
src/
├── types/
│   ├── index.ts        # 统一导出
│   ├── user.ts         # 用户相关类型
│   ├── site.ts         # 站点相关类型
│   └── api.ts          # API 通用类型
```

### 7.5 类型定义示例

```
// types/user.ts
export interface User {
  id: number
  username: string
  email: string
  role: 'admin' | 'user'
  createdAt: string
}

export interface LoginParams {
  username: string
  password: string
}

export interface LoginResult {
  token: string
  user: User
}

// types/api.ts
export interface ApiResponse<T = unknown> {
  code: number
  message: string
  data: T
}

export interface PageParams {
  page: number
  pageSize: number
}

export interface PageResult<T> {
  list: T[]
  total: number
}
```

---

## 8. 目录结构

<!-- [注释] 推荐的前端项目结构 -->

```
web/
├── src/
│   ├── api/                 # API 请求模块
│   │   ├── index.ts
│   │   ├── user.ts
│   │   └── site.ts
│   ├── assets/              # 静态资源
│   │   ├── images/
│   │   └── styles/
│   ├── components/          # 通用组件
│   │   ├── common/         # 基础通用组件
│   │   └── business/       # 业务通用组件
│   ├── hooks/               # 自定义 Hooks
│   │   ├── useAuth.ts
│   │   └── useTable.ts
│   ├── layouts/             # 布局组件
│   │   └── DefaultLayout.tsx
│   ├── router/              # 路由配置
│   │   └── index.tsx
│   ├── stores/              # Valtio stores
│   │   ├── index.ts
│   │   └── userStore.ts
│   ├── types/               # TS 类型
│   │   └── index.ts
│   ├── utils/               # 工具函数
│   │   ├── request.ts
│   │   └── format.ts
│   ├── pages/               # 页面组件
│   │   ├── home/
│   │   └── user/
│   ├── App.tsx
│   └── main.tsx
├── index.html
├── package.json
├── tsconfig.json
└── vite.config.ts
```

---

## 9. 代码检查工具

<!-- [注释] 可根据项目实际配置调整 -->

### 9.1 推荐配置

```
npm install -D eslint prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

### 9.2 常用命令

```
npm run lint          # 代码检查
npm run lint:fix      # 自动修复
npm run format        # 格式化
```

---

## 10. 性能优化

<!-- [注释] 先写正确的代码，再优化性能 -->

### 核心原则

| 原则 | 说明 |
|---|---|
| **先正确后优化** | 先确保功能正确，再考虑性能 |
| **先测量后优化** | 用 DevTools 定位瓶颈 |
| **用户感知优先** | 优化用户能感知到的性能问题 |

### 组件渲染优化

```
import { useMemo, useCallback, memo } from 'react'

// ✅ 使用 useMemo 缓存计算结果
const filteredList = useMemo(() =>
  list.filter(item => item.active)
, [list])

// ✅ 使用 useCallback 稳定函数引用
const handleClick = useCallback(() => {
  // ...
}, [deps])

// ✅ 使用 memo 避免不必要的重渲染
export const ExpensiveComponent = memo(({ data }) => {
  // ...
})
```

### 列表渲染优化

```
import { FixedSizeList } from 'react-window'

// ✅ 大列表使用虚拟滚动
<FixedSizeList
  height={400}
  itemCount={1000}
  itemSize={50}
  width="100%"
>
  {Row}
/FixedSizeList>

// ❌ 避免：大列表直接渲染
{list.map(item => <div key={item.id}>{item.name}</div>)}
```

### 懒加载

```
import { lazy, Suspense } from 'react'

// ✅ 路由懒加载
const routes = [
  {
    path: '/dashboard',
    element: <Dashboard />
  }
]

// ✅ 组件懒加载
const HeavyComponent = lazy(() => import('@/components/HeavyComponent'))

// ✅ Suspense 包裹
<Suspense fallback={<Spin />}>
  <HeavyComponent />
</Suspense>

// ✅ 条件懒加载（仅在需要时加载）
{showHeavy && <HeavyComponent />}
```

### 网络请求优化

```
// ✅ 请求防抖
import { useDebounceCallback } from 'antd/es/input/hooks'

const debouncedSearch = useDebounceCallback((keyword: string) => {
  api.search(keyword)
}, 300)

// ✅ Alova 缓存
import { useRequest } from 'alova'

const { data } = useRequest(
  () => api.getUser(id),
  {
    localCache: 5 * 60 * 1000, // 5 分钟缓存
  }
)
```

### 打包优化

```
// vite.config.ts
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          'vendor': ['react', 'react-router', 'zustand'],
          'antd': ['antd'],
        }
      }
    }
  }
})
```

### 避免常见陷阱

| 陷阱 | 解决方案 |
|---|---|
| 大列表直接渲染 | 使用虚拟滚动 |
| 频繁触发计算 | 检查 useMemo 依赖 |
| key 不稳定 | 使用唯一稳定的 key |
| 监听整个对象 | 使用 useMemo 替代 |
| 未取消的请求 | useEffect 中返回清理函数 |

### 性能分析工具

```
# Chrome DevTools
# - Performance 面板：录制运行时性能
# - Lighthouse：整体性能评分
# - React DevTools：组件渲染性能

# 打包分析
npm install -D rollup-plugin-visualizer
```

---

## 规则溯源要求

当回复明确受到本规则约束时，在回复末尾声明：

```
> 📋 本回复遵循规则：`frontend-style.md` - [具体章节]
```

示例：

```
> 📋 本回复遵循规则：`frontend-style.md` - UI 视觉风格
> 📋 本回复遵循规则：`frontend-style.md` - React 编码规范
```

---

## 参考资料

- [React 官方文档](https://react.dev/)
- [React Hooks](https://react.dev/reference/react)
- [Ant Design](https://ant.design/)
- [Valtio](https://valtio.pmnd.rs/)
- [TS 官方文档](https://www.typescriptlang.org/)
