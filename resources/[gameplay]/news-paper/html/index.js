Charges = {}
ChargeReferences = {}
Editing = undefined;
EnableDebug = false;
EntryHandle = 0;
EntryTemplate = undefined;
IsEditing = false;
LastSearch = {};
Offset = 0;
SearchLimit = 50;
Spinner = undefined;
Waiting = false;

$(document).ready(function() {
	
});

window.addEventListener("message", function(event) {
	var data = event.data;
	
	if (data.display === true) {
		$("#main")[0].style.display = "block";
	} else if (data.display === false) {
		$("#main")[0].style.display = "none";
	}
});