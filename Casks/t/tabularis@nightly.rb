cask "tabularis@nightly" do
  arch arm: "aarch64", intel: "x64"

  version "0.21.1-2,20260828-9e6975a"
  sha256 arm:   "f4b7eff2cace440356a396413c487ebbdcf6c3a114d633216bc0e581ce2d92d0",
         intel: "961b3adb310e96fee3adb063780ac206217f469fe1aa074d25a540961cb1b5eb"

  url "https://github.com/TabularisDB/tabularis/releases/download/nightly-#{version.csv.second}/tabularis_#{version.csv.first}_#{arch}.dmg"
  name "Tabularis Nightly"
  desc "Lightweight database management tool"
  homepage "https://tabularis.dev/"

  livecheck do
    url "https://github.com/TabularisDB/tabularis/releases"
    strategy :github_releases do |json|
      json.map do |release|
        next unless release["prerelease"]

        tag = release["tag_name"]
        next unless tag&.start_with?("nightly-")

        tag_suffix = tag.sub(/^nightly-/, "")
        asset = release["assets"]&.find { |a| a["name"]&.match?(/^tabularis_.*_#{arch}\.dmg$/) }
        next if asset.nil?

        app_version = asset["name"][/^tabularis_(.+)_#{arch}\.dmg$/, 1]
        next if app_version.nil?

        "#{app_version},#{tag_suffix}"
      end
    end
  end

  auto_updates true
  conflicts_with cask: "tabularis"
  depends_on macos: :monterey

  app "tabularis.app"

  zap trash: [
    "~/Library/Application Support/tabularis",
    "~/Library/Caches/tabularis",
    "~/Library/Logs/tabularis",
    "~/Library/Preferences/com.debba.tabularis.plist",
    "~/Library/Saved Application State/com.debba.tabularis.savedState",
    "~/Library/WebKit/tabularis",
  ]
end
