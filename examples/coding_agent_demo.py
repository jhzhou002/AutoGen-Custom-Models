#!/usr/bin/env python3
"""
编程代理演示 - 展示 Kimi-K2 和 Qwen3 的编程能力
"""

import asyncio
import yaml
from pathlib import Path
from autogen_agentchat.agents import AssistantAgent
from autogen_ext.models.openai import OpenAIChatCompletionClient
from autogen_agentchat.teams import RoundRobinGroupChat
from autogen_agentchat.conditions import MaxMessageTermination
from autogen_agentchat.ui import Console


async def create_coding_agents():
    """创建编程相关的代理"""
    
    # 配置文件路径
    config_file = Path(__file__).parent.parent / "custom_models_config.yaml"
    
    with open(config_file, 'r', encoding='utf-8') as f:
        config = yaml.safe_load(f)
    
    # 创建 Kimi-K2 架构师
    kimi_config = config['kimi_k2']['config']
    kimi_client = OpenAIChatCompletionClient(**kimi_config)
    
    architect = AssistantAgent(
        name="架构师",
        model_client=kimi_client,
        system_message="""你是一个资深的软件架构师，具备以下能力：
1. 分析需求并设计合理的系统架构
2. 选择合适的设计模式和技术栈
3. 考虑代码的可维护性、可扩展性和性能
4. 提供清晰的架构图和接口设计
请用中文回复，并保持专业和详细。"""
    )
    
    # 创建 Qwen3 程序员
    qwen_config = config['qwen3_coder']['config']
    qwen_client = OpenAIChatCompletionClient(**qwen_config)
    
    programmer = AssistantAgent(
        name="程序员",
        model_client=qwen_client,
        system_message="""你是一个专业的Python程序员，具备以下能力：
1. 根据架构设计实现高质量的代码
2. 遵循Python最佳实践和PEP规范
3. 编写清晰的注释和文档字符串
4. 进行适当的错误处理和边界检查
5. 提供使用示例和测试代码
请用中文回复，代码要完整且可执行。"""
    )
    
    # 创建 DeepSeek-R1 审查员（用于代码审查）
    deepseek_config = config['deepseek_r1']['config']
    deepseek_client = OpenAIChatCompletionClient(**deepseek_config)
    
    reviewer = AssistantAgent(
        name="代码审查员",
        model_client=deepseek_client,
        system_message="""你是一个代码审查专家，具备以下能力：
1. 审查代码的正确性、性能和安全性
2. 识别潜在的bug和改进点
3. 检查代码是否符合最佳实践
4. 提供具体的改进建议
5. 评估代码的可读性和维护性
请用中文回复，提供详细的审查意见。"""
    )
    
    return architect, programmer, reviewer, [kimi_client, qwen_client, deepseek_client]


async def coding_collaboration_demo():
    """编程协作演示"""
    
    print("🚀 启动编程团队协作演示...")
    print("👥 团队成员:")
    print("   🏗️  架构师 (Kimi-K2) - 负责系统设计")
    print("   💻 程序员 (Qwen3) - 负责代码实现") 
    print("   🔍 审查员 (DeepSeek-R1) - 负责代码审查")
    print("="*80)
    
    # 创建代理
    architect, programmer, reviewer, clients = await create_coding_agents()
    
    # 创建团队
    team = RoundRobinGroupChat([architect, programmer, reviewer])
    
    # 编程任务
    task = """
    设计并实现一个学生成绩管理系统，要求：

    功能需求：
    1. 添加学生信息（姓名、学号、班级）
    2. 录入成绩（科目、分数）
    3. 计算学生平均分和总分
    4. 按成绩排序显示学生列表
    5. 查询指定学生的成绩详情
    6. 统计各科目的平均分

    技术要求：
    1. 使用面向对象编程
    2. 数据持久化（文件或数据库）
    3. 异常处理
    4. 提供命令行界面
    5. 代码结构清晰，注释完整

    请按以下流程进行：
    1. 架构师：分析需求，设计系统架构和类结构
    2. 程序员：根据设计实现完整代码
    3. 审查员：审查代码质量并提出改进建议
    """
    
    try:
        print("📋 任务描述:")
        print(task)
        print("\n🏃‍♂️ 开始协作...")
        print("="*80)
        
        # 开始协作
        result = await Console(
            team.run_stream(
                task=task,
                termination_condition=MaxMessageTermination(max_messages=6)
            )
        )
        
        print("\n✅ 编程协作演示完成!")
        
    except Exception as e:
        print(f"❌ 演示过程中出错: {str(e)}")
    
    finally:
        # 关闭所有客户端
        for client in clients:
            await client.close()


async def single_model_coding_test():
    """单模型编程能力测试"""
    
    print("\n" + "="*80)
    print("🎯 单模型编程能力测试")
    print("="*80)
    
    config_file = Path(__file__).parent.parent / "custom_models_config.yaml"
    
    with open(config_file, 'r', encoding='utf-8') as f:
        config = yaml.safe_load(f)
    
    # 测试任务
    coding_tasks = [
        {
            "title": "算法实现",
            "task": "实现快速排序算法，包含详细注释和时间复杂度分析"
        },
        {
            "title": "数据结构",
            "task": "实现一个链表类，支持插入、删除、查找和遍历操作"
        },
        {
            "title": "实际应用",
            "task": "编写一个简单的计算器程序，支持四则运算和括号"
        }
    ]
    
    # 测试 Kimi-K2 和 Qwen3
    models_to_test = ["kimi_k2", "qwen3_coder"]
    
    for model_name in models_to_test:
        print(f"\n🤖 测试模型: {model_name}")
        print("-" * 50)
        
        model_config = config[model_name]['config']
        client = OpenAIChatCompletionClient(**model_config)
        
        agent = AssistantAgent(
            name=f"{model_name}_coder",
            model_client=client,
            system_message="你是一个专业的Python程序员，请编写高质量、可读性强的代码。"
        )
        
        for i, coding_task in enumerate(coding_tasks, 1):
            print(f"\n📝 任务 {i}: {coding_task['title']}")
            print(f"要求: {coding_task['task']}")
            print("💻 实现:")
            
            try:
                response = await agent.run(task=coding_task['task'])
                print(response.messages[-1].content)
                print("\n" + "-"*60)
                
            except Exception as e:
                print(f"❌ 错误: {str(e)}")
        
        await client.close()


async def main():
    """主函数"""
    
    print("🎨 AutoGen 编程代理演示")
    print("📚 展示多模型协作和编程能力")
    print("="*80)
    
    # 选择演示模式
    print("请选择演示模式:")
    print("1. 多代理协作演示 (推荐)")
    print("2. 单模型编程测试")
    print("3. 两者都运行")
    
    choice = input("\n请输入选择 (1-3): ").strip()
    
    if choice in ["1", "3"]:
        await coding_collaboration_demo()
    
    if choice in ["2", "3"]:
        await single_model_coding_test()
    
    if choice not in ["1", "2", "3"]:
        print("🔄 默认运行协作演示...")
        await coding_collaboration_demo()
    
    print(f"\n🎉 演示完成！")


if __name__ == "__main__":
    asyncio.run(main())