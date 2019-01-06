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

    var onDismiss: (() -> Void)?
    
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: fullHeight, width: UIScreen.main.bounds.width, height: fullHeight))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomViewController.panGesture))
        self.view.addGestureRecognizer(gesture)

        setupHoldView()
    }

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        let y = view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            duration = duration > 1.3 ? 1 : duration

            (velocity.y >= 0) ? toPartialView(withDuration: duration) : toFullView(withDuration: duration)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
        addShadow()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            guard let self = self else { return }
            let frame = self.view.frame
            let yComponent = (self.openFullView) ? self.fullView : self.partialView
            self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
        })
    }

    func toPartialView(withDuration duration: Double = 1.0) {
        let completion: (Bool) -> Void = { [weak self] _ in
            if let self = self, self.allowDismiss {
                Presenter.dismiss(self)
                self.onDismiss?()
            }
        }
        changeYWithAnimation(y: partialView, withDuration: duration, completion: completion)
    }

    func toFullView(withDuration: Double = 1.0) {
        changeYWithAnimation(y: fullView, withDuration: withDuration, completion: {_ in})
    }

    private func changeYWithAnimation(y: CGFloat, withDuration duration: Double, completion: @escaping (Bool) -> Void) {
        let animations = { [weak self] in
            guard let self = self else { return }
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            self.view.layoutIfNeeded()
        }
        UIView.animate(
            withDuration: duration,
            delay: 0.0, options: [.allowUserInteraction],
            animations: animations,
            completion: completion
        )
    }

    private func addShadow() {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: -10.0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 20.0
    }

    private func prepareBackgroundView() {
        let blurEffect = UIBlurEffect.init(style: .extraLight)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let blurredView = UIVisualEffectView.init(effect: blurEffect)
        blurredView.contentView.addSubview(visualEffect)

        visualEffect.frame = UIScreen.main.bounds
        blurredView.frame = UIScreen.main.bounds

        blurredView.clipsToBounds = true
        blurredView.layer.cornerRadius = 10.0
        
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

}
