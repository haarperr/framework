function post(callback, payload) {
	fetch(`https://${GetParentResourceName()}/${callback}`, {
		method: "POST",
		headers: { "Content-Type": "application/json; charset=UTF-8" },
		body: JSON.stringify(payload)
	})
}

document.addEventListener("DOMContentLoaded", function() {
	post("init")
})

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.eval) {
		eval(data.eval)
	}
})