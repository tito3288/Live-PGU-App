//
//  WelcomeView.swift
//  PGU
//
//  Created by Bryan Arambula on 3/2/26.
//

import SwiftUI

struct WelcomeView: View {

    private let navy = Color(hex: "0f2d53")
    private let gold = Color(hex: "c7972b")

    var body: some View {
        ZStack {
            // Background
            navy.ignoresSafeArea()

            // Faint basketball court overlay
            CourtOverlay()
                .stroke(Color.white.opacity(0.03), lineWidth: 1)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    Spacer().frame(height: 30)

                    // Basketball icon with concentric rings
                    ZStack {
                        Circle()
                            .stroke(gold.opacity(0.3), lineWidth: 2)
                            .frame(width: 110, height: 110)

                        Circle()
                            .fill(gold)
                            .frame(width: 80, height: 80)

                        Text("🏀")
                            .font(.system(size: 36))
                    }
                    .padding(.bottom, 5)

                    // Logo text
                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Text("PG")
                                .font(.system(size: 42, weight: .black))
                                .foregroundColor(.white)

                            Rectangle()
                                .fill(gold)
                                .frame(width: 3, height: 36)

                            Text("U")
                                .font(.system(size: 42, weight: .black))
                                .foregroundColor(.white)
                        }

                        Text("POINT GUARD UNIVERSITY")
                            .font(.system(size: 13, weight: .semibold))
                            .tracking(2)
                            .foregroundColor(gold.opacity(0.8))
                    }
                    .padding(.bottom, 10)

                    // Stats card
                    VStack(spacing: 12) {
                        HStack(spacing: 6) {
//                            Text("⚡")
//                                .font(.system(size: 14))
                            Text("2026 SUMMER TOUR")
                                .font(.system(size: 13, weight: .bold))
                                .tracking(1)
                                .foregroundColor(gold)
                        }

                        HStack(spacing: 0) {
                            statItem(value: "4", label: "States")

                            Rectangle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 1, height: 30)

                            statItem(value: "4", label: "Stops")

                            Rectangle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 1, height: 30)

                            statItem(value: "∞", label: "Memories")
                        }
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.08))
                    )
                    .padding(.horizontal, 40)

                    Spacer().frame(height: 20)

                    // Decorative pill divider
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 40, height: 4)

                    Spacer().frame(height: 10)

                    // Create Account button
                    NavigationLink(destination: SignUpView()) {
                        HStack(spacing: 8) {
                            Text("🏀")
                                .font(.system(size: 16))
                            Text("Create Account")
                                .font(.system(size: 17, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(gold)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    .padding(.horizontal, 40)

                    // I Already Have an Account button
                    NavigationLink(destination: LoginView()) {
                        Text("I Already Have an Account")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal, 40)

                    Spacer().frame(height: 30)
                }
            }
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }
}

// Faint basketball court outline shape
struct CourtOverlay: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let midX = rect.midX
        let midY = rect.midY

        // Outer court boundary
        path.addRect(CGRect(x: rect.width * 0.1, y: rect.height * 0.15,
                            width: rect.width * 0.8, height: rect.height * 0.7))

        // Half-court line
        path.move(to: CGPoint(x: rect.width * 0.1, y: midY))
        path.addLine(to: CGPoint(x: rect.width * 0.9, y: midY))

        // Center circle
        path.addEllipse(in: CGRect(x: midX - 40, y: midY - 40, width: 80, height: 80))

        // Top key
        path.addRect(CGRect(x: midX - 30, y: rect.height * 0.15, width: 60, height: 70))

        // Bottom key
        path.addRect(CGRect(x: midX - 30, y: rect.height * 0.85 - 70, width: 60, height: 70))

        return path
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
