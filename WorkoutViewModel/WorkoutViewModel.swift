import Foundation

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []

    func fetchWorkouts() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/workouts/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch workouts:", error)
                DispatchQueue.main.async {
                    self.loadMockData()  // Load mock data when backend is unavailable
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
                WorkoutExercise(id: 1, exercise: Exercise(id: 1, name: "Push-ups")),
                WorkoutExercise(id: 2, exercise: Exercise(id: 2, name: "Squats"))
            ]),
            Workout(id: 2, name: "Cardio Session", duration: 30, exercises: [
                WorkoutExercise(id: 3, exercise: Exercise(id: 3, name: "Running")),
                WorkoutExercise(id: 4, exercise: Exercise(id: 4, name: "Jump Rope"))
            ]),
            Workout(id: 3, name: "Strength Training", duration: 50, exercises: [
                WorkoutExercise(id: 5, exercise: Exercise(id: 5, name: "Bench Press")),
                WorkoutExercise(id: 6, exercise: Exercise(id: 6, name: "Deadlift"))
            ]),
            Workout(id: 4, name: "Yoga Flow", duration: 40, exercises: [
                WorkoutExercise(id: 7, exercise: Exercise(id: 7, name: "Downward Dog")),
                WorkoutExercise(id: 8, exercise: Exercise(id: 8, name: "Warrior Pose"))
            ]),
            Workout(id: 5, name: "HIIT Circuit", duration: 25, exercises: [
                WorkoutExercise(id: 9, exercise: Exercise(id: 9, name: "Jump Squats")),
                WorkoutExercise(id: 10, exercise: Exercise(id: 10, name: "Burpees"))
            ])
        ]
    }

}

