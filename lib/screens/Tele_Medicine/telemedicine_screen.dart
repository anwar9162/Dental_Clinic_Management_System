import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:omni_jitsi_meet/jitsi_meet.dart';

class TelemedicineScreen extends StatefulWidget {
  @override
  _TelemedicineScreenState createState() => _TelemedicineScreenState();
}

class _TelemedicineScreenState extends State<TelemedicineScreen> {
  final roomText = TextEditingController();
  bool isAudioOnly = true;
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  // Mock patient data
  final List<Map<String, String>> patients = [
    {"name": "John Doe", "room": "john_doe_room"},
    {"name": "Jane Smith", "room": "jane_smith_room"},
    {"name": "Emily Davis", "room": "emily_davis_room"},
  ];

  String? selectedPatientRoom;

  @override
  void initState() {
    super.initState();
    if (patients.isNotEmpty) {
      selectedPatientRoom = patients.first['room'];

      roomText.text = selectedPatientRoom!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telemedicine'),
        backgroundColor: Colors.teal,
        elevation: 4.0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog or tooltip
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[900]!, Colors.blueGrey[500]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: kIsWeb
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Container with Elevation 1
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: _meetConfig(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  // Right Container with Elevation 4
                  Expanded(
                    flex: 7,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: width * 0.60 * 0.70,
                            child: JitsiMeetConferencing(
                              extraJS: [
                                '<script src="https://code.jquery.com/jquery-3.6.3.slim.js" integrity="sha256-DKU1CmJ8kBuEwumaLuh9Tl/6ZB6jzGOBV/5YpNE2BWc=" crossorigin="anonymous"></script>'
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : _meetConfig(),
      ),
    );
  }

  Widget _meetConfig() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 16.0),
          Text(
            "Select Patient",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8.0),
          InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPatientRoom,
                onChanged: (String? newRoom) {
                  setState(() {
                    selectedPatientRoom = newRoom;
                    roomText.text = selectedPatientRoom!;
                  });
                },
                items: patients.map<DropdownMenuItem<String>>((patient) {
                  return DropdownMenuItem<String>(
                    value: patient['room'],
                    child: Text(patient['name']!),
                  );
                }).toList(),
                isExpanded: true,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: roomText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: "Room",
              filled: true,
              fillColor: Colors.grey[200],
            ),
            readOnly: true, // Room is set based on the patient selection
          ),
          SizedBox(height: 16.0),
          _buildCheckboxListTile(
              "Audio Only", isAudioOnly, _onAudioOnlyChanged),
          _buildCheckboxListTile(
              "Audio Muted", isAudioMuted, _onAudioMutedChanged),
          _buildCheckboxListTile(
              "Video Muted", isVideoMuted, _onVideoMutedChanged),
          Divider(height: 48.0, thickness: 2.0),
          SizedBox(
            height: 64.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _joinMeeting,
              child: Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
            ),
          ),
          SizedBox(height: 48.0),
        ],
      ),
    );
  }

  Widget _buildCheckboxListTile(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.blueGrey[800],
      checkColor: Colors.white,
    );
  }

  void _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value!;
    });
  }

  void _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  void _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

  void _joinMeeting() async {
    if (selectedPatientRoom == null) {
      // Show error message or handle the case where room is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a patient to join the meeting.")),
      );
      return;
    }

    final featureFlags = {
      FeatureFlagEnum.RESOLUTION: FeatureFlagVideoResolution.MD_RESOLUTION,
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb && Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    }

    final options = JitsiMeetingOptions(
      room: selectedPatientRoom!,
      serverURL: "https://meet.jit.si/",
      subject: "Telemedicine session",
      userDisplayName: "Doctor",
      userEmail: "aa@gmail.com",
      audioOnly: isAudioOnly,
      audioMuted: isAudioMuted,
      videoMuted: isVideoMuted,
      featureFlags: featureFlags,
      webOptions: {
        "roomName": selectedPatientRoom!,
        "userDisplayName": "Doctor",
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "enableNoAudioDetection": true,
        "enableNoisyMicDetection": true,
        "enableClosePage": false,
        "prejoinPageEnabled": false,
        "hideConferenceTimer": true,
        "disableInviteFunctions": true,
        "chromeExtensionBanner": null,
        'userInfo': {
          'displayName': 'Doctor',
          'email': 'anwarahmed9162@gmail.com',
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
