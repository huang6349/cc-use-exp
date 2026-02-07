---
name: frontend-dev
description: 前端开发规范，包含 React 编码规范、UI 风格约束、TS/JS 规范等
version: v1.0.0
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/*.vue"
  - "**/*.ts"
  - "**/*.js"
  - "**/*.css"
  - "**/*.scss"
  - "**/*.less"
  - "**/package.json"
---

# 前端开发规范

> 参考来源: React 官方风格指南、Ant Design 最佳实践、个人/团队约定

---

## UI 风格约束

### 严格禁止（常见 AI 风格）

- ❌ 蓝紫色霓虹渐变背景、发光描边、玻璃拟态
- ❌ 大面积渐变、过多装饰性几何图形、无意义的动效堆叠
- ❌ UI 文案中使用 emoji
- ❌ 赛博风、暗黑科技风、AI 风格 UI

### 后台系统（默认风格）

| 要素 | 要求 |
|------|------|
| 主题 | 使用组件库默认主题 |
| 配色 | 黑白灰为主 + 1 个主色点缀 |
| 动效 | 克制，仅保留必要的交互反馈 |

---

## 技术栈

| 层级 | React（首选） | Vue（备选） |
|------|------|------|
| 框架 | React 18 + TS/JS | Vue 3 + TS/JS |
| 构建 | Umi | Vite |
| 路由 | React Router 6 | Vue Router 4 |
| 状态 | Valtio | Pinia |
| UI 库 | Ant Design | Element Plus |

---

## React 编码规范

### 组件基础

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

  // 6. 计算属性
  const displayName = useMemo(() => (
    user?.name ?? '未知用户'
  ), [user?.name]);

  // 7. 状态守卫
  if (loading) return <Spin />;
  return (<Card
    className={styles['card']}
    title={title}>
    <h3>{displayName}</h3>
    <Button onClick={handleDelete}>删除</Button>
  </Card>);
};

UserCard.defaultProps = {
  title: '用户信息',
};

export default UserCard;

// UserCard/index.scss
.card:global(.ant-card) {
  padding: 16px;
}

// UserCard/service.ts
import type { User } from '@/types';
import { safeRequest } from '@/utils';

export const queryById = (id: string) => id ? (
  safeRequest.Get<User>(`/api/user/${id}`)
) : null;

export const removeById = (id: string) => id ? (
  safeRequest.Delete<boolean>(`/api/user/${id}`)
) : null;

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
export type UserCardProps = {
  userId: string;
  title?: string;
  onDelete?: (id: string) => void;
};
```

### 命名约定

| 类型 | 约定 | 示例 |
|------|------|------|
| 组件文件 | `ComponentName/index.tsx` | `UserCard/index.tsx` |
| 样式文件 | `ComponentName/index.scss` | `UserCard/index.scss` |
| 状态文件 | `ComponentName/state.ts` | `UserCard/state.ts` |

---

## 状态管理（Valtio）

```
// ComponentName/state.ts
import { proxy } from 'valtio';

export type STATE = Record<string, any>;

export default proxy<STATE>({
  user: null,
});
```

---

## TS 规范

```
// components/SysButton/types.ts
import type { ComponentProps } from 'react';
import { Button } from 'antd';

export type SysButtonProps = ComponentProps<typeof Button> & {
  invisible?: boolean | (() => boolean);
};

// components/UserCard/types.ts
export type UserCardProps = {
  userId: string;
  title?: string;
  onDelete?: (id: string) => void;
};
```

---

## 性能优化

| 场景 | 方案 |
|------|------|
| 大列表 | 虚拟滚动 |
| 计算 | 精简依赖 |

---

## 目录结构

```
src/
├── assets/              # 静态资源
├── components/          # 通用组件
├── constants/           # 常量
├── hocs/                # 高阶组件
├── hofs/                # 高阶函数
├── hooks/               # Hooks
├── layouts/             # 布局组件
├── models/              # Valtio
├── pages/               # 页面
├── services/            # 服务层
├── utils/               # 工具函数
├── access.js
└── app.js
```

---

## 详细参考

完整规范见 `references/frontend-style.md`，包含：

- 完整 UI 风格约束
- React 编码规范详解
- Valtio 状态管理
- API 请求封装
- 性能优化详解

---

> 📋 本回复遵循：`frontend-dev` - [具体章节]
