var CounterMinTime = 1.0;
var CounterMaxTime = 20.0;
var CounterMaxAmount = 100000;
var UpdateInterval;

// $(document).ready(function() {
// });

$(".navigate").click(function(data) {
	var id = data.target.id;

	if (id === "close") {
		$.post("http://banking/toggle", JSON.stringify({}));
	} else if (id.substring(0, 4) === "nav-") {
		$("#main-menu").css("display", "none");
		$("#transfer-menu").css("display", "initial");
		$("#transfer").text(data.target.textContent);
		
		if (id === "nav-transfer") {
			$("#transfer-id").removeAttr("disabled");
		} else {
			$("#transfer-id").attr("disabled", "disabled");
		}
	} else if (id === "back") {
		$("#main-menu").css("display", "initial");
		$("#transfer-menu").css("display", "none");
	}
})

document.getElementById("transfer").onclick = function(data) {
	var transferType = -1;
	var target = null;

	if (data.target.textContent == "Withdraw") {
		transferType = 0;
	} else if (data.target.textContent == "Deposit") {
		transferType = 1;
	} else {
		transferType = 2;
		target = document.getElementById("transfer-id").value
	}

	$.post("http://banking/transfer", JSON.stringify({
		type: transferType,
		target: target,
		amount: document.getElementById("transfer-amount").value,
	}))
}

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.display != undefined) {
		$("#main").css("display", data.display ? "initial" : "none");
		if (!data.display && UpdateInterval != null) {
			clearInterval(UpdateInterval);
		}
	}

	document.getElementById("nav-deposit").disabled = !data.info?.isBank;

	if (!data.info?.isBank) {
		$("#main-menu").css("display", "initial");
		$("#transfer-menu").css("display", "none");
	}
	
	if (data.info != undefined) {
		document.getElementById("name").textContent = data.info.name;
		document.getElementById("bank").textContent = data.info.bank;
		document.getElementById("balance").textContent = "$" + data.info.balance.toLocaleString(undefined, { maximumFractionDigits: 0 });
		
		if (data.info.isBank) {
			document.getElementById("available").textContent = "$0";
			document.getElementById("available-root").style.display = "block";
			document.getElementById("unavailable-root").style.display = "none";

			var available = data.info.available;
			var unavailable = data.info.unavailable;
			
			var lastUpdate = Date.now();
			var count = 0;
			var max = available + unavailable;
			var increment = max / (Math.min(Math.pow(max / CounterMaxAmount, 2.0), 1.0) * (CounterMaxTime - CounterMinTime) + CounterMinTime);

			UpdateInterval = setInterval(availableAnim, 0);
			
			function availableAnim() {
				var now = Date.now();
				var delta = (now - lastUpdate) / 1000;
				lastUpdate = now;

				count = Math.min(count + increment * delta, max);
				
				document.getElementById("available").textContent = "$" + Math.min(count, available).toLocaleString(undefined, { maximumFractionDigits: 0 });

				if (unavailable > 0 && count >= available) {
					document.getElementById("unavailable-root").style.display = "block";
					document.getElementById("unavailable").textContent = "$" + Math.min(count - available, unavailable).toLocaleString(undefined, { maximumFractionDigits: 0 });
				}

				if (count >= max) {
					clearInterval(UpdateInterval);
				}
			}
		} else {
			document.getElementById("available-root").style.display = "none";
		}
	}
});