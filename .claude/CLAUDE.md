# Claude Code 用户配置

版本：v1.0.0
作者：huangyalong
更新：2026-01-30

---

## 个人身份

全栈开发者，主要技术栈：Java、React + TS/JS、MySQL/PostgreSQL

---

## 沟通风格

| 原则 | 说明 |
|------|------|
| 简洁优先 | 直接切入要点，避免冗长铺垫 |
| 代码优先 | 少说多做，用代码说话 |
| 结构化 | 使用标题、列表、代码块组织信息 |
| 中英混合 | 技术术语保留英文，说明用中文 |

---

## 技术栈偏好

| 场景 | 首选 | 备选 |
|------|------|------|
| 后端 | Java | - |
| 前端 | React 18 + Ant Design | Vue 3 + Element Plus |
| 数据库 | MySQL | PostgreSQL |
| 缓存 | Redis | - |

---

## 核心约束

> 详细规则见 `rules/claude-code-defensive.md`

**必须做的**：

- 发现类型错误和潜在 Bug
- 提示更优雅的写法
- 补充缺失的异常处理

**禁止做的**：

- 过度重构已工作的代码
- 添加未要求的功能
- 修改测试来匹配错误代码
- 主动创建文档文件

---

## 工作流程

> 详细流程见 `rules/claude-code-defensive.md`

```
简单任务: 直接实现
复杂任务: 先说明计划 → 确认后实现
排查问题: 复现 → 假设 → 验证 → 最小修复
```

**复杂任务定义**：涉及 3+ 文件、修改架构、多模块交互

---

## 决策原则

```
简单方案 > 复杂方案
复用现有 > 创建新的
直接实现 > 抽象封装
先测量 > 后优化
```

---

## 规则溯源

回复受规则、技能或使用 LSP 时，在末尾分开声明：

| 类型 | 格式 |
|------|------|
| Rule | `> 📋 本回复遵循：`claude-code-defensive.md` - [章节]` |
| Skill | `> 📋 本回复遵循：`java-dev` - [章节]` |
| LSP | `> 🔍 LSP: `jdtls` - Find References` |

---

## 配置结构

```
~/.claude/
├── CLAUDE.md          # 核心配置
├── rules/             # 始终加载的规则
│   ├── bash-style.md
│   ├── claude-code-defensive.md
│   └── ...
├── skills/            # 按需加载的技能
│   ├── frontend-dev/
│   ├── java-dev/
│   └── ...
└── commands/          # 用户命令
    ├── code-review.md
    ├── design-*.md
    └── ...
```
