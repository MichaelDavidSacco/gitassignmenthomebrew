# frozen_string_literal: true

require "cmd/shared_examples/args_parse"
require "support/lib/config"

describe "Homebrew.home_args" do
  it_behaves_like "parseable arguments"
end

describe "brew home", :integration_test do
  let(:testballhome_homepage) {
    Formula["testballhome"].homepage
  }

  let(:local_caffeine_path) {
    cask_path("local-caffeine")
  }

  let(:local_caffeine_homepage) {
    Cask::CaskLoader.load(local_caffeine_path).homepage
  }

  it "opens the homepage for a given Formula" do
    setup_test_formula "testballhome"

    expect { brew "home", "testballhome", "HOMEBREW_BROWSER" => "echo" }
      .to output("#{testballhome_homepage}\n").to_stdout
      .and not_to_output.to_stderr
      .and be_a_success
  end

  it "opens the homepage for a given Cask" do
    expect { brew "home", cask_path("local-caffeine"), "HOMEBREW_BROWSER" => "echo" }
      .to output(/Formula "#{local_caffeine_path}" not found. Found a cask instead.\n#{local_caffeine_homepage}/m)
            .to_stdout
      .and not_to_output.to_stderr
      .and be_a_success
  end

  it "opens the homepages for a given formula and Cask" do
    setup_test_formula "testballhome"

    expect { brew "home", "testballhome", cask_path("local-caffeine"), "HOMEBREW_BROWSER" => "echo" }
      .to output(/Formula "#{local_caffeine_path}" not found. Found a cask instead.\n#{testballhome_homepage} #{local_caffeine_homepage}/m)
      .to_stdout
      .and not_to_output.to_stderr
      .and be_a_success
  end
end
