// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scanResultControllerHash() =>
    r'7c02f6a69d9f094f7d2355f38e9a5fcdc98eff50';

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

abstract class _$scanResultController extends BuildlessAsyncNotifier<Object?> {
  late final ActivityTag type;
  late final GeminiService service;
  late final bool isRecent;
  late final String? imageUrl;

  FutureOr<Object?> build(
    ActivityTag type,
    GeminiService service,
    bool isRecent,
    String? imageUrl,
  );
}

/// See also [scanResultController].
@ProviderFor(scanResultController)
const scanResultControllerProvider = ScanResultControllerFamily();

/// See also [scanResultController].
class ScanResultControllerFamily extends Family<AsyncValue> {
  /// See also [scanResultController].
  const ScanResultControllerFamily();

  /// See also [scanResultController].
  ScanResultControllerProvider call(
    ActivityTag type,
    GeminiService service,
    bool isRecent,
    String? imageUrl,
  ) {
    return ScanResultControllerProvider(
      type,
      service,
      isRecent,
      imageUrl,
    );
  }

  @override
  ScanResultControllerProvider getProviderOverride(
    covariant ScanResultControllerProvider provider,
  ) {
    return call(
      provider.type,
      provider.service,
      provider.isRecent,
      provider.imageUrl,
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
  String? get name => r'scanResultControllerProvider';
}

/// See also [scanResultController].
class ScanResultControllerProvider
    extends AsyncNotifierProviderImpl<scanResultController, Object?> {
  /// See also [scanResultController].
  ScanResultControllerProvider(
    ActivityTag type,
    GeminiService service,
    bool isRecent,
    String? imageUrl,
  ) : this._internal(
          () => scanResultController()
            ..type = type
            ..service = service
            ..isRecent = isRecent
            ..imageUrl = imageUrl,
          from: scanResultControllerProvider,
          name: r'scanResultControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scanResultControllerHash,
          dependencies: ScanResultControllerFamily._dependencies,
          allTransitiveDependencies:
              ScanResultControllerFamily._allTransitiveDependencies,
          type: type,
          service: service,
          isRecent: isRecent,
          imageUrl: imageUrl,
        );

  ScanResultControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
    required this.service,
    required this.isRecent,
    required this.imageUrl,
  }) : super.internal();

  final ActivityTag type;
  final GeminiService service;
  final bool isRecent;
  final String? imageUrl;

  @override
  FutureOr<Object?> runNotifierBuild(
    covariant scanResultController notifier,
  ) {
    return notifier.build(
      type,
      service,
      isRecent,
      imageUrl,
    );
  }

  @override
  Override overrideWith(scanResultController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ScanResultControllerProvider._internal(
        () => create()
          ..type = type
          ..service = service
          ..isRecent = isRecent
          ..imageUrl = imageUrl,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
        service: service,
        isRecent: isRecent,
        imageUrl: imageUrl,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<scanResultController, Object?> createElement() {
    return _ScanResultControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScanResultControllerProvider &&
        other.type == type &&
        other.service == service &&
        other.isRecent == isRecent &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);
    hash = _SystemHash.combine(hash, service.hashCode);
    hash = _SystemHash.combine(hash, isRecent.hashCode);
    hash = _SystemHash.combine(hash, imageUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScanResultControllerRef on AsyncNotifierProviderRef<Object?> {
  /// The parameter `type` of this provider.
  ActivityTag get type;

  /// The parameter `service` of this provider.
  GeminiService get service;

  /// The parameter `isRecent` of this provider.
  bool get isRecent;

  /// The parameter `imageUrl` of this provider.
  String? get imageUrl;
}

class _ScanResultControllerProviderElement
    extends AsyncNotifierProviderElement<scanResultController, Object?>
    with ScanResultControllerRef {
  _ScanResultControllerProviderElement(super.provider);

  @override
  ActivityTag get type => (origin as ScanResultControllerProvider).type;
  @override
  GeminiService get service => (origin as ScanResultControllerProvider).service;
  @override
  bool get isRecent => (origin as ScanResultControllerProvider).isRecent;
  @override
  String? get imageUrl => (origin as ScanResultControllerProvider).imageUrl;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
