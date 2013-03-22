# bootloader

bootloader takes care of many of the common tasks across your Ruby applications:

- Loading YAML configuration.
- Loading multiple source files at once.
- Setting up a syslogger.
- etc.

## Installation

Add the following line to your _Gemfile_:

```ruby
gem 'bootloader'
```

And then run:

```shell
bundle install
```

## Example

Say you have a project with the following structure:

```shell
my_project/
  Gemfile
  config/
    my_project.yml
  lib/
    foo.rb
    bar.rb
```

Here's the _my_project.yml_:

```yaml
development:
  database:
    name: my_project_dev
    hosts:
      - db101
      - db102
```

### Loading YAML configs

```ruby
require 'bootloader'

Bootloader.load_configs # => Loads my_project.yml into MyProjectConfig
MyProjectConfig.database.name # => "my_project_dev"
MyProjectConfig.database.hosts # => ['db101', 'db102']
```

### Loading multiple files at once

```ruby
Bootloader.load_dir 'lib' # Loads all the files under lib
```

### Setting up a Syslogger

```ruby
Bootloader.syslogger 'my_project' # => #<Logger>
```

## License

bootloader is released under the [MIT License](http://opensource.org/licenses/MIT).
