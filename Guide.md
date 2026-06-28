# LLM-wiki OpenCode Bridge 开发指导文件

## 1. 项目目标

基于现有项目：

```text
https://github.com/TiaraBasori/OpenCode2API
```

做一个面向 **LLM-wiki / Obsidian 课程小白学员** 的教学友好版包装工具。

目标是让 Windows 学员在本机已经安装并运行 OpenCode Desktop / OpenCode CLI 的情况下，可以把 OpenCode 本地可用的免费模型能力转换成 **OpenAI-compatible API**，从而填入 LLM-wiki 的自定义 API 配置中使用。

最终学员只需要在 LLM-wiki 中填写：

```text
API 模式：OpenAI 兼容
Endpoint：http://127.0.0.1:9999/v1
API 密钥：sk-tjad1230
模型：mimo-v2.5-free
```

显示名称可以写：

```text
MiMO V2.5 Free
```

实际模型 ID 优先使用：

```text
mimo-v2.5-free
```

如果原项目或 OpenCode 返回的模型 ID 不一致，需要在 `/v1/models` 中做一个别名映射，让 `mimo-v2.5-free` 能正常指向 OpenCode 里的 MiMO V2.5 Free 模型。

---

## 2. 产品定位

项目建议命名：

```text
llm-wiki-opencode-bridge
```

或：

```text
OpenCode2API-For-LLM-Wiki
```

一句话介绍：

```text
一个面向 LLM-wiki / Obsidian 教学场景的 OpenCode 本地模型桥接器，把本机 OpenCode 的模型能力转换成 LLM-wiki 可调用的 OpenAI-compatible API。
```

项目只用于：

```text
个人学习
课堂演示
本地测试
官方免费模型体验
LLM-wiki 教学辅助
```

不要做：

```text
公网 API 服务
账号池
多用户商业网关
绕过平台限制
自动注册账号
```

---

## 3. 默认配置要求

请把项目默认配置改成以下值：

```json
{
  "BIND_HOST": "127.0.0.1",
  "PORT": 9999,
  "API_KEY": "sk-tjad1230",
  "DEFAULT_MODEL": "mimo-v2.5-free",
  "DEFAULT_MODEL_DISPLAY_NAME": "MiMO V2.5 Free",
  "OPENCODE_SERVER_URL": "http://127.0.0.1:5949"
}
```

如果项目使用 `.env`，则提供 `.env.example`：

```env
BIND_HOST=127.0.0.1
PORT=9999
API_KEY=sk-tjad1230
DEFAULT_MODEL=mimo-v2.5-free
DEFAULT_MODEL_DISPLAY_NAME=MiMO V2.5 Free
OPENCODE_SERVER_URL=http://127.0.0.1:5949
```

注意：

```text
默认必须监听 127.0.0.1
不要默认监听 0.0.0.0
不要默认开放局域网访问
```

---

## 4. MVP 功能范围

第一版只做课堂刚需。

### 必须实现

```text
1. Windows 一键启动脚本
2. 默认端口 9999
3. 默认 API Key：sk-tjad1230
4. 默认模型：mimo-v2.5-free
5. 默认模型显示名：MiMO V2.5 Free
6. 自动检测 OpenCode 是否运行
7. 自动检测 OpenCode 本地 server 是否可访问
8. 暴露 OpenAI-compatible API
9. 首页显示 LLM-wiki 配置方式
10. 提供一键复制配置文本
11. 提供健康检查接口
12. 提供模型列表接口
13. 提供 chat completions 接口
```

### 暂时不要做

```text
1. 不做公网部署
2. 不做账号池
3. 不做多用户管理
4. 不做复杂后台
5. 不强制 Docker
6. 不强制注册 OpenCode Zen
7. 不强制 Google / GitHub 登录
8. 不处理 vision
9. 不处理复杂 tool calling
10. 不做过度工程化
```

---

## 5. Windows 一键启动脚本

新增文件：

```text
start-windows.bat
```

目标：

