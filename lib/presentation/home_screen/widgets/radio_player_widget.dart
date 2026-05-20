import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import './waveform_widget.dart';

class RadioPlayerWidget extends StatefulWidget {
  const RadioPlayerWidget({super.key});

  @override
  State<RadioPlayerWidget> createState() => _RadioPlayerWidgetState();
}

class _RadioPlayerWidgetState extends State<RadioPlayerWidget>
    with TickerProviderStateMixin {
  // TODO: Replace with [Riverpod/Bloc] for production audio state management
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState(false, ProcessingState.idle);
  double _volume = 0.8;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  late AnimationController _liveRingController;
  late Animation<double> _liveRingAnimation;
  late AnimationController _playButtonController;
  late Animation<double> _playButtonScale;

  static const String _streamUrl = 'https://stream.radiomisionerafm.com/stream';

  @override
  void initState() {
    super.initState();

    _liveRingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: false);

    _liveRingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _liveRingController, curve: Curves.easeOut),
    );

    _playButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _playButtonScale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );

    _initAudio();
  }

  Future<void> _initAudio() async {
    _audioPlayer = AudioPlayer();

    try {
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.defaultToSpeaker,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.music,
            flags: AndroidAudioFlags.none,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
        ),
      );

      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _playerState = state;
          });
        }
      });

      await _audioPlayer.setUrl(_streamUrl);
      await _audioPlayer.setVolume(_volume);

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'No se pudo conectar al stream. Verifica tu conexión.';
          _isInitialized = true;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    _playButtonController.forward().then(
      (_) => _playButtonController.reverse(),
    );

    try {
      if (_playerState.playing) {
        await _audioPlayer.pause();
      } else {
        if (_hasError) {
          setState(() {
            _hasError = false;
          });
          await _audioPlayer.setUrl(_streamUrl);
        }
        await _audioPlayer.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Error de conexión. Intenta de nuevo.';
        });
      }
    }
  }

  void _onVolumeChanged(double value) {
    // TODO: Replace with [Riverpod/Bloc] for production
    setState(() {
      _volume = value;
    });
    _audioPlayer.setVolume(value);
  }

  bool get _isBuffering =>
      _playerState.processingState == ProcessingState.loading ||
      _playerState.processingState == ProcessingState.buffering;

  bool get _isPlaying => _playerState.playing;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _liveRingController.dispose();
    _playButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 6.w : 4.w,
        vertical: isTablet ? 3.h : 2.5.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.glassSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppTheme.primary.withAlpha(26),
            blurRadius: 40,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: Column(
          children: [
            // EN VIVO badge + status
            _buildLiveStatusRow(),

            SizedBox(height: 2.h),

            // Waveform visualizer
            WaveformWidget(isPlaying: _isPlaying && !_isBuffering),

            SizedBox(height: 2.5.h),

            // Play/Pause button
            _buildPlayButton(isTablet),

            SizedBox(height: 2.5.h),

            // Volume control
            _buildVolumeControl(),

            // Error state
            if (_hasError) ...[SizedBox(height: 1.5.h), _buildErrorMessage()],
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated live ring
        AnimatedBuilder(
          animation: _liveRingAnimation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Expanding ring
                if (_isPlaying)
                  Container(
                    width: 24 + 16 * _liveRingAnimation.value,
                    height: 24 + 16 * _liveRingAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.liveGreen.withOpacity(
                          0.6 * (1 - _liveRingAnimation.value),
                        ),
                        width: 1.5,
                      ),
                    ),
                  ),
                // Core dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isPlaying ? AppTheme.liveGreen : AppTheme.textMuted,
                    boxShadow: _isPlaying
                        ? [
                            BoxShadow(
                              color: AppTheme.liveGreen.withAlpha(153),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 10),
        Text(
          _isPlaying
              ? 'EN VIVO'
              : (_isBuffering ? 'CONECTANDO...' : 'EN PAUSA'),
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: _isPlaying
                ? AppTheme.liveGreen
                : (_isBuffering ? AppTheme.gold : AppTheme.textSecondary),
            letterSpacing: 2.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton(bool isTablet) {
    return GestureDetector(
      onTap: _isInitialized ? _togglePlayPause : null,
      child: ScaleTransition(
        scale: _playButtonScale,
        child: Container(
          width: isTablet ? 22.w : 28.w,
          height: isTablet ? 22.w : 28.w,
          constraints: const BoxConstraints(
            maxWidth: 100,
            maxHeight: 100,
            minWidth: 72,
            minHeight: 72,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _hasError
                  ? [AppTheme.accent, AppTheme.error]
                  : [AppTheme.primary, AppTheme.accent],
            ),
            boxShadow: [
              BoxShadow(
                color: (_hasError ? AppTheme.accent : AppTheme.primary)
                    .withAlpha(115),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: _isBuffering
                ? SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : Icon(
                    _isPlaying
                        ? Icons.pause_rounded
                        : (_hasError
                              ? Icons.refresh_rounded
                              : Icons.play_arrow_rounded),
                    color: Colors.white,
                    size: isTablet ? 11.w : 14.w,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Row(
      children: [
        Icon(
          _volume == 0
              ? Icons.volume_off_rounded
              : (_volume < 0.5
                    ? Icons.volume_down_rounded
                    : Icons.volume_up_rounded),
          color: AppTheme.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.gold,
              inactiveTrackColor: AppTheme.glassBorder,
              thumbColor: AppTheme.gold,
              overlayColor: AppTheme.gold.withAlpha(38),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: _volume,
              min: 0.0,
              max: 1.0,
              onChanged: _onVolumeChanged,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(_volume * 100).round()}%',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 9.sp,
            color: AppTheme.textMuted,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.error.withAlpha(31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.error.withAlpha(77)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: AppTheme.accentLight,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 9.sp,
                color: AppTheme.accentLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
