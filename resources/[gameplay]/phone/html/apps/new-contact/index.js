$(document).ready(function() {
	
});

window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (payload != undefined) {
		$("#contact-name").val(payload.name || "");
		$("#contact-number").val(payload.number || "");
		$("#contact-number").prop("disabled", payload.number != undefined)
	}
});

function saveContact() {
	$.post("http://phone/saveContact", JSON.stringify({
		name: document.querySelector("#contact-name").value,
		number: (document.querySelector("#contact-number").value || "").replace(/[^0-9]+/g, ''),
	}));
	closeApp(false, false, false);
}

function deleteContact() {
	$.post("http://phone/deleteContact", JSON.stringify({
		number: document.querySelector("#contact-number").value,
	}));
	closeApp(false, false, false);
}