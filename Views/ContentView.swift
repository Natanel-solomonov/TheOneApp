import SwiftUI
struct ContentView: View {
    @State private var logoOpacity: Double = 0.0 // Controls the logo's visibility
    @State private var textOpacity: Double = 0.0 // Controls the first text's visibility
    @State private var secondaryTextOpacity: Double = 0.0 // Controls the second text's visibility
    @State private var buttonOpacity: Double = 0.0 // Controls the button's visibility
    var body: some View {
        NavigationStack { // Wrap content in NavigationStack
            ZStack {
                // Background Color
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Spacer() // Push content to the center
                    // Center content (logo and text)
                    VStack(spacing: 20) {
                        // Logo Image
                        Image("OneLogo") // Replace "OneLogo" with your PNG file name (without extension)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300) // Adjust size as needed
                            .opacity(logoOpacity) // Bind the opacity to the state
                            .onAppear {
                                fadeInLogo() // Trigger fade-in animation
                            }
                        
                    }
                    Spacer() // Push button to the bottom
                    // Button
                    if buttonOpacity > 0 {
                        NavigationLink(destination: SignUpView()) { // Link to the new screen
                            Text("Sign Up")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 200, height: 50) // Fixed size for square shape
                                .background(Color.white)
                                .cornerRadius(10) // Rounded corners
                        }
                        .opacity(buttonOpacity)
                    }
                }
                .padding() // Add some padding around the VStack
            }
        }
    }
    // Function to fade in the logo
    private func fadeInLogo() {
        withAnimation(.easeIn(duration: 2.0)) { // 2.5-second fade-in
            logoOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            fadeInText()
        }
    }
    // Function to fade in the first text
    private func fadeInText() {
        withAnimation(.easeIn(duration: 1.0)) { // 2.5-second fade-in
            textOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            fadeInSecondaryText()
        }
    }
    // Function to fade in the second text
    private func fadeInSecondaryText() {
        withAnimation(.easeIn(duration: 1.0)) { // 2.5-second fade-in
            secondaryTextOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            fadeInButton()
        }
    }
    // Function to fade in the button
    private func fadeInButton() {
        withAnimation(.easeIn(duration: 2.5)) { // 2.5-second fade-in
            buttonOpacity = 1.0
        }
    }
}
#Preview {
    ContentView()
}


