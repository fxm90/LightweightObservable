# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

---

## [Unreleased]
## [2.1.1] - 2020-15-03
### Fixed
 - Fix sending incorrect `oldValue` to filtered observer.

## [2.1.0] - 2020-03-03
### Added
 - Add method `bind(to:on)` to use Swift's KeyPath feature to bind an observable directly to a property.

## [2.0.0] - 2019-28-11
### Added
 - PublishSubject: A new subject type, that starts empty and only emits new elements to subscribers.

### Removed
 - Removed property `asObservable`, as Swift can do the casting automatically.

### Changed
 - Changed type of property `value` from `Observable` to optional. For further details please have a look at the [Lightweight Observable 2.0 Migration Guide
](Documentation/Lightweight%20Observable%202.0%20Migration%20Guide.md)

## [1.0.3] - 2019-22-09
### Added
 - Added support for Swift Package Manager.

## [1.0.2] - 2019-29-08
### Fixed
 - Added missing `public` attribute, so the value of an observable is readable without observing it.

## [1.0.1] - 2019-09-06
### Fixed
 - Fix Carthage build failed due to non shared scheme.

## [1.0.0] - 2019-18-05
- Initial release.


[Unreleased]: https://github.com/fxm90/LightweightObservable/compare/2.1.1...master
[2.1.1]: https://github.com/fxm90/LightweightObservable/compare/2.1.0...2.1.1
[2.1.0]: https://github.com/fxm90/LightweightObservable/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/fxm90/LightweightObservable/compare/1.0.3...2.0.0
[1.0.3]: https://github.com/fxm90/LightweightObservable/compare/1.0.2...1.0.3
[1.0.2]: https://github.com/fxm90/LightweightObservable/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/fxm90/LightweightObservable/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/fxm90/LightweightObservable
