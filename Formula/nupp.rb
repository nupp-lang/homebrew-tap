class Nupp < Formula
  desc "Typed programming language for LuaJIT with an optimizing compiler"
  homepage "https://nupp.org"
  url "https://github.com/nupp-lang/nupp/releases/download/v0.0.9/nupp-macos-arm64.tar.gz"
  sha256 "e7c5a77b8a6b44b23cc27fa317092dafc19a92e833f963e985cd106c5bd7acb9"

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
