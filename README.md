# Concerto Player

Concerto Player is an experimental new frontend for
[Concerto Digital Signage](https://www.concerto-signage.org/) written in Flutter.

It aims to provide a cross-platform screen player that is easier to maintain
than the existing stack by bundling all content types into the same package
instead of relying on the post-distribution plugin process of the prior
Concerto V2 frontends.

This is _not_ ready for production use.

## Target Platforms

One of the benefits of Flutter is that the same codebase can develop nearly
native experiences on a variety of platforms. The player targets:

1. Web, to provide compatability with the existing frontend platform.
2. Android, to support tablets and TV devices.
3. Everything else.