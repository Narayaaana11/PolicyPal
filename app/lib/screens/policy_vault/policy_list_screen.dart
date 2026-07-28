import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/policy_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/policy_card.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/document_scanner_modal.dart';

class PolicyListScreen extends StatefulWidget {
  const PolicyListScreen({super.key});

  @override
  State<PolicyListScreen> createState() => _PolicyListScreenState();
}

class _PolicyListScreenState extends State<PolicyListScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final policyProvider = Provider.of<PolicyProvider>(context);

    final filteredPolicies = policyProvider.policies.where((p) {
      final matchesCategory = _selectedFilter == 'all' || p.type == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          p.provider.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.policyNumber.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

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
              title: const Text('Policy Vault'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.premiumGradient,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.document_scanner_outlined, color: AppTheme.primaryColor),
                tooltip: 'Scan Policy OCR',
                onPressed: () => DocumentScannerModal.show(context),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppTheme.alabasterGrey),
                tooltip: 'Add Policy',
                onPressed: () => context.push('/add-policy'),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppTheme.alabasterGrey, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by provider or policy number...',
                  hintStyle: TextStyle(color: AppTheme.dustyDenim.withValues(alpha: 0.6), fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.dustyDenim),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.dustyDenim),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppTheme.prussianBlue.withValues(alpha: 0.6),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppTheme.duskBlue.withValues(alpha: 0.3)),
                  ),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                },
              ),
            ).animate().fadeIn(duration: 400.ms),
          ),

          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: ['all', 'health', 'auto', 'life', 'home', 'travel'].map((category) {
                  final isSelected = _selectedFilter == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ChoiceChip(
                      label: Text(
                        category.toUpperCase(),
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
                      onSelected: (selected) {
                        if (selected) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedFilter = category);
                        }
                      },
                    ),
                  );
                }).toList(),
              ).animate().fadeIn(delay: 200.ms),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: policyProvider.isLoading
                ? SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(3, (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: ShimmerLoading(height: 120),
                      )),
                    ),
                  )
                : filteredPolicies.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              'No policies matching current filter/search.',
                              style: TextStyle(color: AppTheme.dustyDenim),
                            ),
                          ),
                        ).animate().fadeIn(),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final policy = filteredPolicies[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: PolicyCard(
                                policy: policy,
                                onTap: () => context.push('/policy-detail', extra: policy),
                              ),
                            ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.1);
                          },
                          childCount: filteredPolicies.length,
                        ),
                      ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
