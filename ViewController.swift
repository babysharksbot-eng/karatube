// NOTE: Demo ViewController created by assistant — minor comment added for testing push
import UIKit
import AVFoundation
import AVKit
import os

class ViewController: UIViewController {
    let playButton = UIButton(type: .system)
    let airplayButton = AVRoutePickerView()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    let queueManager = QueueManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Debug: confirm viewDidLoad called
        print("ViewController: viewDidLoad called")
        view.backgroundColor = UIColor.systemBackground
        title = "Karaoke Demo"

        setupUI()
        queueManager.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Debug: visible confirmation
        print("ViewController: viewDidAppear called")
        os_log("ViewController appeared", log: OSLog.default, type: .debug)

        // Add a large on-screen label so it's obvious the VC loaded
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "VC LOADED"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 240),
            label.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func setupUI() {
        // Play button
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(onPlay), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)

        // AirPlay route picker
        airplayButton.translatesAutoresizingMaskIntoConstraints = false
        airplayButton.activeTintColor = .systemBlue
        airplayButton.prioritizesVideoDevices = true
        view.addSubview(airplayButton)

        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            airplayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            airplayButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }

    @objc func onPlay() {
        if player == nil {
            // use sample mp4 url for demo
            guard let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4") else { return }
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = CGRect(x: 16, y: 120, width: view.bounds.width - 32, height: 220)
            playerLayer?.videoGravity = .resizeAspect
            if let pl = playerLayer { view.layer.addSublayer(pl) }
            // observe end
            NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        }
        player?.play()
        playButton.setTitle("Playing...", for: .normal)
    }

    @objc func itemDidFinish() {
        // Ask queue manager for next URL
        if let next = queueManager.popNext() {
            player?.replaceCurrentItem(with: AVPlayerItem(url: next))
            player?.play()
        } else {
            playButton.setTitle("Play", for: .normal)
        }
    }
}

extension ViewController: QueueManagerDelegate {
    func queueUpdated() {
        // update UI if needed
    }
}
