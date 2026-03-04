# KnowledgeBuilder - Zendesk 知识库批量导入工具

## 项目背景
Zendesk AIAA 实施项目工具，用于批量处理知识库文章的完整生命周期：**抓取 → 清洗 → 重写 → 草稿发布**

## 核心工作流

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  内容抓取   │ →> │  数据清洗   │ →> │  百炼重写   │ →> │ Zendesk发布 │
│ (客户提供/  │    │ (格式统一/  │    │ (风格一致/  │    │ (草稿状态)  │
│  网络抓取)  │    │  去重过滤)  │    │  术语规范)  │    │             │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## 技术栈

### Zendesk API
- Help Center API (Categories/Sections/Articles)
- 认证方式: Email + API Token
- 基础域名: `https://{subdomain}.zendesk.com`

### 阿里百炼 API
- 用于文章重写和风格统一
- 确保术语一致性和可读性

### 数据处理
- Excel 输入: `openpyxl`
- 输出格式: JSON（每行处理结果）

## 当前文件说明

### zendesk_xlsx_import.py
从 Excel 批量导入文章到 Zendesk Help Center

**Excel 表头要求：**
- 类别/Category/分类
- 组别/Section/分组
- 文章标题/Title
- 文章内容/Body/内容

**关键参数：**
- `--subdomain`: Zendesk 子域名
- `--email`: API 认证邮箱
- `--api-token`: Zendesk API Token
- `--xlsx`: Excel 文件路径
- `--draft`: 是否草稿（默认 false）
- `--locale`: 语言区域（默认 zh-cn）

## 开发规范

### 代码风格
- 保持简洁实用，优先实现功能
- 函数命名使用中文拼音缩写（如 `gc`=get categories, `cc`=create category）
- 每个函数只做一件事

### 错误处理
- 所有 API 调用返回统一结构：`{"key": value}` 或 `{"_error": True, ...}`
- 每行处理结果以 JSON 格式输出，便于日志追踪

### 测试要求
- 先在测试环境验证
- 草稿模式发布后再正式发布
- 批量操作前先小范围测试

## 实施注意事项

1. **权限配置**: 确保 API Token 有 Help Center 的读写权限
2. **分类层级**: 文章必须属于 Category → Section → Article 三级结构
3. **HTML 格式**: 文章内容需要 HTML 格式，纯文本会自动包裹 `<p>` 标签
4. **批量处理**: 建议每次处理不超过 100 篇，避免 API 限流

## 待扩展功能

- [ ] 集成阿里百炼 API 实现自动重写
- [ ] 支持从 URL/文档抓取原始内容
- [ ] 添加数据清洗模块（去重、格式校验）
- [ ] 支持多语言内容处理
- [ ] 添加进度条和错误重试机制
