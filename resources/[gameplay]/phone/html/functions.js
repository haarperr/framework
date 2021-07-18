$("input").focus(function() {
	$.post("http://phone/focus", JSON.stringify({
		focus: true,
	}));
});

$("input").blur(function() {
	$.post("http://phone/focus", JSON.stringify({
		focus: false,
	}));
});

$("textarea").focus(function() {
	$.post("http://phone/focus", JSON.stringify({
		focus: true,
	}));
});

$("textarea").blur(function() {
	$.post("http://phone/focus", JSON.stringify({
		focus: false,
	}));
});

function sendMessage(target, type, message) {
	$.post("http://phone/sendMessage", JSON.stringify({
		target: target,
		type: type,
		message: message
	}));
}

function addApp(target, name, display) {
	var parent = $(`.${target}`)[0];
	var div = document.createElement("div");
	div.classList.add("app")
	div.style.backgroundImage = `url(assets/app-${name}.png)`;
	div.onclick = function() {
		openApp(name);
	}

	parent.appendChild(div);

	if (display) {
		var text = document.createElement("div");
		text.innerHTML = display;
		text.classList.add("app-text");
		div.appendChild(text);
	}
}

function openApp(app, payload, content) {
	windowParent().postMessage({
		app: app,
		payload: payload,
		appContent: content,
	});
}

function closeApp(forced, appCheck, payload) {
	windowParent().postMessage({ app: false, forced: forced, appCheck: appCheck, payload: payload });
}

function close() {
	$.post("http://phone/close", JSON.stringify({}));
}

function windowParent() {
	if (window.parent.origin == "nui://game") {
		return window;
	}
	return window.parent;
}

function nav(dest) {
	if (dest == "back") {
		closeApp();
	} else if (dest == "grid") {
		close();
	} else if (dest == "home") {
		closeApp(true);
	}
}

function formatPhoneNumber(phoneNumberString) {
	var cleaned = ('' + phoneNumberString).replace(/\D/g, '');
	var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
	if (match) {
		return '(' + match[1] + ') ' + match[2] + '-' + match[3];
	}
	return null;
}

function formatInitials(name) {
	if (!name) {
		return "??";
	}
	var initials = name.match(/\b\w/g) || [];
	initials = ((initials.shift() || '') + (initials.pop() || '')).toUpperCase();
	return initials;
}

function formatNumber(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/* Multiselections */
var MultiCallbacks = {};

function multiselectResponse(event) {
	var callback = MultiCallbacks[event.data.option];
	if (callback) {
		callback();
	}
}

function openMultiselect(options) {
	var message = [];
	
	// Create the response event.
	window.removeEventListener("message", multiselectResponse);
	window.addEventListener("message", multiselectResponse);

	// Create and post the message.
	for (var option in options) {
		message.push(option);
		MultiCallbacks[option] = options[option];
	}
	windowParent().postMessage({ multiselect: message });
}

function closeMultiselect() {
	windowParent().postMessage({ multiselect: false });
}

/* Images */
function embed(element, replaceImage) {
	setTimeout(async () => {
		let text = element.innerHTML;

		text = await replaceAsync(text,
			/((?:[a-z]+:\/\/)?(?:(?:[a-z0-9\-]+\.)+(?:[a-z]{2}|aero|arpa|biz|com|coop|edu|gov|info|int|jobs|mil|museum|name|nato|net|org|pro|travel|local|internal))(?::[0-9]{1,5})?(?:\/[a-z0-9_\-.~]+)*(?:\/(?:[a-z0-9_\-.]*)(?:\?[a-z0-9+_\-.%=&amp;]*)?)?(?:#[a-zA-Z0-9!$&'(?:)*+.=-_~:@/?]*)?)(?:\s+|$)/g
		, async function(match) {
			let isImage = false;

			await testImage(match).then(() => {
				isImage = true;
			}).catch(() => {});
	
			if (isImage) {
				return `<img src='${replaceImage || match}' class='embed'></img>`;
			} else {
				return match
			}
		})

		text = text.replace(/\*{2}(.+)\*{2}/g, "<b>$1</b>");
		text = text.replace(/\*(.+)\*/g, "<i>$1</i>");
		text = text.replace(/\_{2}(.+)\_{2}/g, "<u>$1</u>");

		element.innerHTML = text;
	}, 0)
}

function testImage(url, timeoutT) {
	return new Promise(function (resolve, reject) {
		var timeout = timeoutT || 5000;
		var timer, img = new Image();
		img.onerror = img.onabort = function () {
			clearTimeout(timer);
			reject("error");
		};
		img.onload = function () {
			clearTimeout(timer);
			resolve("success");
		};
		timer = setTimeout(function () {
			// reset .src to invalid URL so it stops previous
			// loading, but doesn't trigger new load
			img.src = "//!!!!/test.jpg";
			reject("timeout");
		}, timeout);
		img.src = url;
	});
}

async function replaceAsync(str, regex, asyncFn) {
	const promises = [];
	str.replace(regex, (match, ...args) => {
		const promise = asyncFn(match, ...args);
		promises.push(promise);
	});
	const data = await Promise.all(promises);
	return str.replace(regex, () => data.shift());
}