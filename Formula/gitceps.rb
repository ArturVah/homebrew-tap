class Gitceps < Formula
  desc "Gym bro who lifts your code every time you git push"
  homepage "https://github.com/ArturVah/gitceps"
  url "https://github.com/ArturVah/gitceps/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c6198f659b59a068161ea3a25c46d4412d4e87b3eb0e0a2d93b178673a5135cc"
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
