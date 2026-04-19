// Mock 数据 - 模拟从 API 或 Hive 获取的多语言数据
// Mock data - Simulating multilingual data from API or Hive

class MockLocalizationData {
  /// 模拟从 API 返回的数据结构
  /// Simulating API response data structure
  static Map<String, Map<String, String>> get apiResponseData => {
        'app_en': {
          'appname': 'Nice Player',
          'welcome': 'Welcome to {appName}!',
          'today': 'Today is {month}/{day}/{year}',
          'greeting': 'Hello, {name}!',
          'items_count': 'You have {count} items',
          'source': 'Loaded from Map (API/Hive)',
        },
        'app_zh': {
          'appname': 'Nice Player',
          'welcome': '歡迎使用 {appName}！',
          'today': '今天是{year}年{month}月{day}日',
          'greeting': '你好，{name}！',
          'items_count': '你有 {count} 個項目',
          'source': '從 Map 加載 (API/Hive)',
        },
        'app_zh_cn': {
          'appname': 'Nice Player',
          'welcome': '欢迎使用 {appName}！',
          'today': '今天是{year}年{month}月{day}日',
          'greeting': '你好，{name}！',
          'items_count': '你有 {count} 个项目',
          'source': '从 Map 加载 (API/Hive)',
        },
      };

  /// 模拟存储到 Hive 的数据
  /// Simulating data stored in Hive
  static Future<Map<String, Map<String, String>>> loadFromHive() async {
    // 实际使用时从 Hive 读取
    // In real usage, read from Hive
    // final box = await Hive.openBox<Map<String, Map<String, String>>>('localization');
    // return box.get('translations') ?? {};

    // 这里返回 mock 数据
    // Return mock data here
    await Future.delayed(const Duration(milliseconds: 100)); // 模拟延迟
    return apiResponseData;
  }

  /// 模拟 API 请求获取数据
  /// Simulating API request to fetch data
  static Future<Map<String, Map<String, String>>> fetchFromApi() async {
    // 实际使用时从 API 获取
    // In real usage, fetch from API
    // final response = await http.get(Uri.parse('https://api.example.com/localization'));
    // return jsonDecode(response.body);

    // 这里返回 mock 数据
    // Return mock data here
    await Future.delayed(const Duration(milliseconds: 300)); // 模拟网络延迟
    return apiResponseData;
  }
}
