import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/api_service.dart';
import '../../utils/app_theme.dart';
import '../../widgets/luxury_card.dart';
import '../../widgets/shimmer_loading.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  String _selectedType = 'auto';
  bool _isLoading = false;
  List<dynamic> _marketPlans = [];

  @override
  void initState() {
    super.initState();
    _fetchComparison();
  }

  Future<void> _fetchComparison() async {
    setState(() => _isLoading = true);
    try {
      final catalogData = await ApiService.fetchPolicyCatalog(_selectedType);
      if (catalogData is List && catalogData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _marketPlans = catalogData;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error fetching policy catalog: $e');
    }
    
    List<dynamic> dummyPlans = [];
    if (_selectedType == 'auto') {
      dummyPlans = [
        {
          'provider': 'Digit General Insurance',
          'planName': 'Private Car Comprehensive + Zero Dep',
          'valueScore': 97,
          'premiumAmount': '₹22,400',
          'coverageLimit': '₹18.5 Lakh IDV',
          'csr': '98.5% IRDAI Claim Settlement',
          'features': ['50% NCB Lock Cover', 'Engine & Gearbox Protection', 'Pan-India 24x7 Cashless Garage Access']
        },
        {
          'provider': 'Tata AIG Auto Secure',
          'planName': 'Gold Comprehensive DriveShield',
          'valueScore': 94,
          'premiumAmount': '₹24,100',
          'coverageLimit': '₹19.0 Lakh IDV',
          'csr': '97.8% IRDAI Claim Settlement',
          'features': ['Zero Depreciation Included', 'Personal Accident Cover ₹15 Lakhs', 'Key & Lock Replacement']
        },
        {
          'provider': 'ICICI Lombard Motor',
          'planName': 'Comprehensive Car Protection',
          'valueScore': 91,
          'premiumAmount': '₹21,800',
          'coverageLimit': '₹18.0 Lakh IDV',
          'csr': '96.9% IRDAI Claim Settlement',
          'features': ['Roadside Towing Assistance', 'Consumables Cover', 'Tyre & Battery Protect']
        },
      ];
    } else if (_selectedType == 'health') {
      dummyPlans = [
        {
          'provider': 'Star Health Insurance',
          'planName': 'Comprehensive Optima Plan',
          'valueScore': 98,
          'premiumAmount': '₹24,500',
          'coverageLimit': '₹15 Lakhs + ₹5L Restoration',
          'csr': '99.1% Cashless Settlement',
          'features': ['14,000+ Cashless Network Hospitals', 'No Room Rent Capping', 'Save up to ₹75,000 under Sec 80D', 'AYUSH Treatment Included']
        },
        {
          'provider': 'HDFC ERGO Health',
          'planName': 'Optima Secure (2X Coverage)',
          'valueScore': 96,
          'premiumAmount': '₹32,000',
          'coverageLimit': '₹25 Lakhs Effective Sum',
          'csr': '98.7% Claim Settlement',
          'features': ['2X Secure Benefit (Double Cover)', 'Zero Copay in Metro Hospitals', '10,000+ Cashless Hospitals', 'Unlimited Recharge Bonus']
        },
        {
          'provider': 'Niva Bupa (Max Bupa)',
          'planName': 'ReAssure 2.0 Titanium',
          'valueScore': 93,
          'premiumAmount': '₹22,900',
          'coverageLimit': '₹10 Lakhs Base + Lock Age',
          'csr': '96.2% Cashless Approval',
          'features': ['Lock the Age Feature (Same premium)', 'Unlimited ReAssure Forever', 'Organ Donor Expenses Covered']
        },
      ];
    } else if (_selectedType == 'life') {
      dummyPlans = [
        {
          'provider': 'LIC of India',
          'planName': 'Tech Term Plan (Pure Term)',
          'valueScore': 99,
          'premiumAmount': '₹18,500',
          'coverageLimit': '₹1,00,00,000 (1 Crore)',
          'csr': '99.4% Highest IRDAI CSR',
          'features': ['Sovereign Guarantee by Govt of India', 'Section 80C Tax Exemption', '10(10D) Tax Free Payout', 'Accidental Disability Rider']
        },
        {
          'provider': 'HDFC Life',
          'planName': 'Click 2 Protect Super',
          'valueScore': 95,
          'premiumAmount': '₹19,200',
          'coverageLimit': '₹1,25,00,000 (1.25 Crore)',
          'csr': '98.9% Settlement Ratio',
          'features': ['Critical Illness Lump Sum Benefit', 'Terminal Illness Early Payout', 'Return of Premium Option']
        },
      ];
    } else {
      dummyPlans = [
        {
          'provider': 'ICICI Lombard',
          'planName': 'Bharat Griha Raksha',
          'valueScore': 92,
          'premiumAmount': '₹6,200',
          'coverageLimit': '₹75 Lakhs Structure + ₹10L Contents',
          'csr': '97.5% Claim Ratio',
          'features': ['Earthquake & Flood Protection', 'Burglary & Theft Cover', 'Temporary Accommodation Allowance']
        }
      ];
    }

    setState(() {
      _marketPlans = dummyPlans;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text('Compare Policies'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.premiumGradient,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: ['auto', 'health', 'life', 'home'].map((type) {
                  final isSelected = _selectedType == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ChoiceChip(
                      label: Text(
                        type.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? AppTheme.inkBlack : AppTheme.alabasterGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: AppTheme.prussianBlue,
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : AppTheme.duskBlue,
                      ),
                      onSelected: (val) {
                        if (val) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedType = type);
                          _fetchComparison();
                        }
                      },
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 200.ms),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _isLoading
                ? SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(2, (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ShimmerLoading(height: 240),
                      )),
                    ),
                  )
                : _marketPlans.isEmpty
                    ? SliverToBoxAdapter(
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text('No comparison plans found.', style: TextStyle(color: AppTheme.textSecondary)),
                          ),
                        ).animate().fadeIn(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final plan = _marketPlans[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: LuxuryCard(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                plan['provider'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.alabasterGrey,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                plan['planName'] ?? '',
                                                style: const TextStyle(fontSize: 14, color: AppTheme.dustyDenim),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppTheme.secondaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
                                          ),
                                          child: Text(
                                            'Score: ${plan['valueScore']}',
                                            style: const TextStyle(
                                              color: AppTheme.secondaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Divider(color: AppTheme.duskBlue, height: 1),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Annual Premium:', style: TextStyle(color: AppTheme.dustyDenim)),
                                        Text(
                                          '${plan['premiumAmount']} / yr',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Sum Insured / IDV:', style: TextStyle(color: AppTheme.dustyDenim)),
                                        Text(
                                          '${plan['coverageLimit']}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey),
                                        ),
                                      ],
                                    ),
                                    if (plan['csr'] != null) ...[
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Claim Ratio (CSR):', style: TextStyle(color: AppTheme.dustyDenim)),
                                          Text(
                                            '${plan['csr']}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.successColor, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 20),
                                    const Text('Key Features:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.alabasterGrey)),
                                    const SizedBox(height: 8),
                                    ...((plan['features'] as List? ?? []).map(
                                      (f) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.check, color: AppTheme.primaryColor, size: 16),
                                            const SizedBox(width: 8),
                                            Text(f, style: const TextStyle(fontSize: 13, color: AppTheme.alabasterGrey)),
                                          ],
                                        ),
                                      ),
                                    )),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppTheme.primaryColor,
                                          side: const BorderSide(color: AppTheme.primaryColor),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                        ),
                                        child: const Text('View Full Details', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.1);
                          },
                          childCount: _marketPlans.length,
                        ),
                      ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
