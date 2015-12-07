Parse.Cloud.afterSave("bookChatMessages", function(request) {

   console.log("afterSave: bookChatMessages");

   var message = {
      objectId: request.object.get('objectId'),
      bookChatId: request.object.get('bookChatId'),
      createdAt: request.object.get('createdAt'),
      senderId: request.object.get('senderId'),
      senderDisplayName: request.object.get('senderDisplayName'),
      text: request.object.get('text')
   };

   console.log("afterSave: bookChatMessages", message);

   Parse.Push.send({
         channels: [ message.bookChatId ],
         data: {
            alert: "Book chat update available"
         }
      }, {
         success: function() {
            console.log("success: bookChatId=" + message.bookChatId +
               "; objectId=" + message.objectId +
               "; text=" + message.text);
         },
         error: function(error) {
            console.log("error:" + error.code + "; " + error.message);
      }
   });
});
