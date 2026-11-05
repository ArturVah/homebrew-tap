class Gitceps < Formula
  desc "Gym bro who pushes your code to the cloud every time you git push"
  homepage "https://github.com/ArturVah/gitceps"
  url "https://github.com/ArturVah/gitceps/releases/download/v0.5.3/gitceps-0.5.3.tar.gz"
  sha256 "252ef511966140725dfefeda73c219adbeba1179f9ca114bb9baf0c2aef8610a"
  license "MIT"

  depends_on :macos

  def install
    system "xcrun", "swiftc", "-O", "-swift-version", "6", "app/main.swift", "-o", "app/gitceps-app",
           "-framework", "AppKit", "-framework", "WebKit"
    libexec.install "app", "overlay", "hooks", "bin"
    # opt_libexec stays the same across upgrades, so the hooks path git remembers keeps working.
    (bin/"gitceps").write_env_script libexec/"bin/gitceps", GITCEPS_HOME: opt_libexec
  end

  def caveats
    <<~EOS
      Turn Gitceps on for every git repo:
        gitceps on
      Turn him off before uninstalling, or git stops running your repos' own hooks:
        gitceps off
    EOS
  end

  test do
    assert_predicate libexec/"app/gitceps-app", :executable?
    assert_equal "off", shell_output("#{bin}/gitceps status").strip
  end
end
