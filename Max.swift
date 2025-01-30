import SwiftUI
import Foundation
import SwiftUI

struct MessageBubble: View {
    var text: String
    var isUser: Bool
    var isSystemMessage: Bool = false

    var body: some View {
        HStack {
            if isUser {
                Spacer()
                Text(text)
                    .foregroundColor(.black)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    )
            } else if isSystemMessage {
                Text(text)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.4))
                    )
                Spacer()
            } else {
                Text(text)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                    )
                Spacer()
            }
        }
        .padding(.horizontal, 10)
    }
}



struct MaxView: View {
    var userName: String
    var phoneNumber: String
    @State private var showSecondBubble = true
    @State private var showThirdBubble = false
    @State private var userMessages: [String] = []
    @State private var userInput: String = ""
    @State private var verificationInProgress = false
    @State private var isVerified = false
    @State private var onboardingStage = 0
    @State private var generalGoals: String = ""
    @State private var mentalHealthGoals: String = ""
    @State private var dietaryRestrictions: String = ""
    @State private var weight: String = ""
    @State private var gender: String = ""
    @State private var showContinueButton = false
    @State private var navigateToDashboard = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 5) {
                    Image("Max")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.top, -10)
                    Text("Max")
                        .foregroundColor(.white)
                        .font(.headline)
                }

                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
                    .padding(.horizontal, 20)

                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack(alignment: .leading, spacing: 10) {
                            MessageBubble(text: "Hi \(userName), I'm Max, your personal guide to a healthier college life", isUser: false)
                            if showSecondBubble {
                                MessageBubble(text: "We keep things simple here. One helps you improve your fitness, nutrition, sleep, and mental health while earning rewards to try new brands.", isUser: false)
                            }

                            if !isVerified {
                                MessageBubble(text: "Let’s get started by verifying your phone number. I’ve sent you a code. Please enter it here.", isUser: false)
                            }

                            ForEach(userMessages.indices, id: \.self) { index in
                                let messageParts = userMessages[index].split(separator: "|")
                                let text = String(messageParts[0])
                                let isSystemMessage = messageParts.count > 1 && messageParts[1] == "System"
                                MessageBubble(text: text, isUser: !isSystemMessage, isSystemMessage: isSystemMessage)
                                    .id(index)
                            }
                        }
                        .padding(.horizontal, 20)
                        .onChange(of: userMessages.count) { _ in
                            scrollViewProxy.scrollTo(userMessages.count - 1, anchor: .bottom)
                        }
                    }
                }
                .padding(.top, 10)

                VStack {
                    Divider()
                        .frame(height: 1)
                        .background(Color.gray)

                    if showContinueButton {
                        Button(action: {
                            navigateToDashboard = true
                        }) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 150, height: 50)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                        .padding(.top, 10)
                    } else {
                        HStack {
                            TextField(isVerified ? "Enter your response here..." : "Enter verification code", text: $userInput)
                                .padding()
                                .padding(.leading, 20)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .foregroundColor(.white)
                                .accentColor(.white)

                            Button(action: handleUserInput) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 50, height: 50)
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "arrow.up.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.leading, 10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
                .background(Color.black.opacity(0.9))
            }
            .fullScreenCover(isPresented: $navigateToDashboard) {
                DashboardView()
            }
        }
    }

    func handleUserInput() {
        guard !userInput.isEmpty else { return }
        userMessages.append(userInput)

        if !isVerified {
            let enteredCode = userInput
            userInput = ""
            verificationInProgress = true
            TwilioAPI().checkVerification(for: phoneNumber, code: enteredCode) { result in
                DispatchQueue.main.async {
                    verificationInProgress = false
                    switch result {
                    case .success(let verified):
                        if verified {
                            isVerified = true
                            userMessages.append("Your phone number has been successfully verified!|System")
                            onboardingStage = 0
                            userMessages.append("Can you give me a description of your physical health goals?|System")
                        } else {
                            userMessages.append("That does not seem to be the correct code. Please try again.|System")
                        }
                    case .failure(let error):
                        userMessages.append("An error occurred during verification: \(error.localizedDescription)|System")
                    }
                }
            }
        } else {
            switch onboardingStage {
            case 0:
                generalGoals = userInput
                userMessages.append("Ok, great! Now, how about some of your mental health goals?|System")
            case 1:
                mentalHealthGoals = userInput
                userMessages.append("Do you have any dietary restrictions?|System")
            case 2:
                dietaryRestrictions = userInput
                userMessages.append("What is your current weight?|System")
            case 3:
                weight = userInput
                userMessages.append("Lastly, what is your gender?|System")
            case 4:
                gender = userInput
                saveUserData()
                userMessages.append("Ok, I have all that I need to help create your own personal One Plan. So get out there and start earning some points! Tap continue to go to your personal dashboard.|System")
                showContinueButton = true
            default:
                break
            }
            onboardingStage += 1
            userInput = ""
        }
    }

    func saveUserData() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let decoder = JSONDecoder()

            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent("user.json")

                var users: [user] = []

                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let data = try Data(contentsOf: fileURL)
                    if !data.isEmpty {
                        do {
                            users = try decoder.decode([user].self, from: data)
                        } catch {
                            print("Existing data is corrupted or missing keys, starting fresh: \(error)")
                        }
                    }
                }

                if let existingIndex = users.firstIndex(where: { $0.phoneNumber == phoneNumber }) {
                    users[existingIndex].generalGoals = generalGoals
                    users[existingIndex].mentalHealthGoals = mentalHealthGoals
                    users[existingIndex].dietaryRestrictions = dietaryRestrictions
                    users[existingIndex].weight = weight
                    users[existingIndex].gender = gender
                } else {
                    let newUser = user(
                        firstName: "Natanel",
                        lastName: "Solomonov",
                        phoneNumber: phoneNumber,
                        generalGoals: generalGoals,
                        mentalHealthGoals: mentalHealthGoals,
                        dietaryRestrictions: dietaryRestrictions,
                        weight: weight,
                        gender: gender
                    )
                    users.append(newUser)
                }

                let jsonData = try encoder.encode(users)
                try jsonData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print("Failed to save user data: \(error)")
        }
    }
}

#Preview {
    MaxView(userName: "John", phoneNumber: "2159136110")
}
