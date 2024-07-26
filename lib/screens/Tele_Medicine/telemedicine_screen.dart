import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:omni_jitsi_meet/jitsi_meet.dart';

class TelemedicineScreen extends StatefulWidget {
  @override
  _TelemedicineScreenState createState() => _TelemedicineScreenState();
}

class _TelemedicineScreenState extends State<TelemedicineScreen> {
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "telemedicine_room");
  final subjectText = TextEditingController(text: "Telemedicine Consultation");
  final nameText = TextEditingController(text: "Patient Name");
  final emailText = TextEditingController(text: "patient@example.com");
  final iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); // transparent blue
  bool? isAudioOnly = true;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telemedicine'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: kIsWeb
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.30,
                    child: meetConfig(),
                  ),
                  Container(
                    width: width * 0.60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white54,
                        child: SizedBox(
                          width: width * 0.60 * 0.70,
                          height: width * 0.60 * 0.70,
                          child: JitsiMeetConferencing(
                            extraJS: [
                              // extraJs setup example
                              '<script src="https://code.jquery.com/jquery-3.6.3.slim.js" integrity="sha256-DKU1CmJ8kBuEwumaLuh9Tl/6ZB6jzGOBV/5YpNE2BWc=" crossorigin="anonymous"></script>'
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : meetConfig(),
      ),
    );
  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 16.0),
          TextField(
            controller: serverText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Server URL",
              hintText: "Hint: Leave empty for meet.jitsi.si",
            ),
          ),
          SizedBox(height: 14.0),
          TextField(
            controller: roomText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Room",
            ),
          ),
          SizedBox(height: 14.0),
          TextField(
            controller: subjectText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Subject",
            ),
          ),
          SizedBox(height: 14.0),
          TextField(
            controller: nameText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Display Name",
            ),
          ),
          SizedBox(height: 14.0),
          TextField(
            controller: emailText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
          ),
          SizedBox(height: 14.0),
          TextField(
            controller: iosAppBarRGBAColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "AppBar Color(IOS only)",
              hintText: "Hint: This HAS to be in HEX RGBA format",
            ),
          ),
          SizedBox(height: 14.0),
          CheckboxListTile(
            title: Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          SizedBox(height: 14.0),
          CheckboxListTile(
            title: Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          SizedBox(height: 14.0),
          CheckboxListTile(
            title: Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          Divider(height: 48.0, thickness: 2.0),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: _joinMeeting,
              child: Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 48.0),
        ],
      ),
    );
  }

  void _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  void _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  void _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  void _joinMeeting() async {
    final String? serverUrl =
        serverText.text.trim().isEmpty ? null : serverText.text;

    final featureFlags = {
      FeatureFlagEnum.RESOLUTION: FeatureFlagVideoResolution.MD_RESOLUTION,
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb && Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    }

    final options = JitsiMeetingOptions(
      room: roomText.text,
      serverURL: serverUrl,
      subject: subjectText.text,
      userDisplayName: nameText.text,
      userEmail: emailText.text,
      iosAppBarRGBAColor: iosAppBarRGBAColor.text,
      audioOnly: isAudioOnly,
      audioMuted: isAudioMuted,
      videoMuted: isVideoMuted,
      featureFlags: featureFlags,
      webOptions: {
        "roomName": roomText.text,
        "width": "75%",
        "height": "75%",
        "enableWelcomePage": false,
        "enableNoAudioDetection": true,
        "enableNoisyMicDetection": true,
        "enableClosePage": false,
        "prejoinPageEnabled": false,
        "hideConferenceTimer": true,
        "disableInviteFunctions": true,
        "chromeExtensionBanner": null,
        "configOverwrite": {
          "prejoinPageEnabled": false,
          "disableDeepLinking": true,
          "enableLobbyChat": false,
          "enableClosePage": false,
          "chromeExtensionBanner": null,
        },
        "userInfo": {
          "email": emailText.text,
          "displayName": nameText.text,
        },
      },
    );

    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
        onOpened: () {
          debugPrint("JitsiMeetingListener - onOpened");
        },
        onClosed: () {
          debugPrint("JitsiMeetingListener - onClosed");
        },
        onError: (error) {
          debugPrint("JitsiMeetingListener - onError: error: $error");
        },
        onConferenceWillJoin: (url) {
          debugPrint("JitsiMeetingListener - onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("JitsiMeetingListener - onConferenceJoined: url:$url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint(
              "JitsiMeetingListener - onConferenceTerminated: url: $url, error: $error");
        },
        onParticipantLeft: (participantId) {
          debugPrint(
              "JitsiMeetingListener - onParticipantLeft: $participantId");
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
              "JitsiMeetingListener - onParticipantJoined: email: $email, name: $name, role: $role, participantId: $participantId");
        },
        onAudioMutedChanged: (muted) {
          debugPrint(
              "JitsiMeetingListener - onAudioMutedChanged: muted: $muted");
        },
        onVideoMutedChanged: (muted) {
          debugPrint(
              "JitsiMeetingListener - onVideoMutedChanged: muted: $muted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
              "JitsiMeetingListener - onScreenShareToggled: participantId: $participantId, isSharing: $isSharing");
        },
        genericListeners: [
          JitsiGenericListener(
            eventName: 'readyToClose',
            callback: (message) {
              debugPrint("JitsiMeetingListener - readyToClose callback");
            },
          ),
        ],
      ),
    );
  }
}
