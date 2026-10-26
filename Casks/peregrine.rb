cask "peregrine" do
  version "1.1.0"
  sha256 "3e3605e10cb1ef43888a38f264127ac08739d735a2a34ce176bed8619c859fea"

  url "https://github.com/fahadjibransheikh/homebrew-tap/releases/download/peregrine-v#{version}/Peregrine_#{version}_aarch64.dmg"
  name "Peregrine"
  desc "Casts your screen and sound to a TV from the menu bar"
  homepage "https://github.com/fahadjibransheikh/homebrew-tap"

  livecheck do
    url "https://github.com/fahadjibransheikh/homebrew-tap/releases"
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
