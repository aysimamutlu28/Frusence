import Foundation
import FirebaseAuth
import Combine

class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    // Register a new user
    func registerUser(withEmail email: String, password: String, name: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let authResult = authResult else {
                    promise(.failure(NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create user"])))
                    return
                }
                
                // Update user profile with name
                let changeRequest = authResult.user.createProfileChangeRequest()
                changeRequest.displayName = name
                
                changeRequest.commitChanges { error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    promise(.success(authResult.user))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // User login
    func loginUser(withEmail email: String, password: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.failure(NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to login"])))
                    return
                }
                
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Anonymous login
    func loginAnonymously() -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.failure(NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to login anonymously"])))
                    return
                }
                
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Sign out
    func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Check current authentication state
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    // Check if user is logged in
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    // Check if user is logged in anonymously
    var isAnonymous: Bool {
        return Auth.auth().currentUser?.isAnonymous ?? false
    }
} 