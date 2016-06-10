//
//  Toaster.swift
//  Toaster
//
//  Created by Neil Dwyer on 6/10/16.
//  Copyright © 2016 Neil Dwyer. All rights reserved.
//

import UIKit

class Toaster {
    
    private typealias Handler = (Void->Void)
    
    private var toastToWindow = [UIView: UIWindow]()
    private var toastWindows = [UIWindow]()
    private var toastToTapHandler = [UIView: Handler]()
    private var toastToCancelHandler = [UIView: Handler]()
    
    init() {
    }
}

extension Toaster {
    func showGeneralToast(text text: String, duration: NSTimeInterval, tapHandler:(Void->Void)?, cancelHandler:(Void -> Void)?) {
        guard let toast = NSBundle.mainBundle().loadNibNamed("GeneralToastView", owner: nil, options: nil).first as? GeneralToastView else {
            return
        }
        
        let window = UIWindow()
        window.windowLevel = UIWindowLevelStatusBar + 1
        
        if let th = tapHandler {
            toastToTapHandler[toast] = th
        }
        
        if let ch = cancelHandler {
            toastToCancelHandler[toast] = ch
        }
        
        toast.configureWithText(text)
        toast.toastViewDelegate = self
        
        let height: CGFloat = 20.0
        let width = UIScreen.mainScreen().bounds.width
        
        let startFrame = CGRect(x: -width, y: 0, width: width, height: height)
        let endFrame = CGRect(x: 0, y: 0, width: width, height: height)
        
        window.frame = startFrame
        toast.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: height)
        window.addSubview(toast)
        
        toastToWindow[toast] = window
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
            window.frame = endFrame
            }, completion: nil)
        
        window.backgroundColor = UIColor.clearColor()
        window.hidden = false
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * 1000 * NSTimeInterval(NSEC_PER_MSEC))), dispatch_get_main_queue()) { [weak self]() in
            self?.hideToast(toast)
        }
        
    }
    
    func hideToast(toast: GeneralToastView) {
        guard let window = toastToWindow[toast] else {
            return
        }
        let height: CGFloat = 20.0
        let width = UIScreen.mainScreen().bounds.width
        let endFrame = CGRect(x: width, y: 0, width: width, height: height)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: {
            window.frame = endFrame
        }) { [weak self] complete in
            toast.removeFromSuperview()
            window.removeFromSuperview()
            self?.toastToWindow.removeValueForKey(toast)
        }
    }
}

// MARK: - GeneralToastViewDelegate
extension Toaster: GeneralToastViewDelegate {
    func didPress(toastView: GeneralToastView) {
        if let tapHandler = toastToTapHandler[toastView] {
            tapHandler()
        }
        hideToast(toastView)
    }
    
    func didCancel(toastView: GeneralToastView) {
        if let cancelHandler = toastToCancelHandler[toastView] {
            cancelHandler()
        }
        hideToast(toastView)
    }
}