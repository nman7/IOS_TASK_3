import SwiftUI

struct RouletteWheelView: View {
    let categories: [String]
    let onResult: (String) -> Void

    @State private var rotation: Double = 0
    @State private var isSpinning = false
    let wheelSize: CGFloat = 250

    var body: some View {
        ZStack {
            // Draw the outer circle with a colorful border
            Circle()
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink]),
                        center: .center
                    ),
                    lineWidth: 40
                )
                .frame(width: wheelSize, height: wheelSize)

            // Place each category label around the wheel
            ForEach(categories.indices, id: \.self) { index in
                let rawAngle = Double(index) / Double(categories.count) * 360
                let angle = Angle(degrees: rawAngle - 90) // Adjust to start from the top

                Text(categories[index])
                    .font(.system(size: 11))
                    .foregroundColor(.black)
                    .rotationEffect(angle)
                    .offset(
                        x: wheelSize / 2 * CGFloat(cos(angle.radians)),
                        y: wheelSize / 2 * CGFloat(sin(angle.radians))
                    )
            }

            // The pointer that indicates the selected category
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
                .offset(y: -wheelSize / 2 - 12)
                .rotationEffect(.degrees(rotation))
                .animation(.easeOut(duration: 3), value: rotation)
                .onTapGesture {
                    spinNeedle()
                }
        }
        .frame(width: wheelSize + 80, height: wheelSize + 80)
    }

    private func spinNeedle() {
        guard !isSpinning else { return }
        isSpinning = true

        let angleMap = createAngleMap(for: categories)

        // Spin the needle randomly for a few full rotations
        let fullSpins = Double.random(in: 3...6) * 360
        let extraAngle = Double.random(in: 0..<360)
        let totalRotation = fullSpins + extraAngle

        withAnimation {
            rotation += totalRotation
        }

        // Wait for the spin animation to finish before determining the result
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            let finalNeedleAngle = rotation.truncatingRemainder(dividingBy: 360)
            let adjustedAngle = (360 - finalNeedleAngle).truncatingRemainder(dividingBy: 360)

            let result = closestCategory(to: finalNeedleAngle, using: angleMap)
            onResult(result)
            isSpinning = false
        }
    }

    // Create a dictionary mapping each category to its corresponding angle
    private func createAngleMap(for categories: [String]) -> [Double: String] {
        let anglePerCategory = 360.0 / Double(categories.count)
        var angleMap: [Double: String] = [:]

        for (index, category) in categories.enumerated() {
            let angle = Double(index) * anglePerCategory
            angleMap[angle] = category
        }

        return angleMap
    }

    // Find the category whose angle is closest to the needle's final angle
    private func closestCategory(to angle: Double, using angleMap: [Double: String]) -> String {
        let closest = angleMap.keys.min(by: { abs($0 - angle) < abs($1 - angle) }) ?? 0
        return angleMap[closest] ?? "Unknown"
    }
}
