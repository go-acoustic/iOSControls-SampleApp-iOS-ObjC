//
//  CustomAlertView.swift
//  iOSControls
//
//  Created by Chanikya on 9/26/18.
//  Copyright © 2018 CanNMobile. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    weak var delegate:MyAlertsViewController?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func closeAlertView(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            if let delegate = self.delegate {
                delegate.view.alpha = 1.0
            }
        })
        self.removeFromSuperview()
    }
}
