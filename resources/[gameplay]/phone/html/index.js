Debug = false;

// Requests = {};
// MessageCache = {};
// AppData = {};
AppOrder = [];
AppWindows = {};
CurrentApp = undefined;
Multiselect = undefined;
FadeTime = 200;
AlertSound = new Audio("./sounds/alert.ogg");
HasAlertSound = {
	["messages"]: true,
}

$(document).ready(function() {
	addApp("app-bar", "phone");
	addApp("app-bar", "contacts");
	addApp("app-bar", "messages");
	addApp("app-bar", "options");

	addApp("apps", "lifeinvader", "Life Invader");
	addApp("apps", "bank", "Banking");
	addApp("apps", "bleeter", "Bleeter");
	addApp("apps", "properties", "Properties");
	addApp("apps", "jobs", "Jobs");
	addApp("apps", "vehicles", "Vehicles");
	addApp("apps", "racing", "Racing");

	if (Debug) {
		window.postMessage({ display: true, setTime: true,
			setTime: true,
			minutes: 30,
			hours: 12,
			weekday: "Monday",
			day: 2,
			month: 12,
			year: 1969,
		});

		openApp("racing", {
			
		});
	}

	// openApp("bleeter")
	// addNotification("Person Name", "Messaging you lol", "messages");
	// addNotification("Something else", "Idk https://cdn.betterttv.net/emote/583089f4737a8e61abb0186b/3x");
	// addNotification("Incoming Call", "69696969", "phone");
	// openApp("messages-dm", {
	// 	appData: {
	// 		name: "Mediner",
	// 		number: 8454411281,
	// 	},
	// });

	// openApp("jobs", { factions: [
	// 	{
	// 		job: {
	// 			Name: "Test Job",
	// 		},
	// 		rank: 1,
	// 		level: 1,
	// 	},
	// ] });
	// openApp("jobs-info", { job: JSON.parse('{"Clocks":[{"x":1836.724609375,"y":2589.686279296875,"z":45.95234298706055},{"x":1789.9520263671876,"y":2548.165283203125,"z":45.797828674316409}],"Vehicles":[{"Coords":[{"x":1834.5264892578126,"y":2542.110107421875,"z":45.871665954589847,"w":269.2328796386719}],"Extras":[true,true,null,null,true,null,true,null,null,null,true],"In":{"x":1828.4527587890626,"y":2539.071533203125,"z":45.8806037902832},"Rank":0,"PrimaryColor":111,"Model":"06tahoe"},{"Coords":[{"x":1845.020751953125,"y":2529.9638671875,"z":46.47146987915039,"w":358.4324951171875}],"Model":"coach","In":{"x":1840.2677001953126,"y":2529.259033203125,"z":45.67201614379883},"Rank":0},{"Coords":[{"x":1833.6126708984376,"y":2559.674072265625,"z":45.67201614379883,"w":268.8992919921875},{"x":1844.60400390625,"y":2559.732421875,"z":45.67201614379883,"w":270.42413330078127}],"Extras":[true,null,null,true,true,null,true,true],"In":{"x":1829.0782470703126,"y":2554.73388671875,"z":47.213706970214847},"Rank":0,"Model":"vic"}],"Pay":75,"Ranks":{"Corporal":30,"Warden":100,"Lieutenant":50,"Deputy Warden":90,"Corrections Officer II":20,"Sergeant":40,"Captain":60,"Corrections Officer I":10,"Probationary Corrections Officer":0},"Max":7,"Master":["Judge"],"Name":"DOC","ControlAt":10,"Tracker":{"SecondaryColor":34,"Color":8,"LabelColor":"HUD_COLOUR_PINK","Group":"emergency"},"Group":"Emergency"}') });
	
	// openApp("phone-call", {
	// 	appData: {
	// 		state: "Incoming Call",
	// 		number: 1234567890
	// 	}
	// });
});

