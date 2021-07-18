Template = undefined;
ContactNodes = [];
BeepBoop = new Audio("../../sounds/beepboop.ogg");

$("#phone-number").on("input", function(event) {
	checkInput(this);
})

$("button:not(.action)").click(function() {
	if (isNaN(this.innerHTML)) { return; }

	var phoneNumber = document.querySelector("#phone-number");
	phoneNumber.value = phoneNumber.value + this.innerHTML;

	BeepBoop.play();
	checkInput(phoneNumber);
});

$("#call").click(function() {
	var number = document.querySelector("#phone-number").value;
	if (number.length != 10) { return; }

	openApp("phone-call", undefined, {
		state: "Calling",
		number: number
	})
});

$("#message").click(function() {
	var number = document.querySelector("#phone-number").value;
	if (number.length != 10) { return; }

	openApp("messages-dm", undefined, {
		number: number
	});
});

function checkInput(target) {
	target.value = target.value.substring(0, 10);
}