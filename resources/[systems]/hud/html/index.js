
document.addEventListener("DOMContentLoaded", function() {
	document.querySelector("#vehicle").style.display = "none";
	document.querySelector("#content").style.display = "none";
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

function setFuel(value) {
	var bar = document.querySelector("#fuel-bar");
	var label = document.querySelector("#fuel");

	bar.style.top = `${(1.0 - value) * 30.0 + 70.0}%`
	label.textContent = `${Math.round(value * 100.0)}%`;
}

function addIcon() {
	
}

function setDisplay(data) {
	document.querySelector(`#${data.target}`).style.display = data?.value ? (data.target == "air" ? "flex" : "block") : "none";
}

function setUnderwater(value) {
	var root = document.querySelector("#content");
	if (value) {
		root.classList.add("underwater");
	} else {
		root.classList.remove("underwater");
	}
}