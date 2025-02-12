import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding()
            
            Text("Duration: \(workout.duration) minutes")
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Text("Exercises:")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(workout.exercises) { workoutExercise in
                        ExerciseCard(
                            exercise: workoutExercise.exercise,
                            sets: workoutExercise.sets ?? 3, // Use actual data from API
                            reps: workoutExercise.reps ?? 10, // Use actual data from API
                            equipment: workoutExercise.equipment ?? "None" // Use actual data from API
                        )
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

