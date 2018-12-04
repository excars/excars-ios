//
//  BottomViewController.swift
//  ExCars
//
//  Created by Леша on 02/12/2018.
//  Copyright © 2018 Леша. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController {

    private var _fullHeight: CGFloat = 0
    var fullHeight: CGFloat {
        get { return _fullHeight }
        set { _fullHeight = newValue }
    }
    
    private var _height: CGFloat = 0
    var height: CGFloat {
        get { return _height }
        set { _height = newValue }
    }
    
    var fullView: CGFloat {
        return UIScreen.main.bounds.height - fullHeight
    }
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - height
    }

    var allowDismiss = false
    var openFullView = false

    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: fullHeight, width: UIScreen.main.bounds.width, height: fullHeight))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomViewController.panGesture))
        self.view.addGestureRecognizer(gesture)
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
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    func render() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomViewController.panGesture))
        self.view.addGestureRecognizer(gesture)
        self.viewWillAppear(true)
    }

}
