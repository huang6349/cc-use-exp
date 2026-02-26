#!/usr/bin/env bash
set -euo pipefail

# 同步 .claude 配置到用户根目录

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}=== 配置同步工具 ===${NC}"
echo -e "源目录: ${SCRIPT_DIR}"
echo -e "目标目录: ${HOME}"
echo ""

# --- Claude Code ---
if [[ -d "${SCRIPT_DIR}/.claude" ]]; then
    echo -e "${GREEN}[Claude Code] 开始同步${NC}"

    # 确保目标目录存在
    mkdir -p ~/.claude

    # 删除旧配置目录（保留历史记录、projects 等）
    rm -rf ~/.claude/rules ~/.claude/skills ~/.claude/commands ~/.claude/templates ~/.claude/tasks
    echo -e "${YELLOW}  已清理旧配置目录${NC}"

    # 复制配置目录
    cp -r "${SCRIPT_DIR}/.claude/rules" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/skills" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/commands" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/templates" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/tasks" ~/.claude/
    cp "${SCRIPT_DIR}/.claude/CLAUDE.md" ~/.claude/

    echo -e "${GREEN}  ✓ rules/ skills/ commands/ templates/ tasks/ CLAUDE.md${NC}"
else
    echo -e "${YELLOW}[Claude Code] 源目录不存在，跳过${NC}"
fi

echo ""
echo -e "${GREEN}=== 同步完成 ===${NC}"
