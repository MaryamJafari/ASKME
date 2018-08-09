const functions = require('firebase-functions');

const request = require('request-promise')

exports.indexPostsToElastic = functions.database.ref('/Messages/{message_id}')
	.onWrite(event => {
		let postData = event.data.val();
		let message_id = event.params.message_id;
		
		console.log('Indexing post:', postData);
		
		let elasticSearchConfig = functions.config().elasticsearch;
		let elasticSearchUrl = elasticSearchConfig.url + 'messages/message/' + message_id;
		let elasticSearchMethod = postData ? 'POST' : 'DELETE';
		
		let elasticSearchRequest = {
			method: elasticSearchMethod,
			url: elasticSearchUrl,
			body: postData,
			json: true
		  };
		  
		  return request(elasticSearchRequest).then(response => {
			 console.log("ElasticSearch response", response);
		  });
	});

==========================
firebase deploy --only functions
==========================
https://search-askme-sjsu2018-zhy7hhcolubrnazpqdzj23kpj4.us-west-1.es.amazonaws.com/

npm install -g firebase-tools
firebase login
firebase init functions
npm install --save request request-promise
firebase functions:config:set elasticsearch.url="https://search-askme-sjsu2018-zhy7hhcolubrnazpqdzj23kpj4.us-west-1.es.amazonaws.com/"

firebase functions:config:set elasticsearch.url="https://search-askme-sjsu2018-zhy7hhcolubrnazpqdzj23kpj4.us-west-1.es.amazonaws.com/"
