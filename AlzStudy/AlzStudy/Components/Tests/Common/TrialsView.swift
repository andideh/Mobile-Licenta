//
//  TrialsView.swift
//  AlzStudy
//
//  Created by Andrei Dehelean on 26/12/2017.
//  Copyright © 2017 Dehelean Andrei. All rights reserved.
//

import UIKit


final class TrialsView: UIView {
    
    var trialsLeft: Int = 0 {
        didSet {
            self.trialsLeftLabel?.text = "Trials left: \(trialsLeft)"
        }
    }
    
    var timeLeft: Int = 0 {
        didSet {
            self.timeLeftLabel.text = String(describing: timeLeft)
        }
    }
    
    private var trialsLeftLabel: UILabel!
    private var timeLeftLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.trialsLeftLabel = UILabel()
        self.trialsLeftLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.trialsLeftLabel.textColor = .darkGray
        self.trialsLeftLabel.sizeToFit()
        self.trialsLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.trialsLeftLabel)
        
        self.timeLeftLabel = UILabel()
        self.timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLeftLabel.textColor = UIColor.red
        self.timeLeftLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.timeLeftLabel.sizeToFit()
        
        self.addSubview(self.timeLeftLabel)
        
        NSLayoutConstraint.activate([
            self.trialsLeftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.trialsLeftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            self.timeLeftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.timeLeftLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
