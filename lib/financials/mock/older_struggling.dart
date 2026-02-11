import 'package:finance_app/financials/mock/mock_scenario.dart';
import 'package:finance_app/financials/models/models.dart';

// ---------------------------------------------------------------------------
// Older & Struggling — Dennis, 56, distribution center supervisor
// ---------------------------------------------------------------------------

// ── Account IDs ──────────────────────────────────────────────────────────
const _checking = 'acc_og_checking';
const _savings = 'acc_og_savings';
const _credit = 'acc_og_credit';
const _auto = 'acc_og_auto';
const _student = 'acc_og_student';

final olderStrugglingScenario = MockScenario(
  name: 'Older & Struggling',
  description:
      'Dennis, 56 – distribution center supervisor, divorced. '
      '94.7% credit utilisation, paying only minimums, medical debt on a '
      'payment plan, co-signed student loan, savings being drained to cover '
      'shortfalls, and bank fees piling up. Every dollar is accounted for '
      'before the paycheck clears.',
  accounts: _accounts,
  transactions: _transactions,
);

// ── Accounts ─────────────────────────────────────────────────────────────
const _accounts = <Account>[
  Account(
    id: _checking,
    name: 'Midwest Federal Checking',
    type: AccountType.depository,
    subtype: AccountSubtype.checking,
    mask: '3456',
    balance: Balance(
      current: 1245.30,
      available: 1163.16,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _savings,
    name: 'Midwest Federal Savings',
    type: AccountType.depository,
    subtype: AccountSubtype.savings,
    mask: '3457',
    balance: Balance(
      current: 820,
      available: 820,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _credit,
    name: 'Metro Cash Back Card',
    type: AccountType.credit,
    subtype: AccountSubtype.creditCard,
    mask: '7890',
    balance: Balance(
      current: 14200,
      limit: 15000,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _auto,
    name: 'Summit Auto Finance',
    type: AccountType.loan,
    subtype: AccountSubtype.autoLoan,
    mask: '4561',
    balance: Balance(
      current: 18500,
      currencyCode: CurrencyCode.usd,
    ),
  ),
  Account(
    id: _student,
    name: 'Federal Loan Services',
    type: AccountType.loan,
    subtype: AccountSubtype.studentLoan,
    mask: '2222',
    balance: Balance(
      current: 32000,
      currencyCode: CurrencyCode.usd,
    ),
  ),
];

// ── Transactions (Dec 1 2025 – Feb 5 2026, chronological) ───────────────
final _transactions = <Transaction>[
  // ── December 2025 ───────────────────────────────────────────────────

  // Dec 1 – Paycheck
  Transaction(
    id: 'txn_og_001',
    accountId: _checking,
    amount: -2200,
    date: DateTime(2025, 12),
    name: 'Metro Distribution - Direct Deposit',
    merchantName: 'Metro Distribution',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 1 – Rent
  Transaction(
    id: 'txn_og_002',
    accountId: _checking,
    amount: 1350,
    date: DateTime(2025, 12),
    name: 'Bank Transfer - Rent',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 2 – Auto loan payment
  Transaction(
    id: 'txn_og_003',
    accountId: _checking,
    amount: 420,
    date: DateTime(2025, 12, 2),
    name: 'Summit Auto Payment',
    merchantName: 'Summit Auto Finance',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 3 – Student loan payment (co-signed for child)
  Transaction(
    id: 'txn_og_004',
    accountId: _checking,
    amount: 280,
    date: DateTime(2025, 12, 3),
    name: 'Federal Loan Payment',
    merchantName: 'Federal Loan Services',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 4 – Credit card minimum payment
  Transaction(
    id: 'txn_og_005',
    accountId: _checking,
    amount: 285,
    date: DateTime(2025, 12, 4),
    name: 'Metro Card Payment',
    merchantName: 'Metro Bank',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),
  Transaction(
    id: 'txn_og_005b',
    accountId: _credit,
    amount: -285,
    date: DateTime(2025, 12, 4),
    name: 'Metro Card Payment',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 5 – Electric bill
  Transaction(
    id: 'txn_og_006',
    accountId: _checking,
    amount: 165,
    date: DateTime(2025, 12, 5),
    name: 'Valley Power Electric',
    merchantName: 'Valley Power',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 5 – Phone bill
  Transaction(
    id: 'txn_og_007',
    accountId: _checking,
    amount: 35,
    date: DateTime(2025, 12, 5),
    name: 'BudgetTel Wireless',
    merchantName: 'BudgetTel',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 6 – Internet
  Transaction(
    id: 'txn_og_008',
    accountId: _checking,
    amount: 55,
    date: DateTime(2025, 12, 6),
    name: 'CableLink Internet',
    merchantName: 'CableLink',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 6 – Auto insurance (liability-only, cheapest option)
  Transaction(
    id: 'txn_og_008b',
    accountId: _checking,
    amount: 95,
    date: DateTime(2025, 12, 6),
    name: 'SafeRide Insurance',
    merchantName: 'SafeRide',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.online,
  ),

  // Dec 6 – Medical payment plan
  Transaction(
    id: 'txn_og_009',
    accountId: _checking,
    amount: 150,
    date: DateTime(2025, 12, 6),
    name: 'Regional Medical Center',
    merchantName: 'Regional Medical Center',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 7 – Groceries
  Transaction(
    id: 'txn_og_010',
    accountId: _checking,
    amount: 98.42,
    date: DateTime(2025, 12, 7),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 8 – Gas
  Transaction(
    id: 'txn_og_011',
    accountId: _checking,
    amount: 58.30,
    date: DateTime(2025, 12, 8),
    name: 'QuickFuel Gas',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 9 – Account maintenance fee (can't keep minimum balance)
  Transaction(
    id: 'txn_og_012',
    accountId: _checking,
    amount: 12,
    date: DateTime(2025, 12, 9),
    name: 'Monthly Maintenance Fee',
    category: TransactionCategory.bankFees,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 10 – Fast food
  Transaction(
    id: 'txn_og_013',
    accountId: _checking,
    amount: 9.47,
    date: DateTime(2025, 12, 10),
    name: 'QuickBurger',
    merchantName: 'QuickBurger',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 11 – Discount store
  Transaction(
    id: 'txn_og_014',
    accountId: _checking,
    amount: 16.83,
    date: DateTime(2025, 12, 11),
    name: 'Discount Depot',
    merchantName: 'Discount Depot',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 12 – Pharmacy (put on credit card — adding to debt)
  Transaction(
    id: 'txn_og_015',
    accountId: _credit,
    amount: 67.50,
    date: DateTime(2025, 12, 12),
    name: 'MedPlus Pharmacy',
    merchantName: 'MedPlus',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 13 – Savings-to-checking transfer $200 (covering shortfall)
  // Checking side: money in
  Transaction(
    id: 'txn_og_016',
    accountId: _checking,
    amount: -200,
    date: DateTime(2025, 12, 13),
    name: 'Transfer from Savings',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),
  // Savings side: money out
  Transaction(
    id: 'txn_og_017',
    accountId: _savings,
    amount: 200,
    date: DateTime(2025, 12, 13),
    name: 'Transfer to Checking',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 14 – Groceries
  Transaction(
    id: 'txn_og_018',
    accountId: _checking,
    amount: 76.19,
    date: DateTime(2025, 12, 14),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 15 – Paycheck
  Transaction(
    id: 'txn_og_019',
    accountId: _checking,
    amount: -2200,
    date: DateTime(2025, 12, 15),
    name: 'Metro Distribution - Direct Deposit',
    merchantName: 'Metro Distribution',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Dec 16 – Fast food
  Transaction(
    id: 'txn_og_020',
    accountId: _checking,
    amount: 10.63,
    date: DateTime(2025, 12, 16),
    name: 'Redtop Grill',
    merchantName: 'Redtop Grill',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 17 – Discount groceries
  Transaction(
    id: 'txn_og_021',
    accountId: _checking,
    amount: 52.34,
    date: DateTime(2025, 12, 17),
    name: 'SaveMore Grocery',
    merchantName: 'SaveMore',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 18 – Gas (put on credit card — adding to debt)
  Transaction(
    id: 'txn_og_022',
    accountId: _credit,
    amount: 62.10,
    date: DateTime(2025, 12, 18),
    name: 'QuickFuel Gas',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 20 – Discount store
  Transaction(
    id: 'txn_og_023',
    accountId: _checking,
    amount: 14.29,
    date: DateTime(2025, 12, 20),
    name: 'Discount Depot',
    merchantName: 'Discount Depot',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 21 – Groceries
  Transaction(
    id: 'txn_og_024',
    accountId: _checking,
    amount: 105.67,
    date: DateTime(2025, 12, 21),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 22 – Gas
  Transaction(
    id: 'txn_og_025',
    accountId: _checking,
    amount: 53.80,
    date: DateTime(2025, 12, 22),
    name: 'QuickFuel Gas',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 23 – Fast food
  Transaction(
    id: 'txn_og_026',
    accountId: _checking,
    amount: 11.28,
    date: DateTime(2025, 12, 23),
    name: 'QuickBurger',
    merchantName: 'QuickBurger',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 26 – Household necessities
  Transaction(
    id: 'txn_og_027',
    accountId: _checking,
    amount: 37.14,
    date: DateTime(2025, 12, 26),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 28 – Groceries
  Transaction(
    id: 'txn_og_028',
    accountId: _checking,
    amount: 88.53,
    date: DateTime(2025, 12, 28),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Dec 29 – Fast food
  Transaction(
    id: 'txn_og_029',
    accountId: _checking,
    amount: 9.86,
    date: DateTime(2025, 12, 29),
    name: 'Redtop Grill',
    merchantName: 'Redtop Grill',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // ── January 2026 ────────────────────────────────────────────────────

  // Jan 1 – Paycheck
  Transaction(
    id: 'txn_og_030',
    accountId: _checking,
    amount: -2200,
    date: DateTime(2026),
    name: 'Metro Distribution - Direct Deposit',
    merchantName: 'Metro Distribution',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 1 – Rent
  Transaction(
    id: 'txn_og_031',
    accountId: _checking,
    amount: 1350,
    date: DateTime(2026),
    name: 'Bank Transfer - Rent',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 2 – Auto loan payment
  Transaction(
    id: 'txn_og_032',
    accountId: _checking,
    amount: 420,
    date: DateTime(2026, 1, 2),
    name: 'Summit Auto Payment',
    merchantName: 'Summit Auto Finance',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 3 – Student loan payment
  Transaction(
    id: 'txn_og_033',
    accountId: _checking,
    amount: 280,
    date: DateTime(2026, 1, 3),
    name: 'Federal Loan Payment',
    merchantName: 'Federal Loan Services',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 4 – Credit card minimum payment
  Transaction(
    id: 'txn_og_034',
    accountId: _checking,
    amount: 285,
    date: DateTime(2026, 1, 4),
    name: 'Metro Card Payment',
    merchantName: 'Metro Bank',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),
  Transaction(
    id: 'txn_og_034b',
    accountId: _credit,
    amount: -285,
    date: DateTime(2026, 1, 4),
    name: 'Metro Card Payment',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 5 – Electric bill
  Transaction(
    id: 'txn_og_035',
    accountId: _checking,
    amount: 165,
    date: DateTime(2026, 1, 5),
    name: 'Valley Power Electric',
    merchantName: 'Valley Power',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 5 – Phone bill
  Transaction(
    id: 'txn_og_036',
    accountId: _checking,
    amount: 35,
    date: DateTime(2026, 1, 5),
    name: 'BudgetTel Wireless',
    merchantName: 'BudgetTel',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 6 – Internet
  Transaction(
    id: 'txn_og_037',
    accountId: _checking,
    amount: 55,
    date: DateTime(2026, 1, 6),
    name: 'CableLink Internet',
    merchantName: 'CableLink',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 6 – Auto insurance
  Transaction(
    id: 'txn_og_037b',
    accountId: _checking,
    amount: 95,
    date: DateTime(2026, 1, 6),
    name: 'SafeRide Insurance',
    merchantName: 'SafeRide',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.online,
  ),

  // Jan 6 – Medical payment plan
  Transaction(
    id: 'txn_og_038',
    accountId: _checking,
    amount: 150,
    date: DateTime(2026, 1, 6),
    name: 'Regional Medical Center',
    merchantName: 'Regional Medical Center',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 7 – Account maintenance fee
  Transaction(
    id: 'txn_og_039',
    accountId: _checking,
    amount: 12,
    date: DateTime(2026, 1, 7),
    name: 'Monthly Maintenance Fee',
    category: TransactionCategory.bankFees,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 7 – Late fee on credit card (missed timing)
  Transaction(
    id: 'txn_og_040',
    accountId: _credit,
    amount: 39,
    date: DateTime(2026, 1, 7),
    name: 'Late Payment Fee',
    category: TransactionCategory.bankFees,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 8 – Groceries
  Transaction(
    id: 'txn_og_041',
    accountId: _checking,
    amount: 110.25,
    date: DateTime(2026, 1, 8),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 9 – Gas
  Transaction(
    id: 'txn_og_042',
    accountId: _checking,
    amount: 55.40,
    date: DateTime(2026, 1, 9),
    name: 'QuickFuel Gas',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 10 – Discount store
  Transaction(
    id: 'txn_og_043',
    accountId: _checking,
    amount: 19.72,
    date: DateTime(2026, 1, 10),
    name: 'Discount Depot',
    merchantName: 'Discount Depot',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 11 – Savings-to-checking transfer $350 (desperate shortfall)
  Transaction(
    id: 'txn_og_044',
    accountId: _checking,
    amount: -350,
    date: DateTime(2026, 1, 11),
    name: 'Transfer from Savings',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),
  Transaction(
    id: 'txn_og_045',
    accountId: _savings,
    amount: 350,
    date: DateTime(2026, 1, 11),
    name: 'Transfer to Checking',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 12 – Pharmacy
  Transaction(
    id: 'txn_og_046',
    accountId: _checking,
    amount: 48.90,
    date: DateTime(2026, 1, 12),
    name: 'MedPlus Pharmacy',
    merchantName: 'MedPlus',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 13 – Lab work (one-time)
  Transaction(
    id: 'txn_og_047',
    accountId: _checking,
    amount: 85,
    date: DateTime(2026, 1, 13),
    name: 'Metro Diagnostics',
    merchantName: 'Metro Diagnostics',
    category: TransactionCategory.healthcare,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 14 – Fast food
  Transaction(
    id: 'txn_og_048',
    accountId: _checking,
    amount: 8.56,
    date: DateTime(2026, 1, 14),
    name: 'QuickBurger',
    merchantName: 'QuickBurger',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 15 – Paycheck
  Transaction(
    id: 'txn_og_049',
    accountId: _checking,
    amount: -2200,
    date: DateTime(2026, 1, 15),
    name: 'Metro Distribution - Direct Deposit',
    merchantName: 'Metro Distribution',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Jan 16 – Groceries
  Transaction(
    id: 'txn_og_050',
    accountId: _checking,
    amount: 72.38,
    date: DateTime(2026, 1, 16),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 17 – Discount groceries
  Transaction(
    id: 'txn_og_051',
    accountId: _checking,
    amount: 44.60,
    date: DateTime(2026, 1, 17),
    name: 'SaveMore Grocery',
    merchantName: 'SaveMore',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 18 – Fast food
  Transaction(
    id: 'txn_og_052',
    accountId: _checking,
    amount: 10.17,
    date: DateTime(2026, 1, 18),
    name: 'Redtop Grill',
    merchantName: 'Redtop Grill',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 19 – Oil change (one-time)
  Transaction(
    id: 'txn_og_053',
    accountId: _checking,
    amount: 45,
    date: DateTime(2026, 1, 19),
    name: 'Express Oil Change',
    merchantName: 'Express Oil',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 20 – Gas
  Transaction(
    id: 'txn_og_054',
    accountId: _checking,
    amount: 61.25,
    date: DateTime(2026, 1, 20),
    name: 'QuickFuel Gas',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 22 – Fast food
  Transaction(
    id: 'txn_og_055',
    accountId: _checking,
    amount: 10.89,
    date: DateTime(2026, 1, 22),
    name: 'QuickBurger',
    merchantName: 'QuickBurger',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 23 – Supermarket household necessities (put on credit card)
  Transaction(
    id: 'txn_og_056',
    accountId: _credit,
    amount: 43.27,
    date: DateTime(2026, 1, 23),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 24 – Discount store
  Transaction(
    id: 'txn_og_057',
    accountId: _checking,
    amount: 13.45,
    date: DateTime(2026, 1, 24),
    name: 'Discount Depot',
    merchantName: 'Discount Depot',
    category: TransactionCategory.generalMerchandise,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 25 – Groceries
  Transaction(
    id: 'txn_og_058',
    accountId: _checking,
    amount: 65.80,
    date: DateTime(2026, 1, 25),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // Jan 28 – Fast food
  Transaction(
    id: 'txn_og_059',
    accountId: _checking,
    amount: 9.34,
    date: DateTime(2026, 1, 28),
    name: 'Redtop Grill',
    merchantName: 'Redtop Grill',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
  ),

  // ── February 2026 ───────────────────────────────────────────────────

  // Feb 1 – Paycheck
  Transaction(
    id: 'txn_og_060',
    accountId: _checking,
    amount: -2200,
    date: DateTime(2026, 2),
    name: 'Metro Distribution - Direct Deposit',
    merchantName: 'Metro Distribution',
    category: TransactionCategory.income,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 1 – Rent
  Transaction(
    id: 'txn_og_061',
    accountId: _checking,
    amount: 1350,
    date: DateTime(2026, 2),
    name: 'Bank Transfer - Rent',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 2 – Auto loan payment
  Transaction(
    id: 'txn_og_062',
    accountId: _checking,
    amount: 420,
    date: DateTime(2026, 2, 2),
    name: 'Summit Auto Payment',
    merchantName: 'Summit Auto Finance',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 3 – Student loan payment
  Transaction(
    id: 'txn_og_063',
    accountId: _checking,
    amount: 280,
    date: DateTime(2026, 2, 3),
    name: 'Federal Loan Payment',
    merchantName: 'Federal Loan Services',
    category: TransactionCategory.loanPayments,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 3 – Credit card minimum payment
  Transaction(
    id: 'txn_og_064',
    accountId: _checking,
    amount: 285,
    date: DateTime(2026, 2, 3),
    name: 'Metro Card Payment',
    merchantName: 'Metro Bank',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),
  Transaction(
    id: 'txn_og_064b',
    accountId: _credit,
    amount: -285,
    date: DateTime(2026, 2, 3),
    name: 'Metro Card Payment',
    category: TransactionCategory.transfer,
    paymentChannel: PaymentChannel.other,
  ),

  // Feb 4 – Electric bill
  Transaction(
    id: 'txn_og_065',
    accountId: _checking,
    amount: 165,
    date: DateTime(2026, 2, 4),
    name: 'Valley Power Electric',
    merchantName: 'Valley Power',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 4 – Phone bill
  Transaction(
    id: 'txn_og_066',
    accountId: _checking,
    amount: 35,
    date: DateTime(2026, 2, 4),
    name: 'BudgetTel Wireless',
    merchantName: 'BudgetTel',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 4 – Auto insurance
  Transaction(
    id: 'txn_og_066b',
    accountId: _checking,
    amount: 95,
    date: DateTime(2026, 2, 4),
    name: 'SafeRide Insurance',
    merchantName: 'SafeRide',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 4 – Internet
  Transaction(
    id: 'txn_og_067',
    accountId: _checking,
    amount: 55,
    date: DateTime(2026, 2, 4),
    name: 'CableLink Internet',
    merchantName: 'CableLink',
    category: TransactionCategory.rentAndUtilities,
    paymentChannel: PaymentChannel.online,
  ),

  // Feb 5 – Groceries (PENDING)
  Transaction(
    id: 'txn_og_068',
    accountId: _checking,
    amount: 82.14,
    date: DateTime(2026, 2, 5),
    name: 'ValueMart Supercenter',
    merchantName: 'ValueMart',
    category: TransactionCategory.foodAndDrink,
    paymentChannel: PaymentChannel.inStore,
    pending: true,
  ),

  // Feb 5 – Gas (PENDING, on credit card — adding to debt)
  Transaction(
    id: 'txn_og_069',
    accountId: _credit,
    amount: 50.45,
    date: DateTime(2026, 2, 5),
    name: 'QuickFuel Gas',
    merchantName: 'QuickFuel',
    category: TransactionCategory.transportation,
    paymentChannel: PaymentChannel.inStore,
    pending: true,
  ),
];
