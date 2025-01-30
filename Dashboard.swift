import SwiftUI

struct DashboardView: View {
    @State private var showMaxView = false
    @State private var showProfileView = false
    @State private var expandedBoxIndex: Int? = nil
    @State private var totalPoints: Int = 0
    let userFirstName: String

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // Sticky Top Bar
                VStack {
                    HStack {
                        Button(action: { showMaxView = true }) {
                            HStack(spacing: 10) {
                                Image("Max")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                Text("Talk to Max")
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.top, 10)

                        Spacer()

                        Button(action: { showProfileView = true }) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 5)
                    .background(Color.black.opacity(0.9))
                }
                .zIndex(1)

                ScrollView {
                    VStack(spacing: 0) {
                        // "Today's Activities" Section
                        HStack {
                            Text("\(userFirstName)'s Activities")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .bold()
                                .padding(.leading, 20)
                                .padding(.top, 10)
                            Spacer()
                        }

                        // Activity Section
                        HStack(spacing: 5) {
                            VStack {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(expandedBoxIndex == index ? .white : .gray.opacity(0.5))
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 2)
                                                .opacity(expandedBoxIndex == index ? 0 : 1)
                                        )
                                    if index < 2 {
                                        Rectangle()
                                            .frame(width: 3, height: 100)
                                            .foregroundColor(.gray.opacity(0.5))
                                    }
                                }
                            }

                            VStack(spacing: 8) {
                                ActivityBox(
                                    title: "Traditional Strength Training",
                                    points: 100,
                                    buttonText: "Get Today's Workout",
                                    isExpanded: expandedBoxIndex == 0,
                                    onExpand: { expandedBoxIndex = expandedBoxIndex == 0 ? nil : 0 },
                                    onPointsEarned: addPoints
                                )
                                ActivityBox(
                                    title: "Track Meals",
                                    points: 100,
                                    buttonText: "Log Now",
                                    isExpanded: expandedBoxIndex == 1,
                                    onExpand: { expandedBoxIndex = expandedBoxIndex == 1 ? nil : 1 },
                                    onPointsEarned: addPoints
                                )
                                ActivityBox(
                                    title: "Wind Down for Bed",
                                    points: 100,
                                    buttonText: "View Checklist",
                                    isExpanded: expandedBoxIndex == 2,
                                    onExpand: { expandedBoxIndex = expandedBoxIndex == 2 ? nil : 2 },
                                    onPointsEarned: addPoints
                                )
                            }
                        }
                        .padding(.horizontal, 5)

                        // Points Bar
                        VStack {
                            Text("\(totalPoints)/500 Points")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 1)
                                .frame(width: UIScreen.main.bounds.width)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 10)

                        // "My Shortcuts" Section
                        HStack {
                            Text("My Shortcuts")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                                .padding(.top, 10)
                            Spacer()
                        }

                        // 2x2 Shortcut Buttons Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                            ShortcutButton(iconName: "fork.knife", label: "Food Tracking")
                            ShortcutButton(iconName: "brain.head.profile", label: "Mindfulness")
                            ShortcutButton(iconName: "dumbbell", label: "Physical Activity")
                            ShortcutButton(iconName: "book", label: "Add New Shortcut")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 5)

                        Spacer()
                    }
                }
                .padding(.bottom, 60)
            }

            // Sticky Footer
            VStack {
                Spacer()
                HStack {
                    FooterButton(iconName: "house", label: "Dashboard")
                    FooterButton(iconName: "chart.bar", label: "Insights")
                    FooterButton(iconName: "book", label: "Explore")
                    FooterButton(iconName: "person.2", label: "Social")
                    FooterButton(iconName: "gift", label: "Rewards")
                }
                .padding()
                .background(Color.black.opacity(0.9))
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .fullScreenCover(isPresented: $showMaxView) {
            MaxView(userName: "John", phoneNumber: "2159136110", userFirstName:"Natanel")
        }
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
        }
    }

    func addPoints(_ points: Int) {
        totalPoints = min(totalPoints + points, 500)
    }
}

struct ActivityBox: View {
    let title: String
    let points: Int
    let buttonText: String
    let isExpanded: Bool
    let onExpand: () -> Void
    let onPointsEarned: (Int) -> Void

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    onPointsEarned(points)
                }) {
                    Text("+\(points) Points")
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .overlay(
                            Capsule().stroke(Color.green, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 10)

            if isExpanded {
                Button(action: {}) {
                    Text(buttonText)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                .padding(.vertical, 5)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: isExpanded ? 170 : 100)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .onTapGesture {
            onExpand()
        }
        .animation(.easeInOut, value: isExpanded)
    }
}

struct FooterButton: View {
    let iconName: String
    let label: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ShortcutButton: View {
    let iconName: String
    let label: String

    var body: some View {
        Button(action: {}) {
            VStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                Text(label)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(width: UIScreen.main.bounds.width / 2 - 25, height: 100)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}

#Preview {
    DashboardView(userFirstName: "Natanel")
}

