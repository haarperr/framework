var Enabled = true;
var Queue = []
var HasEnded = true;

window.addEventListener("message", function(event) {
	var data = event.data;
	if (data.type == "addSegment") {
		var info = data.info
		var dispatchPlaylist = [];
		var dispatchVolume = data.volume / 15;

		var onLoad = function(index) {
			dispatchPlaylist.push("./assets/sounds/" + info[index] + ".ogg")
		}

		for (sound in info) {
			var audio = new Howl({ src: "./assets/sounds/" + info[sound] + ".ogg", onload: onLoad(sound), buffer: true, volume: dispatchVolume })
		}

		Queue.push(
			function(e) {
				pCount = 0;
				pCountReal = dispatchPlaylist.length + 1;
				dispatchList = dispatchPlaylist;
				howlerBank = [],
				loop = false;
				HasEnded = false;

				var onEnd = function(e) {
					pCount = pCount + 1;
					if (pCount <= dispatchPlaylist.length) {
						if (pCountReal - 1 === pCount) {
							Queue.shift();
							HasEnded = true;
							pCountReal = 0;
						} else {
							howlerBank[pCount].play();
						}
					}
				};

				dispatchList.forEach(function(current, i) {
					howlerBank.push(new Howl({ src: [dispatchList[i]], onend: onEnd, buffer: true, volume: dispatchVolume }))
				});
				howlerBank[0].play();
			}
		);
	}
})

function TriggerDispatch() {
	if (Enabled === true) {
		if (Queue.length > 0 && HasEnded === true) {
			Queue[0]();
		}
	}
}

Timer = setInterval(function() { TriggerDispatch() }, 1000)