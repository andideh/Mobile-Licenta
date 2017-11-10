//
//  MailService.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import Foundation
import MessageUI

final class MailService: NSObject {
    
    var completion: VoidBlock?
    
   
    
}

extension MailService: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        completion?()
    }
    
}
