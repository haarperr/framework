window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (payload != undefined) {
		if (payload.number) {
			document.querySelector("#number").innerHTML = `My Number: ${formatPhoneNumber(payload.number)}`;
		}
	}
});