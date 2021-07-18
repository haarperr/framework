Template = undefined;
RequestId = -1;

window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (payload && payload.messages) {
		payload.messages.sort(function(a, b) {
			return b[2] - a[2];
		});
		for (var message of payload.messages) {
			addMessage(message[4], message[0], message[1], message[2]);
		}
	}
});

function addMessage(name, number, preview, timestamp) {
	// Cache the template.
	if (Template == undefined) {
		Template = $("#message")[0];
		Template.id = "message-template";
	}

	// Create the preview.
	var node = Template.cloneNode(true);
	node.style.display = "flex";
	Template.parentNode.appendChild(node);

	// Get the time difference.
	var currentDate = new Date();
	var date = new Date(timestamp);
	var interval = 0;
	var suffix = "";

	var seconds = Math.floor((currentDate - date) / 1000);
	var minutes = Math.floor(seconds / 60);
	var hours = Math.floor(minutes / 60);
	var days = Math.floor(hours / 24);
	var months = Math.floor(days / 30);
	var years = Math.floor(months / 12);
	
	var timestamp = "";
	if (seconds < 30) {
		timestamp = "Just now";
	} else if (seconds < 60) {
		interval = seconds.toFixed(0)
		suffix = "second";
	} else if (minutes < 60) {
		interval = minutes.toFixed(0)
		suffix = "minute";
	} else if (hours < 24) {
		interval = hours.toFixed(0)
		suffix = "hour";
	} else if (months > 0 && years < 1) {
		interval = months.toFixed(0)
		suffix = "month";
	} else if (years > 0) {
		interval = years.toFixed(0)
		suffix = "year";
	} else {
		interval = days.toFixed(0)
		suffix = "day";
	}

	if (interval != 0) {
		timestamp = `${interval} ${suffix}${interval > 1 ? "s" : ""} ago`;
	}

	// Set values.
	node.querySelector("#name").innerHTML = name || number;
	node.querySelector("#pfp").innerHTML = name == undefined ? "??"  : formatInitials(name);;
	node.querySelector("#preview").innerHTML = preview;
	node.querySelector("#timestamp").innerHTML = timestamp;

	// Click events.
	node.onclick = function() {
		openApp("messages-dm", undefined, {
			number: number,
		});
	}
}