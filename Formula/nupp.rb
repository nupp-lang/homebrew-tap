class Nupp < Formula
  desc "Typed programming language for LuaJIT with an optimizing compiler"
  homepage "https://nupp.org"
  url "https://github.com/nupp-lang/nupp/releases/download/v0.0.2/nupp-macos-arm64.tar.gz"
  sha256 "1eab178104f47342276e941f16630d61ca6db835e4f45de9eaceed78117621ba"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "nupp"
    lib.install "lib/nupp" if (buildpath/"lib/nupp").directory?
    pkgshare.install "NOTICE.md", "SIGNING.txt", "SHA256SUMS",
                     "stub-catalog-record.json", "notices"
  end

  test do
    assert_match "Nupp compiler and project tool", shell_output("#{bin}/nupp --help")
  end
end
