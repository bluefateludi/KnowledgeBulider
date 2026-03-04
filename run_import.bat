@echo off
REM Zendesk 知识库导入脚本
REM 使用方法: run_import.bat your_excel_file.xlsx

set SUBDOMAIN=pdi-siebre
set EMAIL=ethan.qi@almt.com.cn
set API_TOKEN=9Jwt6Rdty4SKZRGgtOsaolRUKkb9XaD9X72abfPS

if "%1"=="" (
    echo 用法: run_import.bat excel_file.xlsx
    echo 示例: run_import.bat articles.xlsx
    pause
    exit /b 1
)

python zendesk_xlsx_import.py ^
  --subdomain %SUBDOMAIN% ^
  --email %EMAIL% ^
  --api-token %API_TOKEN% ^
  --xlsx %1 ^
  --draft true

echo.
echo 导入完成! 检查上面的输出结果。
pause
