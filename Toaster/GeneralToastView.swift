//
//  GeneralToastView.swift
//  riano
//
//  Created by Neil Dwyer on 5/9/16.
//  Copyright © 2016 Neil Dwyer. All rights reserved.
//

import UIKit

protocol GeneralToastViewDelegate: class {
    func didCancel(toastView: GeneralToastView)
    func didPress(toastView: GeneralToastView)
}

class GeneralToastView: UIView {
    weak var toastViewDelegate: GeneralToastViewDelegate?
    @IBOutlet weak var toastTextLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTap()
    }
}

extension GeneralToastView {
    
    func configureWithText(text: String) {
        toastTextLabel.text = text
    }
    
    private func setupTap() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func didTap() {
        toastViewDelegate?.didPress(self)
    }
    @IBAction func didPressCloseButton(sender: AnyObject) {
        toastViewDelegate?.didCancel(self)
    }
}
