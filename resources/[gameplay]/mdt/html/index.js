EnableDebug = false;

ChargeReferences = {};
Charges = {};
CurrentFaction = undefined;
Editing = undefined;
EntryHandle = 0;
EntryTemplate = undefined;
IsEditing = false;
IsJudge = false;
LastSearch = {};
Offset = 0;
ReportCharges = {};
SearchLimit = 50;
Spinner = undefined;
Waiting = false;

$(document).ready(function() {
	var template = $("#entry-template")[0];

	EntryTemplate = {
		root: template,
		name: document.querySelector("#entry-template #entry-name"),
		info: document.querySelector("#entry-template #entry-info"),
		desc: document.querySelector("#entry-template #entry-desc"),
	};

	Spinner = document.querySelector("#loading");

	if (EnableDebug) {
		window.postMessage({
			display: true,
			charges: [
				{ id: 1, class: "Federal Felony", reference: "b", charge: "Torture", definition: "Action or practice of inflicting severe pain on someone as a punishment or to force them to do or say something or for the pleasure of the person inflicting the pain.", time: 45, fine: 500 },
				{ id: 2, class: "Federal Felony", reference: "c", charge: "Something", definition: "Idk lol haha.", time: 69, fine: 500 },
				{ id: 3, class: "Federal Felony", reference: "c", charge: "B", definition: "", time: 69, fine: 500 },
				{ id: 4, class: "Federal Felony", reference: "c", charge: "C", definition: "", time: 69, fine: 500 },
				{ id: 5, class: "Federal Felony", reference: "c", charge: "X", definition: "", time: 69, fine: 500 },
				{ id: 6, class: "Federal Felony", reference: "c", charge: "Y", definition: "", time: -1, fine: 500 },
				{ id: 7, class: "Traffic Infraction", reference: "c", charge: "Don't speeed", definition: ">:(", time: 69, fine: 500 },
				{ id: 8, class: "Federal Felony", reference: "c", charge: "A", definition: "", time: 69, fine: 500 },
			],
			faction: "police",
		});
		
		// setTimeout(() => {
		// 	setTab({
		// 		loader: "person",
		// 		data: {
		// 			profile: {
		// 				notes: "Hi",
		// 			},
		// 			character: {
		// 				first_name: "John",
		// 				last_name: "Doe",
		// 			},
		// 		}
		// 	});
		// }, 1000)

		setTimeout(() => {
			// $(".nav li:eq(3) a").tab("show");
			// $("#template-tab").tab("show");
			// $("#new-report-tab").tab("show");
			$("#new-report-tab")[0].click();
		}, 200)
	}
});

