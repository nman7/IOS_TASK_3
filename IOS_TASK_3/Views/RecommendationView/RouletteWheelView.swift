import SwiftUI

struct RouletteWheelView: View {
    let categories: [String]
    let onResult: (String) -> Void

    @State private var rotation: Double = 0
    @State private var isSpinning = false
    let wheelSize: CGFloat = 350

    var body: some View {
        ZStack {
            // Fixed top needle
            VStack {
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .padding(.bottom, 6)
                Spacer()
            }

            // Rotating Wheel with Spin Button
            GeometryReader { geometry in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                ZStack {
                    // Main wheel circle with light blue background
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: wheelSize, height: wheelSize)
                        .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)

                    // Category segments with borders
                    ForEach(categories.indices, id: \.self) { index in
                        let segmentAngle = 360.0 / Double(categories.count)
                        let startAngle = Double(index) * segmentAngle
                        let endAngle = startAngle + segmentAngle
                        let midAngle = startAngle + segmentAngle / 2
                        let angle = Angle(degrees: midAngle - 90)

                        // Draw segment lines
                        Path { path in
                            path.move(to: center)
                            path.addArc(
                                center: center,
                                radius: wheelSize / 2,
                                startAngle: Angle(degrees: startAngle),
                                endAngle: Angle(degrees: endAngle),
                                clockwise: false
                            )
                            path.closeSubpath()
                        }
                        .stroke(Color.gray, lineWidth: 1)

                        // Category labels inside the slice
                        Text(categories[index])
                            .font(.caption2)
                            .foregroundColor(.primary)
                            .rotationEffect(angle)
                            .position(
                                x: center.x + (wheelSize / 3) * CGFloat(cos(angle.radians)),
                                y: center.y + (wheelSize / 3) * CGFloat(sin(angle.radians))
                            )
                    }

                    // Center SPIN Button, properly aligned
                    Button(action: {
                        spinNeedle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: wheelSize / 3, height: wheelSize / 3) // Consistent size
                            Text("Spin")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .position(center) // Ensuring the button is exactly at the center
                    .disabled(isSpinning)
                }
                .position(center) // Center the whole wheel
                .rotationEffect(.degrees(rotation))
                .animation(.easeOut(duration: 3), value: rotation)
            }
            .frame(width: wheelSize + 80, height: wheelSize + 100)
        }
    }

    private func spinNeedle() {
        guard !isSpinning else { return }
        isSpinning = true

        let fullSpins = Double.random(in: 3...6) * 360
        let extraAngle = Double.random(in: 0..<360)
        let totalRotation = fullSpins + extraAngle

        withAnimation {
            rotation += totalRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            let finalNeedleAngle = rotation.truncatingRemainder(dividingBy: 360)
            let angleAtPin = (360 - finalNeedleAngle).truncatingRemainder(dividingBy: 360)

            let result = closestCategory(to: angleAtPin, using: createAngleMap(for: categories))
            onResult(result)
            isSpinning = false
        }
    }

    private func createAngleMap(for categories: [String]) -> [(startAngle: Double, endAngle: Double, category: String)] {
        let anglePerCategory = 360.0 / Double(categories.count)
        return categories.enumerated().map { index, category in
            let startAngle = Double(index) * anglePerCategory
            let endAngle = startAngle + anglePerCategory
            return (startAngle, endAngle, category)
        }
    }

    private func closestCategory(to angle: Double, using angleMap: [(startAngle: Double, endAngle: Double, category: String)]) -> String {
        let normalizedAngle = (angle + 360).truncatingRemainder(dividingBy: 360)
        for (startAngle, endAngle, category) in angleMap {
            if startAngle <= normalizedAngle && normalizedAngle < endAngle {
                return category
            }
        }
        return "Unknown"
    }
}
