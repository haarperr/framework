VectorType = "vector4"
InputCache = {}

function changeVector(data) {
	VectorType = data.innerHTML
}

function isVector(data) {
	if (data != null && typeof(data) == "object") {
		return data[0] != undefined && data[1] != undefined && data[2] != undefined;
	}
	return false;
}

function formatVector(vector) {
	if (VectorType == "vector3" || vector[3] == undefined) {
		return `vector3(${vector[0]}, ${vector[1]}, ${vector[2]})`;
	} else if (VectorType == "vector4") {
		return `vector4(${vector[0]}, ${vector[1]}, ${vector[2]}, ${vector[3]})`;
	} else if (vector[3] == undefined) {
		return `{${vector[0]}, ${vector[1]}, ${vector[2]})`;
	} else {
		return `{${vector[0]}, ${vector[1]}, ${vector[2]}, ${vector[3]})`;
	}
}

window.addEventListener("message", function(event) {
	var data = event.data;
	
	if (data.open === true) {
		$("#main").css("display", "initial")
	} else if (data.open === false) {
		$("#main").css("display", "none")
	}

	if (data.copy) {
		var proxy = document.querySelector("#copy-proxy");
		proxy.value = data.copy;
		proxy.select();
		document.execCommand("Copy");
	}

	if (data.info != undefined) {
		var template = document.querySelector("#info-template");
		
		for (index in data.info) {
			var field = data.info[index];
			var name = field[0];
			var id = name.replace(" ", "").replace("(", "").replace(")", "");
			var value = field[1];
			var cache = InputCache[id];
			
			if (value == undefined) {
				if (cache == undefined) {
					var instance = template.cloneNode(true);
					instance.id = "title-template-" + id;
					instance.style.display = "block";
					instance.innerHTML = name;
					template.parentNode.appendChild(instance);

					InputCache[id] = instance;
				}
			}
			else {
				if (cache == undefined) {
					var instance = template.cloneNode(true);
					instance.id = "info-instance-" + id;
					instance.style.display = "block";
					template.parentNode.appendChild(instance);

					var text = document.querySelector("#" + instance.id + " #info-text")
					var clipboard = document.querySelector("#" + instance.id + " #info-copy");

					clipboard.innerHTML = name;
					clipboard.onclick = function(data) {
						var input = document.querySelector("#" + data.target.parentNode.parentNode.parentNode.id + " #info-text")
						input.select();
						document.execCommand("Copy");
					}

					cache = {
						instance: instance,
						text: text,
					};

					InputCache[id] = cache;
				}

				if (isVector(value)) {
					value = formatVector(value);
				}

				if (cache.text != undefined) {
					cache.text.value = value;
				}
			}
		}
	}
});

document.onkeydown = function(data) {
	if (data.which == 33) { // Page up
		$.post('http://admin-tools/toggleMenu', JSON.stringify({}));
	} else if (data.which == 34) { // Page down
		$.post('http://admin-tools/toggleCursor', JSON.stringify({}));
	}
};