```text
1. 检查 Node.js
2. 检查 npm
3. 自动安装依赖
4. 启动服务
5. 在终端中显示 LLM-wiki 配置
```

脚本示例：

```bat
@echo off
chcp 65001 >nul
title LLM-wiki OpenCode Bridge

echo ==========================================
echo LLM-wiki OpenCode Bridge
echo ==========================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo [错误] 未检测到 Node.js
  echo 请先安装 Node.js LTS 版本
  echo 下载地址：https://nodejs.org/
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo [错误] 未检测到 npm
  pause
  exit /b 1
)

if not exist node_modules (
  echo 正在安装依赖，请稍等...
  npm install
)

echo.
echo 即将启动本地 API 服务...
echo.
echo ==========================================
echo LLM-wiki 请填写：
echo.
echo API 模式：OpenAI 兼容
echo Endpoint：http://127.0.0.1:9999/v1
echo API 密钥：sk-tjad1230
echo 模型：mimo-v2.5-free
echo.
echo 模型显示名：MiMO V2.5 Free
echo ==========================================
echo.

npm start

pause
```

---

## 6. 首页设计

访问：

```text
http://127.0.0.1:9999
```

显示一个极简网页。

页面内容：

```text
LLM-wiki OpenCode Bridge 已启动

OpenCode 状态：已连接 / 未连接
API 服务状态：正常
当前 Endpoint：http://127.0.0.1:9999/v1
API Key：sk-tjad1230
推荐模型：mimo-v2.5-free
模型显示名：MiMO V2.5 Free
```

页面中显示 LLM-wiki 配置：

```text
API 模式：OpenAI 兼容
Endpoint：http://127.0.0.1:9999/v1
API 密钥：sk-tjad1230
模型：mimo-v2.5-free
```

按钮：

```text
复制 LLM-wiki 配置
测试连接
查看模型列表
```

如果没有检测到 OpenCode，显示：

```text
未检测到 OpenCode 本地服务。
请先打开 OpenCode Desktop，并确认 Local Server 为绿色在线状态。
如果使用 OpenCode CLI，请先运行 opencode。
```

---

## 7. 健康检查接口

新增或保留：

```text
GET /health
```

正常返回：

```json
{
  "status": "ok",
  "service": "llm-wiki-opencode-bridge",
  "opencode": "connected",
  "endpoint": "http://127.0.0.1:9999/v1",
  "defaultModel": "mimo-v2.5-free",
  "defaultModelDisplayName": "MiMO V2.5 Free"
}
```

OpenCode 未连接时返回：

```json
{
  "status": "degraded",
  "service": "llm-wiki-opencode-bridge",
  "opencode": "not_connected",
  "message": "请先启动 OpenCode Desktop 或 OpenCode CLI"
}
```

---

## 8. OpenAI-compatible 接口

至少支持：

```text
GET  /v1/models
POST /v1/chat/completions
```

### `/v1/models`

至少返回：

```json
{
  "object": "list",
  "data": [
    {
      "id": "mimo-v2.5-free",
      "object": "model",
      "owned_by": "opencode",
      "display_name": "MiMO V2.5 Free"
    },
    {
      "id": "opencode-auto",
      "object": "model",
      "owned_by": "opencode",
      "display_name": "OpenCode Auto"
    }
  ]
}
```

如果可以从 OpenCode 获取真实模型列表，则把真实列表也返回。
但无论真实列表如何，必须保证 `mimo-v2.5-free` 这个模型 ID 可用。

---

## 9. 模型别名映射

需要做模型别名兼容。

如果请求模型是：

```text
mimo-v2.5-free
MiMO V2.5 Free
mimo
opencode-auto
```

都优先映射到 OpenCode 当前可用的 MiMO V2.5 Free 模型。

如果 OpenCode 内部返回的真实模型名称类似：

```text
MiMO V2.5 Free
Mimo V2.5 Free
mimo-v2.5-free
opencode/mimo-v2.5-free
```

都需要兼容。

实现建议：

