import SwiftUI

struct ProfileView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    // States for dropdown toggles
    @State private var isFitnessExpanded = false
    @State private var isNutritionExpanded = false
    @State private var isSleepExpanded = false
    @State private var isMindExpanded = false
    @State private var isCommunityExpanded = false
    @State private var isPersonalizationExpanded = false

    @State private var isNotificationsEnabled = false // Toggle for notifications
    @State private var isLegalExpanded = false
    @State private var isDeleteAccountExpanded = false
    @State private var isLogoutExpanded = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea() // Set background color to white

                ScrollView {
                    VStack(spacing: 30) { // Add spacing between sections
                        // Profile Section Header
                        VStack(spacing: 20) {
                            // Profile Picture
                            Image("EmptyPFP") // Replace with your actual asset name
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle()) // Makes the image circular
                                .frame(width: 120, height: 120) // Adjust the size as needed
                                .shadow(radius: 5)

                            // Profile Header
                            Text("Profile")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .bold()

                            // User Name
                            if firstName.isEmpty || lastName.isEmpty {
                                Text("Loading...")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            } else {
                                Text("\(firstName) \(lastName)")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Features Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Features")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.bottom, 10)

                            // Dropdowns
                            dropdown(title: "Fitness", isExpanded: $isFitnessExpanded)
                            Divider()
                            dropdown(title: "Nutrition", isExpanded: $isNutritionExpanded)
                            Divider()
                            dropdown(title: "Sleep", isExpanded: $isSleepExpanded)
                            Divider()
                            dropdown(title: "Mind", isExpanded: $isMindExpanded)
                            Divider()
                            dropdown(title: "Community", isExpanded: $isCommunityExpanded)
                            Divider()
                            dropdown(title: "Personalization", isExpanded: $isPersonalizationExpanded)
                        }
                        .padding(.horizontal)

                        // App Settings Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("App Settings")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.bottom, 10)
                            
                            // Notifications Toggle
                            HStack {
                                Text("Notifications")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Toggle("", isOn: $isNotificationsEnabled)
                                    .labelsHidden()
                            }
                            
                            Divider()
                            // Legal Dropdown
                            dropdown(title: "Legal", isExpanded: $isLegalExpanded)
                            Divider()
                            // Delete Account Dropdown
                            dropdown(title: "Delete Account", isExpanded: $isDeleteAccountExpanded)
                            Divider()
                            // Log Out Dropdown
                            dropdown(title: "Log Out", isExpanded: $isLogoutExpanded)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20) // Add spacing around the entire scrollable content
                }

                // Navigation buttons
                VStack {
                    HStack {
                        // Back Button
                        NavigationLink(destination: DashboardView(userFirstName: "Natanel")) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding()
                                .background(Circle().fill(Color.gray.opacity(0.2)))
                        }

                        Spacer()

                        // Edit Button
                        Button(action: {
                            print("Edit button pressed")
                        }) {
                            Text("Edit")
                                .foregroundColor(.black) // Changed to black
                                .bold()
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10) // Adjust top padding to align at the top of the screen

                    Spacer()
                }
            }
            .onAppear {
                loadUserData()
            }
        }
    }

    /// Function to create a dropdown view
    @ViewBuilder
    func dropdown(title: String, isExpanded: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: isExpanded.wrappedValue ? "chevron.down" : "chevron.right")
                    .foregroundColor(.black)
            }
            .onTapGesture {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }
            
            if isExpanded.wrappedValue {
                // Placeholder for expanded content
                Text("Content coming soon...")
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
            }
        }
    }

    /// Function to load user data from JSON
    func loadUserData() {
        let decoder = JSONDecoder()
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("user.json")
            do {
                let data = try Data(contentsOf: fileURL)
                let users = try decoder.decode([User].self, from: data)
                if let latestUser = users.last { // Load the most recent user's data
                    firstName = latestUser.firstName
                    lastName = latestUser.lastName
                }
            } catch {
                print("Failed to load user data: \(error)")
            }
        }
    }
}

#Preview {
    ProfileView()
}

