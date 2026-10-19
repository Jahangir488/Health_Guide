import 'package:flutter/material.dart';

void main() => runApp(const HealthGuideApp());

class HealthGuideApp extends StatefulWidget {
  const HealthGuideApp({super.key});
  @override
  State<HealthGuideApp> createState() => _HealthGuideAppState();
}

class _HealthGuideAppState extends State<HealthGuideApp> {
  bool bengali = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087F72)),
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
        cardTheme: CardThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
      ),
      home: HealthShell(bengali: bengali, onLanguageChanged: (v) => setState(() => bengali = v)),
    );
  }
}

String tr(bool bn, String en, String bnText) => bn ? bnText : en;

class HealthShell extends StatefulWidget {
  final bool bengali;
  final ValueChanged<bool> onLanguageChanged;
  const HealthShell({super.key, required this.bengali, required this.onLanguageChanged});
  @override
  State<HealthShell> createState() => _HealthShellState();
}

class _HealthShellState extends State<HealthShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final bn = widget.bengali;
    final pages = [
      HomePage(bn: bn, onStart: () => setState(() => index = 1)),
      AssessmentPage(bn: bn),
      MedicinePage(bn: bn),
      SafetyPage(bn: bn),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [const Icon(Icons.health_and_safety, color: Color(0xFF087F72)), const SizedBox(width: 9), Text(tr(bn, 'Health Guide', 'হেলথ গাইড'), style: const TextStyle(fontWeight: FontWeight.w800))]),
        actions: [TextButton(onPressed: () => widget.onLanguageChanged(!bn), child: Text(bn ? 'English' : 'বাংলা')), const SizedBox(width: 8)],
      ),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr(bn, 'Home', 'হোম')),
          NavigationDestination(icon: const Icon(Icons.fact_check_outlined), selectedIcon: const Icon(Icons.fact_check), label: tr(bn, 'Symptoms', 'উপসর্গ')),
          NavigationDestination(icon: const Icon(Icons.medication_outlined), selectedIcon: const Icon(Icons.medication), label: tr(bn, 'Medicines', 'ওষুধ')),
          NavigationDestination(icon: const Icon(Icons.shield_outlined), selectedIcon: const Icon(Icons.shield), label: tr(bn, 'Safety', 'নিরাপত্তা')),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool bn;
  final VoidCallback onStart;
  const HomePage({super.key, required this.bn, required this.onStart});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE0F3ED), Color(0xFFEDF5FC)]), borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.health_and_safety, size: 44, color: Color(0xFF087F72)), const SizedBox(height: 18),
      Text(tr(bn, 'Understand your health', 'আপনার স্বাস্থ্য সম্পর্কে জানুন'), style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800)), const SizedBox(height: 10),
      Text(tr(bn, 'Clear, simple health information to help you understand next steps.', 'পরবর্তী পদক্ষেপ বুঝতে সহজ স্বাস্থ্যতথ্য।'), style: const TextStyle(fontSize: 16)), const SizedBox(height: 20),
      FilledButton.icon(onPressed: onStart, icon: const Icon(Icons.arrow_forward), label: Text(tr(bn, 'Start symptom check', 'উপসর্গ যাচাই শুরু করুন'))),
    ])), const SizedBox(height: 18),
    FeatureTile(icon: Icons.fact_check_outlined, title: tr(bn, 'Symptom guidance', 'উপসর্গের নির্দেশনা'), body: tr(bn, 'Review selected symptoms and general safety guidance.', 'নির্বাচিত উপসর্গ ও সাধারণ নিরাপত্তা নির্দেশনা দেখুন.')),
    FeatureTile(icon: Icons.medication_outlined, title: tr(bn, 'Medicine information', 'ওষুধের তথ্য'), body: tr(bn, 'Search illustrative medicine information and cautions.', 'ওষুধের তথ্য ও সতর্কতা খুঁজুন।')),
    const SizedBox(height: 8), const PrototypeNotice(),
  ]);
}

class FeatureTile extends StatelessWidget {
  final IconData icon; final String title; final String body;
  const FeatureTile({super.key, required this.icon, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFE0F3ED), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: const Color(0xFF087F72)),), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 5), Text(body)]))])));
}