window.addEventListener("message", function(event) {
	var data = event.data;

	// Multiselect boxes.
	if (data.multiselect != undefined) {
		toggleMultiselect(data.multiselect, event.source);
		return;
	}

	// Opening apps.
	if (data.app != undefined) {
		var container = $(".app-container");
		var background = $("#home-page");
		var lastApp = CurrentApp;

		if (lastApp && lastApp != data.app && AppWindows[lastApp]) {
			console.log("closing last app "+lastApp);
			AppWindows[lastApp].postMessage({ closed: true });
			AppWindows[lastApp] = undefined;
		}

		if (data.app == false && (!data.appCheck || data.appCheck == CurrentApp)) {
			// Going back.
			CurrentApp = data.forced ? undefined : AppOrder[AppOrder.length - 2];
			if (data.forced) {
				AppOrder = [];
			}

			// Closing apps.
			if (CurrentApp == undefined) {
				container.fadeOut(FadeTime);
				background.fadeIn(FadeTime);
				background.css("display", "flex");

				setTimeout(function() {
					container.css("display", "none");
				}, FadeTime)
			}

			AppOrder.pop();
		} else if (data.app && data.app != lastApp) {
			// Going forward.
			CurrentApp = data.app;
			AppOrder.push(CurrentApp);

			container.css("display", "block");
			background.fadeOut(FadeTime);
			
			setTimeout(function() {
				background.css("display", "none");
			}, FadeTime)
		}
		
		// Opening the app and requesting the load.
		var app = CurrentApp;
		if (app != undefined) {
			// Attempt to load the app.
			if (!data.payload) {
				$.post("http://phone/loadApp", JSON.stringify({
					app: app,
					content: data.appContent,
				}));
			}
			
			if (lastApp != CurrentApp) {
				// Fade out the last app or immediately if none.
				container.fadeOut(lastApp == undefined ? 0 : FadeTime);

				// Wait for the fade out and setup the app window.
				setTimeout(function() {
					container[0].src = `apps/${app}/index.html`;
					container[0].onload = function() {
						container.fadeIn(FadeTime);
						AppWindows[app] = container[0].contentWindow;
						if (data.payload) {
							console.log("opening app and internally posting payload "+JSON.stringify(data.payload));
							AppWindows[app].postMessage({ payload: data.payload });
						}
					}
				}, FadeTime)
			}
		}
		
		return;
	}
	
	// Receiving the app load.
	var loaded = data.loaded;
	if (loaded != undefined) {
		var loopback = function() {
			if (CurrentApp != loaded.app) {
				console.error(`Failed loading app: ${loaded.app} (does not match current app: ${CurrentApp})`);
				return;
			}

			appWindow = AppWindows[loaded.app];

			if (appWindow == undefined) {
				setTimeout(loopback, 1);
			} else {
				console.log("loaded app and posting payload "+JSON.stringify(loaded.payload))
				appWindow.postMessage({ payload: loaded.payload });
			}
		};

		if (loaded.payload && loaded.payload.notification) {
			data.notification = loaded.payload.notification;
		}
		
		loopback();
	}
	
	// Adding notifications.
	var notification = data.notification;
	if (notification != undefined) {
		addNotification(notification.title, notification.text, notification.app);
	}

	// Home-page stuff.
	if (data.setTime) {
		var hours = (data.hours == 0 ? 12 : data.hours > 12 ? data.hours - 12 : data.hours).toString().padStart(2, "0");
		var minutes = data.minutes.toString().padStart(2, "0");
		var suffix = data.hours >= 12 ? "PM" : "AM";

		document.querySelector("#time").innerHTML = hours + ":" + minutes + " " + suffix;
		document.querySelector("#date").innerHTML = `${data.weekday}, ${data.month} ${data.day}`;
	}

	// Toggle display.
	if (data.display === true) {
		document.documentElement.style.setProperty("--scale", window.innerHeight / 1080.0 * 0.55);

		$("#phone")[0].style.display = "block";
		$(".notifications")[0].style.display = "none";
	} else if (data.display === false) {
		$("#phone")[0].style.display = "none";
		$(".notifications")[0].style.display = "flex";
	}
});

function addNotification(title, text, app) {
	var template = $(".notification")[0];
	var node = template.cloneNode(true);
	node.style.display = "block";
	template.parentNode.appendChild(node);

	$(node).fadeOut(0);
	$(node).fadeIn(400);

	if (app == undefined) {
		node.querySelector("img").remove();
	} else {
		node.querySelector("img").src = `assets/app-${app}.png`;
	}

	if (HasAlertSound[app]) {
		AlertSound.volume = 0.3;
		AlertSound.play();
	}

	node.querySelector("#title").innerHTML = title;
	node.querySelector("#text").innerHTML = text;

	embed(node.querySelector("#text"), "./assets/image.png")

	setTimeout(function() {
		$(node).fadeOut(400);
		setTimeout(function() {
			node.remove();
		}, 400);
	}, 10000)
}

function toggleMultiselect(data, source) {
	$(".multiselect").css("display", data !== false ? "flex" : "none");
	$(".multiselect-close")[0].onclick = function() {
		closeMultiselect();
	};
	if (data) {
		var content = $(".multiselect-content")[0];
		var templateNode = content.children[0];

		$(".multiselect-content button").remove();
		
		for (var option of data) {
			var optionNode = templateNode.cloneNode(true);
			optionNode.style.display = "block";
			optionNode.innerHTML = option;
			optionNode.onclick = function() {
				if (source != undefined) {
					source.postMessage({ option: this.innerHTML });
				}
				toggleMultiselect(false);
			}
			content.appendChild(optionNode);
		}
	}
}