window.addEventListener("message", function(event) {
	var data = event.data;
	
	if (EnableDebug) {
		addEntry("#active-warrants", "Name", "Name ― Date, Time", "Description");
		addEntry("#active-bolos", "Name", "Name ― Date, Time", "Description");
		addEntry("#recent-arrests", "Name", "Name ― Date, Time", "Description");
		addEntry("#recent-citations", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
		// addEntry("#desc-convictions", "Name", "Name ― Date, Time", "Description");
		// addEntry("#search-results", "Name", "Name ― Date, Time", "Description");
	}
	
	var result = data.result;
	var description = data.description;

	if (data.display === true) {
		$("#main")[0].style.display = "block";
	} else if (data.display === false) {
		$("#main")[0].style.display = "none";
	}

	if (data.faction) {
		var lastFaction = CurrentFaction;
		CurrentFaction = data.faction;

		var isPolice = CurrentFaction == "police";
		document.querySelector("#theme-link").href = `theme-${data.faction}.css`;
		document.querySelector("#search-option-vehicles").style.display = isPolice ? "block" : "none";
		document.querySelector("#search-option-weapons").style.display = isPolice ? "block" : "none";
		document.querySelector("#desc-convictions").parentNode.style.display = isPolice ? "block" : "none";

		if (lastFaction == undefined) {
			document.querySelector("#home-tab").click();
		}
	}

	if (data.isJudge != undefined) {
		IsJudge = data.isJudge;
	}

	if (data.notes != undefined) {
		document.querySelector("#notes-text").value = data.notes;
	}

	if (data.charges) {
		Charges = data.charges;

		var searchRoot = $("#search-charges")[0];
		
		for (var charge of Charges) {
			var chargeReference = addCharge(searchRoot, charge, true);
			
			ChargeReferences[charge.name] = chargeReference;
		}
		filterCharges();
	}

	if (result != undefined) {
		var wasSearchPrepare = function() {
			if (result.offset == 0) {
				clearEntries("#search-results");
			}

			result.data = result.data[0];
			
			$("#search-load-more")[0].style.display = result.data.length < SearchLimit ? "none" : "block";
			$("#search-sum")[0].innerHTML = Offset + result.data.length + (result.data.length >= SearchLimit ? "+" : "") + " results";
		};

		if (result.loader == "persons") {
			wasSearchPrepare();

			for (var result of result.data) {
				var instance = addEntry("#search-results", result.first_name + " " + result.last_name, result.dead ? "<i>Deceased</i>" : "", "ID: " + result.license_text + "<br>Gender: " + getGender(result.gender) + "<br>DOB: " + getDate(result.dob, 1));
				instance.info = {
					character_id: result.id,
				}
			}
		} else if (result.loader == "vehicles") {
			wasSearchPrepare();

			for (var result of result.data) {
				var instance = addEntry("#search-results", result.plate, "", result.name);
				instance.info = {
					vehicle_id: result.id,
				}
			}
		} else if (result.loader == "weapons") {
			wasSearchPrepare();

			for (var result of result.data) {
				var instance = addEntry("#search-results", result.serial_number, "", result.name);
				instance.info = {
					serial_number: result.serial_number,
				}
			}
		}
		Spinner.style.display = "none";
	}
	// } else if (description != undefined) {
	// 	setTab(description);
	// }
});

$("#home-tab").click(function() {
	search("home", {}, 0, (result) => {
		// console.log("home loaded "+JSON.stringify(result))
		if (result == undefined) {
			return;
		}

		var data = result.data;
		if (data == undefined) {
			return;
		}

		clearEntries("#recent-drafts");
		clearEntries("#active-warrants");
		clearEntries("#active-bolos");
		clearEntries("#recent-arrests");
		clearEntries("#recent-citations");

		var callback = (entry) => {
			Viewing = undefined;
			startReport(entry);
		};

		if (data.drafts) {
			addEntries("#recent-drafts", data.drafts, callback);
		}

		if (data.citationDrafts) {
			addEntries("#recent-drafts", data.citationDrafts, callback);
		}

		if (data.warrants) {
			addEntries("#active-warrants", data.warrants, callback);
		}

		if (data.arrests) {
			addEntries("#recent-arrests", data.arrests, callback);
		}

		if (data.citations) {
			addEntries("#recent-citations", data.citations, callback);
		}
	})
});

function getGender(gender) {
	if (gender == 1) {
		return "Male";
	} else {
		return "Female";
	}
}

function getDate(time, format) {
	var date = new Date(1970, 1, 1);
	date.setMilliseconds(time);

	if (format == 1) {
		return date.getMonth() + "/" + date.getDate() + "/" + date.getFullYear();
	}

	return date;
}

function chargeCount(element, dir, set) {
	element = element.parentNode;
	if (element.count == undefined) {
		element.count = 1;
	}

	element.count = Math.max(set ? dir : element.count + dir, 1);
	element.querySelector("#charge-count").innerHTML = element.count + "x";
	filterCharges();
}

function addCharge(root, charge, isReport) {
	var entry = addEntry("#" + root.id, charge.charge, (charge.time == -1 ? "Indefinitely" : charge.time + " months") + " — $" + charge.fine, charge.definition);
	entry.charge = charge;
	
	if (isReport) {
		ReportCharges[charge.id] = entry;

		entry.onclick = function(e) {
			if (e.target != entry) {
				return;
			}
			
			var isRoot = e.target.parentNode == root;
			if (isRoot) {
				$("#current-charges").append(e.target);
			} else {
				$("#search-charges").append(e.target);
			}
			
			e.target.querySelector(".charge-count").style.display = isRoot ? "flex" : "none";
			filterCharges();
		}
	}
	return entry;
}

function addEntries(target, data, callback) {
	for (let entry of data) {
		if (entry.charges != undefined) {
			entry.charges = JSON.parse(entry.charges);
		}
		
		var instance = addEntry(target, `${entry.first_name} ${entry.last_name} — Authored By ${entry.author_name}`, `${entry.status}` + (entry.plead ? ` — Plead ${entry.plead}` : "") + (entry.served ? " & Served" : ""), entry.details.substring(0, Math.min(entry.details.length, 128)));
		if (callback != undefined) {
			instance.onclick = function() {
				callback(entry);
			}
		}
	}
}

function addEntry(target, name, info, desc) {
	var parent = $(target)[0];

	if (EntryTemplate.root == undefined || parent == undefined) {
		return;
	}

	EntryTemplate.name.innerHTML = name;
	EntryTemplate.info.innerHTML = info;
	EntryTemplate.desc.innerHTML = desc;

	var instance = EntryTemplate.root.cloneNode(true);
	instance.style.display = "block";
	instance.id = "entry-instance-" + EntryHandle;

	instance.onclick = function () {
		if (instance.info != undefined) {
			search(instance.info.vehicle_id ? "vehicle" : "person", instance.info, 0, (result) => {
				for (var x in result.data) {
					console.log(x + ": " + JSON.stringify(result.data[x]));
				}
				setTab(result);
			})
		}
	}
	
	parent.append(instance);
	
	if (info == "") {
		document.querySelector("#" + instance.id + " br").remove()
	}

	EntryHandle++;

	return instance;
}

function clearEntries(target) {
	$(target).children().each(function () {
		if (this.localName == "div") {
			this.remove();
		}
	});
}

function search(loader, data, offset, callback) {
	Offset = offset;

	Spinner.style.display = "block";
	Waiting = true;

	if (offset == 0) {
		LastSearch = {
			loader: loader,
			data: data
		}
	} else {
		loader = LastSearch.loader;
		data = LastSearch.data;
	}

	$.post("http://mdt/search", JSON.stringify({
		loader: loader,
		data: data,
		offset: offset
	}));

	if (callback) {
		var onMessageLoaded = (event) => {
			var data = event.data;
			if (data == undefined) {
				return;
			}
	
			var result = data.result;
			if (result == undefined) {
				return;
			}

			callback(result);
			window.removeEventListener("message", onMessageLoaded, false);
		};
		window.addEventListener("message", onMessageLoaded, false);
	}

	if (EnableDebug) {
		setTimeout(function () {
			window.postMessage({
				result: {
					target: "persons",
					data: [
						{ first_name: "First", last_name: "Last" },
						{ first_name: "First", last_name: "Last" },
						{ first_name: "First", last_name: "Last" },
						{ first_name: "First", last_name: "Last" },
					]
				}
			});
		}, 500);
	}
}

function setTab(result) {
	Viewing = result;

	var data = result.data;
	if (data == undefined) {
		return;
	}

	var isPerson = result.loader == "person";
	var isVehicle = result.loader == "vehicle";

	var text = "";
	if (isPerson) {
		if (data.profile == undefined) {
			data.profile = {}
		}

		text = `${data.character.first_name} ${data.character.last_name}`

		$("#mugshot").css("background-image", `url("${(data.profile.mugshot_url || "https://i.imgur.com/S2IRHcz.jpg")}")`);

		document.querySelector("#desc-notes").innerHTML = (data.profile.notes || "").replace(/\n/g, "<br>");
		document.querySelector("#desc-notes-edit").value = data.profile.notes || "";
		document.querySelector("#desc-dob").innerHTML = data.character.dob;
		document.querySelector("#desc-license").innerHTML = data.character.license_text;

		clearEntries("#desc-recent-arrests");
		clearEntries("#desc-recent-citations");

		var callback = (entry) => {
			Viewing = undefined;
			startReport(entry);
		};

		if (data.arrests != undefined) {
			addEntries("#desc-recent-arrests", data.arrests, callback);
		}

		if (data.citations != undefined) {
			addEntries("#desc-recent-citations", data.citations, callback);
		}
		
		IsEditing = true;
		editPerson($("#desc-edit")[0], true);
	} else if (isVehicle) {
		text = data.vehicle.plate;
	}
	
	var tab = $("#template-tab")[0];
	tab.parentNode.style.display = "block";
	tab.innerHTML = text;
	
	$("#person-description").css("display", isPerson ? "flex" : "none");
	$("#desc-name").text(text);
	$("#template-tab").tab("show");
}

function loadMore(source) {
	source.style.display = "none";
	search(Offset + SearchLimit);
}

function closeMenu() {
	$.post("http://mdt/toggleMenu", JSON.stringify({}));
}

function saveNotes() {
	var text = $("#notes-text")[0].value;
	$.post("http://mdt/saveNotes", JSON.stringify({ notes: text }));
}

function editPerson(self, init) {
	var previousData = {
		mugshot_url: Viewing.data.profile.mugshot_url,
		notes: Viewing.data.profile.notes,
	};

	IsEditing = !IsEditing;

	self.innerHTML = IsEditing ? "Save" : "Edit";

	var notes = document.querySelector("#desc-notes")
	var notesEdit = document.querySelector("#desc-notes-edit");
	var mugshot = document.querySelector("#mugshot");
	var mugshotUrl = document.querySelector("#mugshot-url");

	notes.style.display = IsEditing ? "none" : "block";
	notesEdit.style.display = IsEditing ? "block" : "none";

	mugshotUrl.style.display = IsEditing && CurrentFaction == "police" ? "block" : "none";
	
	if (IsEditing) {
		mugshotUrl.value = Viewing.data.profile.mugshot_url || "";
	} else if (!init) {
		Viewing.data.profile.mugshot_url = mugshotUrl.value == "" ? false : mugshotUrl.value;
		Viewing.data.profile.notes = notesEdit.value == "" ? false : notesEdit.value;
		
		notes.innerHTML = notesEdit.value.replace(/\n/g, "<br>");

		var diff = {};
		var hasDiff = false;

		if (previousData.mugshot_url != Viewing.data.profile.mugshot_url) {
			diff.mugshot_url = Viewing.data.profile.mugshot_url;
			hasDiff = true;
		}

		if (previousData.notes != Viewing.data.profile.notes) {
			diff.notes = Viewing.data.profile.notes;
			hasDiff = true;
		}

		if (hasDiff) {
			$.post("http://mdt/save", JSON.stringify({
				id: Viewing.data.character.id,
				type: "person",
				diff: diff
			}));
		}
	}
	
	mugshot.style.backgroundImage = `url('${Viewing.data.profile.mugshot_url || "https://i.imgur.com/S2IRHcz.jpg"}')`;
}

function filterEntries(rootId, filter, check) {
	var root = $(rootId);
	var items = root.children("div").sort(function(a, b) {
		var vA = $("#entry-name", a).text();
		var vB = $("#entry-name", b).text();
		
		return (vA < vB) ? -1 : (vA > vB) ? 1 : 0;
	});
	root.append(items);

	for (var item of items) {
		var text = item.querySelector("#entry-name").innerHTML;
		var enabled = (check != undefined ? check(item) : true) && (filter == "" || filter == undefined || text.toLowerCase().includes(filter.toLowerCase()));
		item.style.display = enabled ? "block" : "none";
	}
}

function filterCharges(filter, check) {
	filterEntries("#search-charges", filter, check);

	var totalMonths = 0;
	var totalFine = 0;

	$("#current-charges").children().each(function() {
		if (this.charge) {
			var count = this.querySelector(".charge-count").count || 1;
			totalFine += (this.charge.fine || 0) * count;
			
			if (this.charge.time == -1) {
				totalMonths = -1
			} else if (totalMonths != -1) {
				totalMonths += (this.charge.time || 0) * count;
			}
		}
	});

	document.querySelector("#charges-total").innerHTML = `${totalMonths == -1 ? "Indefinitely" : Math.min(totalMonths, 240) + " months"} — $${totalFine}`
}

function searchSubmit(e) {
	if (event.key == "Enter") {
		$("#search-button").click();
	}
}