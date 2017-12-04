//
//  ConsentViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

protocol ConsentViewControllerProtocol: AnyObject {
    func didTapSendMail()
    func didTapAgree()
}

final class ConsentViewController: UIViewController {
    
    weak var delegate: ConsentViewControllerProtocol?
    
    @IBOutlet weak var textView: UITextView!
    
    
    static func instantiate() -> ConsentViewController {
        return Storyboard.Registration.instantiate() as ConsentViewController
    }

    @IBAction func agreeTapped(_ sender: Any) {
        delegate?.didTapAgree()
    }
    
    @IBAction func sendByMailTapped(_ sender: Any) {
        delegate?.didTapSendMail()
    }
}
