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

    func login(googleToken: String, completion: @escaping (Result<User, Error>) -> Void) {
        KeyChain.setJWTToken(token: googleToken)
        self.fetchUser(completion: completion)
    }

    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        APIClient.me() { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success(let me):
                self.currentUser = me
                self.fetchProfile()
                completion(.success(me))
            case .failure(let error):
                self.logout()
                completion(.failure(error))
                return
            }
        }
    }
    
    private func fetchProfile() {
        guard let userId = self.currentUser?.id else { return }
        APIClient.profile(id: userId) { [weak self] status, result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.currentUser?.destination = profile.destination
                self.currentUser?.role = profile.role
            case .failure:
                if status != 404 {
                    print("Failed to fetch profile")
                }
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
