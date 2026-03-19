import 'package:vgv_genui_financial_advisor/feature_flags/repository/feature_flags_repository.dart';

const activeFeatureFlags = [
  FeatureFlag(
    id: 'dark_mode',
    name: 'Dark Mode',
    description: 'Enable dark mode theme across the app.',
    value: false,
    defaultValue: false,
  ),
  FeatureFlag(
    id: 'ai_insights',
    name: 'AI Insights',
    description: 'Show AI-powered financial insights on the dashboard.',
    value: false,
    defaultValue: false,
  ),
];
