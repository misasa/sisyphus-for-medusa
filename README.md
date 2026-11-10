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

## Build on GitHub from a tag

On a commit that includes the build workflow, create and push a new tag
matching the gem version.

```sh
tag=$(ruby -r ./lib/sisyphus/version -e 'print "v#{Sisyphus::VERSION}"')
git tag "$tag"
git push origin "refs/tags/$tag"
```

Open the **Build tagged gem** run in GitHub Actions and download
`sisyphus-for-medusa-gem` from **Artifacts**. The artifact contains the
verified `.gem` file.
