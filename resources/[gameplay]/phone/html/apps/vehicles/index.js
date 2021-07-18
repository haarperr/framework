window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.vehicles) {
		var template = document.querySelector("#vehicle-template");
		
		$(document.querySelectorAll("#vehicle-instance")).remove();

		for (let vehicle of payload.vehicles) {
			var instance = template.cloneNode(true);
			instance.id = "vehicle-instance";
			instance.style.display = "flex";
			template.parentNode.appendChild(instance);

			instance.querySelector("#title").innerHTML = vehicle.name;

			if (vehicle.garage != undefined) {
				instance.querySelector("#garage").innerHTML = vehicle.garage;
			} else {
				instance.querySelector("#garage").remove();
			}
			
			if (vehicle.canTrack) {
				instance.querySelector("#track").onclick = function() {
					$.post("http://phone/trackVehicle", JSON.stringify({ id: vehicle.garageId }))
				}
			} else {
				instance.querySelector("#track").remove();
			}
		}
	}
});