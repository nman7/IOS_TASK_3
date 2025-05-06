import SwiftUI

struct RouletteWheelView: View {
    let categories: [String]
    let onResult: (String) -> Void

    @State private var rotation: Double = 0
    @State private var isSpinning = false
    let wheelSize: CGFloat = 250

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

            // The rotating wheel
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: wheelSize + 40, height: wheelSize + 40)
                    .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 3)

                Circle()
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.cyan, Color.mint, Color.blue.opacity(0.7)]),
                            center: .center
                        ),
                        lineWidth: 36
                    )
                    .frame(width: wheelSize, height: wheelSize)

                // Category labels around the circle
                ForEach(categories.indices, id: \.self) { index in
                    let rawAngle = Double(index) / Double(categories.count) * 360
                    let angle = Angle(degrees: rawAngle - 90)

                    Text(categories[index])
                        .font(.caption2)
                        .foregroundColor(.primary)
                        .rotationEffect(angle)
                        .offset(
                            x: wheelSize / 2 * CGFloat(cos(angle.radians)),
                            y: wheelSize / 2 * CGFloat(sin(angle.radians))
                        )
                }

                // Optional center decoration
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .shadow(radius: 2)
            }
            .rotationEffect(.degrees(rotation))
            .animation(.easeOut(duration: 3), value: rotation)
            .onTapGesture {
                spinNeedle()
            }
        }
        .frame(width: wheelSize + 80, height: wheelSize + 100)
    }

    private func spinNeedle() {
        guard !isSpinning else { return }
        isSpinning = true

        let angleMap = createAngleMap(for: categories)

        let fullSpins = Double.random(in: 3...6) * 360
        let extraAngle = Double.random(in: 0..<360)
        let totalRotation = fullSpins + extraAngle

        withAnimation {
            rotation += totalRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            // Normalize the final rotation to [0, 360)
            let finalNeedleAngle = rotation.truncatingRemainder(dividingBy: 360)
            // Adjust to find the angle at the top (0 degrees, where the pin is)
            let angleAtPin = (360 - finalNeedleAngle).truncatingRemainder(dividingBy: 360)

            let result = closestCategory(to: angleAtPin, using: angleMap)
            onResult(result)
            isSpinning = false
        }
    }

    private func createAngleMap(for categories: [String]) -> [Double: String] {
        let anglePerCategory = 360.0 / Double(categories.count)
        var angleMap: [Double: String] = [:]

        for (index, category) in categories.enumerated() {
            // Map angles so category at angle 0° is at the top (aligned with pin)
            let angle = (Double(index) * anglePerCategory).truncatingRemainder(dividingBy: 360)
            angleMap[angle] = category
        }

        return angleMap
    }

    private func closestCategory(to angle: Double, using angleMap: [Double: String]) -> String {
        // Find the closest angle, considering the category spans
        let anglePerCategory = 360.0 / Double(categories.count)
        let adjustedAngle = (angle + anglePerCategory / 2).truncatingRemainder(dividingBy: 360)
        let closest = angleMap.keys.min(by: { abs($0 - adjustedAngle) < abs($1 - adjustedAngle) }) ?? 0
        return angleMap[closest] ?? "Unknown"
    }
}
