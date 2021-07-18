Template = undefined;
ContactNodes = [];

$(document).ready(function() {
	// Debug
	// addContact("John Doe", 5905551555);
	// addContact("Jane Doe", 5525556755);
	// addContact("Gamer Bathwater", 5555685555);
	// addContact("Bad Joke", 5555555535);
	// addContact("Anime", 8454411281);
	// addContact("Weeb Shit", 5125525555);
	// addContact("Haha", 5555525155);
	// addContact("ur mum", 5555555555);
	// addContact("Wow", 5555533555);
	// addContact("WOah", 5575555555);
	// addContact("Wah", 5559565555);
	// addContact("Bad", 5555553255);
	// addContact("Ok I guess", 5555995555);
	// addContact("John Doey", 5555555655);
	// addContact("Cawecoawoe", 5555595555);
	// addContact("vAWeopavwe", 5555535555);
	// addContact("vpoawove", 5555555755);
	// addContact("AVweop vawe", 5555545555);
	// addContact("PVPOawe awe", 5555555155);
	// addContact("Ppobitaw tnwa", 5555525555);
	// addContact("miaweo awecaw", 5555455555);
	// addContact("POAwoveiaw nawe", 5555855555);
	// addContact("opvnwqioe awEawe", 5550555555);
	// addContact("VIopawe awe", 5555555515);
	// addContact("vaweawed", 5555555532);
	// addContact("LAST", 5555512555);

	// openContact("LAST", 5555512555);
});

window.addEventListener("message", function(event) {
	var data = event.data;
	if (data.payload != undefined) {
		loadContacts(data.payload);
	}
});

function loadContacts(data) {
	for (var number in data) {
		var node = ContactNodes[number];
		var name = data[number];
		if (node == undefined) {
			addContact(name, number);
		} else {
			node.querySelector("#name").innerHTML = name;
		}
	}

	for (var number in ContactNodes) {
		var node = ContactNodes[number];
		if (data[number] == undefined) {
			node.remove();
		}
	}
}

function addContact(name, number) {
	// Cache the template node.
	if (Template == undefined) {
		Template = $("#contact")[0];
		Template.id = "contact-template";
	}

	// Create the node.
	var node = Template.cloneNode(true);
	node.style.display = "flex";
	
	// Insert alphabetically.
	var inserted = false;
	for (var child of Template.parentNode.children) {
		var childName = child.querySelector("#name");
		if (childName == undefined) {
			continue;
		} else if (childName.innerHTML.localeCompare(name) > 0) {
			Template.parentNode.insertBefore(node, child);
			inserted = true;
			break;
		}
	}
	if (!inserted) {
		Template.parentNode.appendChild(node);
	}

	// Set values.
	var initials = formatInitials(name);
	var numberText = formatPhoneNumber(number);

	node.querySelector("#pfp").innerHTML = initials;
	node.querySelector("#name").innerHTML = name;
	node.querySelector("#number").innerHTML = numberText;

	// Click event.
	node.onclick = function() {
		openMultiselect({
			"Call": function() {
				openApp("phone-call", undefined, {
					state: "Calling",
					number: number,
				})
			},
			"Message": function() {
				openApp("messages-dm", undefined, {
					number: number,
				});
			},
			"Edit": function() {
				openContact(name, number);
			}
		});
	}

	// Cache the node.
	ContactNodes[number] = node;
}

function filterContacts(filter) {
	filter = filter.toLowerCase();
	for (var number in ContactNodes) {
		var contactNode = ContactNodes[number];
		
		var name = contactNode.querySelector("#name").innerHTML;
		contactNode.style.display = filter == "" || number.toString().includes(filter) || name.toLowerCase().includes(filter) ? "flex" : "none";
	}
}

function openContact(name, number) {
	openApp("new-contact", { name: name, number: number });
}