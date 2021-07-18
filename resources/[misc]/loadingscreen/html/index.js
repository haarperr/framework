document.addEventListener("DOMContentLoaded", function() {
	let background = document.querySelector("video");
	let fromX = 0.0;
	let fromY = 0.0;
	let offsetX = 0.0;
	let offsetY = 0.0;
	let targetX = 0.0;
	let targetY = 0.0;
	let targetTime = 0;
	let scale = 2.0;
	let duration = 1000.0;

	setInterval(() => {
		var time = new Date().getTime();
		
		if (time >= targetTime) {
			duration = lerp(1000, 2000, Math.random()^1.5);
			targetTime = time + Math.floor(duration);

			fromX = offsetX;
			fromY = offsetY;

			targetX = Math.random();
			targetY = Math.random();
		}

		var delta = Math.sin(1.0 - (targetTime - time) / duration);

		offsetX = Math.min(Math.max(lerp(fromX, targetX, delta), 0.0), 1.0);
		offsetY = Math.min(Math.max(lerp(fromY, targetY, delta), 0.0), 1.0);

		background.style.transform = `translate(-${50 + (offsetX - 0.5) * scale}%, -${50 + (offsetY - 0.5) * scale}%) scale(${1.0 + scale * 0.01})`;

	}, 20);
});

function lerp(a, b, u) {
	return (1 - u) * a + u * b;
}