```js
function normalizeModel(model) {
  const m = String(model || "").toLowerCase().trim();

  if (
    m === "mimo-v2.5-free" ||
    m === "mimo" ||
    m === "mimo v2.5 free" ||
    m === "opencode-auto"
  ) {
    return "mimo-v2.5-free";
  }

  return model || "mimo-v2.5-free";
}
```

如果 OpenCode 需要真实 display name，则在调用 OpenCode Server API 时再转换为实际模型名称。

---

## 10. LLM-wiki 兼容优先级

优先保证 LLM-wiki 的 Custom OpenAI 模式能跑通。

重点兼容请求：

```json
{
  "model": "mimo-v2.5-free",
  "messages": [
    {
      "role": "system",
      "content": "你是一个知识库助手"
    },
    {
      "role": "user",
      "content": "请根据以下内容生成 wiki 页面"
    }
  ],
  "temperature": 0.7,
  "max_tokens": 4096,
  "stream": false
}
```

第一版优先支持：

```text
stream=false
普通文本 messages
system/user/assistant 三类 role
```

如果收到 `stream=true`，可以先转为非流式返回。
如果暂时不支持流式，返回友好错误：

```json
{
  "error": {
    "message": "当前教学版暂不支持 stream=true，请在 LLM-wiki 中关闭流式输出",
    "type": "unsupported_feature"
  }
}
```

---

## 11. Prompt 转换逻辑

如果 OpenCode Server API 不能直接接收 OpenAI messages，则需要把 messages 合并成一个 prompt。

合并格式：

```text
[System]
系统提示词内容

[User]
用户消息内容

[Assistant]
历史助手回复

[User]
最新用户问题
```

第一版不追求完美多轮上下文，只要满足 LLM-wiki 的生成、总结、改写、结构化输出即可。

---

## 12. 错误提示

错误提示必须面向小白，不要直接抛堆栈。

### OpenCode 未启动

```text
未检测到 OpenCode 本地服务。
请先打开 OpenCode Desktop，并确认 Local Server 为绿色在线。
```

### 端口被占用

```text
端口 9999 已被占用。
请关闭其他正在运行的 Bridge，或者修改配置文件中的 PORT。
```

### API Key 错误

```text
API 密钥不正确。
课堂默认密钥是 sk-tjad1230，请检查 LLM-wiki 中的 API 密钥设置。
```

### 模型调用失败

```text
OpenCode 模型调用失败。
请先在 OpenCode Desktop 中确认 MiMO V2.5 Free 可以正常对话。
```

---

## 13. README 要面向学员重写

README 结构建议：

```text
# LLM-wiki OpenCode Bridge

## 这个工具做什么？

把本机 OpenCode 的模型能力转换成 LLM-wiki 可以识别的 OpenAI 兼容 API。

## 适合谁？

- LLM-wiki 课程学员
- Obsidian 用户
- Windows 小白用户
- 想本地测试 OpenCode 免费模型的人

## 使用前准备

1. 安装 Node.js LTS
2. 安装 OpenCode Desktop
3. 确认 OpenCode Desktop 中 MiMO V2.5 Free 可以正常对话

## 一键启动

双击：

start-windows.bat

## LLM-wiki 配置

API 模式：OpenAI 兼容
Endpoint：http://127.0.0.1:9999/v1
API 密钥：sk-tjad1230
模型：mimo-v2.5-free

## 常见问题

### 连接失败怎么办？
### 模型列表为空怎么办？
### OpenCode 没启动怎么办？
### 9999 端口被占用怎么办？
### 为什么不要关闭 OpenCode Desktop？
```

---

## 14. 安全要求

必须遵守：

```text
1. 默认只监听 127.0.0.1
2. 不默认开放局域网访问
3. 不读取浏览器 Cookie
4. 不导出 OpenCode 账号凭据
5. 不做账号池
6. 不上传用户笔记内容到额外服务器
7. 不保存用户 prompt 日志，除非用户主动开启 debug
8. README 明确说明仅供本机学习测试使用
```

---

## 15. 开发执行顺序

请按以下顺序执行。

