# Sisyphus for Medusa

Sisyphus is a browser-based client for Medusa. Use it to create specimen
records and print barcode labels through a Windows print service. For
Android, see [Sisyphus for Android](https://github.com/misasa/sisyphus).

## Requirements

- Ruby 2.5 or later and the
  [medusa_rest_client gem](https://github.com/misasa/medusa_rest_client)
- Access to a Medusa server
- A Windows print service on port 8889 on the computer running Sisyphus
  for barcode printing

## Installation

```sh
gem source -a http://dream.misasa.okayama-u.ac.jp/rubygems/
gem install sisyphus-for-medusa
```

## Usage

```sh
sisyphus
sisyphus --help
```

The web interface is available at http://localhost:8890 on the computer
running Sisyphus. Use `--port` to change the HTTP port and `--title` to
set the title shown in the browser.

## Test and build

Run the application specs with `bundle install` and `bundle exec rspec`.
Build the gem and verify its installed command from the repository root.

```sh
mkdir -p pkg
archive="pkg/$(ruby -r ./lib/sisyphus/version -e 'puts "sisyphus-for-medusa-#{Sisyphus::VERSION}.gem"')"
gem build sisyphus.gemspec --strict --output "$archive"
ruby script/verify_package.rb "$archive"
```

The package check uses the runtime gems already available to the selected
Ruby. It installs the archive in a temporary directory, checks the CLI help
and HTTP server handler, and renders the specimen form through Rack.

## Build and release on GitHub

GitHub Actions runs the Ruby test matrix, builds the gem, and verifies its
installed CLI and web interface. The `sisyphus-for-medusa-gem` artifact is
available in the **Ruby** workflow run.

A stable `vVERSION` tag on a tested `master` commit also publishes the
verified gem and its SHA-256 manifest to
[GitHub Releases](https://github.com/misasa/sisyphus-for-medusa/releases).
The tag must match `lib/sisyphus/version.rb` (for example, `v1.2.3` for
version `1.2.3`). After merging the workflow and version change into
`master`, create and push the tag from that commit:

```sh
tag=$(ruby -r ./lib/sisyphus/version -e 'print "v#{Sisyphus::VERSION}"')
git tag "$tag"
git push origin "refs/tags/$tag"
```

Releases follow the same process as `tepra`, `pmlatex`, and `scalebar`:
check the tag, version, `master` ancestry, and existing releases; upload a
draft; download and compare both assets; then publish. Existing releases
(including drafts) and legacy version tags are never replaced. A failure
after draft creation leaves the draft unpublished for inspection. Use a
new version and tag for each release.

## Download and transfer from Jenkins

Use Bash, curl, `shasum`, and `link` to fetch a public Release without a
GitHub token or Ruby. Run the helper in an **Execute shell** build step
or a Pipeline `sh` step. The default selects the latest stable Release;
use `--version` to pin the build to deploy.

```sh
bash script/download_release.sh --output-dir ./downloads
bash script/download_release.sh --version 1.2.3 --output-dir ./downloads-1.2.3
```

The helper verifies the SHA-256 manifest before saving the files. For the
Jenkins transfer step, set `SISYPHUS_DEPLOY_DEST` to the server and directory
configured for the job, then run the helper with `--deploy`:

```sh
export SISYPHUS_DEPLOY_DEST='user@server.example.edu:/absolute/web/path'
bash script/download_release.sh --version 1.2.3 --output-dir ./transfer-1.2.3 --deploy
```

The remote parent directory must already exist. Jenkins uses its existing
noninteractive SSH credentials and known host. The helper copies both assets
to a new `vVERSION` subdirectory and refuses existing local files or remote
version directories. Use a fresh local output directory for each transfer.
After the transfer, update the gem index through the existing server-side
process.

For jobs that do not check out the repository, place a reviewed copy of
`script/download_release.sh` on the Jenkins agent. Public releases are also
available directly at versioned URLs, for example:

```text
https://github.com/misasa/sisyphus-for-medusa/releases/download/v1.2.3/sisyphus-for-medusa-1.2.3.gem
https://github.com/misasa/sisyphus-for-medusa/releases/download/v1.2.3/sisyphus-for-medusa-1.2.3.gem.sha256
```

These URLs become available after the tagged release workflow succeeds.
