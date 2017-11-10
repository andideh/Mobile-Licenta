//
//  ContainerViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit
import MessageUI

final class ContainerViewController: UIViewController {
    
    // MARK: - Private properties
    
    fileprivate var visibleVC: UIViewController?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Public

    static func instantiate() -> ContainerViewController {
        return Storyboard.Registration.instantiate() as ContainerViewController
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.transform = CGAffineTransform(translationX: 0.0, y: view.bounds.size.height)
        configureShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startQuestionary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateIn()
        
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods
    
    fileprivate func configureShadow() {
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        containerView.layer.shadowColor = UIColor.blue.cgColor
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.masksToBounds = false
    }
    
    fileprivate func animateIn() {
        
        UIView.animate(withDuration: 0.5) {
            self.containerView.transform = .identity
        }
    }
    
    func startQuestionary() {
        checkAgeEligibility() { eligibil in
            if eligibil {
                self.showConsent()
            } else {
                // handle
            }
        }
    }
    
    func checkAgeEligibility(_ completion:@escaping  (Bool) -> Void) {
        let questionVC = QuestionViewController.instantiate()

        titleLabel.text = "Eligibility"
        
        let viewData = QuestionViewData(title: "Are you over 18 years old?", leftButtonTitle: "No", rightButtonTitle: "Yes", leftButtonAction: {
            completion(false)
            
        }) {
            completion(true)
        }
        
        questionVC.configure(viewData: viewData)
        
        swap(vc: questionVC)
    }
    
    func showConsent() {
        let consentVC = ConsentViewController.instantiate()
        
        consentVC.delegate = self
        
        swap(vc: consentVC)
    }
    
    fileprivate func swap(vc: UIViewController) {
        addChildViewController(vc)
        
        if let visible = visibleVC {
            visible.willMove(toParentViewController: nil)
            
            UIView.animate(withDuration: 0.2, animations: {
                visible.view.alpha = 0.0
            }) { _ in
                visible.view.removeFromSuperview()
                visible.removeFromParentViewController()
            }
        }
        
        vc.view.alpha = 0.0
        
        containerView.addSubview(vc.view)
        vc.view.frame = containerView.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        UIView.animate(withDuration: 0.2, animations: {
            vc.view.alpha = 1.0
        }) { _ in
            vc.didMove(toParentViewController: self)
        }

    }
        
}

extension ContainerViewController: ConsentViewControllerProtocol {
    func didTapSendMail() {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject("Consent")
        mailComposer.setMessageBody("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque at leo sed tortor malesuada vestibulum nec sed risus. Pellentesque aliquet vehicula porttitor. Donec sit amet turpis eros. Integer gravida arcu nec vehicula tincidunt. Sed id ultrices nisl, id convallis lacus. Maecenas at odio libero. Suspendisse sagittis arcu rhoncus justo dictum, et feugiat purus malesuada. Fusce sollicitudin sapien eleifend ex porttitor efficitur. Cras fringilla aliquam ligula, id dignissim odio porta ut. Cras laoreet scelerisque libero congue lacinia. Cras hendrerit pulvinar purus ut tristique. Etiam blandit rhoncus ipsum, sed fermentum ligula malesuada sit amet. Praesent malesuada nibh at libero consequat suscipit. Vivamus tempor, urna et elementum dictum, nisi massa efficitur dolor, eu varius eros enim vitae orci.", isHTML: false)
        mailComposer.setToRecipients(["andi.dehelean@icloud.com"])
        
        present(mailComposer, animated: true, completion: nil)
    }
    
    func didTapAgree() {
        let registrationVC = RegistrationViewController.instantiate()
        
        registrationVC.delegate = self
        swap(vc: registrationVC)
    }
}

extension ContainerViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ContainerViewController: RegistrationViewControllerProtocol {
    
    func didSignup() {
        let setup = SetupViewController.instantiate()
        
        present(setup, animated: true, completion: nil)
    }
}

