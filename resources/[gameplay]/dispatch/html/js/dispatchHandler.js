Toasts = [];
Reports = {};
IsOpen = false;

function AddNotification(report) {
	this.message = report.message;
	this.title = report.title;
	this.type = report.type;
	this.id = report.identifier;

	toastr.options = {
		"closeButton": false,
		"debug": false,
		"newestOnTop": true,
		"progressBar": true,
		"positionClass": "toast-top-right",
		"preventDuplicates": false,
		"showDuration": "30000",
		"hideDuration": "30000",
		"timeOut": "30000",
		"extendedTimeOut": "32000",
		"showEasing": "swing",
		"hideEasing": "linear",
		"showMethod": "fadeIn",
		"hideMethod": "fadeOut",
		"onclick": function() { $.post("http://dispatch/acceptNotification", JSON.stringify({ identifier: id })) }
	}

	var toast = null;
	
	if (type === "major") {
		toast = toastr.error(message, title);
	} else if (type === "minor") {
		toast = toastr.info(message, title);
	} else if (type === "special") {
		toast = toastr.success(message, title);
	}

	if (toast != null) {
		Toasts.push(toast);
	}
}

function ClearReports() {
	Toasts.forEach(toast => {
		if (toast != undefined) {
			toast.remove();
		}
	});

	Toasts = [];
}

function BuildReports(reports) {
	ClearReports();

	var builtReports = [];

	for (var x in reports) {
		var report = reports[x];
		if (report != undefined && !report.isBlip) {
			builtReports.push(report);
		}
	}

	builtReports.sort((a, b) => {
		return a.time - b.time;
	});

	builtReports.forEach(report => {
		if (report != undefined) {
			AddNotification(report);
		}
	});
}

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.report != undefined) {
		var id = data.report.identifier;
		if (id != undefined) {
			Reports[data.report.identifier] = data.report;
		}
	}

	if (data.reports != undefined) {
		Reports = data.reports;
		BuildReports(data.reports);
	};

	if (data.type == "addNotification") {
		AddNotification(data.report);
	};

	if (data.display != undefined) {
		Toggle = data.display;

		Toasts.forEach(toast => {
			if (toast != undefined) {
				if (Toggle) {
					BuildReports(Reports);
				} else {
					ClearReports();
				}
			}
		});
	}
})