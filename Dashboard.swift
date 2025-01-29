import SwiftUI

struct DashboardView: View {
    @State private var showMaxView = false
    @State private var showProfileView = false
    @State private var expandedBoxIndex: Int? = nil // Tracks which box is expanded
    @State private var totalPoints: Int = 0 // Tracks accumulated points

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 10) {
                // Top Bar with Max Button and Profile Icon
                HStack {
                    Button(action: {
                        showMaxView = true
                    }) {
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

                    Button(action: {
                        showProfileView = true
                    }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white) // Uses SF Symbols
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }

                // "Today's Activities" Text
                HStack {
                    Text("Today's Activities")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    Spacer()
                }

                // Activity Boxes
                ZStack(alignment: .leading) {
                    VStack(spacing: 15) {
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

                    // Vertical Slider Dot
                    VStack {
                        Spacer()
                            .frame(height: expandedBoxIndex == 0 ? 20 : expandedBoxIndex == 1 ? 180 : 340)
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                            .offset(x: -20)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // Transparent Points Bar
                VStack {
                    Text("\(totalPoints)/500 Points")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .overlay(
                            Capsule()
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity) // Spans entire screen
                        .padding(.top, 10)
                }

                Spacer()

                // Footer Navigation Bar
                HStack {
                    FooterButton(iconName: "house", label: "Dashboard")
                    FooterButton(iconName: "chart.bar", label: "Insights")
                    FooterButton(iconName: "book", label: "Explore")
                    FooterButton(iconName: "person.2", label: "Social")
                    FooterButton(iconName: "gift", label: "Rewards")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
            }
        }
        .fullScreenCover(isPresented: $showMaxView) {
            MaxView(userName: "John", phoneNumber: "2159136110")
        }
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView() // Pass required arguments
        }
    }

    func addPoints(_ points: Int) {
        totalPoints = min(totalPoints + points, 500) // Ensures points stop at 500
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
                    .padding(.top, 5) // Reduced padding
                Spacer()
                Button(action: {
                    onPointsEarned(points)
                }) {
                    Text("+\(points) Points")
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .overlay(
                            Capsule().stroke(Color.green, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 5) // Reduced padding

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
                .padding(.vertical, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: isExpanded ? 200 : 120) // Adjusted height for collapsed and expanded states
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
    @State private var isHighlighted = false

    var body: some View {
        Button(action: {
            withAnimation {
                isHighlighted = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isHighlighted = false
                }
            }
        }) {
            VStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isHighlighted ? .white : .gray)
                Text(label)
                    .font(.caption)
                    .foregroundColor(isHighlighted ? .white : .gray)
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    DashboardView()
}

