Instances = {}

window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.job) {
		// console.log(JSON.stringify(payload.job));

		for (var fieldName in payload.job) {
			var field = $(`#job${fieldName}`);
			console.log(fieldName, field)
			if (field != undefined) {
				field.text(payload.job[fieldName]);
			}
		}

		
		// $("#job-name").text(payload.job.Name);
	}
});

function getDate(time) {
	var date = new Date(time);

	return `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`;
}

function formatNumber(number) {
	return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
}