
# 🎬 Movieisme

**Movieisme** is a SwiftUI-based iOS application that allows users to explore movies, view cast and director details, write reviews, and save favorite movies. The app follows a modular MVVM architecture and integrates with a RESTful API for dynamic content.

---

## 📱 Features

* Browse movies with detailed information
* View actors and directors per movie
* Write and delete movie reviews
* Save favorite movies per user
* User profile management
* Clean SwiftUI + MVVM architecture

---

## 📁 Project Structure

```text
Movieisme/
├── Models/
│   ├── Cast.swift
│   ├── Movie.swift
│   ├── ProfileUser.swift
│   ├── Review.swift
│   ├── SavedMovieModels.swift
│   └── User.swift
├── Networking/
│   └── APIClient.swift
├── Utilities/
│   └── AppConfig.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── MovieDetailsViewModel.swift
│   ├── MoviesCenterViewModel.swift
│   └── ProfileViewModel.swift
├── Views/
│   ├── MovieDetails/
│   │   ├── AddReviewView.swift
│   │   ├── MovieDetailsComponents.swift
│   │   └── MovieDetailsView.swift
│   ├── MoviesCenter/
│   │   ├── MoviesCenterComponents.swift
│   │   └── MoviesCenterView.swift
│   ├── Profile/
│   │   └── ProfileView.swift
│   └── Signin/
│       ├── Signin.swift
│       └── SigninComponents.swift
├── Assets/
├── Info/
├── MovieismeApp.swift
├── Secrets/
└── UserSession.swift
```

---

## 🌐 API Endpoints

| Method | Endpoint                     | Description                    |
| -----: | ---------------------------- | ------------------------------ |
|    GET | `/movies`                    | Retrieve all movies            |
|    GET | `/actors`                    | Retrieve all actors            |
|    GET | `/movie_actors/:movie_id`    | Retrieve actors for a movie    |
|    GET | `/directors`                 | Retrieve all directors         |
|    GET | `/movie_directors/:movie_id` | Retrieve directors for a movie |
|    GET | `/reviews/:movie_id`         | Retrieve reviews for a movie   |
|   POST | `/review`                    | Create a new review            |
| DELETE | `/review/:id`                | Delete a review                |
|    GET | `/user`                      | Retrieve all users             |
|    PUT | `/user/:id`                  | Update user profile            |
|    GET | `/saved_movies`              | Retrieve saved movies          |
|   POST | `/saved_movies`              | Save a movie for a user        |

---

## 🔧 Sample Networking Code

```swift
import Foundation

struct APIClient {

    // MARK: - GET Requests
    static func fetch(_ url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }

    // MARK: - POST Requests (Saved Movies & Reviews)
    static func post(_ url: URL, body: [String: Any]) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("POST Status Code: \(httpResponse.statusCode)")
        }

        print(String(data: data, encoding: .utf8) ?? "")
    }
}
```

---

## 🚀 Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/SuhailaH20/Movieisme_Team5_M.git
   ```
2. Open `Movieisme.xcodeproj` in Xcode
3. Add your API keys to the `Secrets/` directory
4. Select a simulator or physical device
5. Run the app (`⌘ + R`)

---

## 🧠 Architecture

* **MVVM** for clear separation of concerns
* **SwiftUI** for modern, declarative UI
* **Feature-based view organization**
* **Centralized API client**
* **Reusable view components**


