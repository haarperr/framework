export default class Dummy {
	parts = [
		"Full",
		"SKEL_Head",
		"SKEL_L_Calf",
		"SKEL_L_Clavicle",
		"SKEL_L_Foot",
		"SKEL_L_Forearm",
		"SKEL_L_Hand",
		"SKEL_L_Thigh",
		"SKEL_L_UpperArm",
		"SKEL_Pelvis",
		"SKEL_R_Calf",
		"SKEL_R_Clavicle",
		"SKEL_R_Foot",
		"SKEL_R_Forearm",
		"SKEL_R_Hand",
		"SKEL_R_Thigh",
		"SKEL_R_UpperArm",
		"SKEL_Spine2",
		"SKEL_Spine3",
	]

	effects = {
		"Health": { bg: "grey", fg: "white", low: false, high: false },
		"Blood": { bg: "grey", fg: "white", low: false, high: false },
		"Hunger": { bg: "grey", fg: "white", low: false, high: false },
		"Thirst": { bg: "grey", fg: "white", low: false, high: false },
		"Armor": { bg: "grey", fg: "white", low: false, high: false },
		"Comfort": { bg: "grey", fg: "white", low: false, high: false },
		"Bac": { bg: "grey", fg: "white", low: false, high: false },
		"Drug": { bg: "grey", fg: "white", low: false, high: false },
		"Oxygen": { bg: "grey", fg: "white", low: false, high: false },
		"Poison": { bg: "grey", fg: "white", low: false, high: false },
		"Scuba": { bg: "grey", fg: "white", low: false, high: false },
	}

	canvasSize = 512;

	frames = {
		path: "./images/dummy",
		start: 0,
		end: 500,
		step: 5,
		duration: 100,
		padding: 4,
	}

	palette = {
		healed: [0, 220, 0],
		injured: [220, 0, 0],
	}

	constructor(root, dummy) {
		this.root = root;
		this.dummy = dummy;
		this.info = {};
		
		this.build();

		setInterval(() => {
			requestAnimationFrame(() => this.nextFrame());
		}, this.frames.duration)
	}

	updateInfo(p1, p2) {
		if (typeof p1 === "string") {
			this.info[p1] = p2
		} else {
			this.info = p1
		}
	}

	updateEffect(name, value) {
		const effect = this.effects[name];
		const effectElement = this.effectElements[name];
		if (!effectElement) return;
		
		const display = (effect.high || value < 0.99) && (effect.low || value > 0.01);

		effectElement.root.style.display = display ? "flex" : "none";

		if (!display) return;

		const color = this.lerp(this.palette.injured, this.palette.healed, value);

		effectElement.fill.style.top = `${(1.0 - value) * 100.0}%`;
		effectElement.fill.style.background = `rgba(${color[0]}, ${color[1]}, ${color[2]}, 0.8)`;
	}

	build() {
		this.buffer = {};
		this.elements = {};
		this.frame = this.frames.start;
		this.bufferSize = 8;

		// Create canvases.
		for (let index = 0; index < this.parts.length; index++) {
			const canvas = document.createElement("canvas");
			canvas.classList.add("body-part");

			canvas.width = this.canvasSize;
			canvas.height = this.canvasSize;
			
			this.buffer[index] = {};
			this.elements[index] = canvas;
			this.root.appendChild(canvas);

			for (let frame = this.frames.start; frame < this.frames.start + this.frames.step * this.bufferSize; frame += this.frames.step) {
				this.insertBuffer(index, frame);
			}
		}

		// Create effects.
		this.effectInfo = {};
		this.effectElements = {};

		this.effectsRoot = document.createElement("div");
		this.effectsRoot.classList.add("effects");
		this.root.appendChild(this.effectsRoot);

		for (var name in this.effects) {
			const effect = this.effects[name];
			const element = document.createElement("div");
			element.classList.add("effect");
			element.style.display = "none";

			if (effect.bg) {
				element.classList.add(effect.bg);
			}

			const fill = document.createElement("div");
			fill.classList.add("fill");

			const icon = document.createElement("div");
			icon.classList.add("icon");
			icon.style.maskImage = `url('./images/icons/${name}.png')`;
			icon.style.webkitMaskImage = icon.style.maskImage;
			
			if (effect.fg) {
				icon.classList.add(effect.fg);
			}
			
			element.appendChild(fill);
			element.appendChild(icon);
			this.effectsRoot.appendChild(element);

			this.effectElements[name] = {
				root: element,
				fill: fill,
			}
		}

		// Create pattern.
		this.pattern = new Image();
		this.pattern.src = "./images/misc/pattern.png";

		// Update first frame.
		this.updateFrame();
	}

	getFramePath(name, frame) {
		return `${this.frames.path}/${name}/${frame.toString().padStart(this.frames.padding, "0")}.png`;
	}

	nextFrame(frame) {
		let nextFrame = (frame ?? this.frame) + this.frames.step;

		if (nextFrame >= this.frames.end) {
			nextFrame = this.frames.start + (nextFrame % this.frames.end);
		}
		
		if (!frame) {
			for (var index in this.buffer) {
				var buffer = this.buffer[index];
				if (!buffer || !buffer[nextFrame]?.complete) {
					// console.log("stop frame", buffer, nextFrame)
					return
				}
			}

			this.frame = nextFrame;
			this.updateFrame();
		}

		return nextFrame;
	}

	updateFrame() {
		for (let index = 0; index < this.parts.length; index++) {
			this.updateBodyPart(index);
		}
	}

	render() {
		let then = Date.now();

		this.nextFrame();
		requestAnimationFrame(() => this.render())

		let now = Date.now();
		let elapsed = now - then;

		console.log(elapsed);
	}

	updateBodyPart(index) {
		const frame = this.frame;

		// Get image.
		const img = this.buffer[index][frame];
		if (!img?.complete) return;

		// Get info.
		const name = this.parts[index];
		const isFull = name == "Full";
		const info = this.info[name];
		var color = isFull ? [255, 255, 255] : this.lerp(this.palette.injured, this.palette.healed, info?.health ?? 1.0);
		
		// Update canvas.
		const canvas = this.elements[index];
		const ctx = canvas.getContext("2d");

		ctx.clearRect(0, 0, canvas.width, canvas.height);
		ctx.globalCompositeOperation = "source-over";
		
		if (isFull) {
			ctx.drawImage(img, 0, 0, img.width, img.height);
		} else {
			ctx.fillStyle = `rgb(${color[0]}, ${color[1]}, ${color[2]})`;
			ctx.fillRect(0, 0, canvas.width, canvas.height);
			
			ctx.globalCompositeOperation = "destination-in";
			
			ctx.drawImage(img, 0, 0, img.width, img.height);
			
			if (info?.fractured) {
				var pattern = this.pattern;
				ctx.drawImage(pattern, 0, 0, pattern.width, pattern.height);
			}
		}
		
		ctx.restore();
		ctx.save();

		// this.removeBuffer(index, frame);
		this.insertBuffer(index, this.nextFrame(this.frame + this.frames.step * (this.bufferSize - 2)));
	}

	insertBuffer(index, frame) {
		if (this.buffer[index][frame]) return;

		const name = this.parts[index];
		const path = this.getFramePath(name, frame);

		var img = new Image();
		img.src = path;

		this.buffer[index][frame] = img;
	}

	// removeBuffer(index, frame) {
	// 	var img = this.buffer[index][frame];
	// 	img.src = "";
	// 	img = null;

	// 	delete this.buffer[index][frame];
	// }

	lerp(from, to, value) {
		var output = []
		for (let channel = 0; channel < 3; channel++) {
			output[channel] = (to[channel] - from[channel]) * value + from[channel]
		}
		return output;
	}
}