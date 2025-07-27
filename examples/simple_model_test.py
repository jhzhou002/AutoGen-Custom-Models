#!/usr/bin/env python3
"""
简单的单模型测试示例
可以快速测试任意一个配置的模型
"""

import asyncio
import yaml
from pathlib import Path
from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient


async def simple_test(model_name: str = "kimi_k2"):
    """
    简单测试指定模型
    
    Args:
        model_name: 模型名称，可选: kimi_k2, deepseek_r1, qwen3_coder
    """
    
    # 配置文件路径
    config_file = Path(__file__).parent.parent / "custom_models_config.yaml"
    
    # 加载配置
    with open(config_file, 'r', encoding='utf-8') as f:
        config = yaml.safe_load(f)
    
    model_config = config[model_name]['config']
    
    print(f"🤖 使用模型: {model_name}")
    print(f"📋 模型详情: {model_config['model']}")
    print(f"🌐 API地址: {model_config['base_url']}")
    print("-" * 50)
    
    # 创建模型客户端
    model_client = OpenAIChatCompletionClient(**model_config)
    
    # 创建助手代理
    agent = AssistantAgent(
        name="assistant",
        model_client=model_client,
        system_message="你是一个友好且专业的AI助手，特别擅长编程和技术问题解答。"
    )
    
    # 测试对话
    test_messages = [
        "你好！请简单介绍一下你的能力。",
        "请用Python写一个计算两个数字最大公约数的函数。",
        "解释一下什么是递归，并给出一个简单的例子。"
    ]
    
    for i, message in enumerate(test_messages, 1):
        print(f"\n💬 测试 {i}: {message}")
        print("🤖 回复:")
        
        try:
            response = await agent.run(task=message)
            print(response.messages[-1].content)
            print("\n" + "="*80)
            
        except Exception as e:
            print(f"❌ 错误: {str(e)}")
            break
    
    # 关闭客户端
    await model_client.close()
    print(f"\n✅ {model_name} 测试完成!")


if __name__ == "__main__":
    import sys
    
    # 支持命令行参数指定模型
    model_name = sys.argv[1] if len(sys.argv) > 1 else "kimi_k2"
    
    print(f"🚀 开始测试模型: {model_name}")
    print("📝 支持的模型: kimi_k2, deepseek_r1, qwen3_coder")
    print("💡 使用方法: python simple_model_test.py [model_name]")
    print("="*80)
    
    asyncio.run(simple_test(model_name))