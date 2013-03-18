# bootloader

This gem provides a set of APIs that takes care of common tasks across your non-Railsy Ruby projects:

- Loading YAML configuration
- Loading multiple source files at once
- Setting up a syslogger
- etc.

## Example

Say you have a project with the following structure:

```shell
my_project/
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
Bootloader.logger 'my_project' # => #<Logger>
```
