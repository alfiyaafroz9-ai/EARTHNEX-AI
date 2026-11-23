import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiBaseUrl = 'http://127.0.0.1:8000';
void main() => runApp(const EarthNexApp());

class EarthNexApp extends StatelessWidget {
  const EarthNexApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'EARTHNEX AI', debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF070D19),
      colorScheme: const ColorScheme.dark(primary: Color(0xFF39D6B0), secondary: Color(0xFF69A7FF)),
      cardTheme: CardThemeData(color: const Color(0xFF111C2D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    ),
    home: const DashboardPage(),
  );
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selected = 0;
  bool loading = false;
  Map<String, dynamic>? weather;
  String? error;
  final modules = const [
    ('Overview', Icons.dashboard_outlined), ('Earth Map', Icons.public),
    ('Climate', Icons.thermostat), ('Land', Icons.terrain),
    ('Vegetation', Icons.forest), ('Water', Icons.water_drop),
    ('Rivers', Icons.waves), ('Oceans', Icons.tsunami),
    ('Pollution', Icons.air), ('Geology & Minerals', Icons.layers),
    ('Predictions', Icons.auto_graph), ('AI Assistant', Icons.smart_toy_outlined),
  ];

  @override
  void initState() { super.initState(); loadWeather(); }

  Future<void> loadWeather() async {
    setState(() { loading = true; error = null; });
    try {
      final r = await http.get(Uri.parse('$apiBaseUrl/api/live/weather')).timeout(const Duration(seconds: 25));
      if (r.statusCode != 200) throw Exception('API ${r.statusCode}: ${r.body}');
      weather = jsonDecode(r.body) as Map<String, dynamic>;
    } catch (e) { error = e.toString(); }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      drawer: wide ? null : Drawer(child: _sidebar()),
      body: Row(children: [
        if (wide) _sidebar(),
        Expanded(child: Column(children: [
          _topbar(),
          if (!wide) SizedBox(height: 58, child: _mobileNav()),
          Expanded(child: _content()),
        ])),
      ]),
    );
  }

  Widget _sidebar() => Container(width: 245, color: const Color(0xFF0B1423),
    padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 12),
      const Text('EARTHNEX', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
      const Text('EARTH SYSTEM INTELLIGENCE', style: TextStyle(fontSize: 9, color: Color(0xFF39D6B0), letterSpacing: 1.2)),
      const SizedBox(height: 25),
      Expanded(child: ListView.builder(itemCount: modules.length, itemBuilder: (_, i) =>
        Padding(padding: const EdgeInsets.only(bottom: 4), child: ListTile(
          dense: true, selected: selected == i, selectedTileColor: const Color(0xFF183447),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: Icon(modules[i].$2, size: 19), title: Text(modules[i].$1, style: const TextStyle(fontSize: 13)),
          onTap: () => setState(() => selected = i),
        )))),
      const Divider(color: Colors.white12),
      const Text('POSTGRESQL • POSTGIS-FREE', style: TextStyle(fontSize: 9, color: Colors.white54)),
    ]));

  Widget _mobileNav() => ListView(scrollDirection: Axis.horizontal, children: List.generate(modules.length, (i) =>
    Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ChoiceChip(label: Text(modules[i].$1), selected: selected == i,
        onSelected: (_) => setState(() => selected = i)))));

  Widget _topbar() => Container(height: 70, padding: const EdgeInsets.symmetric(horizontal: 22),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.white10)),
    ),
    child: Row(children: [
      const Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Integrated Earth System Intelligence', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Observe • Understand • Predict', style: TextStyle(color: Colors.white54, fontSize: 11))])),
      IconButton(onPressed: loadWeather, icon: const Icon(Icons.refresh)),
      const Icon(Icons.circle, color: Color(0xFF39D6B0), size: 9),
      const SizedBox(width: 7), const Text('API', style: TextStyle(fontSize: 10, color: Colors.white70)),
    ]));

  Widget _content() {
    if (selected == 0) return _overview();
    if (selected == 2) return _climate();
    return _modulePage(modules[selected].$1);
  }

  Widget _overview() {
    final c = weather?['current'] as Map<String, dynamic>?;
    return ListView(padding: const EdgeInsets.all(22), children: [
      const Text('Earth Intelligence Overview', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('A unified view of climate, land, water, atmosphere and geological systems.', style: TextStyle(color: Colors.white60)),
      const SizedBox(height: 20),
      Wrap(spacing: 12, runSpacing: 12, children: [
        _metric('TEMPERATURE', c?['temperature_2m']?.toString() ?? '--', '°C', Icons.thermostat),
        _metric('HUMIDITY', c?['relative_humidity_2m']?.toString() ?? '--', '%', Icons.water_drop),
        _metric('WIND SPEED', c?['wind_speed_10m']?.toString() ?? '--', 'km/h', Icons.air),
        _metric('PRECIPITATION', c?['precipitation']?.toString() ?? '--', 'mm', Icons.grain),
      ]),
      const SizedBox(height: 18),
      _panel('EARTH SYSTEMS', Wrap(spacing: 8, runSpacing: 8, children: modules.skip(1).map((m) =>
        ActionChip(avatar: Icon(m.$2, size: 16), label: Text(m.$1),
          onPressed: () => setState(() => selected = modules.indexOf(m)))).toList())),
      const SizedBox(height: 18),
      _panel('ILLUSTRATIVE TREND CHART', _chart()),
      const SizedBox(height: 18),
      _panel('DATA STATUS', Text(error ?? (loading ? 'Loading live weather…' :
        'Weather source: Open-Meteo. Other scientific modules require verified datasets.'),
        style: const TextStyle(color: Colors.white70))),
    ]);
  }

  Widget _climate() {
    final daily = weather?['daily'] as Map<String, dynamic>?;
    final dates = (daily?['time'] as List?) ?? [];
    final maxs = (daily?['temperature_2m_max'] as List?) ?? [];
    final mins = (daily?['temperature_2m_min'] as List?) ?? [];
    return ListView(padding: const EdgeInsets.all(22), children: [
      const Text('Climate Intelligence', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      _panel('7-DAY TEMPERATURE FORECAST', dates.isEmpty ? _chart() :
        Column(children: List.generate(dates.length, (i) => ListTile(dense: true,
          title: Text(dates[i].toString()), trailing: Text('${mins[i]}° / ${maxs[i]}°C'))))),
      const SizedBox(height: 14),
      _panel('HISTORICAL CLIMATE', const Text(
        'Connect a validated historical archive to calculate real yearly and monthly trends. Forecasts are not historical climate records.',
        style: TextStyle(color: Colors.white70))),
    ]);
  }

  Widget _modulePage(String name) => ListView(padding: const EdgeInsets.all(22), children: [
    Text(name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    const SizedBox(height: 18),
    _panel('INTELLIGENCE WORKSPACE', const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.public, size: 42, color: Color(0xFF39D6B0)), SizedBox(height: 12),
      Text('Module workspace is ready. Connect validated data sources and analysis models to activate scientific layers and measurements.'),
      SizedBox(height: 12),
      Text('No synthetic measurements or unverified mineral locations are shown.',
        style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
    ])),
    const SizedBox(height: 14),
    _panel('CAPABILITIES', Text(_description(name), style: const TextStyle(color: Colors.white70))),
  ]);

  String _description(String n) {
    const map = {
      'Earth Map': 'Satellite imagery and environmental overlays: temperature, precipitation, humidity, vegetation, land cover, water and pollution.',
      'Land': 'Land cover, land-use change, soil indicators, erosion and degradation.',
      'Vegetation': 'Satellite vegetation indices such as NDVI, seasonal change and vegetation health.',
      'Water': 'Water bodies, water quality indicators, surface-water change and groundwater datasets.',
      'Rivers': 'River networks, flow, sediment, water quality and potential land-to-ocean pathways.',
      'Oceans': 'Sea-surface temperature, ocean colour, coastal change and oceanographic indicators.',
      'Pollution': 'Air pollutant observations, hotspots and modelled transport pathways.',
      'Geology & Minerals': 'Verified geological formations and mineral occurrence records from authoritative surveys.',
      'Predictions': 'Validated trend estimates, forecast models, uncertainty ranges and scenario comparisons.',
      'AI Assistant': 'Ask questions about connected environmental datasets and scientific analyses.',
    };
    return map[n] ?? 'Connect an authoritative dataset and validated analysis method for this module.';
  }

  Widget _metric(String title, String value, String unit, IconData icon) =>
      SizedBox(
        width: 220,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: const Color(0xFF39D6B0)),
                    const SizedBox(width: 8),
                    Text(title, style: const TextStyle(fontSize: 10, color: Colors.white60)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(value, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                Text(unit, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
        ),
      );

  Widget _panel(String title, Widget child) => Card(child: Padding(padding: const EdgeInsets.all(18),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
      const SizedBox(height: 14), child,
    ])));

  Widget _chart() => SizedBox(height: 190, child: LineChart(LineChartData(
    gridData: const FlGridData(show: true, drawVerticalLine: false),
    titlesData: const FlTitlesData(show: false), borderData: FlBorderData(show: false),
    lineBarsData: [LineChartBarData(
      spots: const [FlSpot(0, 22), FlSpot(1, 24), FlSpot(2, 23), FlSpot(3, 27), FlSpot(4, 25), FlSpot(5, 26), FlSpot(6, 24)],
      isCurved: true, color: const Color(0xFF39D6B0), barWidth: 3,
      dotData: const FlDotData(show: true),
    )],
  )));
}
