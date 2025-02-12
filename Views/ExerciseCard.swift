import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise
    let sets: Int
    let reps: Int
    let equipment: String?
    
    var body: some View {
        HStack(spacing: 15) {
            // Exercise Image with Attached Fitness Diagram
            ZStack(alignment: .bottomTrailing) {
                Image("\(exercise.id)_exercise") // Try loading an image from assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 1) // White border
                    )
                
                // Fitness Diagram - Positioned at Bottom Right
                Image("\(exercise.id)_diagram") // Load a fitness diagram
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .background(Color.black.opacity(0.7)) // Slight background for contrast
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .offset(x: 5, y: 5) // Slightly offset to bottom right
            }
            
            // Exercise Details (on the right)
            VStack(alignment: .leading, spacing: 5) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Sets: \(sets)  Reps: \(reps)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                if let equipment = equipment, !equipment.isEmpty {
                    Text("Equipment: \(equipment)")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