class AssessmentPage extends StatefulWidget {
  final bool bn;
  const AssessmentPage({super.key, required this.bn});
  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final Set<String> selected = {};
  String duration = '1–2 days';
  bool showResult = false;
  static const options = <String, String>{
    'Fever': 'জ্বর', 'Cough': 'কাশি', 'Headache': 'মাথাব্যথা', 'Sore throat': 'গলাব্যথা',
    'Nausea or vomiting': 'বমি বমি ভাব বা বমি', 'Skin rash': 'ত্বকে ফুসকুড়ি',
    'Severe difficulty breathing': 'তীব্র শ্বাসকষ্ট', 'Chest pain': 'বুকে ব্যথা',
    'Fainting or loss of consciousness': 'অজ্ঞান হওয়া', 'Severe bleeding': 'প্রচুর রক্তপাত',
  };
  static const urgent = {'Severe difficulty breathing', 'Chest pain', 'Fainting or loss of consciousness', 'Severe bleeding'};
  @override
  Widget build(BuildContext context) {
    final bn = widget.bn;
    final isUrgent = selected.any(urgent.contains);
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(tr(bn, 'Symptom check', 'উপসর্গ যাচাই'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)), const SizedBox(height: 8),
      Text(tr(bn, 'Choose all that apply. This is general information, not a diagnosis.', 'প্রযোজ্য সব উপসর্গ নির্বাচন করুন। এটি সাধারণ তথ্য, রোগ নির্ণয় নয়।')),
      const SizedBox(height: 12),
      ...options.entries.map((entry) => Card(child: CheckboxListTile(value: selected.contains(entry.key), title: Text(bn ? entry.value : entry.key), controlAffinity: ListTileControlAffinity.leading, onChanged: (v) => setState(() { if (v == true) { selected.add(entry.key); } else { selected.remove(entry.key); } showResult = false; })))),
      const SizedBox(height: 12), Text(tr(bn, 'How long?', 'কত দিন ধরে?'), style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8),
      DropdownButtonFormField<String>(value: duration, decoration: const InputDecoration(border: OutlineInputBorder()), items: ['Less than 24 hours', '1–2 days', '3–7 days', 'More than 7 days'].map((d) => DropdownMenuItem(value: d, child: Text(bn ? ({'Less than 24 hours':'২৪ ঘণ্টার কম','1–2 days':'১–২ দিন','3–7 days':'৩–৭ দিন','More than 7 days':'৭ দিনের বেশি'}[d]!) : d))).toList(), onChanged: (v) => setState(() { duration = v ?? duration; showResult = false; })), const SizedBox(height: 16),
      FilledButton(onPressed: () { if (selected.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr(bn, 'Select at least one symptom.', 'অন্তত একটি উপসর্গ নির্বাচন করুন।')))); return; } setState(() => showResult = true); }, child: Text(tr(bn, 'Review answers', 'উত্তর দেখুন'))),
      if (showResult) ...[const SizedBox(height: 16), Card(color: isUrgent ? const Color(0xFFFFE6E2) : const Color(0xFFE2F4EC), child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(tr(bn, isUrgent ? 'Urgent medical attention' : 'General guidance', isUrgent ? 'জরুরি চিকিৎসা প্রয়োজন' : 'সাধারণ নির্দেশনা'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)), const SizedBox(height: 8), Text(isUrgent ? tr(bn, 'A selected warning symptom may be an emergency. Seek emergency medical care now; do not wait for this app.', 'নির্বাচিত সতর্কতামূলক উপসর্গ জরুরি অবস্থা হতে পারে। এখনই জরুরি চিকিৎসা নিন; অ্যাপের জন্য অপেক্ষা করবেন না।') : tr(bn, 'You selected: ${selected.map((s) => bn ? options[s] : s).join(', ')}. Duration: $duration. These answers cannot establish the cause. Seek medical advice if symptoms are severe, worsening, persistent, or concerning.', 'আপনি উপসর্গ নির্বাচন করেছেন। শুধু এই তথ্য দিয়ে কারণ নির্ধারণ করা যায় না। উপসর্গ গুরুতর, বাড়তে থাকা বা দীর্ঘস্থায়ী হলে চিকিৎসকের পরামর্শ নিন।')), const SizedBox(height: 10), Text(tr(bn, 'No diagnosis or medicine recommendation is generated.', 'রোগ নির্ণয় বা ওষুধের পরামর্শ দেওয়া হয় না।'), style: const TextStyle(fontWeight: FontWeight.bold))]))),],
      const SizedBox(height: 14), Text(tr(bn, 'This prototype checks only a few warning signs. A person may need urgent care even if none are selected.', 'এই প্রোটোটাইপে অল্প কিছু সতর্কতামূলক লক্ষণ যাচাই করা হয়। কোনোটি নির্বাচন না করলেও জরুরি চিকিৎসা লাগতে পারে।'), style: const TextStyle(fontSize: 12)),
    ]);
  }
}

