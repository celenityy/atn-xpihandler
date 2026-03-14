/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

'use strict';

addListener();

/*
 * Delete the response header
 *
 */
function rewriteResponseHeader(e) {
    let index = -1;
    for (let i = 0; i < e.responseHeaders.length; i++) {
        if (e.responseHeaders[i].name.toLowerCase() === 'content-disposition') index = i;
    }
    if (index !== -1) {
        e.responseHeaders.splice(index, 1);
    }
    return {responseHeaders: e.responseHeaders};
}

/*
 * Add rewriteResponseHeader as a listener to onHeadersReceived, only for matching ATN URLs.
 * Make it "blocking" so we can modify the headers.
 */
function addListener() {
    chrome.webRequest.onHeadersReceived.addListener(rewriteResponseHeader, {urls: ['https://addons.thunderbird.net/user-media/addons/_attachments/*']}, [
        'blocking',
        'responseHeaders'
    ]);
}
