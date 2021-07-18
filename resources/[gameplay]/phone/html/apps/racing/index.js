var Dragging = undefined;
var Editing = undefined;
var LastOver = undefined;
var Tracks = [];

$(document).ready(() => {
	// var track = addTrack({
	// 	name: "New Track",
	// 	checkpoints: [ "Los Santos Freeway", "Legion Square", "Pillbox Hill", "Some Other Place" ],
	// });

	// addTrack({
	// 	name: "Test Track",
	// 	checkpoints: [ "Los Santos Freeway", "Legion Square" ],
	// });
	
	// editTrack(track);
});

$(document).on("mouseup", () => {
	if (!Dragging) {
		return;
	}
	
	if (LastOver) {
		var instance = LastOver.trackInstance;
		var tableNode = instance.querySelector("tbody");
		var index = Dragging.rowIndex;
		var targetIndex = LastOver.rowIndex + (LastOver.dragDir == -1 ? 0 : 1);
		var targetNode = tableNode.children[LastOver.rowIndex + LastOver.dragDir];

		if (targetNode) {
			tableNode.insertBefore(Dragging, targetNode);
		} else {
			tableNode.appendChild(Dragging);
		}

		$.post("http://phone/moveCheckpoint", JSON.stringify({
			name: instance?.track?.name,
			index: index,
			targetIndex: targetIndex,
		}));

		var checkpoints = instance.track.checkpoints;
		const oldCheckpoint = checkpoints[index - 1];
		checkpoints[index - 1] = checkpoints[targetIndex - 1];
		checkpoints[targetIndex - 1] = oldCheckpoint;

		for	(var childIndex in tableNode.children) {
			var node = tableNode.children[childIndex];
			if (typeof node === "object") {
				node.querySelector("#id").innerHTML = (childIndex + 1).toString();
			}
		}
		
		LastOver = undefined;
	}

	Dragging.style.background = "transparent";
	Dragging = undefined;
});

$("#add-track").click(() => {
	$.post("http://phone/addTrack")
});

window.addEventListener("message", function(event) {
	var data = event.data;

	if (data.closed) {
		if (Editing && Editing.isEditing) {
			editTrack(Editing);
		}
	}

	var payload = data.payload;
	if (!payload) {
		return;
	}

	if (payload.addTrack) {
		addTrack(payload.addTrack);
	}

	if (payload.updateTrack) {
		updateTrack(payload.updateTrack);
	}

	if (payload.tracks) {
		for (let track of payload.tracks) {
			addTrack(track);
		}
	}
});

function addTrack(track) {
	if (!track) {
		return;
	}

	var template = document.querySelector("#track-template");

	let instance = template.cloneNode(true);
	instance.id = "track-instance";
	instance.style.display = "flex";
	template.parentNode.appendChild(instance);
	
	instance.track = track;
	instance.isEditing = false;
	
	instance.querySelector("#title").innerHTML = track.name;
	instance.querySelector("#checkpoints").innerHTML = `${track.checkpoints.length} checkpoints / ${track.laps} laps`;
	instance.querySelector("#edit").onclick = () => { editTrack(instance) };
	instance.querySelector("#start").onclick = () => { startTrack(instance) };

	var deleteNode = instance.querySelector("#delete");
	deleteNode.onclick = () => { deleteTrack(instance) };
	deleteNode.style.display = "none";

	Tracks[track.name] = instance;

	return instance;
}

function deleteTrack(instance) {
	var track = instance.track;

	$.post("http://phone/deleteTrack", JSON.stringify({
		name: track.name,
	}));

	if (instance.isEditing) {
		editTrack(instance);
	}

	instance.remove();
}

function startTrack(instance) {
	$.post("http://phone/startTrack", JSON.stringify({
		name: instance?.track?.name,
	}));
}

function editTrack(instance) {
	var track = instance.track;
	
	// Set editing or saving.
	var isEditing = !instance.isEditing;
	instance.isEditing = isEditing;

	// Post message.
	$.post("http://phone/editTrack", JSON.stringify({
		name: isEditing ? track.name : undefined,
	}))

	// Get nodes.
	var titleNode = instance.querySelector("#title");
	var inputNode = instance.querySelector("#title-input");
	var editNode = instance.querySelector("#edit");
	var addNode = instance.querySelector("#add-checkpoint");
	var deleteNode = instance.querySelector("#delete");
	var lapsNode = instance.querySelector("#laps");

	// Begin editing.
	if (isEditing) {
		// Update current track.
		if (Editing && Editing.isEditing) {
			editTrack(Editing);
		}

		Editing = instance;

		// Update the values.
		inputNode.value = titleNode.innerHTML;
		lapsNode.value = track.laps;

		// Update the table.
		updateTable(instance);
	} else {
		// Update current track.
		if (Editing == instance) {
			Editing = undefined;
		}

		// Get the name.
		var newName = inputNode.value == "" ? "New Track" : inputNode.value;
		var oldName = titleNode.innerHTML;
		var nameConflicts = 1;
		const _newName = newName;

		while (Tracks[newName] && Tracks[newName] != instance) {
			nameConflicts += 1;
			
			newName = `${_newName} ${nameConflicts}`;
		}
		
		// Save track.
		$.post("http://phone/saveTracks", JSON.stringify({
			oldName: oldName,
			newName: newName,
			laps: lapsNode.value,
		}));
		
		// Update the values.
		titleNode.innerHTML = newName;
		instance.track.name = newName;
		instance.track.laps = lapsNode.value;
	}

	// Update the buttons.
	deleteNode.style.display = isEditing ? "block" : "none";
	editNode.innerHTML = isEditing ? "Save" : "Edit";
	addNode.onclick = () => {
		addCheckpoint(instance, instance.track?.checkpoints?.length || 0);
	};
	
	// Update the root visibility.
	instance.querySelector("#editing").style.display = isEditing ? "flex" : "none";
	instance.querySelector("#viewing").style.display = isEditing ? "none" : "flex";
	document.querySelector(".add").style.display = isEditing ? "none" : "block";
}

