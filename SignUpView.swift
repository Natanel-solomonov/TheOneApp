import SwiftUI
struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var isNavigating: Bool = false
    @State private var showError: Bool = false // State for showing error
    @State private var errorMessage: String = "" // State for the error message
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    // Logo as header
                    Image("OneLogo") // Replace "OneLogo" with your image asset name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.top, 50)
                    // "Sign Up" Text
                    Text("Sign Up")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    // Input Boxes with Labels
                    VStack(spacing: 20) {
                        // First Name Input
                        VStack(alignment: .leading, spacing: 5) {
                            Text("First Name")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 40)
                            CustomTextField(text: $firstName)
                        }
                        // Last Name Input
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Last Name")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 40)
                            CustomTextField(text: $lastName)
                        }
                        // Phone Number Input
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Phone Number")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 40)
                            CustomTextField(text: $phoneNumber)
                        }
                    }
                    .padding(.top, 10)
                    // Error Message
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.horizontal, 40)
                    }
                    Spacer()
                    // Onboard Button
                    Button(action: {
                        if validatePhoneNumber(phoneNumber) {
                            print("Formatted : \(phoneNumber)")
                            TwilioAPI().sendVerification(to: phoneNumber) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success:
                                        saveUserData()
                                        isNavigating = true // Navigate to MaxView
                                    case .failure(let error):
                                        showError = true
                                        errorMessage = "Failed to send verification code: \(error.localizedDescription)"
                                    }
                                }
                            }
                        } else {
                            showError = true
                            errorMessage = "Please enter a valid phone number."
                        }
                    }) {
                        Text("Onboard with Max")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            )
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $isNavigating) {
                MaxView(userName: "\(firstName) \(lastName)", phoneNumber: phoneNumber) // Navigate to MaxView
            }
        }
    }
    
    /// Save user data to a JSON file or print it to the console
    func saveUserData() {
        let user = User(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let decoder = JSONDecoder()
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("user.json")
                var users: [User] = []
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let data = try Data(contentsOf: fileURL)
                    if !data.isEmpty {
                        do {
                            users = try decoder.decode([User].self, from: data)
                        } catch {
                            print("Existing data is corrupted, starting fresh: \(error)")
                            users = [] // Reset to an empty array if the data is invalid
                        }
                    }
                }
                users.append(user)
                let jsonData = try encoder.encode(users)
                try jsonData.write(to: fileURL, options: .atomic)
                print("User data saved to: \(fileURL.path)")
                print(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")
            } else {
                print("Could not locate the Documents directory.")
            }
        } catch {
            print("Failed to save user data: \(error)")
        }
    }
    
    /// Validate phone number format
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // Remove any non-digit characters
        let digitsOnly = phoneNumber.filter { $0.isNumber }
        
        // Ensure the phone number has exactly 10 digits
        if digitsOnly.count == 10 {
            self.phoneNumber = "+1\(digitsOnly)" // Add the +1 prefix
            return true
        }
        
        return false
    }
}

// Custom TextField with styling
struct CustomTextField: View {
    @Binding var text: String
    var body: some View {
        TextField("", text: $text)
            .foregroundColor(.white)
            .accentColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2)
            )
            .padding(.horizontal, 40)
    }
}

// User model for JSON data
struct User: Codable {
    let firstName: String
    let lastName: String
    let phoneNumber: String
}

#Preview {
    SignUpView()
}

