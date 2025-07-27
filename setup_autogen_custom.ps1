# AutoGen 自定义模型配置安装脚本 (Windows PowerShell)
# 自动下载AutoGen项目并集成Kimi-K2、DeepSeek-R1、Qwen3模型配置

param(
    [string]$InstallPath = ".\autogen"
)

Write-Host "🚀 AutoGen 自定义模型配置安装脚本 (Windows)" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# 检查必要工具
function Test-Requirements {
    Write-Host "📋 检查系统要求..." -ForegroundColor Yellow
    
    # 检查Git
    try {
        git --version | Out-Null
        Write-Host "✅ Git 已安装" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Git 未安装，请先安装 Git for Windows" -ForegroundColor Red
        Write-Host "下载地址: https://git-scm.com/download/win" -ForegroundColor Yellow
        exit 1
    }
    
    # 检查Python
    try {
        $pythonVersion = python --version 2>&1
        if ($pythonVersion -match "Python 3\.([0-9]+)") {
            $minorVersion = [int]$matches[1]
            if ($minorVersion -ge 10) {
                Write-Host "✅ Python $pythonVersion 已安装" -ForegroundColor Green
            }
            else {
                Write-Host "❌ Python 版本过低，需要 Python 3.10+" -ForegroundColor Red
                exit 1
            }
        }
        else {
            throw "Python not found"
        }
    }
    catch {
        Write-Host "❌ Python 未安装，请先安装 Python 3.10+" -ForegroundColor Red
        Write-Host "下载地址: https://www.python.org/downloads/" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "✅ 系统要求检查通过" -ForegroundColor Green
}

# 克隆AutoGen仓库
function Get-AutoGenRepository {
    Write-Host "📥 克隆 AutoGen 官方仓库..." -ForegroundColor Yellow
    
    if (Test-Path $InstallPath) {
        $response = Read-Host "⚠️  $InstallPath 目录已存在，是否删除并重新克隆？(y/N)"
        if ($response -eq "y" -or $response -eq "Y") {
            Remove-Item -Recurse -Force $InstallPath
        }
        else {
            Write-Host "❌ 安装中止" -ForegroundColor Red
            exit 1
        }
    }
    
    git clone https://github.com/microsoft/autogen.git $InstallPath
    Set-Location $InstallPath
    Write-Host "✅ AutoGen 仓库克隆完成" -ForegroundColor Green
}

# 下载自定义配置
function Get-CustomConfiguration {
    Write-Host "📥 下载自定义模型配置..." -ForegroundColor Yellow
    
    # 下载配置文件
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/custom_models_config.yaml" -OutFile "custom_models_config.yaml"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/CLAUDE.md" -OutFile "CLAUDE.md"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/git_upload_guide.md" -OutFile "git_upload_guide.md"
        
        # 创建examples目录并下载示例文件
        New-Item -ItemType Directory -Force -Path "examples" | Out-Null
        Set-Location "examples"
        
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/README.md" -OutFile "README.md"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/simple_model_test.py" -OutFile "simple_model_test.py"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/test_custom_models.py" -OutFile "test_custom_models.py"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/coding_agent_demo.py" -OutFile "coding_agent_demo.py"
        
        Set-Location ".."
        Write-Host "✅ 自定义配置下载完成" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ 下载配置文件失败: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# 集成配置到AutoGen项目
function Set-ConfigurationIntegration {
    Write-Host "🔧 集成自定义配置到 AutoGen 项目..." -ForegroundColor Yellow
    
    Set-Location "python"
    
    # 创建符号链接 (需要管理员权限) 或复制文件
    try {
        # 尝试创建符号链接
        cmd /c mklink "model_config.yaml" "..\custom_models_config.yaml"
        cmd /c mklink /D "custom_examples" "..\examples"
    }
    catch {
        # 如果符号链接失败，则复制文件
        Copy-Item "..\custom_models_config.yaml" "model_config.yaml"
        Copy-Item "..\examples" "custom_examples" -Recurse
        Write-Host "ℹ️  使用文件复制替代符号链接" -ForegroundColor Yellow
    }
    
    Set-Location ".."
    Write-Host "✅ 配置集成完成" -ForegroundColor Green
}

# 设置Python环境
function Set-PythonEnvironment {
    Write-Host "🐍 设置 Python 环境..." -ForegroundColor Yellow
    
    Set-Location "python"
    
    # 检查并安装uv
    try {
        uv --version | Out-Null
        Write-Host "✅ uv 已安装" -ForegroundColor Green
    }
    catch {
        Write-Host "📦 安装 uv 包管理器..." -ForegroundColor Yellow
        
        # Windows安装uv
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install --id=astral-sh.uv -e
        }
        else {
            # 使用pip安装
            pip install uv
        }
    }
    
    # 安装依赖
    Write-Host "📦 安装 AutoGen 依赖 (这可能需要几分钟)..." -ForegroundColor Yellow
    uv sync --all-extras
    
    Set-Location ".."
    Write-Host "✅ Python 环境设置完成" -ForegroundColor Green
}

# 创建Windows启动脚本
function New-QuickStartScripts {
    Write-Host "📝 创建快速启动脚本..." -ForegroundColor Yellow
    
    # 创建PowerShell启动脚本
    $startScript = @'
# AutoGen 快速启动脚本 (Windows PowerShell)

Write-Host "🤖 AutoGen 自定义模型环境启动" -ForegroundColor Green
Write-Host "📋 可用的自定义模型：" -ForegroundColor Yellow
Write-Host "   • kimi_k2 - Kimi-K2 (通用对话和编程)" -ForegroundColor Cyan
Write-Host "   • deepseek_r1 - DeepSeek-R1 (复杂推理)" -ForegroundColor Cyan  
Write-Host "   • qwen3_coder - Qwen3 (专业编程)" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 快速测试命令：" -ForegroundColor Yellow
Write-Host "   python ..\examples\simple_model_test.py kimi_k2" -ForegroundColor White
Write-Host "   python ..\examples\coding_agent_demo.py" -ForegroundColor White
Write-Host ""
Write-Host "📚 详细说明：" -ForegroundColor Yellow
Write-Host "   Get-Content ..\examples\README.md" -ForegroundColor White
Write-Host ""

Set-Location python

# 激活虚拟环境
if (Test-Path ".venv\Scripts\Activate.ps1") {
    & ".venv\Scripts\Activate.ps1"
    Write-Host "✅ 虚拟环境已激活" -ForegroundColor Green
}
else {
    Write-Host "⚠️  虚拟环境未找到，请先运行 uv sync --all-extras" -ForegroundColor Yellow
}
'@

    $startScript | Out-File -FilePath "start_autogen.ps1" -Encoding UTF8
    
    # 创建批处理启动脚本
    $batchScript = @'
@echo off
echo 🤖 AutoGen 自定义模型环境启动
echo 📋 可用的自定义模型：
echo    • kimi_k2 - Kimi-K2 (通用对话和编程)
echo    • deepseek_r1 - DeepSeek-R1 (复杂推理)
echo    • qwen3_coder - Qwen3 (专业编程)
echo.
echo 🚀 快速测试命令：
echo    python ..\examples\simple_model_test.py kimi_k2
echo    python ..\examples\coding_agent_demo.py
echo.

cd python

REM 激活虚拟环境
if exist ".venv\Scripts\activate.bat" (
    call ".venv\Scripts\activate.bat"
    echo ✅ 虚拟环境已激活
) else (
    echo ⚠️  虚拟环境未找到，请先运行 uv sync --all-extras
)

cmd /k
'@

    $batchScript | Out-File -FilePath "start_autogen.bat" -Encoding ASCII
    
    # 创建模型测试脚本
    $testScript = @'
# 快速测试所有模型 (Windows PowerShell)

Write-Host "🧪 测试自定义模型..." -ForegroundColor Green
Write-Host ""

Set-Location python

# 激活虚拟环境
if (Test-Path ".venv\Scripts\Activate.ps1") {
    & ".venv\Scripts\Activate.ps1"
}

# 测试每个模型
$models = @("kimi_k2", "deepseek_r1", "qwen3_coder")

foreach ($model in $models) {
    Write-Host "📡 测试 $model..." -ForegroundColor Yellow
    
    # 使用超时测试模型
    $job = Start-Job -ScriptBlock { 
        param($m) 
        Set-Location $using:PWD
        python "..\examples\simple_model_test.py" $m 
    } -ArgumentList $model
    
    if (Wait-Job $job -Timeout 30) {
        Receive-Job $job
    } else {
        Write-Host "⏱️  $model 测试超时" -ForegroundColor Yellow
        Stop-Job $job
    }
    Remove-Job $job
    Write-Host ""
}

Write-Host "✅ 模型测试完成" -ForegroundColor Green
'@

    $testScript | Out-File -FilePath "test_models.ps1" -Encoding UTF8
    
    Write-Host "✅ 快速启动脚本创建完成" -ForegroundColor Green
}

# 创建环境变量模板
function New-EnvironmentTemplate {
    Write-Host "🔑 创建环境变量模板..." -ForegroundColor Yellow
    
    $envTemplate = @'
# AutoGen 自定义模型 API 密钥配置 (Windows)
# 复制此文件为 .env 并填入你的实际 API 密钥

# Kimi-K2 (Moonshot AI)
MOONSHOT_API_KEY=sk-5WRXcCdiP1HoPDRwpcKnF0Zi5b9th6q12mF50KqBDJrUc62y

# DeepSeek-R1
DEEPSEEK_API_KEY=sk-17269fe512b74407b22f5c926a216bf1

# Qwen3 (阿里云通义千问)
DASHSCOPE_API_KEY=sk-829bda5565e04302b9bd5a088f0247c3

# Windows 使用方法：
# 1. 复制此文件：Copy-Item .env.template .env
# 2. 或者直接设置环境变量：
#    $env:MOONSHOT_API_KEY="your-key-here"
# 3. 在代码中使用：python examples\simple_model_test.py kimi_k2
'@

    $envTemplate | Out-File -FilePath ".env.template" -Encoding UTF8
    Write-Host "✅ 环境变量模板创建完成" -ForegroundColor Green
}

# 显示完成信息
function Show-CompletionInfo {
    Write-Host ""
    Write-Host "🎉 AutoGen 自定义模型配置安装完成！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 项目结构：" -ForegroundColor Yellow
    Write-Host "   autogen\                    # 完整的AutoGen项目"
    Write-Host "   ├── custom_models_config.yaml   # 三个模型配置"
    Write-Host "   ├── examples\               # 示例和演示脚本"
    Write-Host "   ├── python\                 # Python AutoGen实现"
    Write-Host "   ├── dotnet\                 # .NET AutoGen实现"
    Write-Host "   ├── start_autogen.ps1       # PowerShell启动脚本"
    Write-Host "   ├── start_autogen.bat       # 批处理启动脚本"
    Write-Host "   └── test_models.ps1         # 模型测试脚本"
    Write-Host ""
    Write-Host "🚀 快速开始 (PowerShell)：" -ForegroundColor Yellow
    Write-Host "   cd autogen"
    Write-Host "   .\start_autogen.ps1         # 启动AutoGen环境"
    Write-Host "   .\test_models.ps1           # 测试所有模型"
    Write-Host ""
    Write-Host "🚀 快速开始 (命令提示符)：" -ForegroundColor Yellow
    Write-Host "   cd autogen"
    Write-Host "   start_autogen.bat           # 启动AutoGen环境"
    Write-Host ""
    Write-Host "🎯 测试单个模型：" -ForegroundColor Yellow
    Write-Host "   .\start_autogen.ps1"
    Write-Host "   python ..\examples\simple_model_test.py kimi_k2"
    Write-Host ""
    Write-Host "💻 编程协作演示：" -ForegroundColor Yellow
    Write-Host "   .\start_autogen.ps1"
    Write-Host "   python ..\examples\coding_agent_demo.py"
    Write-Host ""
    Write-Host "📚 详细文档：" -ForegroundColor Yellow
    Write-Host "   Get-Content examples\README.md"
    Write-Host "   Get-Content CLAUDE.md"
    Write-Host ""
    Write-Host "💡 如果遇到执行策略问题，请以管理员身份运行：" -ForegroundColor Yellow
    Write-Host "   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
    Write-Host ""
}

# 主函数
function Main {
    try {
        Test-Requirements
        Get-AutoGenRepository
        Get-CustomConfiguration
        Set-ConfigurationIntegration
        Set-PythonEnvironment
        New-QuickStartScripts
        New-EnvironmentTemplate
        Show-CompletionInfo
    }
    catch {
        Write-Host "❌ 安装过程中出现错误: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "请检查网络连接和权限设置，然后重新运行脚本。" -ForegroundColor Yellow
        exit 1
    }
}

# 运行安装
Main