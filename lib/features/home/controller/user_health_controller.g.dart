// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_health_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userHealthDataPeriodDateHash() =>
    r'6d39920995c236a7802345c13436cd990052710f';

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

/// See also [userHealthDataPeriodDate].
@ProviderFor(userHealthDataPeriodDate)
const userHealthDataPeriodDateProvider = UserHealthDataPeriodDateFamily();

/// See also [userHealthDataPeriodDate].
class UserHealthDataPeriodDateFamily extends Family<AsyncValue<UserHealth?>> {
  /// See also [userHealthDataPeriodDate].
  const UserHealthDataPeriodDateFamily();

  /// See also [userHealthDataPeriodDate].
  UserHealthDataPeriodDateProvider call(
    DateTime periodDate,
  ) {
    return UserHealthDataPeriodDateProvider(
      periodDate,
    );
  }

  @override
  UserHealthDataPeriodDateProvider getProviderOverride(
    covariant UserHealthDataPeriodDateProvider provider,
  ) {
    return call(
      provider.periodDate,
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
  String? get name => r'userHealthDataPeriodDateProvider';
}

/// See also [userHealthDataPeriodDate].
class UserHealthDataPeriodDateProvider
    extends AutoDisposeFutureProvider<UserHealth?> {
  /// See also [userHealthDataPeriodDate].
  UserHealthDataPeriodDateProvider(
    DateTime periodDate,
  ) : this._internal(
          (ref) => userHealthDataPeriodDate(
            ref as UserHealthDataPeriodDateRef,
            periodDate,
          ),
          from: userHealthDataPeriodDateProvider,
          name: r'userHealthDataPeriodDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userHealthDataPeriodDateHash,
          dependencies: UserHealthDataPeriodDateFamily._dependencies,
          allTransitiveDependencies:
              UserHealthDataPeriodDateFamily._allTransitiveDependencies,
          periodDate: periodDate,
        );

  UserHealthDataPeriodDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.periodDate,
  }) : super.internal();

  final DateTime periodDate;

  @override
  Override overrideWith(
    FutureOr<UserHealth?> Function(UserHealthDataPeriodDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserHealthDataPeriodDateProvider._internal(
        (ref) => create(ref as UserHealthDataPeriodDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        periodDate: periodDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserHealth?> createElement() {
    return _UserHealthDataPeriodDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserHealthDataPeriodDateProvider &&
        other.periodDate == periodDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, periodDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserHealthDataPeriodDateRef on AutoDisposeFutureProviderRef<UserHealth?> {
  /// The parameter `periodDate` of this provider.
  DateTime get periodDate;
}

class _UserHealthDataPeriodDateProviderElement
    extends AutoDisposeFutureProviderElement<UserHealth?>
    with UserHealthDataPeriodDateRef {
  _UserHealthDataPeriodDateProviderElement(super.provider);

  @override
  DateTime get periodDate =>
      (origin as UserHealthDataPeriodDateProvider).periodDate;
}

String _$userHealthControllerHash() =>
    r'752aade402c42a26f93955502e2f874d320e9d8f';

/// See also [UserHealthController].
@ProviderFor(UserHealthController)
final userHealthControllerProvider =
    AsyncNotifierProvider<UserHealthController, UserHealth?>.internal(
  UserHealthController.new,
  name: r'userHealthControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userHealthControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserHealthController = AsyncNotifier<UserHealth?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
