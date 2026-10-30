cask "mynah" do
  version "1.2.0"
  sha256 "6d25ba9464b895e3bf8597cf21a9e920558b74f3016b23777fd67e9b6ab9197a"

  url "https://github.com/fahadjibransheikh/homebrew-flock/releases/download/mynah-v#{version}/Mynah_#{version}_aarch64.dmg"
  name "Mynah"
  desc "Bot-free meeting notes: records calls, transcribes locally, names who spoke"
  homepage "https://github.com/fahadjibransheikh/homebrew-flock"

  livecheck do
    url "https://github.com/fahadjibransheikh/homebrew-flock/releases"
    regex(/mynah-v(\d+(?:\.\d+)+)/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Mynah.app"

  # Signed with a development certificate, not notarized yet, so Gatekeeper would refuse to open it.
  # Remove this once releases are notarized.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Mynah.app"]
  end

  uninstall quit: "com.fahadsheikh.mynah"

  # The library may be shared with the Eavesdroppy droplet in Droppy (its container), so zap leaves that alone.
  zap trash: [
    "~/Library/Application Support/Mynah",
    "~/Library/Caches/com.fahadsheikh.mynah",
    "~/Library/Preferences/com.fahadsheikh.mynah.plist",
  ]
end
