import Dummy from "./modules/dummy.js"

let Dummies = {};
let Funcs = {};
let Intervals = {};
let Config = {};

document.addEventListener("DOMContentLoaded", function() {
	post("init");
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.invoke) {
		if (data.invoke.target) {
			var dummy = Dummies[data.invoke.target ?? false];
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
		} else {
			var func = Funcs[data.invoke.method];
			if (func) {
				func(...(data.invoke.args ?? []));
			}
		}
	}
});

Funcs["setOverlay"] = function(id, value) {
	let element = document.querySelector(`.overlays #${id.toLowerCase()}`);
	if (!element) return;

	var interval = Intervals[id];
	if (interval) {
		clearInterval(interval);
	}

	Intervals[id] = setInterval(() => {
		var opacity = parseFloat(element.style.opacity);
		if (isNaN(opacity)) opacity = 0.0;

		var newOpacity = lerp(opacity, value, 0.02);
		
		if (Math.abs(opacity - newOpacity) < 0.001) {
			clearInterval(Intervals[id])
			newOpacity = value;
		}

		element.style.opacity = newOpacity;
	}, 20);
}

Funcs["loadConfig"] = function(data) {
	console.log("load config");
	
	Config = data;

	const root = document.getElementById("dummy");
	if (root) {
		Dummies.main = new Dummy(data, root);
	}
}

function lerp(a, b, t) {
	t = t < 0 ? 0 : t;
	t = t > 1 ? 1 : t;
	return a + (b - a) * t;
};

function post(type, data) {
	try {
		fetch(`https://${GetParentResourceName()}/${type}`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json; charset=UTF-8',
			},
			body: JSON.stringify(data)
		})
	} catch {}
}