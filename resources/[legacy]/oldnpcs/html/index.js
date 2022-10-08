EnableDebug = false;
LastAudio = undefined;
ExitOptions = [
	"See you.",
	"Later.",
	"Goodbye.",
	"Catch you later.",
]

$(document).ready(function() {
	if (EnableDebug) {
		window.postMessage({
			display: true
		});

		// Generate dialogue.
		setText("dialogue", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed maximus mauris ut urna vehicula lobortis. In tortor orci, imperdiet at nisi vitae, posuere pharetra purus. Nunc condimentum diam facilisis viverra lacinia.");
		setText("name", "John Doe");

		var test = "Morbi tincidunt quis metus id lacinia. Aenean mattis, mi quis posuere aliquet, nisi tortor elementum augue, et volutpat sapien nulla ut nisi. In at ligula sollicitudin, convallis dui fermentum, tincidunt elit. Nunc a accumsan tortor, sit amet consequat turpis. Proin malesuada dui nisi, at scelerisque arcu accumsan sit amet. Integer nec porta elit. Maecenas id metus in dolor ornare imperdiet eu sed nibh. Donec tristique enim non rutrum rhoncus. Vestibulum iaculis dolor in purus vestibulum varius. Sed mattis vel lorem vitae porta. Aliquam at nulla orci. In viverra nisl turpis, eget lobortis sem luctus vel. Maecenas vel pharetra enim. Morbi pharetra, nisi non dapibus mollis, lacus sapien volutpat odio, ut elementum leo quam eu odio. Sed eu semper nisi. Integer vel urna at magna interdum laoreet in nec lacus.";
		var testOptions = test.split(". ");
		console.log(testOptions)

		for (var testOption of testOptions) {
			addOption(undefined, testOption + ".");
		}

		makeExitOption();
	}
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.display != undefined) {
		document.querySelector("#main").style.display = data.display ? "flex" : "none";
	}

	if (data.set != undefined) {
		if (data.set.key == "options") {
			clearOptions();

			for (var option of data.set.value) {
				addOption(option.id, option.text);
			}

			makeExitOption();
		} else {
			setText(data.set.key, data.set.value);
		}
	}

	if (data.input != undefined) {
		var input = document.querySelector("input");
		input.disabled = !data.input;

		if (data.input) {
			input.focus();
		} else {
			input.value = "";
		}
	}

	if (data.playAudio != undefined && data.playAudio !== true) {
		if (LastAudio != undefined) {
			LastAudio.pause();
		}

		if (data.playAudio !== false) {
			console.log(`sound/${data.playAudio}.ogg`)
			LastAudio = new Audio(`./sound/${data.playAudio}.ogg`);
			LastAudio.load();
			LastAudio.play();
			LastAudio.onended = () => {
				setTalking(false);
			}

			setTalking(true);
		}
	}
});

function setTalking(value) {
	$.post("http://oldnpcs/setTalking", JSON.stringify({
		value: value
	}));
}

function clearOptions() {
	$(".option").remove();
}

function addOption(id, text) {
	var options = document.querySelector("#options");
	var option = document.createElement("DIV");
	option.innerHTML = text;
	option.classList.add("option");
	option.onclick = () => {
		selectOption(id);
	}

	options.appendChild(option);
}

function setText(key, value) {
	var dialogue = document.querySelector(`#${key}`);
	dialogue.innerHTML = value;
}

function selectOption(id) {
	$.post("http://oldnpcs/selectOption", JSON.stringify({
		id: id
	}));
}

function makeExitOption() {
	addOption(-1, ExitOptions[Math.floor(Math.random() * ExitOptions.length)])
}