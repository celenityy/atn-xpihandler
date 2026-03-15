# ATN-XPIHandler

ATN-XPIHandler is a basic extension to support add-on installation from [`addons.thunderbird.net`](https://addons.thunderbird.net/), without requiring the privileged `mozAddonManager` API.

It works by simply removing the `content-disposition` header for `.xpi` files downloaded from [`addons.thunderbird.net`](https://addons.thunderbird.net/).

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

# Usage Guide

The recommended way to use ATN-XPIHandler is via [Dove](https://dove.celenity.dev/), where it is installed by default. **That being said**, with a little set-up, ATN-XPIHandler can *also* be used on standard Thunderbird installations:

**1**. You'll first want to navigate to [`about:config`](about:config).
    - You can get here by navigating to Thunderbird's `Settings` -> `General`, scrolling down to the very bottom, and selecting the `Config Editor...` button.

**2**. Once there, you'll want to modify the following preferences:
    - `extensions.webapi.enabled` -> `false`
    - `privacy.resistFingerprinting.block_mozAddonManager` -> `true`

**3**. You will also need to remove `,addons.thunderbird.net` from the value of `extensions.webextensions.restrictedDomains`

**4**. To ensure that only reputable extensions can run on `addons.thunderbird.net`, set it as a [`quarantined`](https://support.mozilla.org/kb/quarantined-domains) domain instead with the following preferences:
    - `extensions.remoteSettings.disabled` -> `true`
        - This preference will be hidden by default, so you'll need to manually create it.
        - It's necessary to ensure that our list of quarantined domains isn't overridden remotely.
    - `extensions.quarantinedDomains.enabled` -> `true` *(Default)*
    - `extensions.quarantinedDomains.list` -> `addons.thunderbird.net`

**5**. You should now proceed to install the extension *(Feel free to skip to the step **6** if you've already installed it)*.
    - The simplest way to do this is by navigating to [`https://addons.thunderbird.net/addon/atn-xpihandler/`](https://addons.thunderbird.net/addon/atn-xpihandler/) from within your web browser, selecting `Download Now`, and saving the `.xpi` file locally to your device.
    - From within Thunderbird, you should then navigate to [`about:addons`](about:addons).
        - You can get here by navigating to Thunderbird's `Settings` -> `Add-ons and Themes` *(located on the bottom left)*.
    - From the `Extensions` panel, select the gear to the right of `Manage Your Extensions`, select `Install Add-on From File...`, and select the `.xpi` file we previously downloaded. Be sure to select `Add` when prompted.

**6**. After installation is complete, from the `Extensions` panel of [`about:addons`](about:addons), navigate to `ATN-XPIHandler` -> `Details`, and select `Allow` to the right of `Run on sites with restrictions`.

**7**. Finally, from the same place, select `Permissions`, and ensure that the `Optional` permission to `Access your data for https://addons.thunderbird.net` is granted.

**NOTE**: Because we have now set `addons.thunderbird.net` as a quarantined domain, you will need to repeat step **`6`** for any extension that you'd like to be able to run on `addons.thunderbird.net`, such as content blockers.

# Privacy and Security Consideration

As the purpose of ATN-XPIHandler is to improve privacy and security for users, it is designed with privacy and security in mind:

- ATN-XPIHandler can only access [`addons.thunderbird.net`](https://addons.thunderbird.net/).
    - Specifically, it can only access URLs that match the pattern: `https://addons.thunderbird.net/user-media/addons/_attachments/*`.
- ATN-XPIHandler is a very basic, minimal extension.
    - It is only made up of two files: [`background.js`](/extension/background.js) and [`manifest.json`](/extensions/manifest.json).
- ATN-XPIHandler is signed/reviewed by Mozilla *(unlike a majority of Thunderbird extensions)*.
- ATN-XPIHandler only requires the following permissions: `webRequest` and `webRequestBlocking`.
- ATN-XPIHandler uses [Manifest V3](https://blog.mozilla.org/addons/2022/05/18/manifest-v3-in-firefox-recap-next-steps/).

# Build (Package)

To "build"/package ATN-XPIHandler, from the **root** of the ATN-XPIHandler repository, simply run:

```sh
bash -x scripts/package.sh
```

And enjoy! :)

# Licensing

Contents of this repo are licensed under the [Mozilla Public License 2.0](https://spdx.org/licenses/MPL-2.0.html) *(`MPL-2.0`)* where applicable.

[`background.js`](/extension/background.js) is derived from [`SimpleModifyHeaders`](https://github.com/didierfred/SimpleModifyHeaders/blob/996d485599295e3b4a1b9662b1e4f3232437155e/background.js), which is licensed under the [Mozilla Public License 2.0](https://spdx.org/licenses/MPL-2.0.html) *(`MPL-2.0`)*.  See [`README`](https://github.com/didierfred/SimpleModifyHeaders/blob/2339b8a57bf824659e8f136c083e2dfd33a2f563/README.md#license).
