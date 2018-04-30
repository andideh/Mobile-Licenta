//
//  QuestionViewController.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 11/5/17.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit

typealias VoidBlock = () -> Void

struct QuestionViewData {
    
    let title: String
    let leftButtonTitle: String
    let rightButtonTitle: String
    let leftButtonAction: VoidBlock
    let rightButtonAction: VoidBlock
}

final class QuestionViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // MARK: - Private properties
    
    var viewData: QuestionViewData!
    
    // MARK: - Lifecycle

    static func instantiate() -> QuestionViewController {
        return Storyboard.Registration.instantiate() as QuestionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let radius = leftButton.bounds.height / 2
        
        leftButton.layer.cornerRadius = radius
        rightButton.layer.cornerRadius = radius
        
        titleLabel.text = viewData.title
        leftButton.setTitle(viewData.leftButtonTitle, for: .normal)
        rightButton.setTitle(viewData.rightButtonTitle, for: .normal)
    }
    
    // MARK: - Public
    
    func configure(viewData: QuestionViewData) {
        self.viewData = viewData       
    }
    
    
    // MARK: - IBActions
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        viewData.leftButtonAction()
    }
    
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        viewData.rightButtonAction()
    }
    
    
    
}
