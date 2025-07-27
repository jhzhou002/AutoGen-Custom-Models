# Git 上传指南

## 🚀 快速上传到GitHub

### 选项1：修复现有仓库推送

如果你想继续使用现有的 AutoGen 仓库：

```bash
# 1. 检查当前状态
git status

# 2. 强制推送我们的分支（覆盖远程仓库）
git push --force myfork custom-models-config

# 3. 如果网络问题持续，尝试分次推送单个文件
git add CLAUDE.md
git commit -m "Add CLAUDE.md"
git push myfork custom-models-config

git add custom_models_config.yaml  
git commit -m "Add custom models config"
git push myfork custom-models-config

git add examples/
git commit -m "Add examples directory"
git push myfork custom-models-config
```

### 选项2：创建新的GitHub仓库

1. 访问 https://github.com/new
2. 仓库名：`AutoGen-Custom-Models`
3. 勾选 "Add a README file"
4. 点击 "Create repository"

然后在本地执行：

```bash
# 1. 添加新的远程仓库
git remote add newrepo https://github.com/jhzhou002/AutoGen-Custom-Models.git

# 2. 推送我们的分支
git push newrepo custom-models-config

# 3. 设置为默认分支（可选）
git push newrepo custom-models-config:main
```

### 选项3：使用GitHub Desktop

1. 下载并安装 GitHub Desktop
2. 克隆你的仓库到本地
3. 手动复制以下文件到仓库目录：
   - `CLAUDE.md`
   - `custom_models_config.yaml`
   - `examples/` 目录（包含所有子文件）
4. 在GitHub Desktop中提交并推送

## 📁 需要上传的文件清单

```
AutoGen/
├── CLAUDE.md                           # 开发指南
├── custom_models_config.yaml           # 模型配置文件
└── examples/                           # 示例目录
    ├── README.md                       # 使用说明
    ├── simple_model_test.py            # 简单测试
    ├── test_custom_models.py           # 完整测试套件
    └── coding_agent_demo.py            # 编程协作演示
```

## 🔧 如果推送仍然失败

### 网络问题解决方案：

```bash
# 增加缓冲区大小
git config --global http.postBuffer 524288000

# 设置代理（如果你使用代理）
git config --global http.proxy http://proxy-server:port

# 使用SSH替代HTTPS（需要设置SSH密钥）
git remote set-url myfork git@github.com:jhzhou002/AutoGen.git
```

### 分步骤上传：

```bash
# 只上传最重要的文件
git add CLAUDE.md custom_models_config.yaml
git commit -m "Add core configuration files"
git push myfork custom-models-config

# 然后上传示例
git add examples/
git commit -m "Add examples directory" 
git push myfork custom-models-config
```

## 📝 提交信息模板

如果你需要重新提交，可以使用这个消息：

```
Add custom model configurations for Kimi-K2, DeepSeek-R1, and Qwen3

Features:
- CLAUDE.md: Comprehensive AutoGen development guide
- custom_models_config.yaml: Three model configurations
- examples/: Demo scripts and documentation

Models configured:
- Kimi-K2 (kimi-k2-0711-preview): General coding and conversation
- DeepSeek-R1 (deepseek-reasoner): Complex reasoning tasks  
- Qwen3 (qwen3-coder-plus): Specialized coding tasks

🤖 Generated with Claude Code
```

## ✅ 验证上传成功

上传完成后，你应该能在GitHub仓库中看到：

1. 根目录下的 `CLAUDE.md` 和 `custom_models_config.yaml`
2. `examples/` 目录包含4个文件
3. 文件内容完整且格式正确

## 🆘 如果还有问题

如果上述方法都不行，你可以：

1. 使用我创建的压缩包 `autogen-custom-models.tar.gz`
2. 解压后手动上传文件到GitHub网页界面
3. 或者尝试使用 GitHub CLI: `gh repo create AutoGen-Custom-Models --public`