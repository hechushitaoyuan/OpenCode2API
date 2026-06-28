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
echo 即将启动本地 API 服务...
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
echo 提示：请确保 OpenCode Desktop 已打开并处于在线状态
echo 按 Ctrl+C 可以停止服务
echo.

npm start

pause
