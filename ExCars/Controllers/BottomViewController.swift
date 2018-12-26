//
//  BottomViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController {

    var allowDismiss = false
    var openFullView = false
    
    var fullHeight: CGFloat = 0.0
    var height: CGFloat = 0.0

    let bottomSafeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat(0.0)
    
    private var fullView: CGFloat {
        return UIScreen.main.bounds.height - (fullHeight + bottomSafeAreaInsets)
    }
    private var partialView: CGFloat {
        return UIScreen.main.bounds.height - (height + bottomSafeAreaInsets)
    }

    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: fullHeight, width: UIScreen.main.bounds.width, height: fullHeight))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomViewController.panGesture))
        self.view.addGestureRecognizer(gesture)
        
        setupHoldView()
        makeRoundCorners()
    }

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: {_ in
                if velocity.y >= 0 && self.allowDismiss {
                    Presenter.dismiss(self)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = (self?.openFullView ?? false) ? self?.fullView : self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    private func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let blurredView = UIVisualEffectView.init(effect: blurEffect)
        blurredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        blurredView.frame = UIScreen.main.bounds
        
        view.insertSubview(blurredView, at: 0)
    }

    private func setupHoldView() {
        let holdView = UIView()
        holdView.layer.cornerRadius = 1.5
        holdView.backgroundColor = UIColor.lightGray
        holdView.center = view.center
        
        let width: CGFloat = 30
        holdView.frame = CGRect(x: view.center.x - (width / 2), y: 8, width: width, height: 3)
        
        view.addSubview(holdView)
    }
    
    private func makeRoundCorners() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }

}
