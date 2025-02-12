import SwiftUI

struct WorkoutCard: View {
    let workout: Workout
    let isExpanded: Bool
    let onExpand: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(workout.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "dumbbell")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            
            Text("Duration: \(workout.duration) minutes")
                .foregroundColor(.gray)
            
            if isExpanded {
                Text("Exercises:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(workout.exercises) { workoutExercise in
                        Text("• \(workoutExercise.exercise.name)")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                
                // Start Workout Button - White with Black Text, Centered, Half-width
                HStack {
                    Spacer() // Push the button to center
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        Text("Start Workout")
                            .font(.headline)
                            .foregroundColor(.black) // Black text
                            .padding()
                            .frame(width: 150) // Half-width size
                            .background(Color.white) // White background
                            .cornerRadius(10)
                    }
                    Spacer() // Push the button to center
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
        )
        .cornerRadius(10)
        .onTapGesture {
            onExpand()
        }
        .animation(.easeInOut, value: isExpanded)
    }
}

