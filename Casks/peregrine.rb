cask "peregrine" do
  version "1.3.1"
  sha256 "cf6f4ea26453912dc808cf77112529e90398fa930b09a50cb3cd82f1c00a4637"

  url "https://github.com/fahadjibransheikh/homebrew-flock/releases/download/peregrine-v#{version}/Peregrine_#{version}_aarch64.dmg"
  name "Peregrine"
  desc "Casts your screen and sound to a TV from the menu bar"
  homepage "https://github.com/fahadjibransheikh/homebrew-flock"

  livecheck do
    url "https://github.com/fahadjibransheikh/homebrew-flock/releases"
    regex(/peregrine-v(\d+(?:\.\d+)+)/i)
    strategy :github_releases
  end

  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "Peregrine.app"

  # Signed with a development certificate, not notarized yet, so Gatekeeper would refuse to open it.
  # Remove this once releases are notarized.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Peregrine.app"]
  end

  uninstall quit: "com.fahadsheikh.peregrine"

  zap trash: [
    "~/Library/Caches/com.fahadsheikh.peregrine",
    "~/Library/Preferences/com.fahadsheikh.peregrine.plist",
  ]
end
