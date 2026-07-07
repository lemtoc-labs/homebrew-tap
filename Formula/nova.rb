class Nova < Formula
  desc "A fast, customizable zsh prompt renderer."
  homepage "https://github.com/lemtoc-labs/nova"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.1.0/nova-aarch64-apple-darwin.tar.xz"
      sha256 "1054d9c0b4fefbe4fd5d0496f7a4f4a7a5a927fba9300a87b45e4cc43a8902b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.1.0/nova-x86_64-apple-darwin.tar.xz"
      sha256 "986ed84c53c16cadad7bc67ac8e12cebf8378fe17c2b5210b1fa47f6258e7033"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.1.0/nova-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf310c417be821e5003cf0a9c80eb9aa4cfc03ca10d78f27b11dc9ea5931185f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.1.0/nova-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1550f07e0e5826b4ef0dfb78893ed01bf9cdace1c07713ad87a8958a205cb56a"
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
