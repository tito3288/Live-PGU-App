//
//  ResourcesView.swift
//  PGU
//
//  Created by Bryan Arambula on 1/3/24.
//

import SwiftUI
import SWXMLHash // Import an XML parsing library
import AVFoundation
import UIKit
import MediaPlayer



struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct PodcastEpisode: Identifiable {
    let id: String
    let title: String
    var description: String
    let audioURL: URL // Add this for the audio file URL
    let imageURL: URL? // Add this to include an image URL
}


class ViewState: ObservableObject {
    @Published var isPlaybackControlsVisible: Bool = false
    static let shared = ViewState()
}

class AudioPlayerManager: ObservableObject {
    
    static let shared = AudioPlayerManager()
    
    @Published var isPlaying = false
    @Published var currentPlayingURL: URL?
    
    @Published var currentEpisode: PodcastEpisode?
    
    var player: AVPlayer?
    
    @Published var playbackProgress: Double = 0.0
    
    private var timeObserverToken: Any?
    
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    init() {
        setupPlaybackProgressTracking()
        configureAudioSession()
        configureRemoteCommandCenter()
        setupNotifications()

    }
    
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(pausePlayback), name: .pausePodcastPlayback, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(maybeResumePlayback), name: .resumePodcastPlayback, object: nil)
    }
    
    @objc func pausePlayback() {
        pause()
    }
    
    @objc func maybeResumePlayback() {
        // Implement logic to decide if playback should resume
        // For example, check if the podcast was playing before it was interrupted
    }

    //MARK: THIS HELPS FOR AUDIO TO PLAY WHEN APP IS CLOSED OR LOCKED
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
        
        
    }
    
    private func configureRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()

        // Play command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let self = self, let player = self.player else { return .commandFailed }
            if player.rate == 0 {
                player.play()
                self.isPlaying = true // Make sure to update your isPlaying state
                return .success
            }
            return .commandFailed
        }
        
        // Pause command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let self = self, let player = self.player else { return .commandFailed }
            if player.rate != 0 {
                player.pause()
                self.isPlaying = false // Make sure to update your isPlaying state
                return .success
            }
            return .commandFailed
        }
        
        // Skip forward command
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [30] // Define the skip interval
        commandCenter.skipForwardCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            self?.skipForward()
            return .success
        }
        
        // Skip backward command
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [15] // Define the skip interval
        commandCenter.skipBackwardCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            self?.skipBackward()
            return .success
        }
        
//        commandCenter.changePlaybackPositionCommand.isEnabled = true
//        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(handleChangePlaybackPositionCommand(event:)))
       
        
    }


