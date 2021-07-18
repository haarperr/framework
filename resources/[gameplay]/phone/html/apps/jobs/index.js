Instances = {}

window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.factions) {
		var template = document.querySelector("#job-template");
		
		$(document.querySelectorAll("#job-instance")).remove();

		for (let factionId in payload.factions) {
			let faction = payload.factions[factionId];
			var instance = template.cloneNode(true);
			instance.id = "job-instance";
			instance.style.display = "flex";
			template.parentNode.appendChild(instance);

			instance.querySelector("#clock-on").style.display = !faction.isOnDuty ? "flex" : "none";
			instance.querySelector("#clock-off").style.display = faction.isOnDuty ? "flex" : "none";
			instance.querySelector("#title").innerHTML = `${faction.job.Name} — ${faction.rank} (${faction.level})`;

			instance.querySelector("#clock-on").onclick = () => {
				$.post("http://phone/jobClock", JSON.stringify({ id: factionId, value: true }))
			}

			instance.querySelector("#clock-off").onclick = () => {
				$.post("http://phone/jobClock", JSON.stringify({ id: factionId, value: true }))
			}
			
			// instance.querySelector("#job-info").onclick = () => {
			// 	$.post("http://phone/jobInfo", JSON.stringify({ id: factionId }))
			// }

			Instances[factionId] = instance;
		}
	}

	if (payload.clock) {
		var instance = Instances[payload.clock.name];
		if (instance) {
			instance.querySelector("#clock-on").style.display = !payload.clock.message ? "flex" : "none";
			instance.querySelector("#clock-off").style.display = payload.clock.message ? "flex" : "none";
		}
	}
});

function getDate(time) {
	var date = new Date(time);

	return `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`;
}

function formatNumber(number) {
	return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
}