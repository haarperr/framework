window.addEventListener("message", function(event) {
	var data = event.data;
	var payload = data.payload;

	if (!payload) {
		return;
	}

	if (payload.properties) {
		var template = document.querySelector("#property-template");
		
		$(document.querySelectorAll("#property-instance")).remove();

		for (let property of payload.properties) {
			var isOwned = property.payment == undefined;
			var instance = template.cloneNode(true);
			instance.id = "property-instance";
			instance.style.display = "flex";
			template.parentNode.appendChild(instance);

			instance.querySelector("#title").innerHTML = `${property.name} (${property.id}) — ${property.address}`;

			var rentDue = instance.querySelector("#rent-due");
			var paymentButton = instance.querySelector("#make-payment");

			rentDue.style.display = isOwned ? "none" : "block";
			paymentButton.style.display = isOwned ? "none" : "block";

			if (!isOwned) {
				rentDue.innerHTML = `$${formatNumber(property.payment.mortgage != 0 ? property.payment.mortgage : property.payment.due)} — Due by ${getDate(property.payment.next_payment)}` +
					(property.payment.mortgage ? `<br>$${formatNumber(property.payment.payed)} Paid — $${formatNumber(property.payment.due - property.payment.payed)} Remaining` : "");
				paymentButton.disabled = new Date() < new Date(property.payment.next_payment - 8.64e+7 * 7);
				paymentButton.onclick = function() {
					$.post("http://phone/payProperty", JSON.stringify({ id: property.id }))
				}
			}

			if (property.isKey) {
				instance.style.backgroundColor = "#9C2BC6";
			}

			instance.querySelector("#track").onclick = function() {
				$.post("http://phone/trackProperty", JSON.stringify({ id: property.id }))
			}
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