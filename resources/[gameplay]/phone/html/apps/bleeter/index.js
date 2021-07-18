Template = undefined;
LastNode = undefined;

$(document).ready(function() {

});

window.addEventListener("message", async function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.messages != undefined) {
		payload.messages.reverse();
		for (var message of payload.messages) {
			await addMessage(message.name, message.message);
		}
	}

	var message = payload.message;
	if (message != undefined) {
		await addMessage(message.name, message.message);
	}
});

$("#message-input").on("change keyup paste", function() {
	var value = $(this).val();
	var length = value.length;
	document.querySelector("#send-message").style.display = length > 0 && length <= 255 ? "block" : "none";
	document.querySelector("#char-left").innerHTML = 255 - length;
});

$("#send-message").on("click", function() {
	var input = document.querySelector("#message-input");
	var value = input.value;
	input.value = "";

	$.post("http://phone/sendMessage", JSON.stringify({
		target: -1,
		type: "tweet",
		message: value,
	}));

	$(this).css("display", "none");
	document.querySelector("#char-left").innerHTML = 255;
})

async function addMessage(title, text) {
	if (Template == undefined) {
		Template = document.querySelector("#template");
	}

	// Create the instance.
	var instance = Template.cloneNode(true);
	var textElement = instance.querySelector("#text");

	instance.style.display = "block";
	instance.querySelector("#title").innerHTML = `@${title}`;
	textElement.innerHTML = text;
	if (LastNode) {
		Template.parentNode.insertBefore(instance, LastNode);
	} else {
		Template.parentNode.appendChild(instance);
	}
	LastNode = instance;

	embed(textElement);
}