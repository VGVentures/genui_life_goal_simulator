import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:finance_app/financials/models/models.dart';

// ---------------------------------------------------------------------------
// Older & Stable — Margaret, 52, senior marketing director
// ---------------------------------------------------------------------------

// ── Account IDs ──────────────────────────────────────────────────────────
const _checking = 'acc_os_checking';
const _savings = 'acc_os_savings';
const _credit = 'acc_os_credit';
const _fourOhOneK = 'acc_os_401k';
const _mortgage = 'acc_os_mortgage';

final olderStableScenario = MockScenario(
  name: 'Older & Stable',
  description:
      'Margaret, 52 — senior marketing director. High earner with '
      'intentional spending habits, maxing retirement contributions, '
      'mortgage nearly paid off, premium credit card used strategically '
      'for points and paid in full monthly.',
  accounts: _accounts,
  transactions: _transactions,
);

// ── Accounts ─────────────────────────────────────────────────────────────
const _accounts = <Account>[
  Account(
    id: _checking,
    name: 'Heritage Bank Platinum Checking',
    type: AccountType.depository,
    subtype: AccountSubtype.checking,
    mask: '1234',
    balance: Balance(
      current: 12450,
      available: 12450,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _savings,
    name: 'Pinnacle High-Yield Savings',
    type: AccountType.depository,
    subtype: AccountSubtype.savings,
    mask: '5678',
    balance: Balance(
      current: 45200,
      available: 45200,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _credit,
    name: 'Heritage Sapphire Rewards',
    type: AccountType.credit,
    subtype: AccountSubtype.creditCard,
    mask: '8901',
    balance: Balance(
      current: 85,
      limit: 28000,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _fourOhOneK,
    name: 'National Retirement 401(k)',
    type: AccountType.investment,
    subtype: AccountSubtype.fourOhOneK,
    mask: '2345',
    balance: Balance(
      current: 485000,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _mortgage,
    name: 'Heritage Bank Home Mortgage',
    type: AccountType.loan,
    subtype: AccountSubtype.mortgage,
    mask: '6789',
    balance: Balance(
      current: 62000,
      currencyCode: CurrencyCode.usd,
    ),
  ),
];

// ── Transactions (Dec 1 2025 – Feb 5 2026) ──────────────────────────────
final _transactions = <Transaction>[
  // ── December 2025 ───────────────────────────────────────────────────

  // Dec 1 — Paycheck
  Transaction(
    id: 'txn_os_001',
    accountId: _checking,
    amount: -4800,
    date: DateTime(2025, 12),
    name: 'Meridian Media Group Payroll',
    merchantName: 'Meridian Media',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 1 — Mortgage payment
  Transaction(
    id: 'txn_os_002',
    accountId: _checking,
    amount: 1850,
    date: DateTime(2025, 12),
    name: 'Heritage Bank Mortgage Payment',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 1 — 401(k) contribution
  Transaction(
    id: 'txn_os_003',
    accountId: _checking,
    amount: 1173,
    date: DateTime(2025, 12),
    name: 'National Retirement 401(k) Contribution',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 2 — Utilities
  Transaction(
    id: 'txn_os_004',
    accountId: _checking,
    amount: 185,
    date: DateTime(2025, 12, 2),
    name: 'Metro Power Electric',
    merchantName: 'Metro Power',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 2 — Phone bill
  Transaction(
    id: 'txn_os_005',
    accountId: _checking,
    amount: 140,
    date: DateTime(2025, 12, 2),
    name: 'Google Fi Family Plan',
    merchantName: 'Google Fi',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 3 — Auto insurance
  Transaction(
    id: 'txn_os_005b',
    accountId: _checking,
    amount: 135,
    date: DateTime(2025, 12, 3),
    name: 'SafeRide Auto Insurance',
    merchantName: 'SafeRide',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 3 — Health insurance
  Transaction(
    id: 'txn_os_006',
    accountId: _checking,
    amount: 320,
    date: DateTime(2025, 12, 3),
    name: 'Summit Health Insurance',
    merchantName: 'Summit Health',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 4 — Weekly groceries
  Transaction(
    id: 'txn_os_007',
    accountId: _checking,
    amount: 98.30,
    date: DateTime(2025, 12, 4),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 5 — News subscription
  Transaction(
    id: 'txn_os_008',
    accountId: _checking,
    amount: 17,
    date: DateTime(2025, 12, 5),
    name: 'Metro Daily News Subscription',
    merchantName: 'Metro Daily News',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 5 — Sports subscription
  Transaction(
    id: 'txn_os_009',
    accountId: _checking,
    amount: 9.99,
    date: DateTime(2025, 12, 5),
    name: 'Sports Insider Subscription',
    merchantName: 'Sports Insider',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 6 — Gas
  Transaction(
    id: 'txn_os_010',
    accountId: _checking,
    amount: 62.40,
    date: DateTime(2025, 12, 6),
    name: 'QuickFuel',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 6 — Dining out on credit card (points)
  Transaction(
    id: 'txn_os_011',
    accountId: _credit,
    amount: 185,
    date: DateTime(2025, 12, 6),
    name: 'Le Petit Bistro',
    merchantName: 'Le Petit Bistro',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 8 — Wholesale run
  Transaction(
    id: 'txn_os_012',
    accountId: _checking,
    amount: 145.60,
    date: DateTime(2025, 12, 8),
    name: 'BulkMart Wholesale',
    merchantName: 'BulkMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 9 — Public radio donation
  Transaction(
    id: 'txn_os_013',
    accountId: _checking,
    amount: 15,
    date: DateTime(2025, 12, 9),
    name: 'Public Radio Monthly Donation',
    merchantName: 'Public Radio',
    category: TransactionCategory.governmentAndNonProfit,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 10 — Wine
  Transaction(
    id: 'txn_os_014',
    accountId: _checking,
    amount: 58.75,
    date: DateTime(2025, 12, 10),
    name: 'Premier Wine & Spirits',
    merchantName: 'Premier Wine',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 11 — Weekly groceries
  Transaction(
    id: 'txn_os_015',
    accountId: _checking,
    amount: 94.45,
    date: DateTime(2025, 12, 11),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 12 — Department store on credit card (points)
  Transaction(
    id: 'txn_os_016',
    accountId: _credit,
    amount: 165,
    date: DateTime(2025, 12, 12),
    name: 'Westfield Department Store',
    merchantName: 'Westfield',
    category: TransactionCategory.shopping,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 13 — Coffee
  Transaction(
    id: 'txn_os_017',
    accountId: _checking,
    amount: 5.75,
    date: DateTime(2025, 12, 13),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 14 — Online order
  Transaction(
    id: 'txn_os_018',
    accountId: _checking,
    amount: 48.90,
    date: DateTime(2025, 12, 14),
    name: 'Google Store',
    merchantName: 'Google',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 15 — Paycheck
  Transaction(
    id: 'txn_os_019',
    accountId: _checking,
    amount: -4800,
    date: DateTime(2025, 12, 15),
    name: 'Meridian Media Group Payroll',
    merchantName: 'Meridian Media',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 15 — 401(k) contribution
  Transaction(
    id: 'txn_os_020',
    accountId: _checking,
    amount: 1173,
    date: DateTime(2025, 12, 15),
    name: 'National Retirement 401(k) Contribution',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 16 — Tolls
  Transaction(
    id: 'txn_os_021',
    accountId: _checking,
    amount: 25,
    date: DateTime(2025, 12, 16),
    name: 'TollPass',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 17 — Hardware store
  Transaction(
    id: 'txn_os_022',
    accountId: _checking,
    amount: 145.80,
    date: DateTime(2025, 12, 17),
    name: 'Hardware Depot',
    merchantName: 'Hardware Depot',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 18 — Dining out on credit card (points)
  Transaction(
    id: 'txn_os_023',
    accountId: _credit,
    amount: 142,
    date: DateTime(2025, 12, 18),
    name: 'The Park Tavern',
    merchantName: 'The Park Tavern',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 19 — Weekly groceries
  Transaction(
    id: 'txn_os_024',
    accountId: _checking,
    amount: 112.20,
    date: DateTime(2025, 12, 19),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 20 — Gas
  Transaction(
    id: 'txn_os_025',
    accountId: _checking,
    amount: 55.80,
    date: DateTime(2025, 12, 20),
    name: 'QuickFuel',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 21 — Pharmacy
  Transaction(
    id: 'txn_os_026',
    accountId: _checking,
    amount: 38.50,
    date: DateTime(2025, 12, 21),
    name: 'MedPlus Pharmacy',
    merchantName: 'MedPlus',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 22 — Wholesale run
  Transaction(
    id: 'txn_os_027',
    accountId: _checking,
    amount: 127.40,
    date: DateTime(2025, 12, 22),
    name: 'BulkMart Wholesale',
    merchantName: 'BulkMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 23 — Wine for holidays
  Transaction(
    id: 'txn_os_028',
    accountId: _checking,
    amount: 64.50,
    date: DateTime(2025, 12, 23),
    name: 'Premier Wine & Spirits',
    merchantName: 'Premier Wine',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 26 — Weekly groceries
  Transaction(
    id: 'txn_os_029',
    accountId: _checking,
    amount: 98.15,
    date: DateTime(2025, 12, 26),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 27 — Local bistro on credit card (points)
  Transaction(
    id: 'txn_os_030',
    accountId: _credit,
    amount: 92,
    date: DateTime(2025, 12, 27),
    name: 'Bistro Lumiere',
    merchantName: 'Bistro Lumiere',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 29 — Year-end donation
  Transaction(
    id: 'txn_os_031',
    accountId: _checking,
    amount: 100,
    date: DateTime(2025, 12, 29),
    name: 'Community Food Bank Donation',
    merchantName: 'Community Food Bank',
    category: TransactionCategory.governmentAndNonProfit,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 30 — Credit card payment — pays off December balance in full
  Transaction(
    id: 'txn_os_032',
    accountId: _credit,
    amount: -584,
    date: DateTime(2025, 12, 30),
    name: 'Heritage Sapphire Payment',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // ── January 2026 ────────────────────────────────────────────────────

  // Jan 1 — Paycheck
  Transaction(
    id: 'txn_os_033',
    accountId: _checking,
    amount: -4800,
    date: DateTime(2026),
    name: 'Meridian Media Group Payroll',
    merchantName: 'Meridian Media',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 1 — Mortgage payment
  Transaction(
    id: 'txn_os_034',
    accountId: _checking,
    amount: 1850,
    date: DateTime(2026),
    name: 'Heritage Bank Mortgage Payment',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 1 — 401(k) contribution
  Transaction(
    id: 'txn_os_035',
    accountId: _checking,
    amount: 1173,
    date: DateTime(2026),
    name: 'National Retirement 401(k) Contribution',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 2 — Utilities
  Transaction(
    id: 'txn_os_036',
    accountId: _checking,
    amount: 185,
    date: DateTime(2026, 1, 2),
    name: 'Metro Power Electric',
    merchantName: 'Metro Power',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 2 — Phone bill
  Transaction(
    id: 'txn_os_037',
    accountId: _checking,
    amount: 140,
    date: DateTime(2026, 1, 2),
    name: 'Google Fi Family Plan',
    merchantName: 'Google Fi',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 3 — Auto insurance
  Transaction(
    id: 'txn_os_037b',
    accountId: _checking,
    amount: 135,
    date: DateTime(2026, 1, 3),
    name: 'SafeRide Auto Insurance',
    merchantName: 'SafeRide',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 3 — Health insurance
  Transaction(
    id: 'txn_os_038',
    accountId: _checking,
    amount: 320,
    date: DateTime(2026, 1, 3),
    name: 'Summit Health Insurance',
    merchantName: 'Summit Health',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 4 — Weekly groceries
  Transaction(
    id: 'txn_os_039',
    accountId: _checking,
    amount: 155.60,
    date: DateTime(2026, 1, 4),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 5 — News subscription
  Transaction(
    id: 'txn_os_040',
    accountId: _checking,
    amount: 17,
    date: DateTime(2026, 1, 5),
    name: 'Metro Daily News Subscription',
    merchantName: 'Metro Daily News',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 5 — Sports subscription
  Transaction(
    id: 'txn_os_041',
    accountId: _checking,
    amount: 9.99,
    date: DateTime(2026, 1, 5),
    name: 'Sports Insider Subscription',
    merchantName: 'Sports Insider',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 6 — Gas
  Transaction(
    id: 'txn_os_042',
    accountId: _checking,
    amount: 68.20,
    date: DateTime(2026, 1, 6),
    name: 'QuickFuel',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 7 — Flight booked on credit card (points)
  Transaction(
    id: 'txn_os_043',
    accountId: _credit,
    amount: 380,
    date: DateTime(2026, 1, 7),
    name: 'National Airlines',
    merchantName: 'National Airlines',
    category: TransactionCategory.travel,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 7 — Hotel booked on credit card (points)
  Transaction(
    id: 'txn_os_044',
    accountId: _credit,
    amount: 220,
    date: DateTime(2026, 1, 7),
    name: 'Grand Hotels',
    merchantName: 'Grand Hotels',
    category: TransactionCategory.travel,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 9 — Public radio donation
  Transaction(
    id: 'txn_os_045',
    accountId: _checking,
    amount: 15,
    date: DateTime(2026, 1, 9),
    name: 'Public Radio Monthly Donation',
    merchantName: 'Public Radio',
    category: TransactionCategory.governmentAndNonProfit,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 10 — Wholesale
  Transaction(
    id: 'txn_os_046',
    accountId: _checking,
    amount: 158.70,
    date: DateTime(2026, 1, 10),
    name: 'BulkMart Wholesale',
    merchantName: 'BulkMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 11 — Weekly groceries
  Transaction(
    id: 'txn_os_047',
    accountId: _checking,
    amount: 96.35,
    date: DateTime(2026, 1, 11),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 12 — Dining out on credit card (points)
  Transaction(
    id: 'txn_os_048',
    accountId: _credit,
    amount: 88.50,
    date: DateTime(2026, 1, 12),
    name: 'Cafe Margaux',
    merchantName: 'Cafe Margaux',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 13 — Online order
  Transaction(
    id: 'txn_os_049',
    accountId: _checking,
    amount: 34.99,
    date: DateTime(2026, 1, 13),
    name: 'Google Store',
    merchantName: 'Google',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 14 — Car maintenance
  Transaction(
    id: 'txn_os_050',
    accountId: _checking,
    amount: 180,
    date: DateTime(2026, 1, 14),
    name: 'Express Auto Service',
    merchantName: 'Express Auto',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 15 — Paycheck
  Transaction(
    id: 'txn_os_051',
    accountId: _checking,
    amount: -4800,
    date: DateTime(2026, 1, 15),
    name: 'Meridian Media Group Payroll',
    merchantName: 'Meridian Media',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 15 — 401(k) contribution
  Transaction(
    id: 'txn_os_052',
    accountId: _checking,
    amount: 1173,
    date: DateTime(2026, 1, 15),
    name: 'National Retirement 401(k) Contribution',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 16 — Tolls
  Transaction(
    id: 'txn_os_053',
    accountId: _checking,
    amount: 25,
    date: DateTime(2026, 1, 16),
    name: 'TollPass',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 17 — Department store on credit card (points)
  Transaction(
    id: 'txn_os_054',
    accountId: _credit,
    amount: 120,
    date: DateTime(2026, 1, 17),
    name: 'Westfield Department Store',
    merchantName: 'Westfield',
    category: TransactionCategory.shopping,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 18 — Weekly groceries
  Transaction(
    id: 'txn_os_055',
    accountId: _checking,
    amount: 105.90,
    date: DateTime(2026, 1, 18),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 19 — Gas
  Transaction(
    id: 'txn_os_056',
    accountId: _checking,
    amount: 71.50,
    date: DateTime(2026, 1, 19),
    name: 'QuickFuel',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 20 — Wine
  Transaction(
    id: 'txn_os_057',
    accountId: _checking,
    amount: 52,
    date: DateTime(2026, 1, 20),
    name: 'Premier Wine & Spirits',
    merchantName: 'Premier Wine',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 21 — Coffee
  Transaction(
    id: 'txn_os_058',
    accountId: _checking,
    amount: 5.75,
    date: DateTime(2026, 1, 21),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 22 — Medical copay
  Transaction(
    id: 'txn_os_059',
    accountId: _checking,
    amount: 40,
    date: DateTime(2026, 1, 22),
    name: 'Metro Medical Center',
    merchantName: 'Metro Medical',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 23 — Hardware store
  Transaction(
    id: 'txn_os_060',
    accountId: _checking,
    amount: 78.25,
    date: DateTime(2026, 1, 23),
    name: 'Hardware Depot',
    merchantName: 'Hardware Depot',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 24 — Wholesale
  Transaction(
    id: 'txn_os_061',
    accountId: _checking,
    amount: 135.30,
    date: DateTime(2026, 1, 24),
    name: 'BulkMart Wholesale',
    merchantName: 'BulkMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 25 — Weekly groceries
  Transaction(
    id: 'txn_os_062',
    accountId: _checking,
    amount: 102.55,
    date: DateTime(2026, 1, 25),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 26 — Dining out on credit card (points)
  Transaction(
    id: 'txn_os_063',
    accountId: _credit,
    amount: 95,
    date: DateTime(2026, 1, 26),
    name: 'The Elm Restaurant',
    merchantName: 'The Elm',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 27 — Online order
  Transaction(
    id: 'txn_os_064',
    accountId: _checking,
    amount: 72.50,
    date: DateTime(2026, 1, 27),
    name: 'Google Store',
    merchantName: 'Google',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 28 — Pharmacy
  Transaction(
    id: 'txn_os_065',
    accountId: _checking,
    amount: 28.75,
    date: DateTime(2026, 1, 28),
    name: 'MedPlus Pharmacy',
    merchantName: 'MedPlus',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 30 — Credit card payment — pays off January balance in full
  Transaction(
    id: 'txn_os_066',
    accountId: _credit,
    amount: -903.50,
    date: DateTime(2026, 1, 30),
    name: 'Heritage Sapphire Payment',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // ── February 2026 ───────────────────────────────────────────────────

  // Feb 1 — Paycheck
  Transaction(
    id: 'txn_os_067',
    accountId: _checking,
    amount: -4800,
    date: DateTime(2026, 2),
    name: 'Meridian Media Group Payroll',
    merchantName: 'Meridian Media',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 1 — Mortgage payment
  Transaction(
    id: 'txn_os_068',
    accountId: _checking,
    amount: 1850,
    date: DateTime(2026, 2),
    name: 'Heritage Bank Mortgage Payment',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 1 — 401(k) contribution
  Transaction(
    id: 'txn_os_069',
    accountId: _checking,
    amount: 1173,
    date: DateTime(2026, 2),
    name: 'National Retirement 401(k) Contribution',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 2 — Utilities
  Transaction(
    id: 'txn_os_070',
    accountId: _checking,
    amount: 185,
    date: DateTime(2026, 2, 2),
    name: 'Metro Power Electric',
    merchantName: 'Metro Power',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 2 — Phone bill
  Transaction(
    id: 'txn_os_071',
    accountId: _checking,
    amount: 140,
    date: DateTime(2026, 2, 2),
    name: 'Google Fi Family Plan',
    merchantName: 'Google Fi',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 3 — Auto insurance
  Transaction(
    id: 'txn_os_071b',
    accountId: _checking,
    amount: 135,
    date: DateTime(2026, 2, 3),
    name: 'SafeRide Auto Insurance',
    merchantName: 'SafeRide',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 3 — Health insurance
  Transaction(
    id: 'txn_os_072',
    accountId: _checking,
    amount: 320,
    date: DateTime(2026, 2, 3),
    name: 'Summit Health Insurance',
    merchantName: 'Summit Health',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 3 — Weekly groceries
  Transaction(
    id: 'txn_os_073',
    accountId: _checking,
    amount: 108.80,
    date: DateTime(2026, 2, 3),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Feb 4 — News subscription
  Transaction(
    id: 'txn_os_074',
    accountId: _checking,
    amount: 17,
    date: DateTime(2026, 2, 4),
    name: 'Metro Daily News Subscription',
    merchantName: 'Metro Daily News',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 4 — Sports subscription
  Transaction(
    id: 'txn_os_075',
    accountId: _checking,
    amount: 9.99,
    date: DateTime(2026, 2, 4),
    name: 'Sports Insider Subscription',
    merchantName: 'Sports Insider',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 5 — Pending: Groceries (not yet cleared)
  Transaction(
    id: 'txn_os_076',
    accountId: _checking,
    amount: 95.40,
    date: DateTime(2026, 2, 5),
    name: 'Green Basket Market',
    merchantName: 'Green Basket',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
    pending: true,
  ),

  // Feb 5 — Pending: Dining on credit card (not yet cleared)
  Transaction(
    id: 'txn_os_077',
    accountId: _credit,
    amount: 85,
    date: DateTime(2026, 2, 5),
    name: 'Bistro Lumiere',
    merchantName: 'Bistro Lumiere',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
    pending: true,
  ),
];
