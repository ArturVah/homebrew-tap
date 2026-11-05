class Gitceps < Formula
  desc "Gym bro who pushes your code to the cloud every time you git push"
  homepage "https://github.com/ArturVah/gitceps"
  url "https://github.com/ArturVah/gitceps/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "b0d0a0f58f127d87ab42e351491bbef477d6bb76ead24a77dd0d7bb0e51218d0"
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
