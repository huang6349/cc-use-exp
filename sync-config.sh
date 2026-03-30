#!/usr/bin/env bash
if [ -z "${BASH_VERSION:-}" ]; then
    exec /usr/bin/env bash "$0" "$@"
fi

set -euo pipefail

# 同步 .claude 配置到用户根目录

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_line() {
    printf '%b\n' "$1"
}

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

print_line "${GREEN}=== 配置同步工具 ===${NC}"
print_line "源目录: ${SCRIPT_DIR}"
print_line "目标目录: ${HOME}"
printf '\n'

# --- Claude Code ---
if [[ -d "${SCRIPT_DIR}/.claude" ]]; then
    print_line "${GREEN}[Claude Code] 开始同步${NC}"

    # 确保目标目录存在
    mkdir -p ~/.claude

    # 删除旧配置目录（保留历史记录、projects 等）
    rm -rf ~/.claude/rules ~/.claude/skills ~/.claude/commands ~/.claude/templates ~/.claude/tasks
    print_line "${YELLOW}  已清理旧配置目录${NC}"

    # 复制配置目录
    cp -r "${SCRIPT_DIR}/.claude/rules" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/skills" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/commands" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/templates" ~/.claude/
    cp -r "${SCRIPT_DIR}/.claude/tasks" ~/.claude/
    cp "${SCRIPT_DIR}/.claude/CLAUDE.md" ~/.claude/

    print_line "${GREEN}  ✓ rules/ skills/ commands/ templates/ tasks/ CLAUDE.md${NC}"

    # --- Claude Code 插件检测 ---
    PLUGIN_JSON="${SCRIPT_DIR}/.claude/plugins.json"
    INSTALLED_JSON="${HOME}/.claude/plugins/installed_plugins.json"
    if ! command -v claude &>/dev/null; then
        printf '\n'
        print_line "${YELLOW}[Claude Code] 未检测到 claude 命令，跳过插件检测${NC}"
        print_line "${YELLOW}  安装方式: npm install -g @anthropic-ai/claude-code${NC}"
    elif ! command -v python3 &>/dev/null; then
        printf '\n'
        print_line "${YELLOW}[Claude Code] 未检测到 python3，跳过插件检测${NC}"
        print_line "${YELLOW}  插件检测需要 python3 解析 JSON，请安装后重试${NC}"
        print_line "${YELLOW}  macOS: brew install python3 | Ubuntu: sudo apt install python3${NC}"
    elif [[ -f "$PLUGIN_JSON" ]]; then
        printf '\n'
        print_line "${YELLOW}[Claude Code] 正在检测推荐插件...${NC}"

        # 使用 python3 解析 JSON 检查缺失插件
        MISSING_PLUGINS=$(python3 -c "
import json, sys
try:
    with open(sys.argv[1]) as f:
        recommended = json.load(f)
    installed = {}
    try:
        with open(sys.argv[2]) as f:
            installed = json.load(f).get('plugins', {})
    except (FileNotFoundError, json.JSONDecodeError):
        pass
    for p in recommended.get('recommendations', []):
        key = p['id'] + '@' + p['marketplace']
        if key not in installed:
            print(p['id'] + '|' + p['name'] + '|' + p['marketplace'])
except Exception:
    pass
" "$PLUGIN_JSON" "$INSTALLED_JSON")

        if [[ -n "$MISSING_PLUGINS" ]]; then
            print_line "${YELLOW}检测到以下推荐插件尚未安装：${NC}"
            IFS=$'\n'
            for item in $MISSING_PLUGINS; do
                IFS='|' read -r id name marketplace <<< "$item"
                print_line "  - ${YELLOW}$name${NC} ($id)"
            done

            printf '\n'
            read -p "是否现在安装上述缺失的插件？[Y/n] " confirm
            if [[ "$confirm" =~ ^[Yy]$ || "$confirm" == "" ]]; then
                IFS=$'\n'
                for item in $MISSING_PLUGINS; do
                    IFS='|' read -r id name marketplace <<< "$item"
                    print_line "${GREEN}正在安装 $name...${NC}"
                    INSTALL_OUTPUT=$(claude plugin install "${id}@${marketplace}" 2>&1) || {
                        if echo "$INSTALL_OUTPUT" | grep -qi "auth\|login\|token\|credential\|unauthorized\|forbidden"; then
                            print_line "${RED}错误: Claude Code 未认证，请先运行 'claude login' 登录${NC}"
                            break
                        elif echo "$INSTALL_OUTPUT" | grep -qi "already installed\|already exists"; then
                            print_line "${YELLOW}  $name 已安装，跳过${NC}"
                        else
                            print_line "${YELLOW}警告: $name 安装失败 — $INSTALL_OUTPUT${NC}"
                        fi
                    }
                done
                print_line "${GREEN}✓ 插件安装完成${NC}"
            else
                print_line "${YELLOW}已跳过插件安装。你可以之后手动安装。${NC}"
            fi
        else
            print_line "${GREEN}✓ 所有推荐插件已安装${NC}"
        fi
    fi
else
    print_line "${YELLOW}[Claude Code] 源目录不存在，跳过${NC}"
fi

printf '\n'
print_line "${GREEN}=== 同步完成 ===${NC}"
