---
name: frontend-dev
description: 前端开发规范，包含 React 编码规范、UI 风格约束、TypeScript 规范等
version: v3.0
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/*.ts"
  - "**/*.js"
  - "**/*.css"
  - "**/*.scss"
  - "**/*.less"
  - "**/package.json"
  - "**/vite.config.*"
---

# 前端开发规范

> 参考来源: React 官方文档、Ant Design 最佳实践

---

## UI 风格约束

### 严格禁止（常见 AI 风格）

- ❌ 蓝紫色霓虹渐变、发光描边、玻璃拟态
- ❌ 大面积渐变、过多装饰性几何图形
- ❌ 赛博风、暗黑科技风、AI 风格 UI
- ❌ UI 文案中使用 emoji

### 后台系统（默认风格）

| 要素 | 要求 |
|------|------|
| 主题 | 使用 Ant Design 默认主题 |
| 配色 | 黑白灰为主 + 1 个主色点缀 |
| 动效 | 克制，仅保留必要交互反馈 |

---

## 技术栈

| 层级 | React（首选） | Vue（备选） |
|------|-------------|-------------|
| 框架 | React 18 + TypeScript | Vue 3 + TypeScript |
| 构建 | Vite | Vite |
| 路由 | React Router 6 | Vue Router 4 |
| 状态 | Zustand | Pinia |
| UI 库 | Ant Design | Element Plus |

---

## React 编码规范

### 组件基础

```tsx
// UserCard.tsx
import { useState, useEffect, useMemo, useCallback } from 'react'
import type { User } from '@/types'
import { Card, Button, Spin } from 'antd'

interface Props {
  userId: number
}

export function UserCard({ userId }: Props) {
  // 响应式状态
  const [loading, setLoading] = useState(false)
  const [user, setUser] = useState<User | null>(null)

  // 计算属性
  const displayName = useMemo(() => user?.name ?? '未知用户', [user])

  // 回调函数
  const handleRefresh = useCallback(async () => {
    setLoading(true)
    try {
      const data = await api.getUser(userId)
      setUser(data)
    } finally {
      setLoading(false)
    }
  }, [userId])

  // 生命周期
  useEffect(() => {
    handleRefresh()
  }, [handleRefresh])

  if (loading) return <Spin />

  return (
    <Card title={displayName}>
      <Button onClick={handleRefresh}>刷新</Button>
    </Card>
  )
}
```

### 命名约定

| 类型 | 约定 | 示例 |
|------|------|------|
| 组件文件 | PascalCase.tsx | `UserCard.tsx` |
| Hooks | useXxx.ts | `useAuth.ts` |
| Store | XxxStore.ts | `UserStore.ts` |

---

## 状态管理（Zustand）

```typescript
// stores/userStore.ts
import { create } from 'zustand'
import type { User } from '@/types'

interface UserState {
  user: User | null
  token: string
  isLoggedIn: boolean
  login: (username: string, password: string) => Promise<void>
}

export const useUserStore = create<UserState>((set) => ({
  user: null,
  token: '',
  isLoggedIn: false,

  async login(username: string, password: string) {
    const res = await api.login(username, password)
    set({ token: res.token, user: res.user, isLoggedIn: true })
  },
}))
```

---

## 交互状态处理

**必须处理的状态**: loading、empty、error、disabled、submitting

```tsx
if (loading) return <Spin />
if (error) return <Result status="error" title={error} extra={<Button onClick={retry}>重试</Button>} />
if (list.length === 0) return <Empty description="暂无数据" />

// 正常内容
```

---

## TypeScript 规范

```typescript
// types/user.ts
export interface User {
  id: number
  username: string
  role: 'admin' | 'user'
}

export interface ApiResponse<T = unknown> {
  code: number
  message: string
  data: T
}
```

---

## 性能优化

| 场景 | 方案 |
|------|------|
| 大列表 | 虚拟滚动 |
| 路由 | 懒加载 `() => import()` |
| 计算 | 使用 `useMemo` 缓存 |
| 大数据 | 使用 `useRef` |

```typescript
// 路由懒加载
const routes = [
  { path: '/dashboard', element: <Dashboard /> }
]

// 懒加载组件
const HeavyComponent = lazy(() => import('@/components/HeavyComponent'))
```

---

## 目录结构

```
src/
├── api/                 # API 请求
├── components/          # 通用组件
├── hooks/               # 自定义 Hooks
├── router/              # 路由配置
├── stores/              # Zustand stores
├── types/               # TypeScript 类型
├── utils/               # 工具函数
├── pages/               # 页面组件
├── App.tsx
└── main.tsx
```

---

## 详细参考

完整规范见 `references/frontend-style.md`，包含：
- 完整 UI 风格约束
- React 编码规范详解
- Zustand 状态管理
- API 请求封装
- 性能优化详解

---

> 📋 本回复遵循：`frontend-dev` - [具体章节]