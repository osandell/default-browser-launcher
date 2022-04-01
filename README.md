# Default Browser Launcher 

Default Browser Launcher is a set of scripts that ensure specific websites open in particular instances of the Chrome browser. For instance, you can use one instance for mail, calendar, DevOps, GitHub, etc., and another for building/debugging websites. 


This segregation is useful for keeping profiles clean from extensions so they don't interfere with development work, hence necessitating multiple profiles.

The problem this solution addresses is that if a link in a PR or task redirects to a QA site, you may want it to open in the development instance of Chrome. Manual URL copy-pasting isn't efficient, which is where this repo comes in.

This repo circumvents certain Chrome limitations using 3 components:

* A Mac application, `DefaultBrowserLauncher`, that redirects to the correct Chrome instance.
* A `socket.io` server that opens `DefaultBrowserLauncher.app` (since the extension can't directly do it).
* A Chrome extension that hooks into page loads and sends a message to our `socket.io` server.

Currently the routing part is written in AppleScript so only Mac compatible, but I'll soon port it to Linux.

## Set Up 

1. **Clone Chrome for multiple instances**: Each instance is set to launch with a specific profile. To clone Chrome for example to a 'Dev' profile, use:

    ```
    clone-chrome.sh Dev
    ```

2. **Install `defaultbrowser` utility**: This utility is used to set the default browser. Install it with Homebrew:

    ```
    brew install defaultbrowser
    ```

3. **Run `DefaultBrowserLauncher.app`**: Running it once makes Mac OS aware of it. Then, set it as the default browser with:

    ```
    defaultbrowser DefaultBrowserLauncher
    ```

4. **Modify `redirections.json`**: Adjust this file to specify the list of URLs to redirect to which browser.

5. **Install the Chrome extension**: This extension should be installed in instances of Chrome where you want to redirect certain links. To install the extension, open the Chrome extension manager and select 'Load unpacked'.

6. **Install and run PM2 for the server**: To keep the server running on reboot, install PM2. Then, start the server with `pm2 ./server/server.js` and save it for auto-start on reboot with `pm2 save`.

