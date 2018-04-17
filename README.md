# Dark theme for the slack desktop app

## Add code to make slack download your custom CSS

Depending on your distribution, the path to `ssb-interop.js` might differ. Mine
is in `/usr/lib/slack/resources/app.asar.unpacked/src/static/ssb-interop.js`.
Once found, append the following to the file:

```js
document.addEventListener('DOMContentLoaded', function() {
 $.ajax({
   url: 'https://rawgit.com/russellshackleford/slack-dark/master/custom.css',
   success: function(css) {
     $("<style></style>").appendTo('head').html(css);
   }
 });
});
```
