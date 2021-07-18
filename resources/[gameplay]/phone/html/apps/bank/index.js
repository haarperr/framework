window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.balance) {
		document.querySelector("#balance").innerHTML = `$${formatNumber(payload.balance)}`;
	}
});