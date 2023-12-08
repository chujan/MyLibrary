//
//  SignInViewController.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 05/12/2023.
//

import UIKit



class SignInViewController: UIViewController {

    var emailTextField: UITextField!
    var usernameTextField: UITextField!
    var nameTextField: UITextField!
    var passwordTextField: UITextField!
    var actionButton: UIButton!
    var switchButton: UIButton!
    
    let authService = AuthService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Email Text Field
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)

        // Create Username Text Field
        usernameTextField = UITextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextField)
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)

        // Create Password Text Field
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)

        // Create Action Button
        actionButton = UIButton()
        actionButton.setTitle("Sign In", for: .normal)
        actionButton.setTitleColor(.blue, for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        // Example: Add a sign-out button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonTapped))
        // Example: Update navigation bar after sign-out
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(actionButtonTapped))


        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)

        // Create Switch Button
        switchButton = UIButton()
        switchButton.setTitle("Don't have an account? Sign Up", for: .normal)
        switchButton.setTitleColor(.blue, for: .normal)
        switchButton.addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            usernameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            nameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),


            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            actionButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            switchButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 10),
            switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
  
    @objc func signOutButtonTapped() {
        // Clear user information from UserDefaults
        UserDefaults.standard.removeObject(forKey: "signedInUserName")
        UserDefaults.standard.removeObject(forKey: "signedInUserUsername")
        UserDefaults.standard.removeObject(forKey: "signedInUserEmail")
        UserDefaults.standard.synchronize()

        // Navigate to the sign-in or initial screen
        navigateToSignIn()
    }

    func navigateToSignIn() {
        let signInViewController = SignInViewController()
        let navigationController = UINavigationController(rootViewController: signInViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }


    @objc func actionButtonTapped() {
        if actionButton.title(for: .normal) == "Sign In" {
            // Sign In logic
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert(message: "Please enter both email and password for sign in.")
                return
            }

            authService.signIn(username: email, password: password) { result in
                switch result {
                case .success(let response):
                    print("Sign In success:", response)

                    // Hide text fields after successful sign in
                    self.hideTextFields()

                    // Update UserDefaults with user information
                    UserDefaults.standard.set(response.name, forKey: "signedInUserName")
                    UserDefaults.standard.set(response.username, forKey: "signedInUserUsername")
                    UserDefaults.standard.set(response.email, forKey: "signedInUserEmail")

                    // Navigate to HomeViewController
                    self.navigateToHome()

                case .failure(let error):
                    print("Sign In error:", error)
                    // Display an error message to the user
                    self.showAlert(message: "Sign In failed. Please check your credentials.")
                }
            }
        } else {
            // Sign Up logic
            guard let email = emailTextField.text, !email.isEmpty,
                  let username = usernameTextField.text, !username.isEmpty,
                  let name = nameTextField.text, !name.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert(message: "Please enter all required information for sign up.")
                return
            }

            authService.signUp(email: email, username: username, password: password, name: name) { result in
                switch result {
                case .success(let user):
                    print("Sign Up success:", user)

                    // Hide text fields after successful sign up
                    self.hideTextFields()

                    // Update user information in UserDefaults
                    UserDefaults.standard.set(user.name, forKey: "signedInUserName")
                    UserDefaults.standard.set(user.username, forKey: "signedInUserUsername")
                    UserDefaults.standard.set(user.email, forKey: "signedInUserEmail")
                    UserDefaults.standard.synchronize()

                    // Navigate to HomeViewController
                    self.navigateToHome()

                case .failure(let error):
                    print("Sign Up error:", error)
                    // Display an error message to the user
                    self.showAlert(message: "Sign Up failed. Please try again.")
                }
            }
        }
    }

    func navigateToHome() {
        let homeViewController = BookTabViewController() // Instantiate your HomeViewController
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
       

    }


    // ... (previous code)

    // ... (previous code)

    func hideTextFields() {
        emailTextField.text = ""
        usernameTextField.text = ""
        nameTextField.text = ""
        passwordTextField.text = ""
    }

    // ... (remaining code)

    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)

           // Check if the user is already signed in
           if isUserSignedIn() {
               // If signed in, navigate to the HomeViewController
               navigateToHome()
           }
       }

       // Function to check if the user is signed in
       func isUserSignedIn() -> Bool {
           return UserDefaults.standard.value(forKey: "signedInUserName") != nil
       }




    @objc func switchButtonTapped() {
        // Toggle between Sign In and Sign Up
        if actionButton.title(for: .normal) == "Sign In" {
            actionButton.setTitle("Sign Up", for: .normal)
            switchButton.setTitle("Already have an account? Sign In", for: .normal)
            usernameTextField.isHidden = false
        } else {
            actionButton.setTitle("Sign In", for: .normal)
            switchButton.setTitle("Don't have an account? Sign Up", for: .normal)
            usernameTextField.isHidden = true
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func signIn(email: String, password: String) {
        authService.signIn(username: email, password: password) { result in
            switch result {
            case .success(let response):
                print("Sign In success:", response)
                // Update UserDefaults with user information
                UserDefaults.standard.set(response.name, forKey: "signedInUserName")
                UserDefaults.standard.set(response.username, forKey: "signedInUserUsername")
                UserDefaults.standard.set(response.email, forKey: "signedInUserEmail")

                // Update your UI or navigate to the main app screen
                // Optionally, you can trigger a segue or dismiss the SignInViewController
                // and update the ProfileViewController directly.
            case .failure(let error):
                print("Sign In error:", error)
                // Display an error message to the user
                self.showAlert(message: "Sign In failed. Please check your credentials.")
            }
        }
    }


   
    func signUp(email: String, username: String, password: String, name: String) {
        authService.signUp(email: email, username: username, password: password, name: name) { result in
            switch result {
            case .success(let user):
                print("Sign Up success:", user)
                
                // Update user information in UserDefaults
                UserDefaults.standard.set(user.name, forKey: "signedInUserName")
                UserDefaults.standard.set(user.username, forKey: "signedInUserUsername")
                UserDefaults.standard.set(user.email, forKey: "signedInUserEmail")
                UserDefaults.standard.synchronize()

                // Update user information in ProfileViewController
                if let profileViewController = self.navigationController?.viewControllers.first(where: { $0 is ProfileViewController }) as? ProfileViewController {
                    profileViewController.updateUserInfo()
                }

                // Update your UI or navigate to the main app screen
            case .failure(let error):
                print("Sign Up error:", error)
                // Display an error message to the user
                self.showAlert(message: "Sign Up failed. Please try again.")
            }
        }
    }
}