//    @objc func handleChangePlaybackPositionCommand(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
//        guard let player = player else { return .noSuchContent }
//        let newPosition = event.positionTime
//        let seekTime = CMTime(seconds: newPosition, preferredTimescale: 1)
//        player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
//            self?.updateNowPlayingInfoPlaybackPosition() // Update the now playing info to reflect the new position
//        }
//        return .success
//    }

    
    
    func updateNowPlayingInfo(for episode: PodcastEpisode) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        
        // Prepare other now playing info properties
        if let playerItem = player?.currentItem {
            let duration = CMTimeGetSeconds(playerItem.asset.duration)
            if !duration.isNaN {
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(playerItem.currentTime())
                nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate ?? 0
            }
        }
        
        // Asynchronously load the artwork if available
        let imageURL = episode.imageURL ?? URL(string: "https://example.com/defaultImage.png")! // Fallback URL
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
            
            DispatchQueue.main.async {
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }.resume()
    }




    func pause() {
        player?.pause()
        isPlaying = false
        if let currentEpisode = currentEpisode {
            updateNowPlayingInfo(for: currentEpisode)
        }
    }


    
    func setupPlaybackProgressTracking() {
        // Remove any existing observer to avoid duplicates
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }

        guard let player = player else { return }

        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self, let currentItem = self.player?.currentItem else { return }
            let duration = currentItem.duration.seconds
            let currentTime = time.seconds
            self.currentTime = currentTime // Update current time
            self.duration = duration // Update duration

            let progress = currentTime / duration
            self.playbackProgress = progress.isNaN ? 0.0 : progress
        }
    }

    func prepareToPlay(episode: PodcastEpisode) {
        let playerItem = AVPlayerItem(url: episode.audioURL)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        if self.player == nil {
            self.player = AVPlayer(playerItem: playerItem)
        } else {
            self.player?.replaceCurrentItem(with: playerItem)
        }
        play()
        setupPlaybackProgressTracking() // Ensure tracking is updated for the new item
    }

    @objc func playerItemDidReachEnd(notification: Notification) {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.playbackProgress = 0.0 // Reset progress
            self.currentTime = 0 // Reset current time
        }
    }

    func seek(to progress: Double) {
        guard let duration = player?.currentItem?.duration.seconds, duration > 0 else { return }
        let totalSeconds = progress * duration
        let seekTime = CMTime(seconds: totalSeconds, preferredTimescale: 1)
        player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }



 
    
    func setCurrentEpisode(_ episode: PodcastEpisode) {
        // Stop any existing playback
        player?.pause()

        // Check if a new episode is selected or if it's the same as the current one
        if let currentEpisode = self.currentEpisode, currentEpisode.id == episode.id {
            // If the same episode is selected, toggle play/pause
            togglePlayPause()
        } else {
            // If a new episode is selected, prepare to play it
            self.currentEpisode = episode
            prepareToPlay(episode: episode)
        }
    }

    
    func togglePlayPause() {
        guard let player = self.player else { return }
        
        isPlaying.toggle()
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
        
        // Update lock screen controls
        if let currentEpisode = currentEpisode {
            updateNowPlayingInfo(for: currentEpisode)
        }
    }




    
    func play(episode: PodcastEpisode) {
        // Directly use episode.audioURL if it's already a URL
        let url = episode.audioURL
        self.currentEpisode = episode
        self.currentPlayingURL = url
        
        // Check and remove any existing observers to avoid memory leaks
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        // Create a new player item and assign it to the player
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.play()
        self.isPlaying = true
        
        // Update the lock screen info
        updateNowPlayingInfo(for: episode)
        
        // Setup progress tracking for the new player
        setupPlaybackProgressTracking()
    }



    func play() {
        player?.play()
        isPlaying = true
        if let episode = currentEpisode {
            updateNowPlayingInfo(for: episode)
        }
    }

    
    func skipBackward() {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let skipInterval = CMTime(seconds: -15, preferredTimescale: 1) // 15 seconds back
        let newTime = CMTimeAdd(currentTime, skipInterval)
        player.seek(to: newTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            guard let self = self else { return }
            self.updateNowPlayingInfoPlaybackPosition()
        }
    }


    func skipForward() {
        guard let player = player else { return }
        let currentTime = player.currentTime()
        let skipInterval = CMTime(seconds: 30, preferredTimescale: 1) // 30 seconds forward
        let newTime = CMTimeAdd(currentTime, skipInterval)
        player.seek(to: newTime, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            guard let self = self else { return }
            self.updateNowPlayingInfoPlaybackPosition()
        }
    }

    
    func updateNowPlayingInfoPlaybackPosition() {
        guard let player = player, let playerItem = player.currentItem else { return }
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        let currentTime = CMTimeGetSeconds(player.currentTime())
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    
    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        NotificationCenter.default.removeObserver(self)

    }
    
    
}



//MARK: HANDLING RSS FROM PODBEAN
class PodcastService {
    func fetchEpisodes(completion: @escaping ([PodcastEpisode]) -> Void) {
        guard let url = URL(string: "https://feed.podbean.com/offthecourtpgu/feed.xml") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let xml = XMLHash.parse(data)
            var episodes: [PodcastEpisode] = []
            
            for item in xml["rss"]["channel"]["item"].all {
                let id = item["guid"].element?.text ?? UUID().uuidString
                let title = item["title"].element?.text ?? "No Title"
                let description = item["description"].element?.text ?? "No Description"
                let audioURLString = item["enclosure"].element?.attribute(by: "url")?.text ?? ""
                let audioURL = URL(string: audioURLString)!
                let imageURLString = xml["rss"]["channel"]["image"]["url"].element?.text ?? ""
                let imageURL = URL(string: imageURLString)
                
                let episode = PodcastEpisode(id: id, title: title, description: description, audioURL: audioURL, imageURL: imageURL)
                episodes.append(episode)
            }
            
            DispatchQueue.main.async {
                completion(episodes)
            }
        }.resume()
    }
}




struct ResourcesView: View {
    
    @EnvironmentObject var audioPlayerManager: AudioPlayerManager
//    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @EnvironmentObject var viewState: ViewState // Add this line to access ViewState in ResourcesView.
    
