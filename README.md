# ATN-XPIHandler

ATN-XPIHandler is a basic extension to support add-on installation from [`addons.thunderbird.net`](https://addons.thunderbird.net/), without requiring the privileged `mozAddonManager` API.

It works by simply removing the `content-disposition` header for `.xpi` files downloaded from [`addons.thunderbird.net`](https://addons.thunderbird.net/).

# Privacy and Security Consideration

As the purpose of ATN-XPIHandler is to improve privacy and security for users, it is designed with privacy and security in mind:

- ATN-XPIHandler can only access [`addons.thunderbird.net`](https://addons.thunderbird.net/).
    - Specifically, it can only access URLs that match the pattern: `https://addons.thunderbird.net/user-media/addons/_attachments/*`.
- ATN-XPIHandler is a very basic, minimal extension.
    - It is only made up of two files: [`background.js`](/extension/background.js) and [`manifest.json`](/extensions/manifest.json).
- ATN-XPIHandler is signed/reviewed by Mozilla *(unlike a majority of Thunderbird extensions)*.
- ATN-XPIHandler only requires the following permissions: `webRequest` and `webRequestBlocking`.
- ATN-XPIHandler uses [Manifest V3](https://blog.mozilla.org/addons/2022/05/18/manifest-v3-in-firefox-recap-next-steps/).

# Motivation

Currently, installation of add-ons from [`addons.thunderbird.net`](https://addons.thunderbird.net/) requires use of the privileged `mozAddonManager` API *([1](https://bugzilla.mozilla.org/show_bug.cgi?id=1952390#c4), [2](https://bugzilla.mozilla.org/show_bug.cgi?id=1384330))*. This is problematic from a privacy and security perspective, as it:

- Aids fingerprinting *(by allowing [`addons.thunderbird.net`](https://addons.thunderbird.net/) to query a list of installed add-ons)*.
- Allows [`addons.thunderbird.net`](https://addons.thunderbird.net/) to bypass the usual add-on installation permission checks/gate.
- Breaks add-on installation if JavaScript is disabled.
- Increases attack surface.
- Prevents extensions from working on [`addons.thunderbird.net`](https://addons.thunderbird.net/).
    - This is especially problematic for content blockers, such as [uBird](https://codeberg.org/celenity/uBird).
- Provides [`addons.thunderbird.net`](https://addons.thunderbird.net/) with additional information not otherwise available to websites when installing extensions, such as [download state/progress](https://searchfox.org/firefox-main/rev/16a7dee3/dom/webidl/AddonManager.webidl#35).

[`addons.mozilla.org`](https://addons.mozilla.org/) also uses the `mozAddonManager` API for add-on installation, **however**, unlike [`addons.thunderbird.net`](https://addons.thunderbird.net/), when `mozAddonManager` is disabled, installation of extensions will continue to work as expected, by falling back to the standard mechanisms. This unfortunately doesn't typically work on [`addons.thunderbird.net`](https://addons.thunderbird.net/), due to their decision to set the `content-disposition` header for downloaded `.xpi` files *(See related upstream bug [here](https://github.com/thunderbird/addons-server/issues/332))*.

# Build (Package)

To "build"/package ATN-XPIHandler, from the **root** of the ATN-XPIHandler repository, simply run:

```sh
bash -x scripts/package.sh
```

And enjoy! :)

# Licensing

Contents of this repo are licensed under the [Mozilla Public License 2.0](https://spdx.org/licenses/MPL-2.0.html) *(`MPL-2.0`)* where applicable.

[`background.js`](/extension/background.js) is derived from [`SimpleModifyHeaders`](https://github.com/didierfred/SimpleModifyHeaders/blob/996d485599295e3b4a1b9662b1e4f3232437155e/background.js), which is licensed under the [Mozilla Public License 2.0](https://spdx.org/licenses/MPL-2.0.html) *(`MPL-2.0`)*.  See [`README`](https://github.com/didierfred/SimpleModifyHeaders/blob/2339b8a57bf824659e8f136c083e2dfd33a2f563/README.md#license).
