Template = undefined;
TemplateSelf = undefined;
Name = "";
Target = undefined;

window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.name != undefined) {
		// console.log("payload " + payload);
		Name = payload.name;
	}
	
	if (payload.target != undefined) {
		Target = payload.target;
	}

	if (payload.target || payload.name) {
		$(".app-title")[0].innerHTML = payload.name || payload.target;
	}
	
	if (payload.messages != undefined) {
		payload.messages.reverse();
		for (var message of payload.messages) {
			// console.log(">< " + JSON.stringify(message));
			addMessage(message[1], message[2], message[3]);
		}
		scrollToBottom();
	}

	var message = payload.message;
	if (message != undefined && message.target == Target) {
		// console.log("adding new message " + JSON.stringify(message));
		addMessage(message.text, message.timestamp, message.isSelf);
		scrollToBottom();
	}
});

function addMessage(message, timestamp, isSelf) {
	// Cache the template.
	if (Template == undefined) {
		Template = $("#message")[0];
		Template.id = "message-template";
	}
	if (TemplateSelf == undefined) {
		TemplateSelf = $("#message-self")[0];
		TemplateSelf.id = "message-self-template";
	}

	var template = isSelf ? TemplateSelf : Template;

	// Create the preview.
	var node = template.cloneNode(true);
	node.style.display = "flex";
	template.parentNode.appendChild(node);

	var date = new Date(timestamp);

	// Set values.
	if (!isSelf) {
		node.querySelector("#pfp").innerHTML = formatInitials(Name);;
	}

	node.querySelector("#text").innerHTML = message;
	node.querySelector("#timestamp").innerHTML = `${date.getMonth()}/${date.getDate()}/${date.getFullYear()} - ${date.getHours()}:${date.getMinutes()}`;

	embed(node.querySelector("#text"));
}

function sendDm() {
	var messageInput = document.querySelector("#message-text");
	var message = messageInput.value;

	if (message == undefined || message == "") {
		return;
	}

	sendMessage(Target, "text", message);
	messageInput.value = "";
}

function scrollToBottom() {
	$(".contact")[$(".top")[0].children.length -1].scrollIntoView();
}