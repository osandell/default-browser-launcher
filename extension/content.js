// This script will be run on every page the user visits. It will check if the
// current URL is whitelisted for Chrome Dev and if so, it will send the URL to
// the server via a WebSocket connection. The server will then redirect the
// user to the URL in Chrome Dev.

var socket = io.connect("http://localhost:58347");

fetch(chrome.runtime.getURL("redirections.json"))
  .then((response) => response.json())
  .then((browserRedirections) => {
    const chromeDev = browserRedirections.find(
      (redirection) => redirection.browser === "Google Chrome Dev"
    );

    const isWhitelistedForChromeDev = chromeDev.urlsWhitelist.some(
      (whitelistItem) => window.location.href.includes(whitelistItem)
    );

    const isBlacklistedForChromeDev = chromeDev.urlsBlacklist.some(
      (blacklistItem) => window.location.href.includes(blacklistItem)
    );

    if (isWhitelistedForChromeDev && !isBlacklistedForChromeDev) {
      socket.send(window.location.href);

      setTimeout(() => {
        window.close();
      }, 100);
    }
  });
