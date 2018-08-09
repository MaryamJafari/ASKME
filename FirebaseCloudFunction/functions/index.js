const functions = require('firebase-functions');
const request = require('request-promise')
let admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// exports.indexPostsToElastic = functions.database.ref('/Messeges/{message_id}')
// 	.onWrite((change, context) => {
// 		let postData = change.after.val();
// 		let message_id = context.params.message_id;
		
// 		console.log('Indexing post:', postData);
		
// 		let elasticSearchConfig = functions.config().elasticsearch;
// 		let elasticSearchUrl = elasticSearchConfig.url + 'messages/message/' + message_id;
// 		let elasticSearchMethod = postData ? 'POST' : 'DELETE';
		
// 		let elasticSearchRequest = {
// 			method: elasticSearchMethod,
// 			url: elasticSearchUrl,
// 			body: postData,
// 			json: true
// 		  };
		  
// 		  return request(elasticSearchRequest).then(response => {
// 			 console.log("ElasticSearch response", response);
// 		  });
// 	});

exports.sendPushNotification = functions.database.ref('/Messages/{message_id}')
	.onWrite((change, context) => {
		let token = change.after.val().Notification_Token;
		let FromEmail = change.after.val().sender_Name;
		let text = change.after.val().text;
		let payload = {
	            notification: {
	                title: '[' + FromEmail + '] to your message:',
	                body: text,
	                sound: 'default',
	                badge: '0'
	            }
	    };
	    console.log("Token is:", token);
	    console.log("FromEmail is:", FromEmail);
	    return admin.messaging().sendToDevice(token, payload);
	});

