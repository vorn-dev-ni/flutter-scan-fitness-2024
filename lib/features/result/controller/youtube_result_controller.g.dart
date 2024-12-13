// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_result_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$youtubeResultControllerHash() =>
    r'c0a7680633bbc9656e232e731f60354b2b77359d';

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

abstract class _$YoutubeResultController
    extends BuildlessAsyncNotifier<Object?> {
  late final YoutubeRepository youtubeRepository;

  FutureOr<Object?> build(
    YoutubeRepository youtubeRepository,
  );
}

/// See also [YoutubeResultController].
@ProviderFor(YoutubeResultController)
const youtubeResultControllerProvider = YoutubeResultControllerFamily();

/// See also [YoutubeResultController].
class YoutubeResultControllerFamily extends Family<AsyncValue> {
  /// See also [YoutubeResultController].
  const YoutubeResultControllerFamily();

  /// See also [YoutubeResultController].
  YoutubeResultControllerProvider call(
    YoutubeRepository youtubeRepository,
  ) {
    return YoutubeResultControllerProvider(
      youtubeRepository,
    );
  }

  @override
  YoutubeResultControllerProvider getProviderOverride(
    covariant YoutubeResultControllerProvider provider,
  ) {
    return call(
      provider.youtubeRepository,
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
  String? get name => r'youtubeResultControllerProvider';
}

/// See also [YoutubeResultController].
class YoutubeResultControllerProvider
    extends AsyncNotifierProviderImpl<YoutubeResultController, Object?> {
  /// See also [YoutubeResultController].
  YoutubeResultControllerProvider(
    YoutubeRepository youtubeRepository,
  ) : this._internal(
          () =>
              YoutubeResultController()..youtubeRepository = youtubeRepository,
          from: youtubeResultControllerProvider,
          name: r'youtubeResultControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$youtubeResultControllerHash,
          dependencies: YoutubeResultControllerFamily._dependencies,
          allTransitiveDependencies:
              YoutubeResultControllerFamily._allTransitiveDependencies,
          youtubeRepository: youtubeRepository,
        );

  YoutubeResultControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.youtubeRepository,
  }) : super.internal();

  final YoutubeRepository youtubeRepository;

  @override
  FutureOr<Object?> runNotifierBuild(
    covariant YoutubeResultController notifier,
  ) {
    return notifier.build(
      youtubeRepository,
    );
  }

  @override
  Override overrideWith(YoutubeResultController Function() create) {
    return ProviderOverride(
      origin: this,
      override: YoutubeResultControllerProvider._internal(
        () => create()..youtubeRepository = youtubeRepository,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        youtubeRepository: youtubeRepository,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<YoutubeResultController, Object?>
      createElement() {
    return _YoutubeResultControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is YoutubeResultControllerProvider &&
        other.youtubeRepository == youtubeRepository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, youtubeRepository.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin YoutubeResultControllerRef on AsyncNotifierProviderRef<Object?> {
  /// The parameter `youtubeRepository` of this provider.
  YoutubeRepository get youtubeRepository;
}

class _YoutubeResultControllerProviderElement
    extends AsyncNotifierProviderElement<YoutubeResultController, Object?>
    with YoutubeResultControllerRef {
  _YoutubeResultControllerProviderElement(super.provider);

  @override
  YoutubeRepository get youtubeRepository =>
      (origin as YoutubeResultControllerProvider).youtubeRepository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
