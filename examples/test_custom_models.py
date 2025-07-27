#!/usr/bin/env python3
"""
测试自定义模型配置的示例代码
支持 Kimi-K2, DeepSeek-R1, Qwen3 三个模型
"""

import asyncio
import yaml
from pathlib import Path
from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_agentchat.ui import Console


def load_model_config(config_file: str, model_name: str) -> dict:
    """从配置文件加载指定模型的配置"""
    with open(config_file, 'r', encoding='utf-8') as f:
        config = yaml.safe_load(f)
    
    if model_name not in config:
        raise ValueError(f"模型 {model_name} 未在配置文件中找到")
    
    return config[model_name]['config']


async def test_model(model_name: str, model_config: dict, test_message: str):
    """测试单个模型"""
    print(f"\n{'='*50}")
    print(f"测试模型: {model_name}")
    print(f"{'='*50}")
    
    try:
        # 创建模型客户端
        model_client = OpenAIChatCompletionClient(**model_config)
        
        # 创建助手代理
        agent = AssistantAgent(
            name=f"{model_name}_assistant",
            model_client=model_client,
            system_message=f"你是一个基于{model_name}模型的AI助手，擅长编程和问题解决。"
        )
        
        # 发送测试消息
        print(f"发送消息: {test_message}")
        print("-" * 30)
        
        response = await agent.run(task=test_message)
        print(f"模型回复: {response.messages[-1].content}")
        
        # 关闭客户端
        await model_client.close()
        
        print(f"✅ {model_name} 测试成功!")
        
    except Exception as e:
        print(f"❌ {model_name} 测试失败: {str(e)}")


async def test_coding_capability(model_name: str, model_config: dict):
    """测试模型的编程能力"""
    coding_task = """
    请编写一个Python函数来计算斐波那契数列的第n项，要求:
    1. 使用递归方式实现
    2. 添加记忆化优化避免重复计算
    3. 包含详细的注释
    4. 提供使用示例
    """
    
    print(f"\n{'='*50}")
    print(f"测试 {model_name} 编程能力")
    print(f"{'='*50}")
    
    try:
        model_client = OpenAIChatCompletionClient(**model_config)
        
        agent = AssistantAgent(
            name=f"{model_name}_coder",
            model_client=model_client,
            system_message="你是一个专业的Python程序员，擅长编写高质量、高效的代码。"
        )
        
        response = await agent.run(task=coding_task)
        print(f"编程任务回复:\n{response.messages[-1].content}")
        
        await model_client.close()
        print(f"✅ {model_name} 编程能力测试完成!")
        
    except Exception as e:
        print(f"❌ {model_name} 编程能力测试失败: {str(e)}")


async def test_multi_agent_conversation():
    """测试多代理对话 - 使用不同模型的代理进行协作"""
    print(f"\n{'='*50}")
    print("多代理协作测试")
    print(f"{'='*50}")
    
    config_file = Path(__file__).parent.parent / "custom_models_config.yaml"
    
    try:
        # 加载配置
        kimi_config = load_model_config(str(config_file), "kimi_k2")
        qwen_config = load_model_config(str(config_file), "qwen3_coder")
        
        # 创建模型客户端
        kimi_client = OpenAIChatCompletionClient(**kimi_config)
        qwen_client = OpenAIChatCompletionClient(**qwen_config)
        
        # 创建代理
        architect = AssistantAgent(
            name="architect",
            model_client=kimi_client,
            system_message="你是一个软件架构师，负责设计程序的整体架构和接口。"
        )
        
        coder = AssistantAgent(
            name="coder", 
            model_client=qwen_client,
            system_message="你是一个程序员，负责根据架构设计实现具体代码。"
        )
        
        from autogen_agentchat.teams import RoundRobinGroupChat
        from autogen_agentchat.conditions import MaxMessageTermination
        
        # 创建团队
        team = RoundRobinGroupChat([architect, coder])
        
        # 任务
        task = """
        设计并实现一个简单的任务管理系统，要求:
        1. 可以添加、删除、更新任务
        2. 支持任务优先级
        3. 可以按状态过滤任务
        4. 请先讨论架构设计，然后实现代码
        """
        
        print("开始多代理协作...")
        
        # 使用 Console UI 进行交互
        result = await Console(
            team.run_stream(
                task=task,
                termination_condition=MaxMessageTermination(max_messages=6)
            )
        )
        
        # 关闭客户端
        await kimi_client.close()
        await qwen_client.close()
        
        print("✅ 多代理协作测试完成!")
        
    except Exception as e:
        print(f"❌ 多代理协作测试失败: {str(e)}")


async def main():
    """主函数"""
    print("🚀 开始测试自定义模型配置...")
    
    # 配置文件路径
    config_file = Path(__file__).parent.parent / "custom_models_config.yaml"
    
    if not config_file.exists():
        print(f"❌ 配置文件未找到: {config_file}")
        return
    
    # 测试消息
    test_message = "你好！请简单介绍一下你的能力，特别是在编程方面的专长。"
    
    # 测试每个模型
    models_to_test = ["kimi_k2", "deepseek_r1", "qwen3_coder"]
    
    for model_name in models_to_test:
        try:
            model_config = load_model_config(str(config_file), model_name)
            await test_model(model_name, model_config, test_message)
        except Exception as e:
            print(f"❌ 无法加载 {model_name} 配置: {str(e)}")
    
    # 测试编程能力 (重点测试 Kimi-K2 和 Qwen3)
    for model_name in ["kimi_k2", "qwen3_coder"]:
        try:
            model_config = load_model_config(str(config_file), model_name)
            await test_coding_capability(model_name, model_config)
        except Exception as e:
            print(f"❌ 无法测试 {model_name} 编程能力: {str(e)}")
    
    # 测试多代理协作
    await test_multi_agent_conversation()
    
    print(f"\n{'='*50}")
    print("🎉 所有测试完成!")
    print(f"{'='*50}")


if __name__ == "__main__":
    asyncio.run(main())