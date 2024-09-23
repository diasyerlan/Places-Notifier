//
//  Call.swift
//  BusStopNotifier
//
//  Created by Dias Yerlan on 23.09.2024.
//

import Foundation
import CallKit

class CallService: NSObject, CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
    }
    
    static let shared = CallService()
    private let provider: CXProvider
    private let callController = CXCallController()
    
    override init() {
        
        provider = CXProvider(configuration: CXProviderConfiguration())
        super.init()
        
        provider.setDelegate(self, queue: nil)
    }
    
    func reportIncomingCall(uuid: UUID, handle: String) {
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = CXHandle(type: .generic, value: handle)
        
        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if let error = error {
                print("Error reporting incoming call: \(error.localizedDescription)")
            } else {
                
            }
        }
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        let endCallAction = CXEndCallAction(call: action.callUUID)
        let transaction = CXTransaction(action: endCallAction)
        
        callController.request(transaction) { error in
            if let error = error {
                print("Error ending call: \(error.localizedDescription)")
            } else {
                print("Call successfully declined")
            }
        }
        
        action.fulfill()
    }
    // Handle the answer and end calls
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        // Start the call
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // End the call
        action.fulfill()
    }
}
