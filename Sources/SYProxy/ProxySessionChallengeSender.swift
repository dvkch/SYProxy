//
//  ProxySessionChallengeSender.Swift
//  SYProxy
//
//  Created by Stanislas Chevallier on 04/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

import Foundation

// http://stackoverflow.com/questions/27604052/nsurlsessiontask-authentication-challenge-completionhandler-and-nsurlauthenticat
internal class ProxySessionChallengeSender: NSObject {
    
    // MARK: Init
    init(sessionCompletionHandler: @escaping CompletionHandler) {
        self.sessionCompletionHandler = sessionCompletionHandler
        super.init()
    }
    
    // MARK: Properties
    typealias CompletionHandler = (_ disposition: URLSession.AuthChallengeDisposition, _ credential: URLCredential?) -> ()
    private let sessionCompletionHandler: CompletionHandler
}

extension ProxySessionChallengeSender: URLAuthenticationChallengeSender {
    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.useCredential, credential)
    }
    
    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.useCredential, nil)
    }
    
    func cancel(_ challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.performDefaultHandling, nil)
    }
    
    func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        sessionCompletionHandler(.rejectProtectionSpace, nil)
    }
}
