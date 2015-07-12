# Kanagata

Kanagata is a file generator based on ERB template files.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kanagata'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install kanagata
```


## Usage

```sh
$ kanagata -h
Commands:
  kanagata destroy [RECIPE_NAME]   # Destroy files based on recipe and template files
  kanagata generate [RECIPE_NAME]  # Generate files based on recipe and template files
  kanagata help [COMMAND]          # Describe available commands or one specific command
  kanagata init                    # Generate sample recipe and template files
```

### e.g. .gitconfig

You can prepare a recipe file with the following command to set up your gitconfig file:

```sh
$ cat <<EOF>>.kanagata
gitconfig:
  templates:
    - path: ~/.gitconfig
EOF
```

Next, you can make a template file with the following command:

```sh
$ mkdir kanagata
$ cat <<EOF>>kanagata/.kanagata.erb
[user]
  name  = <%= name %>
  email = <%= email %>
[alias]
  ci = commit -v
  co = checkout
  st = status
  di = diff
  br = branch
  df = diff
[color]
  diff        = auto
  status      = auto
  branch      = auto
  interactive = auto
EOF
```

Your gitconfig file is generated at your $HOME dir after running the following command.

```sh
$ kanagata generate gitconfig name:'YOUR NAME' email:your_name@exampl.com
```

If you want to delete kanagata generated files, you can just run `kanagata destroy gitconfig` command.

### To make your original kanagata recipe and template files

You can make sample files with the following command:

```sh
$ kanagata init [YOUR_RECIPE_NAME]
```

`kanagata init` command generates one directory and two files.

- `kanagata' directory is template file directory, so you can store template files in this directory.
- `.kanagata` file is a recipe file.
- `kanagata/sample.yml.erb` file is a sample template file.


## Development

After checking out the repository, run `bundle install` to install dependencies. Then, run `rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

1. Fork it ( https://github.com/masa0x80/kanagata/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
