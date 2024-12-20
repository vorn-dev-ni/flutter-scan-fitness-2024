// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityControllerHash() =>
    r'b87ae6278659cdccc0e962b83a83301f881da94c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ActivityController
    extends BuildlessAutoDisposeStreamNotifier<QuerySnapshot> {
  late final String userId;
  late final bool isLimit;
  late final int limit;
  late final String? sortby;

  Stream<QuerySnapshot> build(
    String userId,
    bool isLimit,
    int limit, {
    String? sortby,
  });
}

/// See also [ActivityController].
@ProviderFor(ActivityController)
const activityControllerProvider = ActivityControllerFamily();

/// See also [ActivityController].
class ActivityControllerFamily extends Family<AsyncValue<QuerySnapshot>> {
  /// See also [ActivityController].
  const ActivityControllerFamily();

  /// See also [ActivityController].
  ActivityControllerProvider call(
    String userId,
    bool isLimit,
    int limit, {
    String? sortby,
  }) {
    return ActivityControllerProvider(
      userId,
      isLimit,
      limit,
      sortby: sortby,
    );
  }

  @override
  ActivityControllerProvider getProviderOverride(
    covariant ActivityControllerProvider provider,
  ) {
    return call(
      provider.userId,
      provider.isLimit,
      provider.limit,
      sortby: provider.sortby,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'activityControllerProvider';
}

/// See also [ActivityController].
class ActivityControllerProvider extends AutoDisposeStreamNotifierProviderImpl<
    ActivityController, QuerySnapshot> {
  /// See also [ActivityController].
  ActivityControllerProvider(
    String userId,
    bool isLimit,
    int limit, {
    String? sortby,
  }) : this._internal(
          () => ActivityController()
            ..userId = userId
            ..isLimit = isLimit
            ..limit = limit
            ..sortby = sortby,
          from: activityControllerProvider,
          name: r'activityControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activityControllerHash,
          dependencies: ActivityControllerFamily._dependencies,
          allTransitiveDependencies:
              ActivityControllerFamily._allTransitiveDependencies,
          userId: userId,
          isLimit: isLimit,
          limit: limit,
          sortby: sortby,
        );

  ActivityControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.isLimit,
    required this.limit,
    required this.sortby,
  }) : super.internal();

  final String userId;
  final bool isLimit;
  final int limit;
  final String? sortby;

  @override
  Stream<QuerySnapshot> runNotifierBuild(
    covariant ActivityController notifier,
  ) {
    return notifier.build(
      userId,
      isLimit,
      limit,
      sortby: sortby,
    );
  }

  @override
  Override overrideWith(ActivityController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivityControllerProvider._internal(
        () => create()
          ..userId = userId
          ..isLimit = isLimit
          ..limit = limit
          ..sortby = sortby,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        isLimit: isLimit,
        limit: limit,
        sortby: sortby,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<ActivityController, QuerySnapshot>
      createElement() {
    return _ActivityControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityControllerProvider &&
        other.userId == userId &&
        other.isLimit == isLimit &&
        other.limit == limit &&
        other.sortby == sortby;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, isLimit.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, sortby.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActivityControllerRef
    on AutoDisposeStreamNotifierProviderRef<QuerySnapshot> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `isLimit` of this provider.
  bool get isLimit;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `sortby` of this provider.
  String? get sortby;
}

class _ActivityControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<ActivityController,
        QuerySnapshot> with ActivityControllerRef {
  _ActivityControllerProviderElement(super.provider);

  @override
  String get userId => (origin as ActivityControllerProvider).userId;
  @override
  bool get isLimit => (origin as ActivityControllerProvider).isLimit;
  @override
  int get limit => (origin as ActivityControllerProvider).limit;
  @override
  String? get sortby => (origin as ActivityControllerProvider).sortby;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
