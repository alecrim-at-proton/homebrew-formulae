# typed: strict
# frozen_string_literal: true

class GitlabTartExecutor < Formula
  desc "GitLab Runner Executor to run jobs inside isolated Tart VMs"
  homepage "https://github.com/cirruslabs/gitlab-tart-executor"
  url "https://github.com/cirruslabs/gitlab-tart-executor/archive/refs/tags/1.29.0.tar.gz"
  version "1.29.0"
  sha256 "c3b27df985cd45bcc8d4b65c085db670a735bca89ab9b49372c4cb4b59d98b76"

  depends_on "go" => :build
  depends_on arch: :arm
  depends_on macos: :sequoia
  depends_on "openai/tools/tart"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = [
      "-X github.com/cirruslabs/gitlab-tart-executor/internal/version.Version=#{version}",
      "-X github.com/cirruslabs/gitlab-tart-executor/internal/version.Commit=e1fb650",
    ].join(" ")

    system "go", "build", "-ldflags", ldflags, "-o", bin/"gitlab-tart-executor", "./cmd/gitlab-tart-executor"
  end

  test do
    assert_match "executor version #{version}-e1fb650", shell_output("#{bin}/gitlab-tart-executor --version")
    assert_match "Usage:", shell_output("#{bin}/gitlab-tart-executor --help")
  end
end
