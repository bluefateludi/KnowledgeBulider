#!/usr/bin/env python3
"""
查询 learnpulse 品牌的知识库结构
"""
import json
import subprocess

# Zendesk 配置
SUBDOMAIN = "pdi-siebre"
EMAIL = "ethan.qi@almt.com.cn"
API_TOKEN = "9Jwt6Rdty4SKZRGgtOsaolRUKkb9XaD9X72abfPS"
LEARNPULSE_BRAND_ID = "15332878018319"

BASE_URL = f"https://{SUBDOMAIN}.zendesk.com"

def api_request(endpoint, method="GET", data=None):
    """发起 API 请求"""
    url = f"{BASE_URL}{endpoint}"
    cmd = ["curl", "-sS", "-u", f"{EMAIL}/token:{API_TOKEN}",
           "-H", "Content-Type: application/json", "-X", method]

    if data is not None:
        cmd += ["-d", json.dumps(data, ensure_ascii=False)]

    cmd += [url]

    result = subprocess.run(cmd, capture_output=True, text=True)
    try:
        return json.loads(result.stdout.strip()) if result.stdout.strip() else {}
    except:
        return {"_error": True, "response": result.stdout[:500]}

def get_brands():
    """获取所有品牌"""
    print("=" * 60)
    print("获取所有品牌 (Brands)")
    print("=" * 60)
    result = api_request("/api/v2/brands.json")
    if "brands" in result:
        for brand in result["brands"]:
            print(f"\nID: {brand.get('id')}")
            print(f"  Name: {brand.get('name')}")
            print(f"  Subdomain: {brand.get('subdomain')}")
            print(f"  Active: {brand.get('is_active')}")
    return result

def get_categories(brand_id=None):
    """获取所有分类"""
    print("\n" + "=" * 60)
    print(f"获取分类 (Categories) - Brand ID: {brand_id}")
    print("=" * 60)
    endpoint = "/api/v2/help_center/categories.json"
    if brand_id:
        endpoint = f"/api/v2/help_center/categories.json?brand_id={brand_id}"
    result = api_request(endpoint)
    if "categories" in result:
        for cat in result["categories"]:
            print(f"\nID: {cat.get('id')}")
            print(f"  Name: {cat.get('name')}")
            print(f"  Locale: {cat.get('locale')}")
            print(f"  Description: {cat.get('description', 'N/A')}")
    return result

def get_sections(brand_id=None):
    """获取所有板块"""
    print("\n" + "=" * 60)
    print(f"获取板块 (Sections) - Brand ID: {brand_id}")
    print("=" * 60)
    endpoint = "/api/v2/help_center/sections.json"
    if brand_id:
        endpoint = f"/api/v2/help_center/sections.json?brand_id={brand_id}"
    result = api_request(endpoint)
    if "sections" in result:
        for sec in result["sections"]:
            print(f"\nID: {sec.get('id')}")
            print(f"  Name: {sec.get('name')}")
            print(f"  Category ID: {sec.get('category_id')}")
            print(f"  Locale: {sec.get('locale')}")
            print(f"  Description: {sec.get('description', 'N/A')}")
    return result

def get_permission_groups():
    """获取权限组"""
    print("\n" + "=" * 60)
    print("获取权限组 (Permission Groups)")
    print("=" * 60)
    result = api_request("/api/v2/guide/permission_groups.json")
    if "permission_groups" in result:
        for pg in result["permission_groups"]:
            print(f"\nID: {pg.get('id')}")
            print(f"  Name: {pg.get('name')}")
            print(f"  Built-in: {pg.get('built_in')}")
    return result

def main():
    print("\n" + "=" * 60)
    print("  Zendesk LearnPulse 品牌知识库查询工具")
    print("=" * 60)

    # 1. 获取所有品牌
    brands = get_brands()

    # 2. 获取 learnpulse 品牌的分类
    categories = get_categories(LEARNPULSE_BRAND_ID)

    # 3. 获取 learnpulse 品牌的板块
    sections = get_sections(LEARNPULSE_BRAND_ID)

    # 4. 获取权限组
    permission_groups = get_permission_groups()

    # 5. 保存完整结果到 JSON
    output = {
        "brands": brands.get("brands", []),
        "learnpulse_categories": categories.get("categories", []),
        "learnpulse_sections": sections.get("sections", []),
        "permission_groups": permission_groups.get("permission_groups", [])
    }

    with open("learnpulse_structure.json", "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    print("\n" + "=" * 60)
    print("完整结果已保存到: learnpulse_structure.json")
    print("=" * 60)

if __name__ == "__main__":
    main()
