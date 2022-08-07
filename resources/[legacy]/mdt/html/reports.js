Served = 0;
Status = "Draft";

window.addEventListener("message", function(event) {
	var data = event.data;
	
	if (data.status) {
		Status = data.status;
		//console.log("status", Status)
		updateReport();
	}
	
	if (data.served) {
		Served = data.served;
		updateReport();
	}

	if (data.reportId) {
		document.querySelector("#new-case-id").value = data.reportId;
		updateReport();
	}
});

function applyCharges(charges) {
	for (var entry in ReportCharges) {
		$("#search-charges").append(ReportCharges[entry]);
		JSON.stringify(ReportCharges[entry]);
		if (!ReportCharges[entry].charge.active) {
			ReportCharges[entry].style.display = "none";
		}
	}
	if (charges != undefined) {
		for (var charge in charges) {
			$("#current-charges").append(ReportCharges[charge]);
			ReportCharges[charge].querySelector(".charge-count").style = "flex";
			if (!ReportCharges[charge].charge.active) {
				ReportCharges[charge].style.display = "block";
				ReportCharges[charge].style.background = 'var(--quaternary-color)';
				ReportCharges[charge].querySelector(".charge-count").innerHTML = charges[charge] + "x";
			} else {;
				ReportCharges[charge].querySelector("#charge-count").innerHTML = charges[charge] + "x";
			}
		}
	}
	filterCharges();
}

function changeNew(self) {
	var isArrest = self.value == "Arrest";
	var isCitation = self.value == "Citation";
	var isWarrant = self.value == "Warrant";

	$("#new-arrest").css("display", isArrest ? "block" : "none");
	$("#new-citation").css("display", isCitation ? "block" : "none");
	$("#new-warrant").css("display", isWarrant ? "block" : "none");
	$("#report-plead-group").css("display", isArrest ? "block" : "none");
	
	document.querySelector("#report-details").style.display = !isCitation ? "block" : "none";
	document.querySelector("#license-plate").style.display = isCitation ? "block" : "none";
}

function updateReport() {
	var type = document.querySelector("#new-type").value;

	var isArrest = type == "Arrest";
	var isCitation = type == "Citation";
	var isWarrant = type == "Warrant";

	var caseId = document.querySelector("#new-case-id").value;
	var isCase = caseId != undefined && caseId != "";

	document.querySelector("#save-report").disabled = isCase && Status != "Draft";
	document.querySelector("#publish-report").disabled = !isCase || (!isArrest && !isCitation && !IsJudge) || (!IsJudge && Status != "Draft");
	document.querySelector("#delete-report").disabled =  !isCase || (!IsJudge && Served);
	document.querySelector("#serve-report").disabled = Served || isWarrant || !isCase || Status == "Draft";

	//console.log("judge? " + IsJudge)
}

function discardReport() {
	for (var id of ["#new-name-first", "#new-name-last", "#new-id", "#new-case-id", "#report-details"]) {
		document.querySelector(id).value = "";
	}

	Status = "Draft";

	updateReport();
	applyCharges();
}

function startReport(data) {
	$("#new-report-tab").click();

	if (Viewing) {
		data = Viewing.data;

		for (var x in data.character) {
			if (x != "id") {
				data[x] = data.character[x];
			}
		}
	}

	var isCitation = data.plate != undefined;
	var isWarrant = data.status == "Pending" || data.status == "Active";
	var isArrest = !isWarrant;

	// var isArrest = data.

	Status = data.status;
	Served = data.served;

	applyCharges(data.charges);

	document.querySelector("#new-type").value = isCitation ? "Citation" : isArrest ? "Arrest" : "Warrant";
	
	document.querySelector("#new-name-first").value = data.first_name;
	document.querySelector("#new-name-last").value = data.last_name;
	document.querySelector("#new-id").value = data.license_text;
	document.querySelector("#new-case-id").value = data.id || "";
	document.querySelector("#report-details").value = data.details || `Arrest:\nDate/Time:\nLocation of Incident:\nName of Defendant:\nOfficers Involved:\nIncident report:\nSeized items/evidence:\nCharges:\nPlea:`;
	document.querySelector("#report-plead").value = data.plead || "Not Guilty";
	
	changeNew(document.querySelector("#new-type"));
	updateReport();
	filterCharges();
	
	if (isCitation) {
		document.querySelector("#license-plate").value = data.plate;
	}
}

function pushReport(state) {
	var chargesNode = document.querySelector("#current-charges");
	var charges = [];

	var children = chargesNode.children;
	for (var i = 0; i < children.length; i++) {
		var child = children[i];
		var charge = child.charge;
		if (charge) {
			charges.push({
				id: charge.id,
				amount: child.querySelector(".charge-count").count || 1,
			});
		}
	}

	var plead = document.querySelector("#report-plead").value;
	var type = document.querySelector("#new-type").value;
	var details = undefined;
	var plate = undefined;

	if (type == "Citation") {
		plate = document.querySelector("#license-plate").value;
		if (!plate) {
			return;
		}
	} else {
		details = document.querySelector("#report-details").value;
	}

	$.post("http://mdt/report", JSON.stringify({
		state: state,
		type: type,
		plead: plead,
		id: document.querySelector("#new-case-id").value,
		license_text: document.querySelector("#new-id").value,
		first_name: document.querySelector("#new-name-first")?.value || "",
		last_name: document.querySelector("#new-name-last")?.value || "",
		charges: charges,
		details: details,
		plate: plate,
	}));
}