import 'dart:ffi';

final class AudioMetricsC extends Struct {
  @Double()
  external double bass;

  @Double()
  external double mid;

  @Double()
  external double treble;

  @Double()
  external double volume;

  @Bool()
  external bool beat;

  /// 256 linear magnitude bins covering 0 .. sampleRate/2 Hz.
  /// Populated by the native layer's downsample of the halfN FFT bins.
  /// Same normalization as bass/mid/treble (magnitude / N).
  @Array(256)
  external Array<Float> spectrum;

  @Uint64()
  external int frameCount;
}

typedef _AudioMetricsInitNative = Void Function(Int32, Int32);
typedef _AudioMetricsInitDart = void Function(int, int);

typedef _AudioMetricsGetNative = Pointer<AudioMetricsC> Function();
typedef _AudioMetricsGetDart = Pointer<AudioMetricsC> Function();

typedef _AudioMetricsResetNative = Void Function();
typedef _AudioMetricsResetDart = void Function();

typedef _AudioMetricsDestroyNative = Void Function();
typedef _AudioMetricsDestroyDart = void Function();

class AudioMetricsNative {
  AudioMetricsNative(this._lookup);

  final Pointer<T> Function<T extends NativeType>(String symbolName) _lookup;

  late final _init = _lookup<NativeFunction<_AudioMetricsInitNative>>(
    'audio_metrics_init',
  ).asFunction<_AudioMetricsInitDart>();

  late final _get = _lookup<NativeFunction<_AudioMetricsGetNative>>(
    'audio_metrics_get',
  ).asFunction<_AudioMetricsGetDart>();

  late final _reset = _lookup<NativeFunction<_AudioMetricsResetNative>>(
    'audio_metrics_reset',
  ).asFunction<_AudioMetricsResetDart>();

  late final _destroy = _lookup<NativeFunction<_AudioMetricsDestroyNative>>(
    'audio_metrics_destroy',
  ).asFunction<_AudioMetricsDestroyDart>();

  void init(int fftSize, int sampleRate) => _init(fftSize, sampleRate);
  Pointer<AudioMetricsC> get() => _get();
  void reset() => _reset();
  void destroy() => _destroy();
}
