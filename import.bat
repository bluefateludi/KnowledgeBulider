@echo off
REM Zendesk 知识库导入工具
REM 用法: import.bat excel_file.xlsx [选项]
REM
REM 选项:
REM   --ai       使用 AI 重写内容
REM   --update   更新已存在的文章（默认跳过）
REM   --publish  直接发布（默认为草稿）
REM
REM 示例:
REM   import.bat articles.xlsx          # 导入为草稿，跳过已存在
REM   import.bat articles.xlsx --ai     # AI 重写后导入为草稿
REM   import.bat articles.xlsx --ai --update   # AI 重写并更新已存在

set SUBDOMAIN=pdi-siebre
set EMAIL=ethan.qi@almt.com.cn
set API_TOKEN=9Jwt6Rdty4SKZRGgtOsaolRUKkb9XaD9X72abfPS
set SECTION_ID=15353931621391
set PERMISSION_GROUP_ID=4467696108175

if "%1"=="" (
    echo 用法: import.bat excel_file.xlsx [选项]
    echo.
    echo 选项:
    echo   --ai       使用 AI 重写内容
    echo   --update   更新已存在的文章（默认跳过）
    echo   --publish  直接发布（默认为草稿）
    echo.
    echo 示例:
    echo   import.bat articles.xlsx
    echo   import.bat articles.xlsx --ai
    echo   import.bat articles.xlsx --ai --update
    pause
    exit /b 1
)

set AI_FLAG=
set UPDATE_FLAG=--skip-existing
set DRAFT_FLAG=--draft true

:parse_args
if "%2"=="--ai" (
    set AI_FLAG=--ai-rewrite
    shift
    goto parse_args
)
if "%2"=="--update" (
    set UPDATE_FLAG=--update-existing
    shift
    goto parse_args
)
if "%2"=="--publish" (
    set DRAFT_FLAG=--draft false
    shift
    goto parse_args
)

echo.
echo ========================================
echo   Zendesk 知识库导入工具
echo ========================================
echo   文件: %~nx1
echo   Section: %SECTION_ID%

if "%AI_FLAG%"=="" (
    echo   AI: 否 (使用原始内容)
) else (
    echo   AI: 是 (使用阿里百炼重写)
)

if "%UPDATE_FLAG%"=="--update-existing" (
    echo   模式: 更新 (覆盖已存在的文章)
) else (
    echo   模式: 跳过 (保留已存在的文章)
)

if "%DRAFT_FLAG%"=="--draft false" (
    echo   状态: 发布
) else (
    echo   状态: 草稿
)
echo ========================================
echo.
echo 正在导入...
echo.

python zendesk_xlsx_import.py ^
  --subdomain %SUBDOMAIN% ^
  --email %EMAIL% ^
  --api-token %API_TOKEN% ^
  --xlsx %1 ^
  --section-id %SECTION_ID% ^
  --permission-group-id %PERMISSION_GROUP_ID% ^
  %UPDATE_FLAG% ^
  %AI_FLAG% ^
  %DRAFT_FLAG%

echo.
echo 完成！
pause
