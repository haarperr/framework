// Config.
var invalidColor = "rgba(220, 220, 220, 0.4)";
var validColor = "rgba(255, 255, 255, 0.8)";
var startAudio = new Audio("assets/start.ogg");

var randomKeys = [
	"1",
	"2",
	"3",
	"B",
	"C",
	"E",
	"F",
	"G",
	"Q",
	"R",
	"V",
	"X",
	"Z",
];

var keysCache = {}
for (var key of randomKeys) {
	keysCache[key] = true
}

// Cache.
let bar = undefined;
let context = undefined;
let end = undefined;
let lastPress = undefined;
let maxPosition = undefined;
let position = undefined;
let progress = undefined;
let randomKey = undefined;
let rootNode = undefined;
let start = undefined;
let startTime = undefined;
var lastTimeout = undefined;

// Events.
$(document).ready(() => {
	context = document.querySelector("#context");
	// window.postMessage({ type: "linear", size: 20.0 });
});

window.addEventListener("message", function(event) {
	var data = event.data;
	if (!data) return;

	if (data.type) {
		init(data.type, data.size || 10.0);
	}
});

// document.addEventListener("keydown", function(event) {
// 	if (!event) return;
	
// 	lastPress = event.key;
// 	console.log(lastPress);
// });

// Functions.
function init(rootName, size) {
	if (lastTimeout) {
		clearTimeout(lastTimeout);
		lastTimeout = null;
	}

	$("body").stop(true, true);
	$("body").fadeIn(500);

	rootNode = document.querySelector("#" + rootName);
	progress = rootNode.querySelector("#progress");
	bar = rootNode.querySelector("#bar");
	
	// Gradient bars.
	start = Math.floor(25.0 + Math.random() * (75.0 - size));
	end = Math.floor(start + size);
	
	progress.style.backgroundImage = `linear-gradient(90deg, ${invalidColor} 0%, ${invalidColor} ${start}%, ${validColor} ${start}%, ${validColor} ${end}%, ${invalidColor} ${end}%)`;
	bar.style.backgroundColor = "black";
	bar.style.left = "0%";
	
	// Timing and positioning.
	position = 0.0;
	barRatio = bar.clientWidth / progress.clientWidth * 100.0;
	maxPosition = 100.0 - (barRatio);
	
	// Random key to press.
	randomKey = randomKeys[Math.floor(Math.random() * randomKeys.length)];
	context.innerHTML = randomKey;

	// Audio.
	startAudio.volume = 0.2;
	startAudio.play();
	
	setTimeout(() => {
		process();
	}, 1000);
}

function process() {
	lastPress = undefined;
	startTime = new Date().getTime();
	
	document.addEventListener("keydown", onKeydown);

	var interval = setInterval(() => {
		let time = new Date().getTime();
		let delta = (time - startTime) / 1000.0;

		position = Math.min(position + Math.pow(delta, 4.0) * 0.5, maxPosition);
		// position = Math.min(position + delta * 0.1, maxPosition);

		if (Math.ceil(position) >= maxPosition || lastPress != undefined) {
			if ((lastPress || "").toLowerCase() == randomKey.toLowerCase() && position > start - (barRatio) && position < end) {
				bar.style.backgroundColor = "rgb(0, 255, 0)";

				$.post("http://quickTime/finish", JSON.stringify({ status: true }));
			} else {
				bar.style.backgroundColor = "rgb(255, 0, 0)";
				
				$.post("http://quickTime/finish", JSON.stringify({ status: false }));
			}

			document.removeEventListener("keydown", onKeydown);

			clearInterval(interval);
			
			lastTimeout = setTimeout(() => {
				$("body").fadeOut(500);
				// init(rootName, size);
			}, 1000);
		}

		bar.style.left = `${position}%`;
	}, 0);
}

function onKeydown(event) {
	if (!event || !keysCache[event.key.toUpperCase()]) return;
	
	lastPress = event.key;
}