class MedicinePage extends StatefulWidget {
  final bool bn;
  const MedicinePage({super.key, required this.bn});
  @override
  State<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final controller = TextEditingController();
  final entries = const [
    {'name':'Paracetamol', 'bn':'প্যারাসিটামল', 'use':'Commonly used for pain and fever.', 'useBn':'সাধারণত ব্যথা ও জ্বর কমাতে ব্যবহৃত হয়।', 'warning':'Excessive doses can cause serious liver damage. Follow the product label and ask a pharmacist if unsure.', 'warningBn':'অতিরিক্ত মাত্রায় লিভারের গুরুতর ক্ষতি হতে পারে। পণ্যের নির্দেশনা অনুসরণ করুন এবং সন্দেহ হলে ফার্মাসিস্টকে জিজ্ঞাসা করুন।'},
    {'name':'Oral rehydration salts (ORS)', 'bn':'খাবার স্যালাইন (ORS)', 'use':'Replaces fluids and electrolytes lost through diarrhoea or dehydration.', 'useBn':'ডায়রিয়া বা পানিশূন্যতায় হারানো পানি ও লবণ পূরণে ব্যবহৃত হয়।', 'warning':'Prepare exactly as the packet directs. Severe dehydration needs urgent medical assessment.', 'warningBn':'প্যাকেটের নির্দেশনা অনুযায়ী তৈরি করুন। গুরুতর পানিশূন্যতায় দ্রুত চিকিৎসা প্রয়োজন।'},
    {'name':'Ibuprofen', 'bn':'আইবুপ্রোফেন', 'use':'An anti-inflammatory pain reliever.', 'useBn':'প্রদাহ ও ব্যথা কমানোর ওষুধ।', 'warning':'May be unsuitable with stomach ulcers, kidney problems, some medicines, or during pregnancy. Ask a qualified professional.', 'warningBn':'পাকস্থলীর আলসার, কিডনির সমস্যা, কিছু ওষুধের সঙ্গে বা গর্ভাবস্থায় অনুপযুক্ত হতে পারে। যোগ্য পেশাজীবীর পরামর্শ নিন।'},
  ];
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final bn = widget.bn; final q = controller.text.trim().toLowerCase();
    final filtered = entries.where((e) => e['name']!.toLowerCase().contains(q) || e['bn']!.contains(controller.text.trim())).toList();
    return ListView(padding: const EdgeInsets.all(20), children: [Text(tr(bn, 'Medicine information', 'ওষুধের তথ্য'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(tr(bn, 'Sample entries only; not a verified medicine database or advice to take a medicine.', 'শুধু নমুনা তথ্য; এটি যাচাইকৃত ওষুধের ডেটাবেস বা ওষুধ খাওয়ার পরামর্শ নয়।')), const SizedBox(height: 16), TextField(controller: controller, onChanged: (_) => setState(() {}), decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: tr(bn, 'Search generic name', 'ওষুধের নাম লিখুন'), border: const OutlineInputBorder())), const SizedBox(height: 12), ...filtered.map((e) => Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(bn ? e['bn']! : e['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text('${tr(bn, 'General use', 'সাধারণ ব্যবহার')}: ${bn ? e['useBn']! : e['use']!}'), const SizedBox(height: 8), Text('${tr(bn, 'Safety', 'সতর্কতা')}: ${bn ? e['warningBn']! : e['warning']!}')]))), if (filtered.isEmpty) Text(tr(bn, 'No sample entry found.', 'কোনো নমুনা তথ্য পাওয়া যায়নি।'))]);
  }
}

class SafetyPage extends StatelessWidget {
  final bool bn;
  const SafetyPage({super.key, required this.bn});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [Text(tr(bn, 'Safety first', 'নিরাপত্তা সবার আগে'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)), const SizedBox(height: 14), FeatureTile(icon: Icons.emergency, title: tr(bn, 'Emergency warning signs', 'জরুরি সতর্কতামূলক লক্ষণ'), body: tr(bn, 'Severe breathing difficulty, chest pain, fainting, or severe bleeding may require emergency care. Contact local emergency services or go to an emergency department.', 'তীব্র শ্বাসকষ্ট, বুকে ব্যথা, অজ্ঞান হওয়া বা প্রচুর রক্তপাতের ক্ষেত্রে জরুরি চিকিৎসা লাগতে পারে। স্থানীয় জরুরি সেবায় যোগাযোগ করুন বা জরুরি বিভাগে যান।')), FeatureTile(icon: Icons.medical_services_outlined, title: tr(bn, 'Medicine safety', 'ওষুধের নিরাপত্তা'), body: tr(bn, 'Do not start, stop, or change prescription medicines based on this app. Ask a qualified doctor or pharmacist.', 'এই অ্যাপের ভিত্তিতে প্রেসক্রিপশনের ওষুধ শুরু, বন্ধ বা পরিবর্তন করবেন না। চিকিৎসক বা ফার্মাসিস্টের পরামর্শ নিন।')), FeatureTile(icon: Icons.verified_user_outlined, title: tr(bn, 'Prototype limitation', 'প্রোটোটাইপের সীমাবদ্ধতা'), body: tr(bn, 'Not clinically validated. It cannot diagnose or replace professional medical care.', 'এটি চিকিৎসাগতভাবে যাচাইকৃত নয়। এটি রোগ নির্ণয় বা পেশাদার চিকিৎসার বিকল্প নয়।')), const SizedBox(height: 8), const PrototypeNotice()]);
}

class PrototypeNotice extends StatelessWidget {
  const PrototypeNotice({super.key});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF0D7), borderRadius: BorderRadius.circular(14)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: Color(0xFF805500)), SizedBox(width: 10), Expanded(child: Text('Prototype only. Not clinically validated. It does not diagnose or prescribe. Do not use it for emergency decisions or real treatment.'))]));
}
