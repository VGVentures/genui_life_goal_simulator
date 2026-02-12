import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:finance_app/financials/models/models.dart';

// ---------------------------------------------------------------------------
// Young & Responsible — Alex, 23, junior software developer
// ---------------------------------------------------------------------------

// ── Account IDs ──────────────────────────────────────────────────────────
const _checking = 'acc_yr_checking';
const _savings = 'acc_yr_savings';
const _credit = 'acc_yr_credit';

final youngResponsibleScenario = MockScenario(
  name: 'Young & Responsible',
  description:
      'Alex, 23 — junior software developer. Disciplined saver who '
      'pays credit card in full monthly, cooks at home mostly, and lives a '
      'modest lifestyle. Biweekly paycheck with automatic savings transfers.',
  accounts: _accounts,
  transactions: _transactions,
);

// ── Accounts ─────────────────────────────────────────────────────────────
const _accounts = <Account>[
  Account(
    id: _checking,
    name: 'First National Checking',
    type: AccountType.depository,
    subtype: AccountSubtype.checking,
    mask: '4523',
    balance: Balance(
      current: 1350.43,
      available: 1303.60,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _savings,
    name: 'Summit High-Yield Savings',
    type: AccountType.depository,
    subtype: AccountSubtype.savings,
    mask: '7891',
    balance: Balance(
      current: 8420,
      available: 8420,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _credit,
    name: 'Horizon Student Card',
    type: AccountType.credit,
    subtype: AccountSubtype.creditCard,
    mask: '3344',
    balance: Balance(
      current: 15.98,
      limit: 3000,
      currencyCode: CurrencyCode.usd,
    ),
  ),
];

// ── Transactions (Dec 1 2025 – Feb 5 2026) ──────────────────────────────
final _transactions = <Transaction>[
  // ── December 2025 ───────────────────────────────────────────────────

  // Dec 1 — Paycheck
  Transaction(
    id: 'txn_yr_001',
    accountId: _checking,
    amount: -2350,
    date: DateTime(2025, 12),
    name: 'ACME CORP PAYROLL',
    merchantName: 'ACME CORP',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 1 — Rent
  Transaction(
    id: 'txn_yr_002',
    accountId: _checking,
    amount: 1100,
    date: DateTime(2025, 12),
    name: 'Bank Transfer - Rent',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 1 — Health insurance premium
  Transaction(
    id: 'txn_yr_002b',
    accountId: _checking,
    amount: 120,
    date: DateTime(2025, 12),
    name: 'Summit Health Insurance',
    merchantName: 'Summit Health',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 2 — Savings transfer (checking side)
  Transaction(
    id: 'txn_yr_003',
    accountId: _checking,
    amount: 500,
    date: DateTime(2025, 12, 2),
    name: 'Transfer to Summit Savings',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 2 — Savings transfer (savings side)
  Transaction(
    id: 'txn_yr_004',
    accountId: _savings,
    amount: -500,
    date: DateTime(2025, 12, 2),
    name: 'Transfer from First National',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 3 — Groceries
  Transaction(
    id: 'txn_yr_005',
    accountId: _checking,
    amount: 52.37,
    date: DateTime(2025, 12, 3),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 4 — YouTube Premium (credit card)
  Transaction(
    id: 'txn_yr_006',
    accountId: _credit,
    amount: 13.99,
    date: DateTime(2025, 12, 4),
    name: 'YouTube Premium',
    merchantName: 'Google',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 4 — Google One (credit card)
  Transaction(
    id: 'txn_yr_007',
    accountId: _credit,
    amount: 1.99,
    date: DateTime(2025, 12, 4),
    name: 'Google One Storage',
    merchantName: 'Google',
    category: TransactionCategory.shopping,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 5 — Gym
  Transaction(
    id: 'txn_yr_008',
    accountId: _checking,
    amount: 29.99,
    date: DateTime(2025, 12, 5),
    name: 'FitLife Gym Monthly',
    merchantName: 'FitLife Gym',
    category: TransactionCategory.personalCare,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 6 — Coffee
  Transaction(
    id: 'txn_yr_009',
    accountId: _checking,
    amount: 5.50,
    date: DateTime(2025, 12, 6),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 7 — Gas
  Transaction(
    id: 'txn_yr_010',
    accountId: _checking,
    amount: 42.18,
    date: DateTime(2025, 12, 7),
    name: 'QuickFuel #13847',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 8 — Fast casual
  Transaction(
    id: 'txn_yr_011',
    accountId: _checking,
    amount: 13.45,
    date: DateTime(2025, 12, 8),
    name: 'Burrito Bowl Co',
    merchantName: 'Burrito Bowl',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 10 — Car Insurance
  Transaction(
    id: 'txn_yr_012',
    accountId: _checking,
    amount: 95,
    date: DateTime(2025, 12, 10),
    name: 'SafeRide Auto Insurance',
    merchantName: 'SafeRide Auto Insurance',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 10 — Google Fi
  Transaction(
    id: 'txn_yr_013',
    accountId: _checking,
    amount: 35,
    date: DateTime(2025, 12, 10),
    name: 'Google Fi Wireless',
    merchantName: 'Google Fi',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 11 — Groceries
  Transaction(
    id: 'txn_yr_014',
    accountId: _checking,
    amount: 38.14,
    date: DateTime(2025, 12, 11),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 13 — Coffee
  Transaction(
    id: 'txn_yr_015',
    accountId: _checking,
    amount: 5.50,
    date: DateTime(2025, 12, 13),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 14 — Movie
  Transaction(
    id: 'txn_yr_016',
    accountId: _checking,
    amount: 16,
    date: DateTime(2025, 12, 14),
    name: 'Cinema Palace',
    merchantName: 'Cinema Palace',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 15 — Paycheck
  Transaction(
    id: 'txn_yr_017',
    accountId: _checking,
    amount: -2350,
    date: DateTime(2025, 12, 15),
    name: 'ACME CORP PAYROLL',
    merchantName: 'ACME CORP',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 16 — Savings transfer (checking side)
  Transaction(
    id: 'txn_yr_018',
    accountId: _checking,
    amount: 500,
    date: DateTime(2025, 12, 16),
    name: 'Transfer to Summit Savings',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 16 — Savings transfer (savings side)
  Transaction(
    id: 'txn_yr_019',
    accountId: _savings,
    amount: -500,
    date: DateTime(2025, 12, 16),
    name: 'Transfer from First National',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 17 — Groceries
  Transaction(
    id: 'txn_yr_020',
    accountId: _checking,
    amount: 61.23,
    date: DateTime(2025, 12, 17),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 18 — Food
  Transaction(
    id: 'txn_yr_021',
    accountId: _checking,
    amount: 14.72,
    date: DateTime(2025, 12, 18),
    name: 'Burrito Bowl Co',
    merchantName: 'Burrito Bowl',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 19 — Google Store (credit card)
  Transaction(
    id: 'txn_yr_022',
    accountId: _credit,
    amount: 27.49,
    date: DateTime(2025, 12, 19),
    name: 'Google Store',
    merchantName: 'Google',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 20 — Gas
  Transaction(
    id: 'txn_yr_023',
    accountId: _checking,
    amount: 37.54,
    date: DateTime(2025, 12, 20),
    name: 'FastGas #09241',
    merchantName: 'FastGas',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 22 — Ride
  Transaction(
    id: 'txn_yr_024',
    accountId: _checking,
    amount: 18.43,
    date: DateTime(2025, 12, 22),
    name: 'Waymo Ride',
    merchantName: 'Waymo',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 23 — Groceries
  Transaction(
    id: 'txn_yr_025',
    accountId: _checking,
    amount: 47.82,
    date: DateTime(2025, 12, 23),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 24 — Bookstore
  Transaction(
    id: 'txn_yr_026',
    accountId: _checking,
    amount: 14.99,
    date: DateTime(2025, 12, 24),
    name: 'Page & Spine Books',
    merchantName: 'Page & Spine',
    category: TransactionCategory.shopping,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 28 — Coffee
  Transaction(
    id: 'txn_yr_027',
    accountId: _checking,
    amount: 5.50,
    date: DateTime(2025, 12, 28),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 30 — Groceries
  Transaction(
    id: 'txn_yr_028',
    accountId: _checking,
    amount: 55.09,
    date: DateTime(2025, 12, 30),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 31 — Credit card payment (pays off statement balance)
  Transaction(
    id: 'txn_yr_028b',
    accountId: _credit,
    amount: -43.47,
    date: DateTime(2025, 12, 31),
    name: 'Horizon Card Payment',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // ── January 2026 ───────────────────────────────────────────────────

  // Jan 1 — Paycheck
  Transaction(
    id: 'txn_yr_029',
    accountId: _checking,
    amount: -2350,
    date: DateTime(2026),
    name: 'ACME CORP PAYROLL',
    merchantName: 'ACME CORP',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 1 — Health insurance premium
  Transaction(
    id: 'txn_yr_029b',
    accountId: _checking,
    amount: 120,
    date: DateTime(2026),
    name: 'Summit Health Insurance',
    merchantName: 'Summit Health',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 1 — Rent
  Transaction(
    id: 'txn_yr_030',
    accountId: _checking,
    amount: 1100,
    date: DateTime(2026),
    name: 'Bank Transfer - Rent',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 2 — Savings transfer (checking side)
  Transaction(
    id: 'txn_yr_031',
    accountId: _checking,
    amount: 500,
    date: DateTime(2026, 1, 2),
    name: 'Transfer to Summit Savings',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 2 — Savings transfer (savings side)
  Transaction(
    id: 'txn_yr_032',
    accountId: _savings,
    amount: -500,
    date: DateTime(2026, 1, 2),
    name: 'Transfer from First National',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 3 — Groceries
  Transaction(
    id: 'txn_yr_033',
    accountId: _checking,
    amount: 43.67,
    date: DateTime(2026, 1, 3),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 4 — YouTube Premium (credit card)
  Transaction(
    id: 'txn_yr_034',
    accountId: _credit,
    amount: 13.99,
    date: DateTime(2026, 1, 4),
    name: 'YouTube Premium',
    merchantName: 'Google',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 4 — Google One (credit card)
  Transaction(
    id: 'txn_yr_035',
    accountId: _credit,
    amount: 1.99,
    date: DateTime(2026, 1, 4),
    name: 'Google One Storage',
    merchantName: 'Google',
    category: TransactionCategory.shopping,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 5 — Gym
  Transaction(
    id: 'txn_yr_036',
    accountId: _checking,
    amount: 29.99,
    date: DateTime(2026, 1, 5),
    name: 'FitLife Gym Monthly',
    merchantName: 'FitLife Gym',
    category: TransactionCategory.personalCare,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 6 — Gas
  Transaction(
    id: 'txn_yr_037',
    accountId: _checking,
    amount: 45.30,
    date: DateTime(2026, 1, 6),
    name: 'QuickFuel #13847',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 7 — Fast casual
  Transaction(
    id: 'txn_yr_038',
    accountId: _checking,
    amount: 12.85,
    date: DateTime(2026, 1, 7),
    name: 'Burrito Bowl Co',
    merchantName: 'Burrito Bowl',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 8 — Coffee
  Transaction(
    id: 'txn_yr_039',
    accountId: _checking,
    amount: 5.50,
    date: DateTime(2026, 1, 8),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 10 — Car Insurance
  Transaction(
    id: 'txn_yr_040',
    accountId: _checking,
    amount: 95,
    date: DateTime(2026, 1, 10),
    name: 'SafeRide Auto Insurance',
    merchantName: 'SafeRide',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 10 — Google Fi
  Transaction(
    id: 'txn_yr_041',
    accountId: _checking,
    amount: 35,
    date: DateTime(2026, 1, 10),
    name: 'Google Fi Wireless',
    merchantName: 'Google Fi',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 11 — General merchandise
  Transaction(
    id: 'txn_yr_042',
    accountId: _checking,
    amount: 28.47,
    date: DateTime(2026, 1, 11),
    name: 'HomeMart T-2174',
    merchantName: 'HomeMart',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 12 — Groceries
  Transaction(
    id: 'txn_yr_043',
    accountId: _checking,
    amount: 58.91,
    date: DateTime(2026, 1, 12),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 14 — Google Play (credit card)
  Transaction(
    id: 'txn_yr_044',
    accountId: _credit,
    amount: 19.99,
    date: DateTime(2026, 1, 14),
    name: 'Google Play',
    merchantName: 'Google',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 15 — Paycheck
  Transaction(
    id: 'txn_yr_045',
    accountId: _checking,
    amount: -2350,
    date: DateTime(2026, 1, 15),
    name: 'ACME CORP PAYROLL',
    merchantName: 'ACME CORP',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 16 — Savings transfer (checking side)
  Transaction(
    id: 'txn_yr_046',
    accountId: _checking,
    amount: 500,
    date: DateTime(2026, 1, 16),
    name: 'Transfer to Summit Savings',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 16 — Savings transfer (savings side)
  Transaction(
    id: 'txn_yr_047',
    accountId: _savings,
    amount: -500,
    date: DateTime(2026, 1, 16),
    name: 'Transfer from First National',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 17 — Groceries
  Transaction(
    id: 'txn_yr_048',
    accountId: _checking,
    amount: 35.42,
    date: DateTime(2026, 1, 17),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 18 — Gas
  Transaction(
    id: 'txn_yr_049',
    accountId: _checking,
    amount: 39.76,
    date: DateTime(2026, 1, 18),
    name: 'FastGas #09241',
    merchantName: 'FastGas',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 19 — Fast casual
  Transaction(
    id: 'txn_yr_050',
    accountId: _checking,
    amount: 14.20,
    date: DateTime(2026, 1, 19),
    name: 'Burrito Bowl Co',
    merchantName: 'Burrito Bowl',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 20 — Google Store (credit card)
  Transaction(
    id: 'txn_yr_051',
    accountId: _credit,
    amount: 34.99,
    date: DateTime(2026, 1, 20),
    name: 'Google Store',
    merchantName: 'Google',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 21 — Ride
  Transaction(
    id: 'txn_yr_052',
    accountId: _checking,
    amount: 14.87,
    date: DateTime(2026, 1, 21),
    name: 'Waymo Ride',
    merchantName: 'Waymo',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 23 — Coffee
  Transaction(
    id: 'txn_yr_053',
    accountId: _checking,
    amount: 5.50,
    date: DateTime(2026, 1, 23),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 25 — Groceries
  Transaction(
    id: 'txn_yr_054',
    accountId: _checking,
    amount: 64.33,
    date: DateTime(2026, 1, 25),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 28 — Fast casual
  Transaction(
    id: 'txn_yr_055',
    accountId: _checking,
    amount: 13.15,
    date: DateTime(2026, 1, 28),
    name: 'Burrito Bowl Co',
    merchantName: 'Burrito Bowl',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 30 — Groceries
  Transaction(
    id: 'txn_yr_056',
    accountId: _checking,
    amount: 41.58,
    date: DateTime(2026, 1, 30),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 31 — Credit card payment (pays off statement balance)
  Transaction(
    id: 'txn_yr_056b',
    accountId: _credit,
    amount: -70.96,
    date: DateTime(2026, 1, 31),
    name: 'Horizon Card Payment',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // ── February 2026 ──────────────────────────────────────────────────

  // Feb 1 — Paycheck
  Transaction(
    id: 'txn_yr_057',
    accountId: _checking,
    amount: -2350,
    date: DateTime(2026, 2),
    name: 'ACME CORP PAYROLL',
    merchantName: 'ACME CORP',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 1 — Health insurance premium
  Transaction(
    id: 'txn_yr_057b',
    accountId: _checking,
    amount: 120,
    date: DateTime(2026, 2),
    name: 'Summit Health Insurance',
    merchantName: 'Summit Health',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 1 — Rent
  Transaction(
    id: 'txn_yr_058',
    accountId: _checking,
    amount: 1100,
    date: DateTime(2026, 2),
    name: 'Bank Transfer - Rent',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 2 — Savings transfer (checking side)
  Transaction(
    id: 'txn_yr_059',
    accountId: _checking,
    amount: 500,
    date: DateTime(2026, 2, 2),
    name: 'Transfer to Summit Savings',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 2 — Savings transfer (savings side)
  Transaction(
    id: 'txn_yr_060',
    accountId: _savings,
    amount: -500,
    date: DateTime(2026, 2, 2),
    name: 'Transfer from First National',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 3 — Groceries
  Transaction(
    id: 'txn_yr_061',
    accountId: _checking,
    amount: 49.26,
    date: DateTime(2026, 2, 3),
    name: 'Fresh Harvest #742',
    merchantName: 'Fresh Harvest',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Feb 4 — YouTube Premium (credit card)
  Transaction(
    id: 'txn_yr_062',
    accountId: _credit,
    amount: 13.99,
    date: DateTime(2026, 2, 4),
    name: 'YouTube Premium',
    merchantName: 'Google',
    category: TransactionCategory.entertainment,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 4 — Google One (credit card)
  Transaction(
    id: 'txn_yr_063',
    accountId: _credit,
    amount: 1.99,
    date: DateTime(2026, 2, 4),
    name: 'Google One Storage',
    merchantName: 'Google',
    category: TransactionCategory.shopping,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 5 — Gas (pending)
  Transaction(
    id: 'txn_yr_064',
    accountId: _checking,
    amount: 41.33,
    date: DateTime(2026, 2, 5),
    name: 'QuickFuel #13847',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
    pending: true,
  ),

  // Feb 5 — Coffee (pending)
  Transaction(
    id: 'txn_yr_065',
    accountId: _checking,
    amount: 5.50,
    date: DateTime(2026, 2, 5),
    name: 'Morning Brew Coffee',
    merchantName: 'Morning Brew Coffee',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
    pending: true,
  ),
];
