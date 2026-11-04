class PushBro < Formula
  desc "Gym bro who lifts your code every time you git push"
  homepage "https://github.com/ArturVah/push-bro"
  url "https://github.com/ArturVah/push-bro/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "72d1f862060c15fb6db14076cb8211500b5f4da7659ea2733780e2366e4b1b7e"
  license "MIT"

  depends_on :macos

  def install
    system "xcrun", "swiftc", "-O", "-swift-version", "6", "app/main.swift", "-o", "app/pushbro",
           "-framework", "AppKit", "-framework", "WebKit"
    libexec.install "app", "overlay", "hooks", "bin"
    # opt_libexec stays the same across upgrades, so the hooks path git remembers keeps working.
    (bin/"push-bro").write_env_script libexec/"bin/push-bro", PB_HOME: opt_libexec
  end

  def caveats
    <<~EOS
      Turn Push Bro on for every git repo:
        push-bro on
      Turn him off before uninstalling, or git stops running your repos' own hooks:
        push-bro off
    EOS
  end

  test do
    assert_predicate libexec/"app/pushbro", :executable?
    assert_equal "off", shell_output("#{bin}/push-bro status").strip
  end
end
