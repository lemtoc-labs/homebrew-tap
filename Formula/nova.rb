class Nova < Formula
  desc "A fast, customizable zsh prompt renderer."
  homepage "https://github.com/lemtoc-labs/nova"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.3.0/nova-aarch64-apple-darwin.tar.xz"
      sha256 "af8a14f814f21402712f96f1816864583b50353c282164c645b9ed9d299d8376"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.3.0/nova-x86_64-apple-darwin.tar.xz"
      sha256 "59d380ffc42384587a29eda35dfecf99d1ac070a9c469a108be80eebeb7bb14a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.3.0/nova-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9edc0abd854769a5607d89ec11e022cc89c7e2f9302a949d4b6fcb1ccde3203e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lemtoc-labs/nova/releases/download/v0.3.0/nova-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "252798065c00337ecc4a1f39abda3b27ad2b6679ec88b2d98d8ba5f637c06710"
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
