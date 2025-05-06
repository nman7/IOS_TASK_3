import SwiftUI

struct CategorySpinnerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Find Something to Eat or Drink")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 8)

                Spacer(minLength: 40)
            }
            .padding()
        }
    }
}
