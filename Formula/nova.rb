class Nova < Formula
  desc "A fast, customizable zsh prompt renderer."
  homepage "https://github.com/lemtoc-labs/nova"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.2.0/nova-aarch64-apple-darwin.tar.xz"
      sha256 "41c853b1785e3dcacf1010d60ede5fd7c202e5fef57deaa3192ca9ebfaa8ee3e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.2.0/nova-x86_64-apple-darwin.tar.xz"
      sha256 "ef15866948040833ecabc974a48395f62c4cf6928bf547ab6da9c104c5d2b578"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.2.0/nova-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "794dd7c447ffeae56d19ce0527ae987e6894294dd83f23e68a9cb0a911790719"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.2.0/nova-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d1d262db86db60dd2056544c97fe710cbd2975c8f983e6fe4d9c0c9602059d1e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "nova" if OS.mac? && Hardware::CPU.arm?
    bin.install "nova" if OS.mac? && Hardware::CPU.intel?
    bin.install "nova" if OS.linux? && Hardware::CPU.arm?
    bin.install "nova" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
