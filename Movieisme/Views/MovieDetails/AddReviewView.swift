

import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss

    let movieID: String
    let userID: String
    var onAdded: (() -> Void)? = nil

    @State private var reviewText: String = ""
    @State private var rating: Int = 0
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 22) {

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Review")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.85))

                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.secondarySystemBackground).opacity(0.99))

                            TextEditor(text: $reviewText)
                                .scrollContentBackground(.hidden)
                                .padding(10)
                                .foregroundStyle(.white)
                                .background(Color.clear)

                            if reviewText.isEmpty {
                                Text("Enter your review")
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 18)
                                    .allowsHitTesting(false)
                            }
                        }
                        .frame(height: 140)
                    }
                    .padding(.vertical, 45)
                    .padding(.horizontal, 10)

                    HStack {
                        Text("Rating")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white.opacity(0.85))

                        Spacer()
                        RatingStars(rating: $rating)
                    }
                    .padding(.horizontal, 16)

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .padding(.horizontal, 16)
                    }

                    Spacer()
                }
                .padding(.top, 10)
            }
            .navigationTitle("Write a review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .overlay(alignment: .top) {
                Divider()
                    .background(Color.white.opacity(0.40))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isSubmitting ? "Adding..." : "Add") {
                        Task { await submit() }
                    }
                    .disabled(isSubmitting || reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || rating == 0)
                    .foregroundColor(.yellow)
                }
            }
        }
    }

    private func submit() async {
        errorMessage = nil
        isSubmitting = true
        
        do {
            let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/reviews")!
            
            let body: [String: Any] = [
                "fields": [
                    "movie_id": movieID,
                    "user_id": userID,   
                    "review_text": reviewText.trimmingCharacters(in: .whitespacesAndNewlines),
                    "rate": rating
                ]
            ]
            
            try await APIClient.post(url, body: body)
            
            onAdded?()
            dismiss()
            
        } catch {
            errorMessage = "Failed to add review. Please try again."
            print("Error adding review: \(error)")
        }
        
        isSubmitting = false
    }
}

// Rating Stars Component
struct RatingStars: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { index in
                Button(action: {
                    rating = index
                }) {
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .font(.title2)
                        .foregroundColor(index <= rating ? .yellow : .gray)
                }
            }
        }
    }
}
