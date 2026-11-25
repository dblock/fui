# frozen_string_literal: true

if RUBY_ENGINE == 'ruby' && Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.3') &&
   Gem.loaded_specs.key?('ruby-gem-release')
  require_relative '../../script/release'
  require 'ruby-gem-release/rspec'

  RSpec.describe FuiRelease do
    include RubyGemRelease::RSpec

    let(:root) { File.expand_path('../..', __dir__) }
    let(:version_path) { 'lib/fui/version.rb' }
    let(:fixture_files) do
      %w[fui.gemspec script/release.rb bin/fui lib/**/*.rb CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md RELEASING.md]
    end
    let(:placeholder) { '* Your contribution here.' }
    let(:note) { '* [#1](https://github.com/dblock/fui/pull/1): Added a feature - [@dblock](https://github.com/dblock).' }

    def changelog(notes)
      [
        '### 1.2.0 (Next)', '', notes, placeholder, '',
        '### 1.1.0 (2026/01/01)', '', '* Previous release.', ''
      ].compact.join("\n")
    end

    def write_version(project, version)
      source = File.read(File.join(root, version_path))
      project.write(version_path, source.sub(/VERSION = (['"])[^'"]+\1/, "VERSION = '#{version}'"))
    end

    def with_project(notes)
      with_release_project do |project|
        project.copy_files(path: root, files: fixture_files)
        project.configure_workflow(require: 'script/release', builder: 'FuiRelease.workflow')
        project.write('CHANGELOG.md', changelog(notes))
        write_version(project, '1.2.0')
        project.commit!
        yield project
      end
    end

    it 'builds the standard ruby-gem-release workflow' do
      expect(described_class.workflow).to be_a(RubyGemRelease::Workflow::RubyGem)
    end

    it 'dates the release and prepares the next patch version' do
      with_project(note) do |project|
        project.release!

        released = project.remote_file('v1.2.0', 'CHANGELOG.md')
        expect(released).to match(%r{\A### 1\.2\.0 \(\d{4}/\d{2}/\d{2}\)\n\n})
        expect(released).to include(note)
        expect(released).not_to include('(Next)', placeholder)
        expect(project.remote_file('v1.2.0', version_path)).to include("VERSION = '1.2.0'")

        pending = project.remote_file('master', 'CHANGELOG.md')
        expect(pending).to start_with("### 1.2.1 (Next)\n\n#{placeholder}\n\n### 1.2.0 (")
        expect(project.remote_file('master', version_path)).to include("VERSION = '1.2.1'")
        expect(project.git('status', '--porcelain')).to be_empty
      end
    end

    it 'rejects placeholder-only notes without changing files or remote refs' do
      with_project(nil) do |project|
        original = project.git('rev-parse', 'origin/master')
        project.run_task('release:workflow:capture')
        expect { project.run_task('release:validate') }.to raise_error(RuntimeError, /no pending changelog notes/)
        expect(project.git('status', '--porcelain')).to be_empty
        expect(project.git('rev-parse', 'origin/master')).to eq(original)
      end
    end
  end
end
