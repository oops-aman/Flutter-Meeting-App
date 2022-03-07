import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:zoom_clone/reesources/auth_methods.dart';
import 'package:zoom_clone/reesources/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  void createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoOff,
    String username = '',
  }) async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution
          .MD_RESOLUTION; // Limit video resolution to 360p

      String name;
      if (username.isEmpty) {
        name = _authMethods.user.displayName!;
      }
      name = username;
      var options = JitsiMeetingOptions(
          room: roomName) // Required, spaces will be trimmed
        ..userDisplayName = name
        ..userEmail = _authMethods.user.email
        ..userAvatarURL = _authMethods.user.photoURL // or .png
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoOff;
        
      _firestoreMethods.addToMeetingHistory(roomName);
      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      // ignore: avoid_print
      print("error: $error");
    }
  }
}
