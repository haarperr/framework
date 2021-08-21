import Dummy from "./modules/dummy.js"

let dummies = {};

document.addEventListener("DOMContentLoaded", function() {
	const root = document.getElementById("dummy");
	if (root) {
		dummies.main = new Dummy(root);
	}
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.invoke) {
		var dummy = dummies[data.invoke.target ?? false];
		if (!dummy) {
			console.log("create dummy maybe lol");
			return
		}

		if (data.invoke.method) {
			var func = dummy[data.invoke.method];
			if (typeof func === "function") {
				dummy[data.invoke.method](...(data.invoke.args ?? []));
			}
		}
	}
});