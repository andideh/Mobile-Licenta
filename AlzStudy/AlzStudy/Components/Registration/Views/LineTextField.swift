//
//  LineTextField.swift
//  AlzStudy
//
//  Created by Dehelean Andrei on 3/3/18.
//  Copyright © 2018 Dehelean Andrei. All rights reserved.
//

import UIKit

@IBDesignable
final class LineTextField: UITextField, UITextFieldDelegate {
    
    private var titleLabel: UILabel!
    private var line: CALayer!
    private var hasUpdatedLayout = false

    @IBInspectable
    var titleText: String = "" {
        didSet {
            self.titleLabel.text = titleText
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.delegate = self
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.commonInit()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 50.0)
    }
    
    private func commonInit() {
        let bounds = self.bounds
        
        // Line
        line = CALayer()
        line.frame = CGRect(x: 0.0,
                            y: bounds.height - 2.0,
                            width: bounds.width,
                            height: 1.5)
        line.backgroundColor = UIColor.black.cgColor
        
        self.layer.addSublayer(line)
        
        // Title label
        let frame = CGRect(x: 0.0,
                           y: bounds.midY,
                           width: bounds.width,
                           height: 17.0)
        self.titleLabel = UILabel(frame: frame)
        self.titleLabel.textColor = .gray
        self.titleLabel.font = UIFont(name: "Futura", size: 17.0)
        
        self.addSubview(self.titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard !hasUpdatedLayout else { return }

        line.frame = CGRect(x: 0.0,
                            y: bounds.height - 2.0,
                            width: bounds.width,
                            height: 1.5)

        self.titleLabel.frame = CGRect(x: 0.0,
                           y: bounds.midY,
                           width: bounds.width,
                           height: 17.0)

        hasUpdatedLayout = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        
        return CGRect(x: rect.origin.x,
                      y: 17.0,
                      width: rect.width,
                      height: rect.height - 17.0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        
        return CGRect(x: rect.origin.x,
                      y: 17.0,
                      width: rect.width,
                      height: rect.height - 17.0)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text, text.count == 0 else { return }
        
        self.animateOut()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.count == 0 else { return }
        
        self.animateIn()
    }
    
    func animateIn() {
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.transform = .identity
            self.titleLabel.textColor = .gray
        }
    }
    
    func animateOut() {
        let bounds = self.bounds
        
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.transform = CGAffineTransform(translationX: 0.0, y: -bounds.midY)
            self.titleLabel.textColor = .black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
