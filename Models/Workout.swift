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
}

struct Exercise: Identifiable, Codable {
    let id: Int
    let name: String
}

//Matches structure of django workout serializer from the backend. 
