import SwiftUI

/// App intro — meeting icon and what the app does
struct AppIntroView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.accent)

            VStack(spacing: 8) {
                Text("Record meetings. Capture notes.")
                    .font(AppTheme.title())
                    .multilineTextAlignment(.center)

                Text("Use your Meta AI Glasses to record meetings with transcript, optional video, and contextual notes that recall when you're back in the same place.")
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
