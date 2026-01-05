
import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    let userID: String = UserSession.currentUserID
    
    @State private var user: User?
    @State private var isLoading = false
    @State private var showProfileInfo = false
    
    @StateObject private var viewModel = ProfileViewModel()
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if isLoading {
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                } else if let user = user {
                    ScrollView {
                        VStack(spacing: 0) {
                            // --- Profile Card ---
                            Button(action: {
                                showProfileInfo = true
                            }) {
                                HStack(spacing: 16) {
                                    AsyncImage(url: URL(string: user.profile_image)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Circle().fill(Color.gray.opacity(0.3))
                                    }
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.name)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)

                                        Text(user.email)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(.white.opacity(0.6))
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white.opacity(0.35))
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.06))
                                )
                                .padding(.horizontal, 18)
                            }
                            .padding(.top, 24)

                            // --- Saved Movies Section ---
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Saved Movies")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top, 30)
                                    .padding(.horizontal, 18)
                                
                                if viewModel.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                } else if viewModel.savedMovies.isEmpty {
                                    Text("No saved movies yet.")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 18)
                                } else {
                                    // The Grid
                                    LazyVGrid(columns: columns, spacing: 15) {
                                        ForEach(viewModel.savedMovies) { movie in
                                            NavigationLink(destination: MovieDetails(movieID: movie.id)) {
                                                
                                                AsyncImage(url: URL(string: movie.fields.poster)) { image in
                                                    image.resizable().scaledToFill()
                                                } placeholder: {
                                                    Color.gray.opacity(0.3)
                                                }
                                                .frame(height: 160)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 18)
                                }
                            }
                            
                            Spacer()
                        }
                    }

                } else {
                    // Error/Empty State
                    VStack(spacing: 12) {
                        Text("No user loaded")
                            .foregroundColor(.white.opacity(0.7))

                        Button("Retry") {
                            Task {
                                await loadUser()
                                await viewModel.loadSavedMovies()
                            }
                        }
                        .foregroundStyle(.yellow)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.yellow)
                    }
                }
            }
            .task {
                await loadUser()
                await viewModel.loadSavedMovies()
            }
            .sheet(isPresented: $showProfileInfo) {
                if user != nil {
                    ProfileInfoScreen(userID: userID, user: Binding($user)!)
                }
            }
        }
    }

    func loadUser() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users/\(userID)"
            guard let url = URL(string: urlString) else { return }

            let data = try await APIClient.fetch(url)
            let userRecord = try JSONDecoder().decode(UserRecord.self, from: data)
            self.user = userRecord.fields

            print("✅ User loaded: \(userRecord.fields.name)")
        } catch {
            print("❌ Error loading user: \(error)")
        }
    }
}

// Profile Info Screen
struct ProfileInfoScreen: View {
    let userID: String
    
    @Binding var user: User

    @Environment(\.dismiss) private var dismiss
    @State private var showEditProfile = false


    var body: some View {
        let parts = splitName(user.name)

        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.15))

                    VStack(spacing: 18) {
                        // Profile Image
                        AsyncImage(url: URL(string: user.profile_image)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.top, 18)

                        // Info Card
                        VStack(spacing: 0) {
                            ProfileInfoRow(title: "First name", value: parts.first)

                            Divider()
                                .background(Color.white.opacity(0.08))

                            ProfileInfoRow(title: "Last name", value: parts.last)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.06))
                        )
                        .padding(.horizontal, 18)
                        .padding(.top, 6)

                        Spacer()

                        // Sign Out Button
                        ProfileDangerButton(title: "Sign Out") {
                            print("Sign out tapped")
                        }
                        .padding(.bottom, 18)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundStyle(.yellow)
                        .font(.system(size: 16, weight: .regular))
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("Profile info")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        showEditProfile = true
                    }
                    .foregroundStyle(.yellow)
                    .font(.system(size: 16, weight: .semibold))
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileScreen(userID: userID, user: $user)
            }
        }
    }
}

// Rows / Components

struct ProfileInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14, weight: .regular))

            Spacer()

            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 160, alignment: .leading)
        }
        .padding(16)
        .contentShape(Rectangle())
    }
}

struct ProfileTextFieldRow: View {
    let title: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14, weight: .regular))

            Spacer()

            TextField("", text: $text)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .multilineTextAlignment(.leading)
                .frame(width: 160, alignment: .leading)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
        }
        .padding(16)
        .contentShape(Rectangle())
    }
}

struct ProfileDangerButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
        )
        .padding(.horizontal, 18)
    }
}

// Edit Profile Screen
struct EditProfileScreen: View {
    let userID: String
    @Binding var user: User

    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName  = ""
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.15))

                    VStack(spacing: 18) {
                        // Profile Image with Camera
                        Button(action: {
                        }) {
                            ZStack {
                                AsyncImage(url: URL(string: user.profile_image)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())

                                Circle()
                                    .fill(Color.black.opacity(0.35))
                                    .frame(width: 80, height: 80)

                                Image(systemName: "camera.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.yellow)
                            }
                        }
                        .padding(.top, 18)

                        VStack(spacing: 0) {
                            ProfileTextFieldRow(title: "First name", text: $firstName)
                            Divider().background(Color.white.opacity(0.08))
                            ProfileTextFieldRow(title: "Last name", text: $lastName)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.06))
                        )
                        .padding(.horizontal, 18)

                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(.yellow)
                        .font(.system(size: 16, weight: .regular))
                }

                ToolbarItem(placement: .principal) {
                    Text("Edit profile")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(isSaving ? "Saving..." : "Save") {
                        Task { await saveProfile() }
                    }
                    .foregroundStyle(.yellow)
                    .font(.system(size: 16, weight: .semibold))
                    .disabled(
                        isSaving ||
                        firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
            .onAppear {
                let parts = splitName(user.name)
                firstName = parts.first
                lastName  = parts.last
            }
        }
    }

    func saveProfile() async {
        isSaving = true
        defer { isSaving = false }

        do {
            let f = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
            let l = lastName.trimmingCharacters(in: .whitespacesAndNewlines)

            let fullName = "\(f) \(l)".trimmingCharacters(in: .whitespacesAndNewlines)

            let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users/\(userID)"
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // PUT full fields
            let body: [String: Any] = [
                "fields": [
                    "name": fullName,
                    "email": user.email,
                    "password": user.password,
                    "profile_image": user.profile_image
                ]
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: body)

            let (data, _) = try await URLSession.shared.data(for: request)
            let userRecord = try JSONDecoder().decode(UserRecord.self, from: data)

            user = userRecord.fields

            print("✅ User updated successfully")
            dismiss()

        } catch {
            print("❌ Error updating user: \(error)")
        }
    }
}


private func splitName(_ full: String) -> (first: String, last: String) {
    let trimmed = full.trimmingCharacters(in: .whitespacesAndNewlines)
    let comps = trimmed.split(separator: " ")
    let first = comps.first.map(String.init) ?? ""
    let last  = comps.dropFirst().joined(separator: " ")
    return (first, last)
}

#Preview {
    ProfileView()
}
