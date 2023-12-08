//
//  AuthService.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 05/12/2023.
//


import Foundation

// Sample User Model

// Authentication Service
class AuthService {

    static var usersDatabase: [String: User] = [:]

    func signIn(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Replace this with your actual sign-in logic
        guard let storedUser = AuthService.usersDatabase[username] else {
            // User not found
            let error = NSError(domain: "AuthServiceErrorDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
            completion(.failure(error))
            return
        }

        // Validate the password
        let hashedPassword = AuthService.hashPassword(password)
        if storedUser.hashedPassword == hashedPassword {
            // Authentication successful
            completion(.success(storedUser))
        } else {
            // Invalid credentials
            let error = NSError(domain: "AuthServiceErrorDomain", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
            completion(.failure(error))
        }
    }

    func signUp(email: String, username: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Your sign-up logic here
        // ...

        // For demonstration purposes, let's assume the sign-up is successful
        guard !username.isEmpty && !password.isEmpty else {
            let error = NSError(domain: "AuthServiceErrorDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "Username and password cannot be empty."])
            completion(.failure(error))
            return
        }

        // Validate password policies (e.g., minimum length, complexity)
        guard AuthService.isPasswordValid(password) else {
            let error = NSError(domain: "AuthServiceErrorDomain", code: 400, userInfo: [NSLocalizedDescriptionKey: "Password does not meet security requirements."])
            completion(.failure(error))
            return
        }

        // Hash the password before storing it
        let hashedPassword = AuthService.hashPassword(password)

        // Store user data (replace this with your database logic)
        let newUser = User(name: name, username: username, email: email, hashedPassword: hashedPassword)
        AuthService.usersDatabase[username] = newUser

        completion(.success(newUser))
    }

    // ... (Other methods remain unchanged)

    // Hashing function (replace with a secure hashing algorithm)
    private static func hashPassword(_ password: String) -> String {
        // Replace this with a secure hashing algorithm (e.g., bcrypt, Argon2)
        return password
    }

    // Password validation function (replace with your policy logic)
    private static func isPasswordValid(_ password: String) -> Bool {
        // Replace this with your password policy logic (e.g., minimum length, complexity)
        return password.count >= 8
    }
    func fetchUser(username: String, completion: @escaping (Result<User, Error>) -> Void) {
           // Replace this with your logic to fetch user information from your data source
           if let user = AuthService.usersDatabase[username] {
               completion(.success(user))
           } else {
               let error = NSError(domain: "AuthServiceErrorDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
               completion(.failure(error))
           }
       }
    func fetchUser(email: String, completion: @escaping (Result<User, Error>) -> Void) {
            // Replace this with your logic to fetch user information from your data source
            if let user = AuthService.usersDatabase.values.first(where: { $0.email == email }) {
                completion(.success(user))
            } else {
                let error = NSError(domain: "AuthServiceErrorDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                completion(.failure(error))
            }
        }


}

        
        
        
   

// Example Usage

