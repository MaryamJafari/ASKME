## Ref : https://firebase.google.com/docs/functions/get-started


## Deploy and test

This sample comes with a web-based UI for testing the function. To test it out:

 1. Create a Firebase Project using the [Firebase Console](https://console.firebase.google.com).
 1. Enable **Google Provider** in the [Auth section](https://console.firebase.google.com/project/_/authentication/providers)
 1. Clone or download this repo and open the `fcm-notification` directory.
 1. You must have the Firebase CLI installed. If you don't have it install it with `npm install -g firebase-tools` and then configure it with `firebase login`.
 1. Configure the CLI locally by using `firebase use --add` and select your project in the list.
 1. Install dependencies locally by running: `cd functions; npm install; cd -`
 1. Deploy your project using `firebase deploy --only functions`
 1. Open the app using `firebase open hosting:site`, this will open a browser.
 1. Start following a user, this will send a notification to him.