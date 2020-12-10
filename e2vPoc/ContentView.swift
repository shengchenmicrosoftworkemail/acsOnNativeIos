//
//  ContentView.swift
//  e2vPoc
//
//  Created by rpteam on 11/11/20.
//

import SwiftUI
import AzureCommunicationCalling
import AVFoundation

public class CallObserver: NSObject, CallAgentDelegate {
    private var _view: ContentView
    private var cli: CallClient
//    private var deviceManager: DeviceManager
    init(_ view: ContentView, client: CallClient) {
        _view = view
        cli = client
//        deviceManager = nil
    }
    
//    private var owner:ContentView
//    init(_ view:ContentView) {
//        owner = view
//    }
    
    public func onCallsUpdated(_ callAgent: CallAgent!, args: CallsUpdatedEventArgs!) {
        print("CALL UPDATED");
        
        
        for call in args.addedCalls {
            if (call.isIncoming) {
                
                call.accept(options: AcceptCallOptions(), completionHandler: { error in
                    
                })
                print("INCOMING CALL")
                
                cli.getDeviceManager(completionHandler: { (deviceManager, error) in
                    if error == nil {
                        var deviceManager = deviceManager!
                        
                        print(deviceManager.getCameraList()![0].name)
                    } else {
                        print("unable to get devicemanager")
                    }
                })
                
                
                //todo 2.3
                for participant in call.remoteParticipants {
                    for stream in participant.videoStreams {
                        if (stream.isAvailable) {
                            print("STREAM AVAILIBLE")

                        }
                    }
                }
            }
        }

        
        
        
        
        
    }
//        args.addedCalls?.forEach { call in
//                    if (call.isIncoming) {
//                        self.owner.incomingCallCaller = call
//                        self.owner.isIncomingCall = true
//                        self.owner.placeCallButtonAction = "AnswerIncoming"
//                    }
//                }
//                let removedCalls = args.removedCalls
//                if (removedCalls != nil && removedCalls!.count > 0) {
//                    self.owner.isIncomingCall = false
//                    self.owner.placeCallButtonAction = "StartOutgoing"
//                }
//    }
}

struct ContentView: View {
    @State var callee: String = ""
    @State var callClient: CallClient?
    @State var callAgent: CallAgent?
    @State var call: Call?
    @State var callObserver: CallObserver?

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Who would you like to call?", text: $callee)
                    Button(action: startCall) {
                        Text("Start Call")
                    }.disabled(callAgent == nil)
                    Button(action: endCall) {
                        Text("End Call")
                    }.disabled(call == nil)
                }
            }
            .navigationBarTitle("Calling Quickstart")
        }.onAppear {
            // Initialize call agent
            var userCredential: CommunicationUserCredential?
            // Skype Token
//            var userToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwMiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MDU2MzQ3NTUsImV4cCI6MTYwNTcyMTE1NSwic2t5cGVpZCI6InRlYW1zdmlzaXRvcjo4ODU2YzJkMmM3ZDQ0ZWZhODkzZDI1YmY5ZWQyNDE1YyIsInNjcCI6NzcyLCJjc2kiOiIxNjA1NjM0NzU1IiwicmduIjoiYW1lciIsInByb2R1Y3QiOiJvYyJ9.hIBp2i60YcS0s3cLj4-wkPOC6DhT40xOWBoxhCLinC28AiZ-_WOfgGKT1oJ8eBsHSJRb4Lkx94gviv-0yxjInKrNBFcY_6NDji3o8idrtnaQ8bjUlrV8rmkw1h4eH2J3bK3crgZCRmi2eu0mrdtgV3ZgHXB2DcsPkkMhwAaFmPPmf-0XJM74HmtpQFzWH9u2BCvNt8GyWGbB22a84O1PiNRmVFfzqFGSzSeTpvv0D5lG_J-nUu8GS75HKC-xHBCEkcrJbPUkl1GLH5xyr1JVOzYi0bcN2y2S29L8ovkBX6UVGhZfv_1Lw14rEm067X9NjjW2LLdtKOY8TpDcgZEUug"
            // ACS Token
            var userToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwMiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MDc2MTIxNDgsImV4cCI6MTYwNzY5ODU0OCwic2t5cGVpZCI6InRlYW1zdmlzaXRvcjpiODc5ODVlYWM1MzE0YWM1YjEwMjJkMTViMTgzZjFlOCIsInNjcCI6NzcyLCJjc2kiOiIxNjA3NjEyMTQ4IiwicmduIjoiYW1lciIsInByb2R1Y3QiOiJvYyJ9.UPq0uNTKbg3YhGW4QDqdihylX1Q5qFDexRLwOAhMLkPvFoPgUApLugBl836FVBPZxp0O6cZT5U-wIQ5iWWs9Ff4RxG-XaFfPvCPiIr8j74e0oFNfFbFR_qkBeu8ApYx20dxLyEQpb9ITEPKcufX37K93ztm_1whUPTzSyzCkEhNE9KUuN0FAqtjFmfksgvntFsrM8ZUkUR66nSghHb8SheDUcerH4mTgXMSiacKc5yWQr2WytyOdWoPieV5GM5GMnIARxSqexHlbcEsIk1qfdaGXC0AecCB5u3D1q7uZYGT_zCdowUHtJxqQ6WZ8VKCx7136ghgSPYtg3YSj_4lHGA"
            do {
                userCredential = try CommunicationUserCredential(token: userToken)
            } catch {
                print("ERROR: It was not possible to create user credential.")
                return
            }

            self.callClient = CallClient()

            // Creates the call agent
            self.callClient?.createCallAgent(with: userCredential) { (agent, error) in
                if error != nil {
                    print("ERROR: It was not possible to create a call agent.")
                }

                if let agent = agent {
                    self.callAgent = agent
                    print("Call agent successfully created.")
                }
            }
        }
    }

    func startCall()
    {
        // Ask permissions
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                // start call logic
//                let callees:[CommunicationIdentifier] = [CommunicationUser(identifier: self.callee)];
//                self.call = self.callAgent?.call(callees, options: ACSStartCallOptions())
                // Join group call logic
//                let groupCallContext: ACSGroupCallContext = ACSGroupCallContext()!
//                groupCallContext.groupId = UUID(uuidString: "26898dc0-2473-11eb-90d6-fd4307f43607")!
//                self.call = self.callAgent?.join(with: groupCallContext, joinCallOptions: ACSJoinCallOptions())
                
                // Register events

//                self.callAgent?.delegate.onCallsUpdated?(self.callAgent, args: CallsUpdatedEventArgs)
            }
            self.callObserver = CallObserver(self, client: callClient!)
            self.callAgent?.delegate = self.callObserver
        }
    }

    func endCall()
    {
        self.call!.hangup(options: HangupOptions()) { (error) in
            if (error != nil) {
                print("ERROR: It was not possible to hangup the call.")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
