//
//  ProfileUIComponents.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 08/07/1447 AH.
//

import SwiftUI

struct ProfileScreen<Content: View, Trailing: View>: View {
    let title: String
    @ViewBuilder var trailing: Trailing
    @ViewBuilder var content: Content

    init(
        title: String,
        @ViewBuilder trailing: () -> Trailing,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.trailing = trailing()
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Divider().profileDivider()

                VStack(spacing: 18) {
                    content
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title).profileNavTitle()
            }
            ToolbarItem(placement: .topBarTrailing) {
                trailing
            }
        }
    }
}

struct ProfileScreenNoTrailing<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Divider().profileDivider()

                VStack(spacing: 18) {
                    content
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title).profileNavTitle()
            }
        }
    }
}

struct ProfileInfoCard<Content: View>: View {
    @ViewBuilder var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, 18)
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        ZStack {
            
            HStack {
                Text(title)
                    .profileRowTitle()
                Spacer()
            }

    
            Text(value)
                .profileRowValue()
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}


struct ProfileTextFieldRow: View {
    let title: String
    @Binding var text: String

    var body: some View {
        ZStack {
            // العنوان يسار
            HStack {
                Text(title).profileRowTitle()
                Spacer()
            }

            // التكست فيلد بالوسط
            TextField("", text: $text)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.system(size: 15, weight: .semibold))
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .keyboardType(.default)
                .frame(maxWidth: 200) // تقدرين تكبرينها إذا تبين
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// Avatar
struct ProfileAvatarView: View {
    let imageName: String
    var size: CGFloat = 80
    var showCameraOverlay: Bool = false

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .opacity(0.9)

            if showCameraOverlay {
                Circle()
                    .fill(Color.black.opacity(0.35))
                    .frame(width: size, height: size)

                Image(systemName: "camera.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.yellow)
                    .padding(10)
                    .background(Circle().fill(Color.black.opacity(0.35)))
            }
        }
        .padding(.top, 18)
    }
}

// Sign Out
struct ProfileDangerButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal, 18)
        }
        .padding(.bottom, 16)
    }
}

extension View {
    func profileDivider() -> some View {
        self
            .overlay(Color.black.opacity(0.15))
    }
}

extension Text {
    func profileNavTitle() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: 16, weight: .semibold))
    }

    func profileRowTitle() -> some View {
        self
            .foregroundStyle(.white.opacity(0.75))
            .font(.system(size: 15, weight: .regular))
    }

    func profileRowValue() -> some View {
        self
            .foregroundStyle(.white)
            .font(.system(size: 15, weight: .semibold))
    }
}
