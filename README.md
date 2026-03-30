<div align="center">

# AI 编码助手配置中心

<!-- 封面图 -->
<img src="./cover.svg" alt="AI 编码助手配置中心" width="100%" style="max-width: 800px" />

> 让 Claude Code 开箱即用的配置模板
>
> 按费力度从低到高，用最少操作获得最大帮助

[![version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/doccker/cc-use-exp)
[![license](https://img.shields.io/badge/license-Custom-green.svg)](./LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Config-orange.svg)](https://docs.anthropic.com/claude-code)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/doccker/cc-use-exp/pulls)

</div>

---

<details>
<summary><strong>📑 目录导航</strong></summary>

- [项目定位](#项目定位)
- [快速部署](#快速部署)
- [快速开始](#快速开始)
- [常见场景速查](#常见场景速查)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [目录结构](#目录结构)
- [开发指南](#开发指南)
- [部署方法](#部署方法)
- [版本记录](#版本记录)
- [参考资料](#参考资料)
- [社区与支持](#社区与支持)
- [许可声明](#许可声明)

</details>

---

## 项目定位

本项目用于 Claude Code 配置的开发与维护。

- **配置仓库**：配置开发/维护环境，不参与实际业务开发
- **用户目录**：实际生效的配置位置（~/.claude/）
- **项目配置**：配置目录为空，自动使用用户目录配置

---

## 快速部署

### 一键同步（推荐）

**macOS/Linux**：

```
./sync-config.sh
```

**Windows**：

```
sync-config.bat
```

脚本会自动将 `.claude/` 同步到用户根目录（`~/.claude/`），文件冲突时提供以下选项：

| 选项 | 按键 | 说明 |
|------|------|------|
| 覆盖当前文件 | `y` | 仅覆盖这一个 |
| 跳过当前文件 | `N` 或回车 | 默认，仅跳过这一个 |
| 全部覆盖 | `a` | 后续所有文件都覆盖 |
| 全部跳过 | `s` | 后续所有文件都跳过 |

### 手动部署

<details>
<summary><strong>Claude Code</strong></summary>

```
# 只覆盖配置目录，保留历史记录
rm -rf ~/.claude/rules ~/.claude/skills ~/.claude/commands ~/.claude/templates ~/.claude/tasks
cp -r .claude/rules ~/.claude/
cp -r .claude/skills ~/.claude/
cp -r .claude/commands ~/.claude/
cp -r .claude/templates ~/.claude/
cp -r .claude/tasks ~/.claude/
cp .claude/CLAUDE.md ~/.claude/
```

</details>

> **注意**：Claude Code 的 `~/.claude/` 包含历史记录（`history.jsonl`、`projects/` 等），不能整体删除，只覆盖配置目录。

---

## 快速开始

### 零费力（自动生效）- Rules

**你需要做什么：什么都不用做**

这些规则始终自动加载，在后台默默保护你：

| 规则 | 作用 | 触发场景 |
|------|------|---------|
| `claude-code-defensive.md` | 防止测试篡改、过度工程化、中途放弃 | 始终生效 |
| `ops-safety.md` | 危险命令确认、回滚方案、风险提示 | 始终生效（详细规范见 skills） |
| `doc-sync.md` | 配置/结构变更时提醒更新文档 | 修改配置时 |
| `bash-style.md` | Bash 核心规范：禁止行尾注释 | 始终生效（详细规范见 skills） |
| `file-size-limit.md` | 单文件行数上限控制（Java 300行、TSX 200行等） | 操作 .java/.tsx/.vue/.ts/.js 时 |

**效果示例**：

- Claude 不会修改测试来适配错误代码
- 执行 `sysctl` 等危险命令前会提示风险和回滚方案
- 新增命令后会提醒你更新 README

### 低费力（自动触发）- Skills

**你需要做什么：正常写代码**

操作相关文件时自动加载对应的开发规范：

| 技能 | 触发条件 | 提供的帮助 |
|------|---------|-----------|
| `java-dev` | 操作 `.java` 文件 | 命名约定、异常处理、Spring 规范、不可变集合、线程池、代码模式 |
| `frontend-dev` | 操作 `.tsx/.ts/.js/.scss/.css` 等 | UI 风格约束、React/Vue 规范、TS/JS |
| `bash-style` | 操作 `.sh/Dockerfile/Makefile/.md` 等 | 注释规范、tee 写入、heredoc、脚本规范 |
| `ops-safety` | 执行系统命令、服务器运维 | 风险说明、回滚方案、问题排查原则 |

**效果示例**：

- 写 Java 服务时，自动遵循 Spring Boot 规范
- 不操作这些文件时，不消耗额外 token

### 中费力（显式调用）- Commands

**你需要做什么：输入 `/命令名`**

#### 高频命令（日常使用）

| 命令 | 用途 | 使用示例 |
|------|------|---------|
| `/fix` | 快速修复 Bug | `/fix 登录接口返回 500` |
| `/review quick` | 快速审查（git diff + 简要意见） | `/review quick` |
| `/review` | 正式代码审查 | `/review` |
| `/debug` | 复杂问题排查（复现→假设→验证→修复） | `/debug 定时任务不执行` |
| `/commit-msg` | 生成 git commit message | `/commit-msg` 或 `/commit-msg all` |

#### 中频命令（按需使用）

| 命令 | 用途 | 使用示例 |
|------|------|---------|
| `/review security` | 安全审查当前分支代码 | `/review security` |
| `/new-feature` | 新功能全流程（需求→设计→实现） | `/new-feature 用户导出功能` |
| `/design-doc` | 生成技术设计文档框架 | `/design-doc 用户权限模块` |
| `/requirement-doc` | 生成需求文档框架 | `/requirement-doc 报表功能` |

#### 低频命令（特定场景）

| 命令 | 用途 | 使用示例 |
|------|------|---------|
| `/requirement-interrogate` | 需求极刑审问，挖掘逻辑漏洞 | `/requirement-interrogate 用户要导出数据` |
| `/design-checklist` | 生成设计质量检查清单 | `/design-checklist` |
| `/style-extract` | 从代码或设计图提取样式变量 | `/style-extract` |
| `/status` | 显示当前配置状态（Rules/Skills/LSP） | `/status` |

---

## 常见场景速查

| 场景 | 推荐方式 | 费力度 |
|------|---------|--------|
| 日常写代码 | 直接写，Rules + Skills 自动生效 | ⭐ |
| 修个小 Bug | `/fix 问题描述` | ⭐⭐ |
| 提交前快速看看 | `/review quick` | ⭐⭐ |
| 生成 commit message | `/commit-msg` | ⭐⭐ |
| 正式代码审查 | `/review` | ⭐⭐ |
| 复杂 Bug 排查 | `/debug 问题描述` | ⭐⭐⭐ |
| 安全审查 | `/review security` | ⭐⭐⭐ |
| 开发新功能 | `/new-feature 功能名` | ⭐⭐⭐ |

```
遇到 Bug？
├─ 简单 Bug → /fix 问题描述
└─ 复杂 Bug → /debug 问题描述

代码审查？
├─ 快速看看 → /review quick
├─ 正式审查 → /review
└─ 安全审查 → /review security

新功能？
├─ 完整流程 → /new-feature 功能名
└─ 只要设计 → /design-doc 模块名
```

---

## 最佳实践

### 让自动化为你工作

- **不要干预 Rules**：它们在后台保护你，比如防止 Claude 修改测试
- **不要手动加载 Skills**：操作相关文件时自动生效
- **相信防御机制**：复杂任务会自动要求确认计划后再执行

### 避免的做法

- ❌ 不要绕过 Rules 的保护机制
- ❌ 不要在简单任务上使用复杂命令
- ❌ 不要忽略文档同步提醒

---

## 常见问题

### Q: 为什么 Claude 总是先说明计划再执行？

A: 这是 `claude-code-defensive.md` 规则的要求。复杂任务（超过 3 个步骤或涉及多个文件）必须先说明计划，等你确认后再执行。这是为了防止
Claude 盲目修改代码。

### Q: 为什么执行系统命令时 Claude 会问很多问题？

A: 这是 `ops-safety.md` 规则的要求。危险命令（如 sysctl、iptables）必须说明影响范围、风险等级和回滚方案。这是为了防止误操作导致系统故障。

### Q: 为什么 Claude 提醒我更新文档？

A: 这是 `doc-sync.md` 规则的要求。当你修改了配置（commands/skills/rules）或项目结构时，会提醒你同步更新相关文档，保持文档与代码一致。

### Q: 如何添加新的语言支持？

A: 在 `.claude/skills/` 下创建新目录（如 `rust-dev/`），添加 `SKILL.md` 文件定义触发条件和规范内容，然后更新本文档。

---

## 目录结构

```
.claude/
├── CLAUDE.md                     # 核心配置：身份、偏好、技术栈
├── rules/                        # 规则：始终加载（精简版）
│   ├── claude-code-defensive.md  # 防御性规则
│   ├── ops-safety.md             # 运维安全（核心）
│   ├── doc-sync.md               # 文档同步
│   └── bash-style.md             # Bash 核心规范
├── skills/                       # 技能：按需加载（完整版）
│   ├── java-dev/
│   ├── frontend-dev/
│   ├── bash-style/               # Bash 完整规范
│   └── ops-safety/               # 运维安全完整规范
└── commands/                     # 命令：显式调用
    ├── fix.md
    ├── review.md
    ├── debug.md
    ├── status.md
    └── ...
```

### 核心概念

| 类型 | 加载时机 | 触发方式 | 适用场景 |
|------|---------|---------|---------|
| **Rules** | 始终加载 | 自动生效 | 核心约束、防御规则 |
| **Skills** | 按需加载 | 根据文件类型自动触发 | 语言规范、领域知识 |
| **Commands** | 调用时加载 | 用户输入 `/命令名` | 明确的工作流任务 |

### Rules 与 Skills 的关键区别

> **重要**：Rules 的 `paths` frontmatter 只是语义提示，**不影响加载**。

| 特性 | Rules | Skills |
|------|-------|--------|
| 加载时机 | 每次对话启动时**全部加载** | 启动时仅加载名称和描述 |
| 内容加载 | 完整内容立即加载 | 匹配时才加载完整内容 |
| `paths` 作用 | 条件应用（不节省 tokens） | N/A |
| Token 消耗 | 始终消耗 | 按需消耗 |

**最佳实践**：

- Rules 保持精简（核心禁止项），详细规范放 Skills
- 例如 `bash-style`：rules 放 37 行核心规则，skills 放 200+ 行完整规范

### 设计理念

1. **按需加载**：语言规范用 Skills，只在操作相关文件时加载，节省 tokens
2. **规则溯源**：每次回复声明依据的规则/技能，便于追踪和调整
3. **简洁优先**：CLAUDE.md 只放身份/偏好，具体约束放 rules

---

## 开发指南

### LSP 服务器配置（v2.0.67+ 支持）

> **前提**：需安装 `@anthropic-ai/claude-code@2.0.67` 或更高版本。

#### 安装命令

```
# Java (macOS)
brew install jdtls

# TS/JS
npm install -g typescript typescript-language-server
```

#### LSP 使用策略

LSP 的核心优势是"精准打击"——查找定义时只返回相关代码，而非整个文件，可节省大量 Token。

| 场景 | 建议 | 原因 |
|------|------|------|
| 查找定义/引用 | 优先用 LSP | 精准定位，节省 ~99% Token |
| 理解模块整体逻辑 | 读取完整文件 | 避免"管中窥豹"，获取完整上下文 |
| 大型项目导航 | LSP + 选择性读文件 | 混合策略最优 |

#### 注意事项

- **环境就绪**：使用前确保依赖已安装（`npm install` / `pip install`）
- **避免过度依赖**：复杂逻辑需要读取完整文件上下文
- **LSP 失败时**：退回到读取文件的方式

### 修改现有配置

1. 在 `.claude/` 下修改对应文件
2. 在本项目目录启动 Claude Code 测试
3. 验证功能符合预期
4. 复制到 `~/.claude/` 正式使用

### 新增命令（Command）

1. 创建 `.claude/commands/<name>.md`
2. 编写 frontmatter（description）和内容
3. 测试 `/<name>` 命令
4. 更新本文档的命令列表

**命令模板**：

```
---
description: 命令的简要描述
---

命令的详细说明和执行逻辑。

## 输入

「$ARGUMENTS」— 用户输入的参数

## 流程

### 第 1 步：...

### 第 2 步：...

## 输出格式

...
```

### 新增技能（Skill）

1. 创建 `.claude/skills/<name>/SKILL.md`
2. 编写 frontmatter（name、description）和内容
3. 可选：添加 `references/` 目录存放详细参考
4. 测试触发是否正确
5. 更新本文档的技能列表

**技能模板**：

```
---
name: skill-name
description: 当用户操作 xxx 文件时触发。提供 xxx 开发规范。
---

# 技能名称

## 核心规范

...

## 详细参考

详细内容见 `references/` 目录。
```

### 测试验证

```
# 在本项目目录启动 Claude Code
cd /path/to/cc-use-exp
claude

# 测试命令
> /fix 测试问题

# 测试技能（操作相关文件类型）
> 帮我看看这个 Java 代码有什么问题

# 检查配置加载
> /memory
```

---

## 部署方法

### 工作原理

```
本项目 .claude/  ──开发/优化──>  确认无误  ──覆盖配置目录──>  ~/.claude/
```

- 在本项目 `.claude/` 目录下开发和优化配置
- 确认无误后，**只覆盖配置目录**到 `~/.claude/`
- `~/.claude/` 中的历史记录（`history.jsonl`、`projects/` 等）会保留

### 配置目录 vs 运行时数据

| 类型 | 目录/文件 | 部署时 |
|------|----------|--------|
| 配置 | `rules/`, `skills/`, `commands/`, `templates/`, `tasks/`, `CLAUDE.md` | 覆盖 |
| 运行时 | `history.jsonl`, `projects/`, `todos/`, `settings.local.json` 等 | 保留 |

### 部署命令

```
# 只覆盖配置目录，保留历史记录
rm -rf ~/.claude/rules ~/.claude/skills ~/.claude/commands ~/.claude/templates ~/.claude/tasks
cp -r .claude/rules ~/.claude/
cp -r .claude/skills ~/.claude/
cp -r .claude/commands ~/.claude/
cp -r .claude/templates ~/.claude/
cp -r .claude/tasks ~/.claude/
cp .claude/CLAUDE.md ~/.claude/

# 验证部署
# 启动 Claude Code，执行 /status 确认配置加载正确
```

> **注意**：不要整体删除 `~/.claude/`，否则会丢失对话历史记录（`claude -c` 依赖）。

---

## 版本记录

---

## 参考资料

- [Claude Code 官方文档](https://docs.anthropic.com/claude-code)

---

## 社区与支持

### GitHub

- [Issues](https://github.com/doccker/cc-use-exp/issues) - 报告问题
- [Pull Requests](https://github.com/doccker/cc-use-exp/pulls) - 贡献代码

---

## 许可声明

本项目采用自定义许可条款：

| 用途 | 条款 |
|------|------|
| **非商业用途** | 免费使用、修改、分发 |
| **商业用途** | 需获得作者书面授权 |
| **转载/二次开发** | 需注明出处并保留许可声明 |

未经授权的商业使用，作者保留追究法律责任的权利。

详见 [LICENSE](./LICENSE)
