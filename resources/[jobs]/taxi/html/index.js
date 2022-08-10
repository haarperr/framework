Enabled = false;

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.enabled != undefined) {
		if (data.enabled == Enabled) {
			return;
		}

		Enabled = data.enabled;
		document.querySelector("#main").style.display = Enabled ? "block" : "none" ;
	}

	if (data.fare != undefined) {
		document.querySelector("#fare").innerHTML = `$${data.fare.toFixed(2)}`;
	}

	if (data.rate != undefined) {
		document.querySelector("#rate").innerHTML = `$${data.rate.toFixed(2)}`;
	}
});