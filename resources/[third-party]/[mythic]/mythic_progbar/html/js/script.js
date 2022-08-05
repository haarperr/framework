var cancelledTimer = null;
var fadeTime = 400

$("document").ready(function() {
	MythicProgBar = {};

	MythicProgBar.Progress = function(data) {
		clearTimeout(cancelledTimer);
		$("#progress-label").text(data.label);
		$(".progress-container").fadeIn(fadeTime);
		$("#progress-bar").stop().css({width: "0px"}).css({width: "0%"}).animate({width: "100%"}, {
			duration: data.duration,
			easing: "linear",
			done: function() {
				$.post("http://mythic_progbar/actionFinish", JSON.stringify({}));
				$(".progress-container").fadeOut(fadeTime, function() {
					$("#progress-bar").removeClass("cancellable");
					$("#progress-bar").css("width", 0);
				})
			}
		});
	};

	MythicProgBar.ProgressCancel = function() {
		$("#progress-bar").stop();
		$("#progress-bar").addClass("cancellable");

		cancelledTimer = setTimeout(function () {
			$(".progress-container").fadeOut(fadeTime, function() {
				$("#progress-bar").css("width", 0);
				$("#progress-bar").removeClass("cancellable");
				$.post("http://mythic_progbar/actionCancel", JSON.stringify({}));
			});
		}, 400);
	};

	MythicProgBar.CloseUI = function() {
		$(".main-container").fadeOut("fast");
	};
	
	window.addEventListener("message", function(event) {
		switch(event.data.action) {
			case "mythic_progress":
				MythicProgBar.Progress(event.data);
				break;
			case "mythic_progress_cancel":
				MythicProgBar.ProgressCancel();
				break;
		}
	});
	
	// Debug.
	// var data = {
	// 	duration: 4000,
	// 	label: "Fuck"
	// }
	// MythicProgBar.Progress(data);

	// var t = setInterval(function(){
	// 	MythicProgBar.ProgressCancel();
	// 	clearInterval(t);
	// }, 2000)
	// var t2 = setInterval(function(){
	// 	MythicProgBar.Progress(data);
	// 	clearInterval(t2);
	// }, 3000)
});