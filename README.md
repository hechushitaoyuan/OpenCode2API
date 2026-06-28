# LLM-wiki OpenCode Bridge

> 把本机 OpenCode 的模型能力转换成 LLM-wiki 可以识别的 OpenAI 兼容 API。

<p align="center">
  <img src="https://img.shields.io/badge/version-2.0.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/Node.js-18+-orange" alt="Node">
</p>

---

## 这个工具做什么？

OpenCode Desktop 本身能调用免费模型（如 MiMO V2.5 Free），但 LLM-wiki 需要的是 OpenAI 兼容 API。这个 Bridge 的作用，就是把本机 OpenCode 的能力转换成 LLM-wiki 能识别的 API。

大家不用额外注册模型平台账号，不用配置复杂密钥，只需要保持 OpenCode Desktop 打开，然后启动 Bridge，再把三个字段填进 LLM-wiki。

课堂主线：

```
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

## 适合谁？

- LLM-wiki 课程学员
- Obsidian 用户
- Windows 小白用户
- 想本地测试 OpenCode 免费模型的人

---

## 使用前准备

1. **安装 Node.js LTS** — 下载地址：https://nodejs.org/
2. **安装 OpenCode Desktop** — 从 OpenCode 官网下载安装
3. **确认 OpenCode Desktop 中 MiMO V2.5 Free 可以正常对话**

> 本工具仅供本机学习测试使用，不要用于公网服务。

---

## 一键启动

双击项目根目录下的：

```
start-windows.bat
```

脚本会自动：
1. 检查 Node.js 是否安装
2. 检查 npm 是否可用
3. 自动安装依赖（首次运行）
4. 启动 API 服务
5. 在终端中显示 LLM-wiki 配置信息

---

## LLM-wiki 配置

在 LLM-wiki 的自定义 API 配置中填写：

| 配置项 | 值 |
|:------|:---|
| API 模式 | OpenAI 兼容 |
| Endpoint | `http://127.0.0.1:9999/v1` |
| API 密钥 | `sk-tjad1230` |
| 模型 | `mimo-v2.5-free` |
| 显示名称 | `MiMO V2.5 Free` |

也可以打开浏览器访问 http://127.0.0.1:9999 查看配置页面，支持一键复制。

---

## 默认配置

项目开箱即用，默认配置如下：

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

如需修改，可以编辑 `config.json` 或设置环境变量（参考 `.env.example`）。

---

## 模型别名兼容

以下模型名都可以正常使用，都会指向 MiMO V2.5 Free：

```
mimo-v2.5-free
MiMO V2.5 Free
mimo
opencode-auto
```

---

## API 接口

| 方法 | 路径 | 说明 |
|:-----|:-----|:-----|
| `GET` | `/` | 首页（配置说明页面） |
| `GET` | `/health` | 健康检查（含 OpenCode 连接状态） |
| `GET` | `/v1/models` | 获取可用模型列表 |
| `POST` | `/v1/chat/completions` | Chat Completions API |

### 健康检查示例

```bash
curl http://127.0.0.1:9999/health
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

### Chat Completions 示例

```bash
curl -X POST http://127.0.0.1:9999/v1/chat/completions \
  -H "Authorization: Bearer sk-tjad1230" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mimo-v2.5-free",
    "messages": [{"role": "user", "content": "你好！"}],
    "stream": false
  }'
```

---

## 常见问题

### 连接失败怎么办？

1. 确认 OpenCode Desktop 已打开
2. 确认 OpenCode Desktop 中 Local Server 为绿色在线状态
3. 确认 Bridge 服务已启动（终端窗口没有关闭）
4. 打开浏览器访问 http://127.0.0.1:9999 查看状态

### 模型列表为空怎么办？

- 检查 OpenCode Desktop 是否正常登录
- 在 OpenCode Desktop 中尝试与 MiMO V2.5 Free 对话一次
- 刷新 http://127.0.0.1:9999/v1/models

### OpenCode 没启动怎么办？

打开 OpenCode Desktop 应用程序，等待其完全加载，确认左下角状态为在线。如果使用 CLI，在终端运行 `opencode` 命令。

### 9999 端口被占用怎么办？

关闭其他正在运行的 Bridge 实例。如果仍有问题，可以在 `config.json` 中修改 `PORT` 为其他端口号，同时更新 LLM-wiki 中的 Endpoint。

### 为什么不要关闭 OpenCode Desktop？

Bridge 只是一个转换层，实际的模型调用由 OpenCode 完成。如果关闭 OpenCode，Bridge 将无法调用任何模型。

---

## 安全说明

- 默认只监听 127.0.0.1，不开放局域网访问
- 不读取浏览器 Cookie
- 不导出 OpenCode 账号凭据
- 不做账号池
- 不上传用户笔记内容到额外服务器
- 不保存用户 prompt 日志（除非主动开启 debug）
- 仅供本机学习测试使用

---

## 开发

```bash
# 安装依赖
npm install

# 启动服务
npm start

# 运行测试
npm test
```

---

## 许可证

MIT · 详见 [LICENSE](./LICENSE.md)
