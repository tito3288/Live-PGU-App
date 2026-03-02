//
//  CoachDrills.swift
//  PGU
//
//  Created by Bryan Arambula on 2/12/24.
//

import SwiftUI
import AVKit
import Combine

// MARK: - Video Data Model
struct VideoItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let thumbnailName: String
    let videoFileName: String
    let isFeatured: Bool
    let year: String
}

// MARK: - Content Category
enum ContentCategory: String, CaseIterable {
    case podcast = "Podcast"
    case campVideo = "Camp Video"
    case robsClips = "Rob's Clips"
}

struct CoachDrills: View {
    
    @EnvironmentObject var navigationState: NavigationState
    @State private var selectedVideo: String? = nil
    @State private var player: AVPlayer = AVPlayer()
    @State private var isVideoPlaying: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    private var scenePhaseCancellable: AnyCancellable?
    @State private var rateObserver: AnyCancellable?
    @State private var selectedCategory: ContentCategory = .campVideo
    
    // Video library
    @State private var videos: [VideoItem] = [
        // 2025 Featured Video (placeholder - you'll add the actual video later)
        VideoItem(
            title: "2026 Summer Tour Recap",
            subtitle: "8 stops • 4 states • Unlimited memories",
            thumbnailName: "camp-2024", // Placeholder until you have 2025 content
            videoFileName: "camp-video-2025", // Will be added later
            isFeatured: true,
            year: "2025"
        ),
        
        // 2024 Videos
        VideoItem(
            title: "Dodge City Highlights",
            subtitle: "June 2025",
            thumbnailName: "camp-2024",
            videoFileName: "dodge-city-highlights",
            isFeatured: false,
            year: "2024"
        ),
        VideoItem(
            title: "Limon, CO Recap",
            subtitle: "June 2025",
            thumbnailName: "camp-2024",
            videoFileName: "limon-recap",
            isFeatured: false,
            year: "2024"
        ),
        VideoItem(
            title: "Top Plays 2024",
            subtitle: "Season Recap",
            thumbnailName: "camp-2024",
            videoFileName: "top-plays-2024",
            isFeatured: false,
            year: "2024"
        ),
        VideoItem(
            title: "Skill Sessions",
            subtitle: "Drills & Training",
            thumbnailName: "camp-2024",
            videoFileName: "skill-sessions",
            isFeatured: false,
            year: "2024"
        )
    ]    
    var featuredVideo: VideoItem? {
        videos.first(where: { $0.isFeatured })
    }
    
    var allVideos: [VideoItem] {
        videos.filter { !$0.isFeatured }
    }

    var body: some View {
        ZStack {
            // Background - same pattern as HomeView
            Color(red: 0.96, green: 0.96, blue: 0.96)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Header - matches HomeView exactly
                HStack {
                    Button(action: {
                        withAnimation {
                            navigationState.isMenuOpen.toggle()
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

                // Category Pills
                HStack(spacing: 12) {
                    ForEach(ContentCategory.allCases, id: \.self) { category in
                        CategoryPillButton(
                            title: category.rawValue,
                            isSelected: selectedCategory == category,
                            action: {
                                selectedCategory = category
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)

                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Featured Video Card
                        if let featured = featuredVideo {
                            FeaturedVideoCard(
                                video: featured,
                                isPlaying: selectedVideo == featured.videoFileName && isVideoPlaying,
                                onPlayTap: {
                                    togglePlayPause(for: featured.videoFileName)
                                }
                            )
                            .padding(.top, 8)
                        }

                        // ALL VIDEOS Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("ALL VIDEOS")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)

                                Spacer()

                                Button(action: {
                                    // Show all videos
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

                            // Video Grid (2 columns)
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                ForEach(allVideos) { video in
                                    VideoGridCard(
                                        video: video,
                                        isPlaying: selectedVideo == video.videoFileName && isVideoPlaying,
                                        onPlayTap: {
                                            togglePlayPause(for: video.videoFileName)
                                        }
                                    )
                                }
                            }
                        }

                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 80)
                    }
                    .padding(.horizontal, 20)
                }

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
            if navigationState.isMenuOpen {
                MenuView(isMenuOpen: $navigationState.isMenuOpen, activePage: .resources)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(4)
            }
        }
        .toolbar(navigationState.isMenuOpen ? .hidden : .visible, for: .tabBar)
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
            self.rateObserver = self.player.publisher(for: \.rate)
                .receive(on: RunLoop.main)
                .sink { rate in
                    DispatchQueue.main.async {
                        self.isVideoPlaying = rate != 0
                    }
                }
        }
        .onDisappear {
            self.rateObserver?.cancel()
            pauseVideo()
        }
    }    
    // MARK: - Helper Functions
    
    func togglePlayPause(for videoName: String) {
        // Check if video file exists
        guard Bundle.main.url(forResource: videoName, withExtension: "mp4") != nil else {
            print("Video file not found: \(videoName)")
            return
        }
        
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

// MARK: - Category Pill Button
struct CategoryPillButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color(hex: "c7972b") : Color(red: 0.11, green: 0.22, blue: 0.37))
                .cornerRadius(20)
        }
    }
}

// MARK: - Featured Video Card
struct FeaturedVideoCard: View {
    let video: VideoItem
    let isPlaying: Bool
    let onPlayTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Thumbnail
            Image(video.thumbnailName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 240)
                .clipped()
                .cornerRadius(20)
            
            // Dark overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, Color.black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(20)
            
            // Play button (center)
            Button(action: onPlayTap) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.9))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Content overlay
            VStack(alignment: .leading, spacing: 8) {
                // Featured badge
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 8))
                    Text("FEATURED")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
                .foregroundColor(Color(hex: "c7972b"))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(red: 0.11, green: 0.22, blue: 0.37))
                .cornerRadius(12)
                
                Text(video.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text(video.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(20)
        }
        .frame(height: 240)
    }
}

// MARK: - Video Grid Card
struct VideoGridCard: View {
    let video: VideoItem
    let isPlaying: Bool
    let onPlayTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Thumbnail with play button
            ZStack {
                Image(video.thumbnailName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                
                // Darker overlay
                Color.black.opacity(0.3)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                
                // Play button
                Button(action: onPlayTap) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 120)
            
            // Video details
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(video.subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    CoachDrills()
}
