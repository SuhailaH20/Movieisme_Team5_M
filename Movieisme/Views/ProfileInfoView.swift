//
//  ProfileInfoView.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 07/07/1447 AH.
//
import SwiftUI

struct ProfileInfoView: View {
    @Binding var user: ProfileUser

    @State private var isEditing = false
    @State private var tempFirstName = ""
    @State private var tempLastName  = ""

    var body: some View {
        ZStack {

            VStack(spacing: 18) {

                ProfileAvatarView(imageName: user.imageName, size: 80)
                    .padding(.top, 18)

                
                VStack(spacing: 0) {

                    if isEditing {
                        
                        ProfileTextFieldRow(title: "First name", text: $tempFirstName)
                        Divider().background(Color.white.opacity(0.08))
                        ProfileTextFieldRow(title: "Last name", text: $tempLastName)
                    } else {
                        
                        ProfileInfoRow(title: "First name", value: user.firstName)
                        Divider().background(Color.white.opacity(0.08))
                        ProfileInfoRow(title: "Last name", value: user.lastName)
                    }

                }
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal, 18)

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            
            ToolbarItem(placement: .principal) {
                Text("Profile info")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
            }

            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isEditing {
                        
                        user.firstName = tempFirstName.trimmingCharacters(in: .whitespacesAndNewlines)
                        user.lastName  = tempLastName.trimmingCharacters(in: .whitespacesAndNewlines)
                    } else {
                        
                        tempFirstName = user.firstName
                        tempLastName  = user.lastName
                    }
                    isEditing.toggle()
                } label: {
                    Text(isEditing ? "Save" : "Edit")
                        .foregroundStyle(.yellow)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
}
