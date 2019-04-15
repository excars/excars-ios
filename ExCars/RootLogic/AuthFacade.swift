//
//  AuthFacade.swift
//  ExCars
//
//  Created by Алексей Коньшин on 14/04/2019.
//  Copyright © 2019 Леша. All rights reserved.
//

import GoogleSignIn

final class AuthFacade: NSObject {
    
    static let shared = AuthFacade()
    
    private(set) var currentUser: User? {
        didSet { NotificationCenter.default.post(name: .authenticationUpdated, object: currentUser) }
    }
    
    // MARK: - lifecycle
    
    private override init() {
        super.init()
    }
    
    // MARK: - actions

    func login(googleToken: String,
               completion: @escaping (Result<User, Error>) -> Void) {
        APIClient.auth(idToken: googleToken) { [weak self] status, result in
            switch result {
            case .success(let response):
                KeyChain.setJWTToken(token: response.jwtToken)
                self?.fetchUser(completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        APIClient.me() { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success(let me):
                self.currentUser = me
                completion(.success(me))
            case .failure(let error):
                KeyChain.setJWTToken(token: nil)
                completion(.failure(error))
                return
            }
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
        KeyChain.setJWTToken(token: nil)
        currentUser = nil
    }
    
    // MARK: - private
    
}

extension Notification.Name {
    
    static let authenticationUpdated = Notification.Name(rawValue: "AUTHENTICATION_UPDATED")
    
}
