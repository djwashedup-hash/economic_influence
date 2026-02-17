// Placeholder for Individual model
// This file needs to be populated with the actual Individual class implementation

class Individual {
  final String id;
  final String name;
  final String role;
  final String? companyContext;
  final double? ownershipPercentage;
  final String? ownershipSource;
  final List<dynamic> publicActions;

  Individual({
    required this.id,
    required this.name,
    required this.role,
    this.companyContext,
    this.ownershipPercentage,
    this.ownershipSource,
    this.publicActions = const [],
  });
}
