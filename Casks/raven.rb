cask "raven" do
  version "1.3.0"
  sha256 arm:          "bd6126d9fac63fc64381582da527e2b3db36bd54085bf1b1b94bf2e50748f52b",
         x86_64_linux: "f1348f9b51c411e454829c6fb36087b77aa0d3042f1737268c3fb553b534c422"

  on_macos do
    url "https://github.com/fahadjibransheikh/homebrew-tap/releases/download/raven-v#{version}/Raven_#{version}_aarch64.dmg"

    depends_on arch: :arm64

    app "Raven.app"

    # The app is not signed or notarized yet, so Gatekeeper would refuse to open
    # it. Remove these postflight steps once it is.
    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Raven.app"]
    end

    zap trash: [
      "~/Library/Application Support/com.fahadsheikh.raven",
      "~/Library/Caches/com.fahadsheikh.raven",
      "~/Library/Saved Application State/com.fahadsheikh.raven.savedState",
      "~/Library/WebKit/com.fahadsheikh.raven",
    ]
  end
  on_linux do
    url "https://github.com/fahadjibransheikh/homebrew-tap/releases/download/raven-v#{version}/Raven_#{version}_amd64.AppImage"

    depends_on arch: :x86_64

    # Version-less target, so the in-app updater replaces the file in place.
    app_image "Raven_#{version}_amd64.AppImage", target: "Raven.AppImage"

    # Homebrew only places the AppImage, so add an app launcher entry. Install
    # steps run with a sandboxed $HOME, so home paths use `base: :home`, and
    # Exec uses ~ for sh to expand when the launcher starts Raven.
    postflight_steps do
      run "/usr/bin/curl",
          args:           ["-fsSL", "https://github.com/fahadjibransheikh/homebrew-tap/releases/download/raven-v{{version}}/raven-icon.png"],
          stdout_path:    "raven.png",
          network_access: true
      copy "raven.png", ".local/share/icons/hicolor/512x512/apps/raven.png", target_base: :home
      write_file ".local/share/applications/raven.desktop", <<~DESKTOP, base: :home
        [Desktop Entry]
        Type=Application
        Name=Raven
        Comment=Desktop email client
        Exec=sh -c "exec ~/Applications/Raven.AppImage"
        Icon=raven
        Terminal=false
        Categories=Network;Email;
      DESKTOP
    end

    uninstall_postflight_steps do
      remove [".local/share/applications/raven.desktop",
              ".local/share/icons/hicolor/512x512/apps/raven.png"],
             base: :home
    end

    zap trash: "~/.local/share/com.fahadsheikh.raven"
  end

  name "Raven"
  desc "Desktop email client"
  homepage "https://github.com/fahadjibransheikh/homebrew-tap"

  livecheck do
    url "https://github.com/fahadjibransheikh/homebrew-tap/releases"
    regex(/raven-v(\d+(?:\.\d+)+)/i)
    strategy :github_releases
  end

  auto_updates true
end
