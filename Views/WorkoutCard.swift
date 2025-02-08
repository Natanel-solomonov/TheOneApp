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
                
                Image(systemName: "dumbbell")  // Dumbbell icon
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
            }
        }
        .padding()
        .frame(maxWidth: .infinity)  // Make it span full screen width
        .background(Color.black)  // Black background for cards
        .overlay(  // White border (same as shortcut buttons)
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

