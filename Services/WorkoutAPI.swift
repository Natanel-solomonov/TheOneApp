import Foundation

class WorkoutAPI {
    static func fetchWorkouts(completion: @escaping (Result<[Workout], Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/workouts/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let workouts = try JSONDecoder().decode([Workout].self, from: data)
                    completion(.success(workouts))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

