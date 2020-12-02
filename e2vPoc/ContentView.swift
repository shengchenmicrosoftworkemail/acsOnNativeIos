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
    init(_ view: ContentView) {
        _view = view
    }
    
    public func onCallsUpdated(_ callAgent: CallAgent!, args: CallsUpdatedEventArgs!) {
        print("CALL UPDATED");
    }
}

struct ContentView: View {
    @State var callee: String = ""
    @State var callClient: CallClient?
    @State var callAgent: CallAgent?
    @State var call: Call?

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
            var userToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwMiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2MDU2MzQ3NTUsImV4cCI6MTYwNTcyMTE1NSwic2t5cGVpZCI6InRlYW1zdmlzaXRvcjo4ODU2YzJkMmM3ZDQ0ZWZhODkzZDI1YmY5ZWQyNDE1YyIsInNjcCI6NzcyLCJjc2kiOiIxNjA1NjM0NzU1IiwicmduIjoiYW1lciIsInByb2R1Y3QiOiJvYyJ9.hIBp2i60YcS0s3cLj4-wkPOC6DhT40xOWBoxhCLinC28AiZ-_WOfgGKT1oJ8eBsHSJRb4Lkx94gviv-0yxjInKrNBFcY_6NDji3o8idrtnaQ8bjUlrV8rmkw1h4eH2J3bK3crgZCRmi2eu0mrdtgV3ZgHXB2DcsPkkMhwAaFmPPmf-0XJM74HmtpQFzWH9u2BCvNt8GyWGbB22a84O1PiNRmVFfzqFGSzSeTpvv0D5lG_J-nUu8GS75HKC-xHBCEkcrJbPUkl1GLH5xyr1JVOzYi0bcN2y2S29L8ovkBX6UVGhZfv_1Lw14rEm067X9NjjW2LLdtKOY8TpDcgZEUug"
            // ACS Token
//            var userToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwMiIsInR5cCI6IkpXVCJ9.eyJza3lwZWlkIjoiYWNzOjE3NTA1YWMzLWQ3ZTQtNDI1Ni1hOWUwLTk0NjgxMzM3Nzk0Y18wMDAwMDAwNi01OWJjLThhYTUtNjhhYi0xYzQ4MjIwMDM5NWIiLCJzY3AiOjE3OTIsImNzaSI6IjE2MDUxNDA5MzIiLCJpYXQiOjE2MDUxNDA5MzIsImV4cCI6MTYwNTIyNzMzMiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6IjE3NTA1YWMzLWQ3ZTQtNDI1Ni1hOWUwLTk0NjgxMzM3Nzk0YyJ9.Dk7zwjD3d08doEOAokRntwOZgkesIlqLzOi91Qvspg_lFPCh6xd4NuUjSY36f5y1tXouFlvJ-Crl5OBkprHFS4v6qYGET6ZmiJEnpA_Yozo9LyMuYEyhXt4vS4NndIoqGY7n-VUCk1SaG_7xREjPyLLxC5tfEpEZ0x2mMgAS_nN_dKICg8DyIE0R3fer1toFZ6kr_LMZMTC_5l_J_PLjrSgwl6v8NLOuKU8-5J4zmb0dK6c1gk0dXUzZCbLs8omluCed_Q5Z9gbyWI29qnmxdMEHmVEcogD9qfGzh4p7mIob7P-RgAE9urwUpl39tT5MEN0pzSGf4umUbEtU7neuOQ"
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
                self.callAgent?.delegate = CallObserver(self)
            }
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
