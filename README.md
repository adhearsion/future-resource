# FutureResource

future-resource allows you to wait on a final value being set for a placeholder, which may occur asynchronously.

## Installation
    gem install future-resource

## Usage

```ruby
require 'future-resource'

fr = FutureResource.new

Thread.new do
  sleep 10
  fr.resource = :foo
end

p fr.set_yet?
p fr.resource
```

You will see `false` printed first, followed by a delay before `:foo` is printed

## Links:
* [Source](https://github.com/adhearsion/future-resource)
* [Documentation](http://rdoc.info/github/adhearsion/future-resource/master/frames)
* [Bug Tracker](https://github.com/adhearsion/future-resource/issues)

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  * If you want to have your own version, that is fine but bump version in a commit by itself so I can ignore when I pull
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Jay Phillips. MIT licence (see LICENSE for details).