### Phase 1：跑通原项目

1. clone 原项目：

```bash
git clone https://github.com/TiaraBasori/OpenCode2API.git
```

2. 安装依赖：

```bash
npm install
```

3. 启动原项目：

```bash
npm start
```

4. 测试原接口是否可用。

---

### Phase 2：修改默认配置

把默认值改成：

```text
BIND_HOST=127.0.0.1
PORT=9999
API_KEY=sk-tjad1230
DEFAULT_MODEL=mimo-v2.5-free
DEFAULT_MODEL_DISPLAY_NAME=MiMO V2.5 Free
```

确保不需要用户手动编辑复杂配置也能启动。

---

### Phase 3：模型别名兼容

确保以下模型名都可以正常工作：

```text
mimo-v2.5-free
MiMO V2.5 Free
mimo
opencode-auto
```

默认全部指向 MiMO V2.5 Free。

---

### Phase 4：Windows 启动脚本

新增：

```text
start-windows.bat
```

要求：

```text
1. 检测 Node.js
2. 检测 npm
3. 自动 npm install
4. 启动 npm start
5. 输出 LLM-wiki 配置
```

---

### Phase 5：首页

新增：

```text
GET /
```

首页显示：

```text
Endpoint：http://127.0.0.1:9999/v1
API Key：sk-tjad1230
Model：mimo-v2.5-free
Display：MiMO V2.5 Free
```

---

### Phase 6：LLM-wiki 实测

在 LLM-wiki 中配置：

```text
API 模式：OpenAI 兼容
Endpoint：http://127.0.0.1:9999/v1
API 密钥：sk-tjad1230
模型：mimo-v2.5-free
```

点击测试连接，确认成功。

然后执行一次真实 wiki 生成任务，确认可以输出内容。

---

## 16. 验收标准

项目完成后必须满足：

```text
1. Windows 用户双击 start-windows.bat 可以启动
2. 浏览器打开 http://127.0.0.1:9999 可以看到配置说明
3. http://127.0.0.1:9999/health 返回正常
4. http://127.0.0.1:9999/v1/models 返回模型列表
5. /v1/models 中必须包含 mimo-v2.5-free
6. LLM-wiki 填入本地 API 后能测试成功
7. LLM-wiki 能完成一次普通文本生成任务
8. OpenCode 未启动时有中文友好提示
9. 端口 9999 被占用时有中文友好提示
10. 默认不会监听 0.0.0.0
11. 默认 API Key 是 sk-tjad1230
12. 默认模型是 MiMO V2.5 Free
```

---

## 17. 课堂演示口径

老师讲课时可以这样说：

```text
OpenCode Desktop 本身能调用免费模型，但 LLM-wiki 需要的是 OpenAI 兼容 API。
这个 Bridge 的作用，就是把本机 OpenCode 的能力转换成 LLM-wiki 能识别的 API。
大家不用额外注册模型平台账号，不用配置复杂密钥，只需要保持 OpenCode Desktop 打开，然后启动 Bridge，再把三个字段填进 LLM-wiki。
```

课堂配置统一为：

```text
Endpoint：http://127.0.0.1:9999/v1
API 密钥：sk-tjad1230
模型：mimo-v2.5-free
```

课堂主线：

```text
Obsidian
  ↓
LLM-wiki
  ↓
OpenAI-compatible API
  ↓
LLM-wiki OpenCode Bridge
  ↓
OpenCode Desktop / CLI
  ↓
MiMO V2.5 Free
```

---

## 18. 后续增强方向

MVP 完成后再考虑：

```text
1. 支持模型下拉选择
2. 支持自动启动 opencode serve
3. 支持 Windows exe 打包
4. 支持托盘程序
5. 支持日志面板
6. 支持一键复制配置
7. 支持自动检测 Obsidian / LLM-wiki 是否安装
8. 支持 stream=true
9. 支持 /v1/responses
10. 支持课堂局域网模式，但必须默认关闭
```

第一版不要做太大，优先保证 LLM-wiki 能稳定跑通。