    @State private var isMenuOpen: Bool = false
    @State private var episodes: [PodcastEpisode] = []
    @State private var items: [String] = []
    
    @State private var selectedEpisode: PodcastEpisode?
    
    @State private var showPlaybackControls = false



    var body: some View {
        
        ZStack{
            VStack{
                //THE HAMBURGER MENU NEEDS TO BE AFTER THE VSTACK IN ORDER FOR THE MENU VIEW TO COVER THE ENTIRE VIEW WHEN THE HAMBURGER MENU GETS CLICKED ⬇️
                HamburgerMenu(isMenuOpen: $isMenuOpen)
                    .navigationBarBackButtonHidden(true)
                    .frame(height: 50)
                    .padding(.bottom, 30)
                
                Spacer()
                
                
                HStack {
                    
                    Text("Podcast")
                        .padding(10)
                        .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                        .background(Color(hex: "c7972b"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Spacer() // Spacing between buttons
                    
                    NavigationLink(destination: CoachDrills()) {
                    Text("Camp Video")
                        .padding(10)
                        .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                        .background(Color(hex: "0f2d53"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    Spacer() // Spacing between buttons
                    
                    NavigationLink(destination: FilmReviewView()) {
                        Text("Rob's Clips")
                            .padding(10)
                            .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                            .background(Color(hex: "0f2d53"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding()
                
                
                Image("podcast-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                    
                    List(episodes) { episode in
                        HStack{
                            
                            if let imageURL = episode.imageURL {
                                AsyncImage(url: imageURL) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Text(episode.title)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "0f2d53"))// Style for regular text
                            
                            Spacer()
                            
                            Button(action: {
                                self.selectedEpisode = episode
                                if audioPlayerManager.currentPlayingURL == episode.audioURL {
                                    // If the same episode, toggle play/pause
                                    audioPlayerManager.togglePlayPause()
                                } else {
                                    // If a different episode, start playing the new episode
                                    audioPlayerManager.setCurrentEpisode(episode)
                                }
                                withAnimation {
                                    showPlaybackControls = true
                                }
                            }) {
                                Image(systemName: audioPlayerManager.isPlaying && audioPlayerManager.currentEpisode?.id == episode.id ? "pause.fill" : "play.fill")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)

                            }
                            
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        PodcastService().fetchEpisodes { fetchedEpisodes in
                            self.episodes = fetchedEpisodes
                        }
                    }
                    
                    

                    
                PlaybackControlsView(audioPlayerManager: audioPlayerManager)

     
                Divider()
                
                HStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeView()) {
                        VStack{
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)// Example icon
                            Text("Home")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                            
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: InboxView()) {
                        VStack{
                            Image(systemName: "tray.full")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)// Example icon
                            Text("Inbox")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                            
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: CampsView()) {
                        VStack{
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)// Example icon
                            Text("Camps")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                            
                        }
                    }
                    
                    
                    
                    Spacer()
                    
                    
                    VStack{
                        Image(systemName: "basketball")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 25, height: 25)// Example icon
                        Text("Resources")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                }
                .padding(.top)
                .background(Color.white)
                
                
                
            }
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(1) // Ensure the menu is on top
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }

}

struct PlaybackControlsView: View {
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @State private var showDetailSheet = false // State to control sheet presentation
    
    var body: some View {
        // Directly use audioPlayerManager.currentEpisode
        if let episode = audioPlayerManager.currentEpisode {
            HStack {
                // Display episode image
                if let imageURL = episode.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        self.showDetailSheet = true // Show sheet when image is tapped
                    }
                }
                
                // Display episode title
                Text(episode.title)
                    .font(.headline)
                    .padding(.leading, 5)
                    .onTapGesture {
                        self.showDetailSheet = true // Show sheet when title is tapped
                    }
                
                Spacer()
                
                // Play/Pause Button
                Button(action: {
                    // Toggle play/pause for the current episode
                    audioPlayerManager.togglePlayPause()
                }) {
                    Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(Color(hex: "c7972b"))
                        .padding()
                        .background(Circle().fill(Color.white))
                }
            }
            .padding()
            .background(BlurView(style: .systemUltraThinMaterial))
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showDetailSheet) {
                EpisodeDetailView(audioPlayerManager: audioPlayerManager, episode: episode)
            }
        }
    }
}





struct EpisodeDetailView: View {
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    var episode: PodcastEpisode


    var body: some View {
        ZStack {
            // Background blur
            Color(hex: "0f2d53").edgesIgnoringSafeArea(.all) // Set the background to red

            VStack(alignment: .center, spacing: 20) {
                
                if let imageURL = episode.imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Display a progress view while the image is loading
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 300, height: 300)
                        case .failure:
                            Image(systemName: "photo") // An image to display in case of failure
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                // Episode title
                Text(episode.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                
                Slider(value: $audioPlayerManager.playbackProgress, in: 0...1) { editing in
                    if !editing {
                        audioPlayerManager.seek(to: audioPlayerManager.playbackProgress)

                        
                    }
                }
                .accentColor(Color(hex: "c7972b"))
                
                HStack {
                    Text(audioPlayerManager.currentTime.asMinuteSecondString())
                    Spacer()
                    // Correct calculation of the remaining time
                    let remainingTime = audioPlayerManager.duration - audioPlayerManager.currentTime
                    Text("-\(remainingTime.asMinuteSecondString())")
                }
                .foregroundColor(.white)

                
                HStack(spacing: 40) { // Adjust spacing as needed
                    // Skip backward 15 seconds
                    Button(action: {
                        audioPlayerManager.skipBackward()
                    }) {
                        Image(systemName: "gobackward.15")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(hex: "c7972b"))
                            .padding()
                    

                    }
                    
                    // Play/Pause Button
                    Button(action: {
                        // Check if the selected episode is the current episode
                        if audioPlayerManager.currentEpisode?.id == episode.id {
                            // If the episode has finished playing (indicated by playbackProgress),
                            // and the user wants to replay it
                            if audioPlayerManager.playbackProgress >= 1.0 {
                                // Reset the playback progress and current time
                                audioPlayerManager.playbackProgress = 0.0
                                audioPlayerManager.currentTime = 0
                                // Seek to the beginning of the episode
                                audioPlayerManager.player?.seek(to: .zero) { _ in
                                    // After seeking to the beginning, start playback
                                    audioPlayerManager.play(episode: episode)
                                }
                            } else {
                                // For any other case, simply toggle play/pause
                                // This will either pause the currently playing episode
                                // or resume playback from the current position
                                audioPlayerManager.togglePlayPause()
                            }
                        } else {
                            // If a different episode is selected, start it
                            audioPlayerManager.play(episode: episode)
                        }
                    }) {
                        Image(systemName: audioPlayerManager.isPlaying && audioPlayerManager.currentEpisode?.id == episode.id ? "pause.fill" : "play.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white)
                            .padding()
                    }



                    
                    
                    //MARK: LOGIC THAT DOES NOT REPLAY PODCAST WHEN ITS DONE.
//                    Button(action: {
//                        if audioPlayerManager.currentEpisode?.id == episode.id {
//                            if !audioPlayerManager.isPlaying {
//                                // If the episode has finished playing or if playbackProgress is at 1.0,
//                                // seek to the beginning and play again.
//                                if audioPlayerManager.playbackProgress >= 1.0 {
//                                    audioPlayerManager.player?.seek(to: .zero) { _ in
//                                        audioPlayerManager.play()
//                                    }
//                                    // Reset progress and current time if necessary
//                                    audioPlayerManager.playbackProgress = 0.0
//                                    audioPlayerManager.currentTime = 0
//                                } else {
//                                    // Resume playing from the current position
//                                    audioPlayerManager.play()
//                                }
//                            } else {
//                                // Pause the playback
//                                audioPlayerManager.pause()
//                            }
//                        } else {
//                            // If a different episode is selected, start it
//                            audioPlayerManager.play(episode: episode)
//                        }
//                    }) {
//                        Image(systemName: audioPlayerManager.isPlaying && audioPlayerManager.currentEpisode?.id == episode.id ? "pause.fill" : "play.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(Color.white)
//                            .padding()
//                    }



                    
                    // Skip forward 30 seconds
                    Button(action: {
                        audioPlayerManager.skipForward()
                    }) {
                        Image(systemName: "goforward.30")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(hex: "c7972b"))
                            .padding()
                    }
                }
                
   
                
            }
            .padding()
        }
        
    }
    

}

extension TimeInterval {
    func asMinuteSecondString() -> String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds) // Ensures the format is MM:SS
    }
}


extension Notification.Name {
    static let pausePodcastPlayback = Notification.Name("pausePodcastPlayback")
    static let resumePodcastPlayback = Notification.Name("resumePodcastPlayback")
}


#Preview {
    ResourcesView()
}
