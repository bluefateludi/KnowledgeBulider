@echo off
REM Zendesk 知识库导入脚本 (固定 Section ID)
REM 使用方法: run_import_fixed.bat your_excel_file.xlsx

set SUBDOMAIN=pdi-siebre
set EMAIL=ethan.qi@almt.com.cn
set API_TOKEN=9Jwt6Rdty4SKZRGgtOsaolRUKkb9XaD9X72abfPS
set SECTION_ID=15351905195407
set PERMISSION_GROUP_ID=4467696108175

if "%1"=="" (
    echo 用法: run_import_fixed.bat excel_file.xlsx
    echo 示例: run_import_fixed.bat articles.xlsx
    echo.
    echo 目标 Section ID: %SECTION_ID% (section1)
    pause
    exit /b 1
)

python zendesk_xlsx_import.py ^
  --subdomain %SUBDOMAIN% ^
  --email %EMAIL% ^
  --api-token %API_TOKEN% ^
  --xlsx %1 ^
  --section-id %SECTION_ID% ^
  --permission-group-id %PERMISSION_GROUP_ID% ^
  --draft true

echo.
echo 导入完成! 检查上面的输出结果。
pause
