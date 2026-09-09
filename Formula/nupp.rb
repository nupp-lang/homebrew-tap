class Nupp < Formula
  desc "Typed programming language for LuaJIT with an optimizing compiler"
  homepage "https://nupp.org"
  url "https://github.com/nupp-lang/nupp/releases/download/v0.0.5/nupp-macos-arm64.tar.gz"
  sha256 "ebf2fb914176c30c741de3df169ab056699f70ca964396cbb8d4f10e8daee999"

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
