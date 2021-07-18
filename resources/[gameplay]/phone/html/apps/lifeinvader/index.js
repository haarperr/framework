Template = undefined;
LastNode = undefined;
Instances = {}

$(document).ready(function() {
	
});

window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.messages != undefined) {
		for (var i in payload.messages) {
			var message = payload.messages[i];
			addMessage(message.name, message.message, message.number);
		}
	}

	var message = payload.message;
	if (message != undefined) {
		addMessage(message.name, message.message, message.number);
	}

	var remove = payload.remove;
	if (remove != undefined && Instances[remove]) {
		if (Instances[remove] == LastNode) {
			LastNode = undefined;
		}
		Instances[remove].remove()
		Instances[remove] = undefined;
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

	$.post("http://phone/updateAd", JSON.stringify({
		message: value,
	}));

	$(this).css("display", "none");
	document.querySelector("#char-left").innerHTML = 255;
})

$("#delete-message").on("click", function() {
	var input = document.querySelector("#message-input");
	var value = input.value;
	input.value = "";

	$.post("http://phone/updateAd");

	$("#send-message").css("display", "none");
	document.querySelector("#char-left").innerHTML = 255;
})

function addMessage(name, text, number) {
	if (Template == undefined) {
		Template = document.querySelector("#template");
	}

	var instance = Instances[number] || Template.cloneNode(true);
	instance.id = `instance-${number}`
	instance.style.display = "block";
	instance.querySelector("#name").innerHTML = name;
	instance.querySelector("#text").innerHTML = text;
	instance.querySelector("#number").innerHTML = number;
	if (LastNode != undefined) {
		Template.parentNode.insertBefore(instance, LastNode);
	} else {
		Template.parentNode.appendChild(instance);
	}
	LastNode = instance;
	Instances[number] = instance;

	embed(instance.querySelector("#text"));
}