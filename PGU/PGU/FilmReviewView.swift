//
//  FilmReviewView.swift
//  PGU
//
//  Created by Bryan Arambula on 1/20/24.
//

import SwiftUI
import AVKit
import Combine

// MARK: - Clip Data Model
struct ClipItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let duration: String
    let videoFileName: String
    let thumbnailName: String
}

struct FilmReviewView: View {

    @State private var isMenuOpen: Bool = false
    @State private var selectedVideo: String? = nil
    @State private var player: AVPlayer = AVPlayer()
    @State private var isVideoPlaying: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    private var scenePhaseCancellable: AnyCancellable?
    @State private var rateObserver: AnyCancellable?

    // Clip data
    private let clips: [ClipItem] = [
        ClipItem(title: "Behind-the-Back Crossover", subtitle: "Breakdown · 3 days ago", duration: "2:34", videoFileName: "pgu-video1", thumbnailName: "coach-rob"),
        ClipItem(title: "No-Look Pass Drill", subtitle: "Breakdown · 1 week ago", duration: "1:58", videoFileName: "pgu-video2", thumbnailName: "coach-rob"),
        ClipItem(title: "Coach Rob Teaches Shooting Mechanics", subtitle: "Breakdown · 2 weeks ago", duration: "3:12", videoFileName: "pgu-video3", thumbnailName: "coach-rob"),
        ClipItem(title: "Coach Rob Teaches The Spin Move", subtitle: "Breakdown · 3 weeks ago", duration: "2:45", videoFileName: "pgu-video4", thumbnailName: "coach-rob"),
        ClipItem(title: "Coach Rob Teaches The Art Of The Floater", subtitle: "Breakdown · 1 month ago", duration: "4:01", videoFileName: "pgu-video5", thumbnailName: "coach-rob"),
    ]

    var body: some View {
        ZStack {
            // Background
            Color(red: 0.96, green: 0.96, blue: 0.96)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Header - matches HomeView/CoachDrills
                HStack {
                    Button(action: {
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.black)
                    }

                    Spacer()

                    // PG|U Logo
                    HStack(spacing: 4) {
                        Text("PG")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Rectangle()
                            .fill(Color(hex: "c7972b"))
                            .frame(width: 3, height: 24)

                        Text("U")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }

                    Spacer()

                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(.black)

                        Circle()
                            .fill(Color(hex: "c7972b"))
                            .frame(width: 8, height: 8)
                            .offset(x: 4, y: -4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                .navigationBarBackButtonHidden(true)

                // Category Pill
                HStack(spacing: 12) {
                    Text("Rob's Clips")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(hex: "c7972b"))
                        .cornerRadius(20)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)

                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Rob's Clips Hero Banner
                        HStack(spacing: 16) {
                            // Gold basketball icon
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "c7972b"))
                                    .frame(width: 48, height: 48)

                                Image(systemName: "basketball.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Rob's Clips")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Personal breakdowns & tips from Coach Rob")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()
                        }
                        .padding(20)
                        .background(Color(red: 0.11, green: 0.22, blue: 0.37))
                        .cornerRadius(16)
                        .padding(.top, 8)

                        // LATEST CLIPS Section Header
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("LATEST CLIPS")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)

                                Spacer()

                                Button(action: {
                                    // Show all clips
                                }) {
                                    HStack(spacing: 4) {
                                        Text("See All")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(hex: "c7972b"))
                                        Image(systemName: "arrow.right")
                                            .font(.caption)
                                            .foregroundColor(Color(hex: "c7972b"))
                                    }
                                }
                            }

                            // Clip Cards
                            ForEach(clips) { clip in
                                ClipCard(
                                    clip: clip,
                                    isPlaying: selectedVideo == clip.videoFileName && isVideoPlaying,
                                    onPlayTap: {
                                        togglePlayPause(for: clip.videoFileName)
                                    }
                                )
                            }
                        }

                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 80)
                    }
                    .padding(.horizontal, 20)
                }

                // Bottom Navigation Tab Bar
                HStack {
                    Spacer()

                    NavigationLink(destination: HomeView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "house")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                            Text("Home")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    NavigationLink(destination: InboxView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "tray")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                            Text("Inbox")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    NavigationLink(destination: CampsView()) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                            Text("Camps")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Image(systemName: "basketball.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "c7972b"))
                        Text("Resources")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "c7972b"))
                    }

                    Spacer()
                }
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
            }

            // Video Player Overlay
            if let videoName = selectedVideo, isVideoPlaying {
                ZStack {
                    Color.black.opacity(0.9)
                        .ignoresSafeArea()

                    VStack {
                        HStack {
                            Button(action: {
                                pauseVideo()
                                selectedVideo = nil
                            }) {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Spacer()
                        }

                        if Bundle.main.url(forResource: videoName, withExtension: "mp4") != nil {
                            VideoPlayer(player: player)
                                .frame(height: 300)
                        }

                        Spacer()
                    }
                }
                .zIndex(3)
            }

            // Sliding menu overlay
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen, activePage: .resources)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(4)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                break
            case .inactive, .background:
                pauseVideo()
            @unknown default:
                break
            }
        }
        .onAppear {
            rateObserver = player.publisher(for: \.rate)
                .receive(on: RunLoop.main)
                .sink(receiveValue: { rate in
                    DispatchQueue.main.async {
                        self.isVideoPlaying = rate > 0
                    }
                })
        }
        .onDisappear {
            rateObserver?.cancel()
            pauseVideo()
        }
    }

    // MARK: - Helper Functions

    func togglePlayPause(for videoName: String) {
        if selectedVideo != videoName || !isVideoPlaying {
            NotificationCenter.default.post(name: .pausePodcastPlayback, object: nil)
        }

        if let currentVideo = selectedVideo, currentVideo == videoName {
            if isVideoPlaying {
                player.pause()
            } else {
                player.play()
            }
            isVideoPlaying.toggle()
        } else {
            playVideo(named: videoName)
        }
    }

    func playVideo(named videoName: String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category or activate it: \(error)")
        }

        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            player.pause()
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()

            selectedVideo = videoName
            isVideoPlaying = true
        }
    }

    private func pauseVideo() {
        if isVideoPlaying {
            player.pause()
            isVideoPlaying = false

            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch {
                print("Failed to deactivate audio session: \(error)")
            }
        }
    }
}

// MARK: - Clip Card Component
struct ClipCard: View {
    let clip: ClipItem
    let isPlaying: Bool
    let onPlayTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Thumbnail with play button and duration badge
            ZStack {
                Image(clip.thumbnailName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12, corners: [.topLeft, .topRight])

                // Dark overlay
                Color.black.opacity(0.3)
                    .cornerRadius(12, corners: [.topLeft, .topRight])

                // Center play button
                Button(action: onPlayTap) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 56, height: 56)

                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                    }
                }

                // Duration badge (bottom-right)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(clip.duration)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(6)
                            .padding(8)
                    }
                }
            }
            .frame(height: 200)

            // Title, subtitle, and play button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(clip.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(2)

                    Text(clip.subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Gold play button
                Button(action: onPlayTap) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "c7972b"))
                            .frame(width: 40, height: 40)

                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    FilmReviewView()
}
