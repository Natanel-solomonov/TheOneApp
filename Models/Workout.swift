import Foundation

struct Workout: Identifiable, Codable {
    let id: Int
    let name: String
    let duration: Int
    let exercises: [WorkoutExercise]
}

struct WorkoutExercise: Identifiable, Codable {
    let id: Int
    let exercise: Exercise
    let sets: Int?
    let reps: Int?
    let equipment: String?
}


struct Exercise: Identifiable, Codable {
    let id: Int
    let name: String
}