function updateTrack(data) {
	var instance = Tracks[data.name];

	if (!instance) {
		return;
	}

	var track = instance.track;

	track.checkpoints = data.checkpoints;

	updateTable(instance);
}

function addCheckpoint(instance, checkpoint) {
	var track = instance.track;

	if (typeof checkpoint === "number") {
		$.post("http://phone/addCheckpoint", JSON.stringify({
			name: track.name,
			index: checkpoint,
		}));
		
		return;
	}

	var tableNode = instance.querySelector("tbody");

	// Create the elements.
	const rowNode = document.createElement("tr");
	const idNode = document.createElement("th");
	const locationNode = document.createElement("th");
	const optionsNode = document.createElement("th");
	const innerOptionsNode = document.createElement("div");
	const addButton = document.createElement("button");
	const removeButton = document.createElement("button");
	
	// Setup the row.
	rowNode.trackInstance = instance;
	
	// Make it draggable.
	// rowNode.onmousedown = (e) => {
	// 	Dragging = rowNode;
	
	// 	rowNode.style.background = "rgba(128, 128, 128, 0.5)";
	// };
	
	rowNode.onmouseup = (e) => {
		rowNode.style.boxShadow = "none";
	};
	
	rowNode.onmouseleave = (e) => {
		if (rowNode == LastOver) {
			LastOver = undefined;
		}
	
		rowNode.style.boxShadow = "none";
	};
	
	rowNode.onmousemove = (e) => {
		if (!Dragging) {
			return;
		}
	
		if (Dragging == rowNode) {
			return;
		}
	
		var color = "rgba(64, 128, 255, 1.0)";
		var bounding = rowNode.getBoundingClientRect();
	
		if (e.clientY < bounding.y + bounding.height * 0.5) {
			rowNode.style.boxShadow = `0px -5px 0px ${color}`;
			rowNode.dragDir = -1;
		} else {
			rowNode.style.boxShadow = `0px 4px 0px ${color}`;
			rowNode.dragDir = 1;
		}
	
		LastOver = rowNode;
	};
	
	// Set the values.
	// idNode.innerHTML = (index + 1).toString();
	idNode.id = "id";
	locationNode.innerHTML = checkpoint;
	
	// Setup the buttons.
	innerOptionsNode.style.display = "flex";
	innerOptionsNode.style.flexDirection = "row";
	
	addButton.classList.add("btn");
	addButton.classList.add("track-add");
	addButton.innerHTML = "+";
	addButton.onclick = () => {
		addCheckpoint(instance, rowNode.rowIndex - 1);
	};
	
	removeButton.classList.add("btn");
	removeButton.classList.add("track-remove");
	removeButton.innerHTML = "-";
	removeButton.onclick = () => {
		removeCheckpoint(instance, rowNode.rowIndex);
	};
	
	// Append the children.
	rowNode.appendChild(idNode);
	rowNode.appendChild(locationNode);
	rowNode.appendChild(optionsNode);
	
	innerOptionsNode.appendChild(addButton);
	innerOptionsNode.appendChild(removeButton);
	optionsNode.appendChild(innerOptionsNode);
	
	tableNode.appendChild(rowNode);

	return rowNode;
}

function removeCheckpoint(instance, index) {
	$.post("http://phone/removeCheckpoint", JSON.stringify({
		name: instance?.track?.name,
		index: index,
	}));

	instance?.track?.checkpoints?.splice(index - 1, 1);
	updateTable(instance);
}

function updateTable(instance) {
	var track = instance.track;
	var tableNode = instance.querySelector("tbody");
	tableNode.innerHTML = "";

	for (let index = 0; index < track.checkpoints.length; index++) {
		let checkpoint = track.checkpoints[index];
		let checkpointInstance = addCheckpoint(instance, checkpoint);
		checkpointInstance.querySelector("#id").innerHTML = (index + 1).toString();
	}

	instance.querySelector("#checkpoints").innerHTML = `${track.checkpoints.length} checkpoints / ${track.laps} laps`;
}