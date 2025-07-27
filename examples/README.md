# AutoGen 自定义模型配置指南

本目录包含了在AutoGen中使用 Kimi-K2、DeepSeek-R1 和 Qwen3 模型的完整配置和示例。

## 📁 文件说明

```
examples/
├── README.md                    # 本说明文件
├── simple_model_test.py         # 简单的单模型测试
├── test_custom_models.py        # 完整的模型测试套件
├── coding_agent_demo.py         # 编程代理协作演示
└── custom_models_config.yaml    # 模型配置文件
```

## 🚀 快速开始

### 1. 环境准备

确保你已经安装了AutoGen和相关依赖：

```bash
cd python
uv sync --all-extras
source .venv/bin/activate
```

### 2. 配置文件

配置文件 `../custom_models_config.yaml` 包含了三个模型的完整配置：

- **kimi_k2**: Moonshot AI 的 Kimi-K2 模型，擅长编程和推理
- **deepseek_r1**: DeepSeek 的推理模型，专注于复杂推理任务
- **qwen3_coder**: 阿里云通义千问的编程专用模型

### 3. 运行示例

#### 简单测试（推荐新手）

```bash
# 测试 Kimi-K2 模型
python examples/simple_model_test.py kimi_k2

# 测试 DeepSeek-R1 模型  
python examples/simple_model_test.py deepseek_r1

# 测试 Qwen3 模型
python examples/simple_model_test.py qwen3_coder
```

#### 完整测试套件

```bash
# 运行所有模型的完整测试
python examples/test_custom_models.py
```

#### 编程协作演示

```bash
# 多代理编程协作演示
python examples/coding_agent_demo.py
```

## 🛠️ 在自己的项目中使用

### 方法1: 直接使用配置

```python
import yaml
from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient

# 加载配置
with open('custom_models_config.yaml', 'r') as f:
    config = yaml.safe_load(f)

# 使用 Kimi-K2 模型
model_config = config['kimi_k2']['config']
model_client = OpenAIChatCompletionClient(**model_config)

agent = AssistantAgent(
    name="kimi_assistant",
    model_client=model_client,
    system_message="你是一个编程助手"
)
```

### 方法2: 环境变量方式（推荐）

首先设置环境变量：

```bash
export MOONSHOT_API_KEY="your-kimi-api-key"
export DEEPSEEK_API_KEY="your-deepseek-api-key"  
export DASHSCOPE_API_KEY="your-qwen-api-key"
```

然后使用环境变量配置：

```python
import os
from autogen_ext.models.openai import OpenAIChatCompletionClient

# Kimi-K2 模型
kimi_client = OpenAIChatCompletionClient(
    model="kimi-k2-0711-preview",
    api_key=os.getenv("MOONSHOT_API_KEY"),
    base_url="https://api.moonshot.cn/v1",
    temperature=0.6
)

# DeepSeek-R1 模型
deepseek_client = OpenAIChatCompletionClient(
    model="deepseek-reasoner", 
    api_key=os.getenv("DEEPSEEK_API_KEY"),
    base_url="https://api.deepseek.com",
    temperature=0.3
)

# Qwen3 模型
qwen_client = OpenAIChatCompletionClient(
    model="qwen3-coder-plus",
    api_key=os.getenv("DASHSCOPE_API_KEY"), 
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
    temperature=0.1
)
```

## 🎯 模型特点和使用建议

### Kimi-K2 (kimi-k2-0711-preview)
- **擅长**: 通用对话、编程、文档理解
- **建议用途**: 架构设计、需求分析、文档生成
- **温度设置**: 0.6 (平衡创造性和准确性)

### DeepSeek-R1 (deepseek-reasoner)  
- **擅长**: 复杂推理、逻辑分析、数学问题
- **建议用途**: 代码审查、问题诊断、算法优化
- **温度设置**: 0.3 (注重准确性)

### Qwen3 (qwen3-coder-plus)
- **擅长**: 代码生成、程序调试、技术实现
- **建议用途**: 具体编程任务、代码实现、技术细节
- **温度设置**: 0.1 (高精度代码生成)

## 🔧 高级配置

### 自定义模型参数

你可以根据需要调整模型参数：

```yaml
custom_model:
  provider: autogen_ext.models.openai.OpenAIChatCompletionClient
  config:
    model: "your-model-name"
    api_key: "your-api-key"
    base_url: "your-api-endpoint"
    temperature: 0.7          # 0-1，控制随机性
    max_tokens: 4096          # 最大输出长度
    top_p: 0.9               # 核采样参数
    frequency_penalty: 0.0    # 重复惩罚
    presence_penalty: 0.0     # 存在惩罚
    timeout: 30.0            # 请求超时时间
    max_retries: 3           # 最大重试次数
```

### 多代理协作模式

利用不同模型的优势进行协作：

```python
from autogen_agentchat.teams import RoundRobinGroupChat

# 创建专门的角色代理
architect = AssistantAgent("architect", kimi_client, "架构师角色")
coder = AssistantAgent("coder", qwen_client, "程序员角色")  
reviewer = AssistantAgent("reviewer", deepseek_client, "审查员角色")

# 创建协作团队
team = RoundRobinGroupChat([architect, coder, reviewer])
```

## 🐛 常见问题

### Q: API密钥错误
**A**: 检查API密钥是否正确，确保没有多余的空格或换行符

### Q: 网络连接超时
**A**: 检查网络连接，可以尝试增加timeout参数

### Q: 模型返回错误
**A**: 检查模型名称是否正确，API版本是否匹配

### Q: 依赖包问题
**A**: 确保安装了正确版本的autogen包：
```bash
pip install -U "autogen-agentchat" "autogen-ext[openai]"
```

## 📚 更多资源

- [AutoGen 官方文档](https://microsoft.github.io/autogen/)
- [Moonshot AI API文档](https://platform.moonshot.cn/docs)
- [DeepSeek API文档](https://platform.deepseek.com/docs)
- [通义千问API文档](https://help.aliyun.com/zh/dashscope/)

## 💡 贡献和反馈

如果你发现问题或有改进建议，欢迎：
1. 提交Issue或Pull Request
2. 分享你的使用经验
3. 贡献更多的示例代码

---

**开始你的AutoGen多模型之旅吧！** 🚀