# LogStu
`LogStu` is a simple, yet powerful, logging framework that provides built-in themes and formatters and a nice API to define your own.

<p align="center">
    <a href ="#usage">Usage</a> • <a href="#installation">Installation</a> • <a href="#license">License</a>
</p>

### Usage

#### The basics

- Assign a logger in a global context, then use your global variable as you would use `print`.

```swift
let log = Logger()

log.trace("the lightest logging level")
log.debug("some variable is \(someVariable)")
log.info(any, list, of, objects)
log.warning(one, two, three, separator: " - ")
log.error(error, terminator: "😱😱😱\n")
```
<img src="https://github.com/jasnstu/LogStu/blob/master/logsExample.png">

- Disable `LogStu` by setting `enabled` to `false`:

```swift
log.enabled = false
```

- Define a minimum level of severity to only print the messages with a greater or equal severity:

```swift
log.minLevel = .warning
```

> The severity levels are `trace`, `debug`, `info`, `warninig`, and `error`.

#### Customization

- Create your own `Logger` by changing its `Theme` and/or `Formatter`.

A suggested way of doing is is by extending `Formatters` and `Themes`:

```swift
extension Formatters {

    static let detailed = Formatters("[%@] %@.%@:%@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .file(fullPath: false, fileExtension: false),
        .function,
        .line,
        .level,
        .message,
    ])

}

extension Themes {

    static let newEmojis = Theme(trace: Theme.Style(emoji: "☎️"),
                                debug: Theme.Style(emoji: "🐜"),
                                info: Theme.Style(emoji: "💁‍♂️"),
                                warning: Theme.Style(emoji: "⚠️"),
                                error: Theme.Style(emoji: "👿"))

}

let log = Logger(formatter: .detailed, theme: .newEmojis)
```

> See the built-in [formatters](https://github.com/jasnstu/LogStu/blob/master/Source/Formatting/Formatters.swift) and [themes](https://github.com/jasnstu/LogStu/blob/master/Source/Formatting/Themes.swift) for more examples.

Nothing prevents you from creating as many loggers as you want!

```swift
let basic = logger()
let short = logger(formatter: Formatter("%@: %@", .level, .message),
                   theme: .tomorrowNightEighties,
                   minLevel: .info)
```

- Turn off the emoji by setting the theme to `nil`:

```swift
Log.theme = nil
```

#### Advanced

Include a custom `Block` component in your formatter to print its result in every log message: 

```swift
struct User {

    static func token() -> Int {
        return NSUserDefaults.standardUserDefaults.integerForKey("token")
    }

}

Log.formatter = Formatter("[%@] %@: %@", .block(User.token), .level, .message)
```

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate LogStu into your Xcode project using CocoaPods, specify it in your `PodFile`:

```ruby
use_frameworks!

pod 'LogStu'
```

## License

Copyright (c) 2019 jasnstu (http://jasnstu.com))

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
