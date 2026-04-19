import 'package:flutter/material.dart';
import 'package:flutter_value_localization/flutter_value_localization.dart';

import 'mock_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 当前加载模式 / Current loading mode
  LoadMode _loadMode = LoadMode.none;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    ValueLocalization.dispose();
    super.dispose();
  }

  /// 方式一：从 Assets 加载 / Method 1: Load from Assets
  Future<void> _initFromAssets() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 清理之前的实例 / Dispose previous instance
      ValueLocalization.dispose();

      // 从 Assets 初始化 / Initialize from Assets
      await ValueLocalization.init(
        langCode: 'en',
        openLog: true,
      );

      setState(() {
        _loadMode = LoadMode.assets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// 方式二：从 Map 加载（模拟 Hive/API）/ Method 2: Load from Map (Mock Hive/API)
  Future<void> _initFromMap() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 清理之前的实例 / Dispose previous instance
      ValueLocalization.dispose();

      // 从 Mock API 获取数据 / Fetch data from Mock API
      final data = await MockLocalizationData.fetchFromApi();

      // 从 Map 初始化 / Initialize from Map
      await ValueLocalization.initFromMap(
        langCode: 'zh',
        data: data,
        openLog: true,
      );

      setState(() {
        _loadMode = LoadMode.map;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Value Localization Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: PopScope(
        canPop: _loadMode == LoadMode.none,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _loadMode != LoadMode.none) {
            // 返回到模式选择界面 / Return to mode selection
            setState(() {
              _loadMode = LoadMode.none;
              ValueLocalization.dispose();
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Localization Demo'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: _loadMode != LoadMode.none
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _loadMode = LoadMode.none;
                        ValueLocalization.dispose();
                      });
                    },
                  )
                : null,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            const Text(
                              '加载失败 / Load Failed',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _error = null;
                                });
                              },
                              child: const Text('重试 / Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // 未初始化时显示选择界面 / Show selection UI when not initialized
    if (_loadMode == LoadMode.none) {
      return _buildModeSelector();
    }

    // 已初始化后显示示例界面 / Show demo UI when initialized
    return _buildDemoUI();
  }

  /// 选择加载模式 / Select loading mode
  Widget _buildModeSelector() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '选择初始化方式 / Select Init Method',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _initFromAssets,
            icon: const Icon(Icons.folder_open),
            label: const Column(
              children: [
                Text('从 Assets 加载'),
                Text('Load from Assets', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _initFromMap,
            icon: const Icon(Icons.storage),
            label: const Column(
              children: [
                Text('从 Map 加载 (Mock API/Hive)'),
                Text('Load from Map (Mock)', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 示例界面 / Demo UI
  /// 使用 LocalizationWidgetBuilder 自动监听语言变化
  Widget _buildDemoUI() {
    return LocalizationWidgetBuilder(
      builder: (context, child) {
        final langCode = ValueLocalization.langCode;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 当前模式 / Current mode
              Card(
                child: ListTile(
                  leading: Icon(
                    _loadMode == LoadMode.assets
                        ? Icons.folder_open
                        : Icons.storage,
                  ),
                  title: Text(
                      _loadMode == LoadMode.assets ? 'Assets 模式' : 'Map 模式'),
                  subtitle: Text(
                    _loadMode == LoadMode.assets
                        ? 'Loaded from Flutter Assets'
                        : 'Loaded from in-memory Map (Mock API/Hive)',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 语言切换 / Language switcher
              _buildLanguageSwitcher(langCode),

              const SizedBox(height: 16),

              // 翻译示例 / Translation examples
              const Text(
                '翻译示例 / Translation Examples',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView(
                  children: [
                    _buildExampleCard(
                      '基础翻译 / Basic',
                      ValueLocalization.get('appname'),
                    ),
                    _buildExampleCard(
                      '带参数 / With Params',
                      ValueLocalization.get(
                        'welcome',
                        params: {'appName': 'MyApp'},
                      ),
                    ),
                    _buildExampleCard(
                      '日期格式 / Date Format',
                      ValueLocalization.get(
                        'today',
                        params: {'year': 2026, 'month': 4, 'day': 19},
                      ),
                    ),
                    _buildExampleCard(
                      '问候语 / Greeting',
                      ValueLocalization.get(
                        'greeting',
                        params: {'name': 'Flutter Dev'},
                      ),
                    ),
                    _buildExampleCard(
                      '数量 / Count',
                      ValueLocalization.get(
                        'items_count',
                        params: {'count': 42},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 重新选择按钮 / Re-select button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loadMode = LoadMode.none;
                    });
                  },
                  child: const Text('切换模式 / Switch Mode'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 语言切换器 / Language switcher
  Widget _buildLanguageSwitcher(String langCode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 8),
            Text(
              '当前语言 / Current: $langCode',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'en', label: Text('EN')),
                ButtonSegment(value: 'zh', label: Text('ZH')),
                ButtonSegment(value: 'zh_cn', label: Text('ZH_CN')),
              ],
              selected: {langCode},
              onSelectionChanged: (selection) async {
                final newLangCode = selection.first;
                if (newLangCode != langCode) {
                  await ValueLocalization.set(newLangCode);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 示例卡片 / Example card
  Widget _buildExampleCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

enum LoadMode {
  none,
  assets,
  map,
}
