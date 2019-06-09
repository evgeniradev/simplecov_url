# SimplecovUrl

The gem publishes Simplecov's test coverage reports to your_url/simplecov.

If you want to restrict the controller to specific Rails environments, please set their names in the **ALLOWED_SIMPLECOV_ENVIRONMENTS** environment variable.

Example:

```
ALLOWED_SIMPLECOV_ENVIRONMENTS=development,test
```

## Installation

Add this line to your application's Gemfile:

```
gem 'simplecov_url', '~> 1.0'
```

And execute:

```
$ bundle
```

## Dependencies

```
gem 'rails', '>= 5.0.3'
```

```
gem 'simplecov', '~> 0.16.1'
```

```
gem 'simplecov-html', '~> 0.10.0'
```

## Running the tests

```
$ bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/evgeniradev/simplecov_url](https://github.com/evgeniradev/simplecov_url).

## License

SimplecovUrl is released under the MIT License. See MIT-LICENSE for details.
