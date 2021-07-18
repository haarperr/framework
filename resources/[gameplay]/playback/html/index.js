var Logs = [];
var Scene = undefined;
var Camera = undefined;
var Renderer = undefined;

window.addEventListener("message", (event) => {
	var data = event.data;

	if (data.toggle != undefined) {
		document.querySelector("#main").style.display = data.toggle ? "block" : "none";
	}

	if (data.time) {
		document.querySelector("#time").innerHTML = formatTime(data.time);
	}

	if (data.camera) {
		if (!Camera) {
			// Create the scene.
			Scene = new THREE.Scene();

			// Create the camera.
			Camera = new THREE.PerspectiveCamera(data.camera.fov, window.innerWidth / window.innerHeight, 1, 1000);

			// Create the renderer.
			Renderer = new THREE.CSS2DRenderer();
			Renderer.domElement.style.position = "absolute";
			Renderer.domElement.style.top = "0px";
			Renderer.setSize(window.innerWidth, window.innerHeight);
			
			document.body.appendChild(Renderer.domElement);

			animate();
		}

		Camera.up.set(0, 0, 1);

		Camera.fov = data.camera.fov;
		Camera.position.set(data.camera.pos.x, data.camera.pos.y, data.camera.pos.z);
		Camera.lookAt(data.camera.target.x, data.camera.target.y, data.camera.target.z);

		Camera.updateProjectionMatrix();
		Camera.updateMatrix();
		Camera.updateMatrixWorld();
	}

	if (data.logs) {
		setLogs(data.logs);
	}

	if (data.interval) {
		document.querySelector("#interval").textContent = data.interval;
	}
});

window.addEventListener("resize", () => {
	Camera.aspect = window.innerWidth / window.innerHeight;

	Renderer.setSize(window.innerWidth, window.innerHeight);
});

function animate() {
	if (!Renderer) {
		return;
	}

	requestAnimationFrame(animate);

	Renderer.render(Scene, Camera);
}

function setLogs(logs) {
	if (Logs) {
		for (var log of Logs) {
			if (log.object) {
				Scene.remove(log.object);
			}
		}
	}

	for (var log of logs) {
		const domElement = document.createElement("div");
		domElement.className = "label";
		domElement.innerHTML = getText(log);
		domElement.style.marginTop = '-1em';
		// domElement.style.marginTop = '-1em';

		// document.body.appendChild(domElement);

		const logLabel = new THREE.CSS2DObject(domElement);
		Scene.add(logLabel);
		logLabel.position.set(log.pos_x, log.pos_y, log.pos_z);

		log.object = logLabel;
		log.domElement = domElement;
		// log.vector = new THREE.Vector3(log.pos_x, log.pos_y, log.pos_z);
	}

	Logs = logs;
}

function getText(log) {
	var text = `[${log.resource}] ${formatTime(log.time_stamp / 1000.0)}<br>`;

	if (log.source) {
		text = appendText(text, `[${log.source}]`);
	}

	text = appendText(text, log.verb);
	text = appendText(text, log.noun);

	if (log.target) {
		text = appendText(text, `[${log.target}]`);
	}

	if (log.extra) {
		text = appendText(text, `(${log.extra})`);
	}

	return text;
}

function appendText(text, append) {
	if (!append) return "";

	if (text != "") {
		text = text + " ";
	}

	return text + append;
}

function formatTime(time) {
	var date = new Date(Date.UTC(1970, 0, 1));
	date.setUTCSeconds(time);

	return `${date.getFullYear()}-${date.getMonth()}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
}