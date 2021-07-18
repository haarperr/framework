const options = {
	default: {
		angle: 0.3,
		lineWidth: 0.08,
		radiusScale: 0.5,
		pointer: {
			length: 0.0,
			strokeWidth: 0.0,
		},
		limitMax: true,
		limitMin: true,
		colorStart: "rgba(50, 140, 240, 1.0)",
		strokeColor: "rgba(20, 120, 220, 0.5)",
		highDpiSupport: true,
	},
	fuel: {
		angle: 0.35,
		lineWidth: 0.06,
		radiusScale: 0.6,
		pointer: {
			length: 0.0,
			strokeWidth: 0.0,
		},
		limitMax: true,
		limitMin: true,
		colorStart: "rgba(240, 160, 40, 1.0)",
		strokeColor: "rgba(150, 100, 20, 0.5)",
		highDpiSupport: true,
		renderTicks: {
			divisions: 4,
			divWidth: 2.0,
			divLength: 1.0,
			divColor: "rgba(0, 0, 0, 0.7)",
			subDivisions: 2,
			subLength: 0.5,
			subWidth: 2.0,
			subColor: "rgba(0, 0, 0, 0.5)"
		},
	},
	rpm: {
		angle: 0.35,
		lineWidth: 0.06,
		radiusScale: 0.6,
		pointer: {
			length: 0.0,
			strokeWidth: 0.0,
		},
		limitMax: true,
		limitMin: true,
		colorStart: "rgba(0, 200, 255, 1.0)",
		strokeColor: "rgba(0, 100, 128, 0.5)",
		highDpiSupport: true,
		renderTicks: {
			divisions: 4,
			divWidth: 2.0,
			divLength: 1.0,
			divColor: "rgba(0, 0, 0, 0.7)",
			subDivisions: 2,
			subLength: 0.5,
			subWidth: 2.0,
			subColor: "rgba(0, 0, 0, 0.5)"
		},
	},
};

var gauges = {};

document.addEventListener("DOMContentLoaded", function() {
	var radials = document.querySelectorAll(".radial");

	for (var radial of radials) {
		var gauge = new Gauge(radial);
		gauge.setOptions(options.default);

		var idOptions = options[radial.id];
		if (idOptions) {
			gauge.setOptions(idOptions);
		}

		gauge.maxValue = idOptions?.maxValue ?? 100;
		gauge.setMinValue(0);
		gauge.animationSpeed = 16;

		gauges[radial.id] = gauge
	}

	document.querySelector("#vehicle").style.display = "none";
	document.querySelector("#content").style.display = "none";
	
	// setScoreboard([
	// 	{ name: "LSSD", count: "Heavy" },
	// 	{ name: "LSPD", count: "Medium" },
	// 	{ name: "DPS", count: "None" },
	// 	{ name: "Mechanic", count: "Heavy" },
	// 	{ name: "Paramedic", count: "Medium" },
	// 	{ name: "Doctor", count: "Medium" },
	// ]);
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.commit) {
		var func = window[data.commit.type];
		if (func) {
			func(data.commit.data)
		}
	}
});

function setAnchor(anchor) {
	var width = window.screen.width;
	var height = window.screen.height;

	var element = document.querySelector("#minimap");
	element.style.width = `${anchor.height * height}px`;
	element.style.height = `${anchor.height * height}px`;
	
	element.style.left = `${anchor.left * width}px`;
	element.style.bottom = `${anchor.bottom * height}px`;

	element.style.top = `auto`;
	element.style.right = `auto`;

	// document.querySelector("#aspect-error").style.display = anchor.aspectError ? "flex" : "none";
}

function setBearing(data) {
	var compass = document.querySelector("#minimap #spinner");
	if (compass) {
		compass.style.transform = `rotate(${data.heading}deg)`;
	}
	var bearing = document.querySelector("#bearing");
	if (bearing) {
		bearing.textContent = `${Math.floor(360.0 - data.heading)}°`;
	}
}

function setText(data) {
	var element = document.querySelector(`#${data.element}`);
	if (element) {
		element.innerHTML = data.text;
	}
}

function setBar(data) {
	var gauge = gauges[data?.id ?? false];
	if (gauge == undefined) return;

	gauge.set(data?.value ?? 0);
}

function addIcon() {
	
}

function setDisplay(data) {
	document.querySelector(`#${data.target}`).style.display = data?.value ? (data.target == "air" ? "flex" : "block") : "none";
}

function setScoreboard(factions) {
	var scoreboard = document.querySelector("#scoreboard");
	scoreboard.style.display = "flex";
	scoreboard.innerHTML = "";

	for (var i in factions) {
		var faction = factions[i];
		var div = document.createElement("div");
		var nameSpan = document.createElement("span");
		var countSpan = document.createElement("span");

		nameSpan.innerHTML = faction.name;
		countSpan.innerHTML = faction.count;

		div.appendChild(nameSpan);
		div.appendChild(countSpan);

		scoreboard.appendChild(div);
	}
}

function hideScoreboard() {
	var scoreboard = document.querySelector("#scoreboard");
	scoreboard.style.display = "none";
}