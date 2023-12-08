import UIKit
import GoogleSignIn

class MySelfViewController: UIViewController{
    let bookshelfId = "0"
    let volumeId =  "WHFMAQAAMAAJ"
var accessToken = "ya29.a0AfB_byDufp9rBoI3uPzhwbF9bcW7cBh-WI03TFXDbREBBQw4ITyubwD1gOxJc9JfX1X6HPeQwajDxMoFEfbDw2od36dofYCxN5INqiiBiWfRKwQBvmuDJ3QNjuecLyCh_jXPEGSIl8RPk1MyZiZ0DOZzIrt-URjM_txSaCgYKAfESARISFQHGX2Micg6iRVirB83jhZaDowEpbA0171"
    var signInButton: UIButton!
        var signOutButton: UIButton!
        var greetingLabel: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            GIDSignIn.sharedInstance().clientID = "190361506925-tocopcervptlh2qhenvc4khc1onheso3.apps.googleusercontent.com"

           
            greetingLabel = UILabel()
            greetingLabel.text = "Please sign in... 🙂"
            greetingLabel.textAlignment = .center
            greetingLabel.backgroundColor = .tertiarySystemFill
            view.addSubview(greetingLabel)
            greetingLabel.translatesAutoresizingMaskIntoConstraints = false
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
            greetingLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
            greetingLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            // Add sign in button
            signInButton = UIButton()
            signInButton.layer.cornerRadius = 10.0
            signInButton.setTitle("Sign in with Google", for: .normal)
            signInButton.setTitleColor(.white, for: .normal)
            signInButton.backgroundColor = .systemRed
            signInButton.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
            view.addSubview(signInButton)
            signInButton.translatesAutoresizingMaskIntoConstraints = false
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
            
            // Add sign out button
            signOutButton = UIButton()
            signOutButton.layer.cornerRadius = 10.0
            signOutButton.setTitle("Sign Out 👋", for: .normal)
            signOutButton.setTitleColor(.label, for: .normal)
            signOutButton.backgroundColor = .systemFill
            signOutButton.addTarget(self, action: #selector(signOutButtonTapped(_:)), for: .touchUpInside)
            view.addSubview(signOutButton)
            signOutButton.translatesAutoresizingMaskIntoConstraints = false
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
            signOutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
            signOutButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            
            // Sign out button is hidden by default
            signOutButton.isHidden = true
            
            // Let GIDSignIn know that this view controller is presenter of the sign-in sheet
            GIDSignIn.sharedInstance()?.presentingViewController = self
            
            // Register notification to update screen after user successfully signed in
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(userDidSignInGoogle(_:)),
                                                   name: .signInGoogleCompleted,
                                                   object: nil)
            
            // Update screen base on sign-in/sign-out status (when screen is shown)
            updateScreen()
        }
        
        private func updateScreen() {
            
            if let user = GIDSignIn.sharedInstance()?.currentUser {
                // User signed in
                
                // Show greeting message
                greetingLabel.text = "Hello \(user.profile.givenName!)! ✌️"
                
                // Hide sign in button
                signInButton.isHidden = true
                
                // Show sign out button
                signOutButton.isHidden = false
                
            } else {
                // User signed out
                
                // Show sign in message
                 greetingLabel.text = "Please sign in... 🙂"
                 
                 // Show sign in button
                 signInButton.isHidden = false
                 
                 // Hide sign out button
                 signOutButton.isHidden = true
            }
        }
        
        // MARK:- Button action
        @objc func signInButtonTapped(_ sender: UIButton) {
            GIDSignIn.sharedInstance()?.scopes = ["https://www.googleapis.com/auth/books"]
                
            GIDSignIn.sharedInstance()?.signIn()
        }

        @objc func signOutButtonTapped(_ sender: UIButton) {
            GIDSignIn.sharedInstance()?.signOut()
            
            // Update screen after user successfully signed out
            updateScreen()
        }

    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
        updateScreen()

        // Retrieve the current user
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            // Retrieve the authentication object
            if let authentication = user.authentication {
                // Access the access token
                let accessToken = authentication.accessToken
                print(accessToken)
               // Replace with the actual bookshelf ID
                APICallers.fetchBooksFromBookshelf(bookshelfId: bookshelfId, accessToken: accessToken!)
                APICallers.addBookToBookshelf(bookshelfId: bookshelfId, id: volumeId, accessToken: accessToken!) { result in
                    switch result {
                    case.success(let mode):
                        print(mode)
                    case.failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        
    }
    

    
}

