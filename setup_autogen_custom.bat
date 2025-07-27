@echo off
REM AutoGen 自定义模型配置安装脚本 (Windows 批处理)
REM 自动下载AutoGen项目并集成Kimi-K2、DeepSeek-R1、Qwen3模型配置

setlocal enabledelayedexpansion

echo 🚀 AutoGen 自定义模型配置安装脚本 (Windows)
echo ========================================

REM 检查必要工具
echo 📋 检查系统要求...

REM 检查Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git 未安装，请先安装 Git for Windows
    echo 下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
) else (
    echo ✅ Git 已安装
)

REM 检查Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python 未安装，请先安装 Python 3.10+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
) else (
    echo ✅ Python 已安装
)

echo ✅ 系统要求检查通过

REM 设置安装路径
set INSTALL_PATH=autogen

REM 检查安装目录
if exist "%INSTALL_PATH%" (
    echo ⚠️  %INSTALL_PATH% 目录已存在
    set /p "response=是否删除并重新克隆？(y/N): "
    if /i "!response!"=="y" (
        rmdir /s /q "%INSTALL_PATH%"
    ) else (
        echo ❌ 安装中止
        pause
        exit /b 1
    )
)

REM 克隆AutoGen仓库
echo 📥 克隆 AutoGen 官方仓库...
git clone https://github.com/microsoft/autogen.git %INSTALL_PATH%
if errorlevel 1 (
    echo ❌ 克隆仓库失败
    pause
    exit /b 1
)

cd %INSTALL_PATH%
echo ✅ AutoGen 仓库克隆完成

REM 下载自定义配置
echo 📥 下载自定义模型配置...

REM 使用curl或PowerShell下载文件
where curl >nul 2>&1
if not errorlevel 1 (
    REM 使用curl下载
    curl -L -o custom_models_config.yaml https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/custom_models_config.yaml
    curl -L -o CLAUDE.md https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/CLAUDE.md
    curl -L -o git_upload_guide.md https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/git_upload_guide.md
    
    mkdir examples 2>nul
    cd examples
    curl -L -o README.md https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/README.md
    curl -L -o simple_model_test.py https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/simple_model_test.py
    curl -L -o test_custom_models.py https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/test_custom_models.py
    curl -L -o coding_agent_demo.py https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/coding_agent_demo.py
    cd ..
) else (
    REM 使用PowerShell下载
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/custom_models_config.yaml' -OutFile 'custom_models_config.yaml'"
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/CLAUDE.md' -OutFile 'CLAUDE.md'"
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/git_upload_guide.md' -OutFile 'git_upload_guide.md'"
    
    mkdir examples 2>nul
    cd examples
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/README.md' -OutFile 'README.md'"
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/simple_model_test.py' -OutFile 'simple_model_test.py'"
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/test_custom_models.py' -OutFile 'test_custom_models.py'"
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/coding_agent_demo.py' -OutFile 'coding_agent_demo.py'"
    cd ..
)

echo ✅ 自定义配置下载完成

REM 集成配置到AutoGen项目
echo 🔧 集成自定义配置到 AutoGen 项目...
cd python

REM 复制配置文件 (Windows批处理不支持符号链接)
copy "..\custom_models_config.yaml" "model_config.yaml" >nul
xcopy "..\examples" "custom_examples\" /E /I /Q >nul

cd ..
echo ✅ 配置集成完成

REM 检查并安装uv
echo 🐍 设置 Python 环境...
cd python

uv --version >nul 2>&1
if errorlevel 1 (
    echo 📦 安装 uv 包管理器...
    
    REM 尝试使用winget安装uv
    winget install --id=astral-sh.uv -e >nul 2>&1
    if errorlevel 1 (
        REM 如果winget失败，使用pip安装
        pip install uv
    )
)

REM 安装依赖
echo 📦 安装 AutoGen 依赖 (这可能需要几分钟)...
uv sync --all-extras
if errorlevel 1 (
    echo ⚠️  uv sync 失败，尝试使用pip安装...
    pip install -e . --all-extras
)

cd ..
echo ✅ Python 环境设置完成

REM 创建启动脚本
echo 📝 创建快速启动脚本...

REM 创建批处理启动脚本
echo @echo off > start_autogen.bat
echo echo 🤖 AutoGen 自定义模型环境启动 >> start_autogen.bat
echo echo 📋 可用的自定义模型： >> start_autogen.bat
echo echo    • kimi_k2 - Kimi-K2 ^(通用对话和编程^) >> start_autogen.bat
echo echo    • deepseek_r1 - DeepSeek-R1 ^(复杂推理^) >> start_autogen.bat
echo echo    • qwen3_coder - Qwen3 ^(专业编程^) >> start_autogen.bat
echo echo. >> start_autogen.bat
echo echo 🚀 快速测试命令： >> start_autogen.bat
echo echo    python ..\examples\simple_model_test.py kimi_k2 >> start_autogen.bat
echo echo    python ..\examples\coding_agent_demo.py >> start_autogen.bat
echo echo. >> start_autogen.bat
echo cd python >> start_autogen.bat
echo if exist ".venv\Scripts\activate.bat" ^( >> start_autogen.bat
echo     call ".venv\Scripts\activate.bat" >> start_autogen.bat
echo     echo ✅ 虚拟环境已激活 >> start_autogen.bat
echo ^) else ^( >> start_autogen.bat
echo     echo ⚠️  虚拟环境未找到，请先运行 uv sync --all-extras >> start_autogen.bat
echo ^) >> start_autogen.bat
echo cmd /k >> start_autogen.bat

REM 创建环境变量模板
echo # AutoGen 自定义模型 API 密钥配置 ^(Windows^) > .env.template
echo # 复制此文件为 .env 并填入你的实际 API 密钥 >> .env.template
echo. >> .env.template
echo # Kimi-K2 ^(Moonshot AI^) >> .env.template
echo MOONSHOT_API_KEY=sk-5WRXcCdiP1HoPDRwpcKnF0Zi5b9th6q12mF50KqBDJrUc62y >> .env.template
echo. >> .env.template
echo # DeepSeek-R1 >> .env.template
echo DEEPSEEK_API_KEY=sk-17269fe512b74407b22f5c926a216bf1 >> .env.template
echo. >> .env.template
echo # Qwen3 ^(阿里云通义千问^) >> .env.template
echo DASHSCOPE_API_KEY=sk-829bda5565e04302b9bd5a088f0247c3 >> .env.template

echo ✅ 快速启动脚本创建完成

REM 显示完成信息
echo.
echo 🎉 AutoGen 自定义模型配置安装完成！
echo ========================================
echo.
echo 📁 项目结构：
echo    autogen\                    # 完整的AutoGen项目
echo    ├── custom_models_config.yaml   # 三个模型配置
echo    ├── examples\               # 示例和演示脚本
echo    ├── python\                 # Python AutoGen实现
echo    ├── dotnet\                 # .NET AutoGen实现
echo    ├── start_autogen.bat       # 批处理启动脚本
echo    └── .env.template           # 环境变量模板
echo.
echo 🚀 快速开始：
echo    cd autogen
echo    start_autogen.bat           # 启动AutoGen环境
echo.
echo 🎯 测试单个模型：
echo    start_autogen.bat
echo    python ..\examples\simple_model_test.py kimi_k2
echo.
echo 💻 编程协作演示：
echo    start_autogen.bat
echo    python ..\examples\coding_agent_demo.py
echo.
echo 📚 详细文档：
echo    type examples\README.md
echo    type CLAUDE.md
echo.

pause