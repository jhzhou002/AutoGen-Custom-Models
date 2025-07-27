# 🚀 AutoGen 自定义模型一键安装指南 (Windows)

## 📋 概述

为Windows用户提供的AutoGen自定义模型配置安装脚本，支持PowerShell和命令提示符两种环境。

## ⚡ 一键安装

### 方法1：PowerShell (推荐)

```powershell
# 下载并运行PowerShell安装脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/setup_autogen_custom.ps1" -OutFile "setup_autogen_custom.ps1"
.\setup_autogen_custom.ps1
```

### 方法2：命令提示符

```cmd
REM 下载并运行批处理安装脚本
curl -L -o setup_autogen_custom.bat https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/setup_autogen_custom.bat
setup_autogen_custom.bat
```

### 方法3：手动下载

1. 访问 https://github.com/jhzhou002/AutoGen-Custom-Models
2. 下载 `setup_autogen_custom.ps1` 或 `setup_autogen_custom.bat`
3. 在下载目录中右键选择"在此处打开PowerShell"或"在此处打开命令提示符"
4. 运行相应的脚本

## 🔧 系统要求

- **Windows 10/11**
- **Git for Windows** - [下载地址](https://git-scm.com/download/win)
- **Python 3.10+** - [下载地址](https://www.python.org/downloads/)
- **PowerShell 5.0+** (Windows 10内置) 或 **命令提示符**

## 🎯 安装完成后的使用

### 📁 项目结构
```
autogen/
├── custom_models_config.yaml   # 三个模型的完整配置
├── examples/                   # 示例和演示脚本
│   ├── README.md              # 详细使用说明
│   ├── simple_model_test.py   # 快速单模型测试
│   ├── test_custom_models.py  # 完整测试套件
│   └── coding_agent_demo.py   # 多代理编程协作演示
├── python/                     # Python AutoGen实现
├── dotnet/                     # .NET AutoGen实现
├── start_autogen.ps1          # PowerShell启动脚本
├── start_autogen.bat          # 批处理启动脚本
├── test_models.ps1            # PowerShell模型测试脚本
└── .env.template              # 环境变量模板
```

### 🚀 快速开始

#### 使用PowerShell (推荐)
```powershell
# 进入项目目录
cd autogen

# 启动AutoGen环境
.\start_autogen.ps1

# 在激活的环境中测试模型
python ..\examples\simple_model_test.py kimi_k2
```

#### 使用命令提示符
```cmd
REM 进入项目目录
cd autogen

REM 启动AutoGen环境
start_autogen.bat

REM 在激活的环境中测试模型
python ..\examples\simple_model_test.py kimi_k2
```

### 🧪 测试所有模型

#### PowerShell
```powershell
cd autogen
.\test_models.ps1
```

#### 命令提示符
```cmd
cd autogen
start_autogen.bat
python ..\examples\simple_model_test.py kimi_k2
python ..\examples\simple_model_test.py deepseek_r1
python ..\examples\simple_model_test.py qwen3_coder
```

### 💻 编程协作演示

```powershell
cd autogen
.\start_autogen.ps1
python ..\examples\coding_agent_demo.py
```

## 🔧 已配置的模型

### 1. Kimi-K2 (kimi-k2-0711-preview)
- **专长**: 通用对话、编程、文档理解
- **API**: Moonshot AI
- **用途**: 架构设计、需求分析、文档生成

### 2. DeepSeek-R1 (deepseek-reasoner)
- **专长**: 复杂推理、逻辑分析、数学问题
- **API**: DeepSeek AI
- **用途**: 代码审查、问题诊断、算法优化

### 3. Qwen3 (qwen3-coder-plus)
- **专长**: 代码生成、程序调试、技术实现
- **API**: 阿里云通义千问
- **用途**: 具体编程任务、代码实现、技术细节

## 📚 使用示例

### 单模型快速测试
```cmd
REM 测试Kimi-K2
python examples\simple_model_test.py kimi_k2

REM 测试DeepSeek-R1
python examples\simple_model_test.py deepseek_r1

REM 测试Qwen3
python examples\simple_model_test.py qwen3_coder
```

### 多代理协作编程
```cmd
REM 运行编程团队协作演示
python examples\coding_agent_demo.py
```

### 完整测试套件
```cmd
REM 运行所有模型的完整测试
python examples\test_custom_models.py
```

## 🔑 API密钥配置

### 方法1：使用配置文件 (默认)
配置文件中已包含预设的API密钥，可直接使用。

### 方法2：环境变量 (推荐生产环境)
```powershell
# PowerShell设置环境变量
$env:MOONSHOT_API_KEY="your-kimi-key-here"
$env:DEEPSEEK_API_KEY="your-deepseek-key-here"  
$env:DASHSCOPE_API_KEY="your-qwen-key-here"
```

```cmd
REM 命令提示符设置环境变量
set MOONSHOT_API_KEY=your-kimi-key-here
set DEEPSEEK_API_KEY=your-deepseek-key-here
set DASHSCOPE_API_KEY=your-qwen-key-here
```

### 方法3：使用.env文件
```cmd
REM 复制环境变量模板
copy .env.template .env

REM 编辑.env文件填入你的API密钥
notepad .env
```

## 🛠️ 手动开发环境设置

如果你想手动设置开发环境：

```powershell
cd autogen\python

# 激活虚拟环境
.\.venv\Scripts\Activate.ps1

# 运行代码检查 (需要安装poethepoet)
poe check

# 运行测试
poe test
```

## ⚠️ 常见问题和解决方案

### Q: PowerShell执行策略错误
```powershell
# 以管理员身份运行PowerShell，然后执行：
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Q: uv安装失败
```cmd
REM 使用pip作为备选方案
pip install uv

REM 或者手动安装AutoGen依赖
pip install -e python/ --all-extras
```

### Q: Git克隆速度慢
```cmd
REM 使用中国镜像加速
git config --global url."https://gitclone.com/github.com/".insteadOf "https://github.com/"
```

### Q: Python虚拟环境激活失败
```cmd
REM 检查Python安装路径
where python

REM 手动创建虚拟环境
python -m venv .venv
.venv\Scripts\activate.bat
```

### Q: 下载文件失败
```powershell
# 检查网络连接，或手动下载文件
# 从 https://github.com/jhzhou002/AutoGen-Custom-Models 下载所需文件
```

## 📖 详细文档

- **使用说明**: `examples\README.md`
- **开发指南**: `CLAUDE.md`
- **故障排除**: `git_upload_guide.md`

## 🔄 更新配置

要获取最新的配置，重新运行安装脚本即可：

```powershell
.\setup_autogen_custom.ps1
```

---

**🎊 享受你的Windows AutoGen多模型开发体验吧！**