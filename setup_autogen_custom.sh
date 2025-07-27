#!/bin/bash

# AutoGen 自定义模型配置安装脚本
# 自动下载AutoGen项目并集成Kimi-K2、DeepSeek-R1、Qwen3模型配置

set -e

echo "🚀 AutoGen 自定义模型配置安装脚本"
echo "========================================"

# 检查必要工具
check_requirements() {
    echo "📋 检查系统要求..."
    
    if ! command -v git &> /dev/null; then
        echo "❌ Git 未安装，请先安装 Git"
        exit 1
    fi
    
    if ! command -v python3 &> /dev/null; then
        echo "❌ Python3 未安装，请先安装 Python 3.10+"
        exit 1
    fi
    
    echo "✅ 系统要求检查通过"
}

# 克隆AutoGen仓库
clone_autogen() {
    echo "📥 克隆 AutoGen 官方仓库..."
    
    if [ -d "autogen" ]; then
        echo "⚠️  autogen 目录已存在，是否删除并重新克隆？(y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            rm -rf autogen
        else
            echo "❌ 安装中止"
            exit 1
        fi
    fi
    
    git clone https://github.com/microsoft/autogen.git
    cd autogen
    echo "✅ AutoGen 仓库克隆完成"
}

# 下载自定义配置
download_custom_config() {
    echo "📥 下载自定义模型配置..."
    
    # 从你的GitHub仓库下载配置文件
    curl -L -o custom_models_config.yaml https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/custom_models_config.yaml
    curl -L -o CLAUDE.md https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/CLAUDE.md
    curl -L -o git_upload_guide.md https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/git_upload_guide.md
    
    # 创建examples目录并下载示例文件
    mkdir -p examples
    cd examples
    curl -L -o README.md https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/README.md
    curl -L -o simple_model_test.py https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/simple_model_test.py
    curl -L -o test_custom_models.py https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/test_custom_models.py
    curl -L -o coding_agent_demo.py https://raw.githubusercontent.com/jhzhou002/AutoGen-Custom-Models/main/examples/coding_agent_demo.py
    cd ..
    
    echo "✅ 自定义配置下载完成"
}

# 集成配置到AutoGen项目
integrate_config() {
    echo "🔧 集成自定义配置到 AutoGen 项目..."
    
    # 在python目录创建自定义模型配置的软链接
    cd python
    if [ ! -f "../custom_models_config.yaml" ]; then
        echo "❌ 自定义配置文件未找到"
        exit 1
    fi
    
    ln -sf ../custom_models_config.yaml ./model_config.yaml
    ln -sf ../examples ./custom_examples
    
    echo "✅ 配置集成完成"
}

# 设置Python环境
setup_python_env() {
    echo "🐍 设置 Python 环境..."
    
    cd python
    
    # 检查uv是否安装
    if ! command -v uv &> /dev/null; then
        echo "📦 安装 uv 包管理器..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        source ~/.bashrc || source ~/.zshrc || true
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    
    # 安装依赖
    echo "📦 安装 AutoGen 依赖..."
    uv sync --all-extras
    
    echo "✅ Python 环境设置完成"
}

# 创建快速启动脚本
create_quick_start() {
    echo "📝 创建快速启动脚本..."
    
    cat > start_autogen.sh << 'EOF'
#!/bin/bash
# AutoGen 快速启动脚本

cd python
source .venv/bin/activate

echo "🤖 AutoGen 自定义模型环境已激活"
echo "📋 可用的自定义模型："
echo "   • kimi_k2 - Kimi-K2 (通用对话和编程)"
echo "   • deepseek_r1 - DeepSeek-R1 (复杂推理)"
echo "   • qwen3_coder - Qwen3 (专业编程)"
echo ""
echo "🚀 快速测试命令："
echo "   python ../examples/simple_model_test.py kimi_k2"
echo "   python ../examples/coding_agent_demo.py"
echo ""
echo "📚 详细说明："
echo "   cat ../examples/README.md"
echo ""

# 启动Python环境
exec bash
EOF

    chmod +x start_autogen.sh
    
    cat > test_models.sh << 'EOF'
#!/bin/bash
# 快速测试所有模型

cd python
source .venv/bin/activate

echo "🧪 测试自定义模型..."
echo ""

# 测试每个模型
for model in kimi_k2 deepseek_r1 qwen3_coder; do
    echo "📡 测试 $model..."
    timeout 30 python ../examples/simple_model_test.py $model
    echo ""
done

echo "✅ 模型测试完成"
EOF

    chmod +x test_models.sh
    
    echo "✅ 快速启动脚本创建完成"
}

# 创建环境变量模板
create_env_template() {
    echo "🔑 创建环境变量模板..."
    
    cat > .env.template << 'EOF'
# AutoGen 自定义模型 API 密钥配置
# 复制此文件为 .env 并填入你的实际 API 密钥

# Kimi-K2 (Moonshot AI)
MOONSHOT_API_KEY=sk-5WRXcCdiP1HoPDRwpcKnF0Zi5b9th6q12mF50KqBDJrUc62y

# DeepSeek-R1
DEEPSEEK_API_KEY=sk-17269fe512b74407b22f5c926a216bf1

# Qwen3 (阿里云通义千问)
DASHSCOPE_API_KEY=sk-829bda5565e04302b9bd5a088f0247c3

# 使用方法：
# 1. 复制此文件：cp .env.template .env
# 2. 在代码中使用：python examples/simple_model_test.py kimi_k2
EOF

    echo "✅ 环境变量模板创建完成"
}

# 显示完成信息
show_completion_info() {
    echo ""
    echo "🎉 AutoGen 自定义模型配置安装完成！"
    echo "========================================"
    echo ""
    echo "📁 项目结构："
    echo "   autogen/                    # 完整的AutoGen项目"
    echo "   ├── custom_models_config.yaml   # 三个模型配置"
    echo "   ├── examples/               # 示例和演示脚本"
    echo "   ├── python/                 # Python AutoGen实现"
    echo "   ├── dotnet/                 # .NET AutoGen实现"
    echo "   ├── start_autogen.sh        # 快速启动脚本"
    echo "   └── test_models.sh          # 模型测试脚本"
    echo ""
    echo "🚀 快速开始："
    echo "   cd autogen"
    echo "   ./start_autogen.sh          # 启动AutoGen环境"
    echo "   ./test_models.sh            # 测试所有模型"
    echo ""
    echo "🎯 测试单个模型："
    echo "   ./start_autogen.sh"
    echo "   python ../examples/simple_model_test.py kimi_k2"
    echo ""
    echo "💻 编程协作演示："
    echo "   ./start_autogen.sh"
    echo "   python ../examples/coding_agent_demo.py"
    echo ""
    echo "📚 详细文档："
    echo "   cat examples/README.md"
    echo "   cat CLAUDE.md"
    echo ""
}

# 主函数
main() {
    check_requirements
    clone_autogen
    download_custom_config
    integrate_config
    setup_python_env
    create_quick_start
    create_env_template
    show_completion_info
}

# 运行安装
main "$@"