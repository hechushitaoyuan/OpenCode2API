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
  echo 请先安装 Node.js LTS 版本
  echo 下载地址：https://nodejs.org/
  pause
  exit /b 1
)

if not exist node_modules (
  echo 正在安装依赖，请稍等...
  npm install
  if errorlevel 1 (
    echo [错误] 依赖安装失败，请检查网络连接后重试
    pause
    exit /b 1
  )
  echo 依赖安装完成！
  echo.
)

echo.
echo 检查 OpenCode CLI 是否已安装...
where opencode >nul 2>nul
if errorlevel 1 (
  echo [警告] 未检测到 OpenCode CLI
  echo 请先安装 OpenCode CLI：npm install -g opencode-ai
  echo 安装后请运行 opencode 进行首次配置（选择模型提供商等）
  echo.
  echo 如果已安装但仍提示未检测到，请检查 npm 全局路径是否在 PATH 中
  echo.
  pause
  exit /b 1
)
echo OpenCode CLI 已安装 ✓
echo.
echo 即将启动本地 API 服务...
echo Bridge 会自动启动 OpenCode CLI 后端服务（opencode serve）
echo.
echo ==========================================
echo LLM-wiki 请填写以下配置：
echo.
echo API 模式：OpenAI 兼容
echo Endpoint：http://127.0.0.1:9999/v1
echo API 密钥：sk-tjad1230
echo 模型：mimo-v2.5-free
echo.
echo 模型显示名：MiMO V2.5 Free
echo ==========================================
echo.
echo 提示：请确保已安装并配置 OpenCode CLI（运行 opencode 进行首次配置）
echo 按 Ctrl+C 可以停止服务
echo.

REM 延迟 3 秒后自动打开浏览器到配置页面
start "" cmd /c "timeout /t 3 >nul && start http://127.0.0.1:9999"

npm start

echo.
echo ==========================================
echo 服务已停止
echo.
echo 如需重新启动，请再次双击 start-windows.bat
echo ==========================================
echo.
pause
