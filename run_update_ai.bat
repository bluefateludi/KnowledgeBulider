@echo off
REM Zendesk 知识库更新脚本 (AI 重写 + 更新已存在)
REM 使用方法: run_update_ai.bat your_excel_file.xlsx

set SUBDOMAIN=pdi-siebre
set EMAIL=ethan.qi@almt.com.cn
set API_TOKEN=9Jwt6Rdty4SKZRGgtOsaolRUKkb9XaD9X72abfPS
set SECTION_ID=15351905195407
set PERMISSION_GROUP_ID=4467696108175

if "%1"=="" (
    echo 用法: run_update_ai.bat excel_file.xlsx
    echo 示例: run_update_ai.bat articles.xlsx
    echo.
    echo 目标 Section ID: %SECTION_ID% (section1)
    echo 功能: AI 重写 + 更新已存在的文章
    echo.
    echo 注意：
    echo - 按标题匹配已存在的文章并更新内容
    echo - 不存在的文章将创建新的
    pause
    exit /b 1
)

echo 正在使用阿里百炼 AI 重写并更新文章...
echo.

python zendesk_xlsx_import.py ^
  --subdomain %SUBDOMAIN% ^
  --email %EMAIL% ^
  --api-token %API_TOKEN% ^
  --xlsx %1 ^
  --section-id %SECTION_ID% ^
  --permission-group-id %PERMISSION_GROUP_ID% ^
  --update-existing ^
  --ai-rewrite ^
  --draft true

echo.
echo 更新完成! 检查上面的输出结果。
pause
