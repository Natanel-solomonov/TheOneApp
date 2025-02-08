import SwiftUI

struct WorkoutListView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var expandedWorkoutId: Int? = nil  // Track which workout is expanded
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Bold White "Workouts" Title
                Text("Workouts")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.workouts) { workout in
                            WorkoutCard(
                                workout: workout,
                                isExpanded: workout.id == expandedWorkoutId,
                                onExpand: {
                                    expandedWorkoutId = (expandedWorkoutId == workout.id) ? nil : workout.id
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))  // Black background
            .onAppear {
                viewModel.fetchWorkouts()
            }
        }
    }
}

