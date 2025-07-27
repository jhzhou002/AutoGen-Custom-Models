# 🚀 AutoGen 自定义模型一键安装指南

## 📋 概述

这个安装脚本会自动为你设置完整的AutoGen项目，并集成Kimi-K2、DeepSeek-R1和Qwen3三个自定义模型配置。

## ⚡ 一键安装

### 方法1：直接运行安装脚本

```bash
# 下载并运行安装脚本
curl -L https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/setup_autogen_custom.sh | bash
```

### 方法2：手动下载安装

```bash
# 下载安装脚本
wget https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/setup_autogen_custom.sh

# 给执行权限
chmod +x setup_autogen_custom.sh

# 运行安装
./setup_autogen_custom.sh
```

## 🎯 安装完成后的使用

安装完成后，你将获得一个完整的AutoGen项目，包含：

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
├── start_autogen.sh           # 快速启动脚本
├── test_models.sh             # 模型测试脚本
└── .env.template              # 环境变量模板
```

### 🚀 快速开始

```bash
# 进入项目目录
cd autogen

# 启动AutoGen环境
./start_autogen.sh

# 在激活的环境中测试模型
python ../examples/simple_model_test.py kimi_k2
```

### 🧪 测试所有模型

```bash
cd autogen
./test_models.sh
```

### 💻 编程协作演示

```bash
cd autogen
./start_autogen.sh
python ../examples/coding_agent_demo.py
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
```bash
# 测试Kimi-K2
python examples/simple_model_test.py kimi_k2

# 测试DeepSeek-R1
python examples/simple_model_test.py deepseek_r1

# 测试Qwen3
python examples/simple_model_test.py qwen3_coder
```

### 多代理协作编程
```bash
# 运行编程团队协作演示
python examples/coding_agent_demo.py
```

### 完整测试套件
```bash
# 运行所有模型的完整测试
python examples/test_custom_models.py
```

## 🔑 API密钥配置

安装脚本会创建 `.env.template` 文件，其中包含了预配置的API密钥。如果你想使用环境变量：

```bash
# 复制环境变量模板
cp .env.template .env

# 编辑API密钥（可选）
nano .env
```

## 🛠️ 手动开发环境设置

如果你想手动设置开发环境：

```bash
cd autogen/python

# 激活虚拟环境
source .venv/bin/activate

# 运行代码检查
poe check

# 运行测试
poe test
```

## 📖 详细文档

- **使用说明**: `examples/README.md`
- **开发指南**: `CLAUDE.md`
- **故障排除**: `git_upload_guide.md`

## 🆘 常见问题

### Q: 安装失败怎么办？
A: 检查网络连接，确保有git和python3，重新运行安装脚本

### Q: 模型测试失败？
A: 检查API密钥是否正确，网络是否可以访问对应的API服务

### Q: 如何更新配置？
A: 重新运行安装脚本即可更新到最新配置

---

**🎊 享受你的AutoGen多模型之旅吧！**