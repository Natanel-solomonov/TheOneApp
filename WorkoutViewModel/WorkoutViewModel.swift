import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []

    func fetchWorkouts() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/workouts/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch workouts:", error)
                DispatchQueue.main.async {
                    self.loadMockData()
                }
                return
            }
            
            if let data = data {
                do {
                    let decodedWorkouts = try JSONDecoder().decode([Workout].self, from: data)
                    DispatchQueue.main.async {
                        self.workouts = decodedWorkouts
                    }
                } catch {
                    print("Error decoding workouts: \(error)")
                }
            }
        }.resume()
    }
    
    
    private func loadMockData() {
        self.workouts = [
            Workout(id: 1, name: "Full Body Workout", duration: 45, exercises: [
                WorkoutExercise(id: 1, exercise: Exercise(id: 1, name: "Push-ups"), sets: 3, reps: 15, equipment: "None"),
                WorkoutExercise(id: 2, exercise: Exercise(id: 2, name: "Squats"), sets: 4, reps: 12, equipment: "Barbell")
            ]),
            Workout(id: 2, name: "Cardio Session", duration: 30, exercises: [
                WorkoutExercise(id: 3, exercise: Exercise(id: 3, name: "Running"), sets: nil, reps: nil, equipment: "Treadmill"),
                WorkoutExercise(id: 4, exercise: Exercise(id: 4, name: "Jump Rope"), sets: 5, reps: 30, equipment: "Jump Rope")
            ]),
            Workout(id: 3, name: "Strength Training", duration: 50, exercises: [
                WorkoutExercise(id: 5, exercise: Exercise(id: 5, name: "Bench Press"), sets: 4, reps: 8, equipment: "Barbell"),
                WorkoutExercise(id: 6, exercise: Exercise(id: 6, name: "Deadlift"), sets: 4, reps: 6, equipment: "Barbell")
            ]),
            Workout(id: 4, name: "Yoga Flow", duration: 40, exercises: [
                WorkoutExercise(id: 7, exercise: Exercise(id: 7, name: "Downward Dog"), sets: nil, reps: nil, equipment: "Yoga Mat"),
                WorkoutExercise(id: 8, exercise: Exercise(id: 8, name: "Warrior Pose"), sets: nil, reps: nil, equipment: "Yoga Mat")
            ]),
            Workout(id: 5, name: "HIIT Circuit", duration: 25, exercises: [
                WorkoutExercise(id: 9, exercise: Exercise(id: 9, name: "Jump Squats"), sets: 3, reps: 20, equipment: "None"),
                WorkoutExercise(id: 10, exercise: Exercise(id: 10, name: "Burpees"), sets: 3, reps: 15, equipment: "None")
            ])
        ]
    }

}

