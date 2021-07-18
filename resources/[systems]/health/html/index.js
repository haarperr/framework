Config = {
	RespawnTime: 300,
	StartColor: { r: 0, g: 128, b: 0 },
	EndColor: { r: 128, g: 0, b: 0 },
	ArmorEmptyColor: { r: 0, g: 0, b: 0 },
	ArmorFullColor: { r: 35, g: 85, b: 173 },
	FadeInt: 1000,
	FadeOut: 2000,
	FadeTimeout: 6000,
	PositiveEffects: {
		["Comfort"]: true,
		["Armor"]: true,
		["Scuba"]: true,
	},
	BodyParts: {
		31086: { id: "Head", name: "Head" },
		24818: { id: "Spine3", name: "Chest" },
		24817: { id: "Spine2", name: "Abdomen" },
		11816: { id: "Pelvis", name: "Pelvis" },
		10706: { id: "R_Clavicle", name: "Right Clavicle" },
		40269: { id: "R_UpperArm", name: "Right UpperArm" },
		28252: { id: "R_Forearm", name: "Right Forearm" },
		57005: { id: "R_Hand", name: "Right Hand" },
		51826: { id: "R_Thigh", name: "Right Thigh" },
		36864: { id: "R_Calf", name: "Right Calf" },
		52301: { id: "R_Foot", name: "Right Foot" },
		64729: { id: "L_Clavicle", name: "Left Clavicle" },
		45509: { id: "L_UpperArm", name: "Left UpperArm" },
		61163: { id: "L_Forearm", name: "Left Forearm" },
		18905: { id: "L_Hand", name: "Left Hand" },
		58271: { id: "L_Thigh", name: "Left Thigh" },
		63931: { id: "L_Calf", name: "Left Calf" },
		14201: { id: "L_Foot", name: "Left Foot" },
	},
	// OtherParts: [
	// 	{ id: "Armor", opacity: 1.0 }
	// ],
	Tools: {
		// "Drugs": [
		// 	{ name: "Acetaminophen" },
		// 	{ name: "Adrenaline" },
		// 	{ name: "Albuterol" },
		// 	{ name: "Aspirin" },
		// 	{ name: "Codeine" },
		// 	{ name: "Glucagon" },
		// 	{ name: "GTN" },
		// 	{ name: "Ibuprofen" },
		// 	{ name: "Morphine" },
		// 	{ name: "Narcan" },
		// 	{ name: "Nitrous Oxide" },
		// 	{ name: "Propofol" },
		// ],
		"Fluid Loss": [
			{ name: "IV Kit" },
			{ name: "Quick Clot" },
			{ name: "Saline" },
		],
		"Wound Care": [
			// { name: "Antiseptic" },
			{ name: "Cohesive Bandage" },
			{ name: "Gauze" },
			{ name: "Ice Pack" },
			{ name: "Medical Tape" },
			{ name: "Bandaid" },
			{ name: "Liquid Bandage" },
		],
		"Tools": [
			{ name: "Forceps" },
			{ name: "Tourniquet" },
			// { name: "Trauma Shears" },
		],
		// "Diagnostics": [
		// 	{ name: "BP Meter" },
		// 	{ name: "ECG" },
		// 	{ name: "Glucometer" },
		// 	{ name: "Opthalmoscope" },
		// 	{ name: "Pulse Oximeter" },
		// 	{ name: "Stethoscope" },
		// 	{ name: "Thermometer" },
		// ],
		"Immobilization": [
			// { name: "Folding Stretcher" },
			// { name: "Immobilization" },
			{ name: "Neck Brace" },
			{ name: "Splint" },
			{ name: "Cast" },
			// { name: "Wheel Chair" },
		],
		// "Airways": [
		// 	{ name: "BVM" },
		// 	{ name: "Laryngoscope" },
		// 	{ name: "Nasopharyngeal Airway" },
		// 	{ name: "Oxygen" },
		// 	{ name: "Suction Device" },
		// 	{ name: "Tracheal Tubes" },
		// 	{ name: "Ventilator" },
		// ],
		"Protection": [
			{ name: "Fire Blanket" },
		],
		// "Misc": [
		// 	{ name: "Syringe" },
		// ],
	},
};

ComponentsCache = [];
Effects = {};
FadeHandle = null;
InjuryNodes = [];
IsDead = false;
Selected = null;

$(document).ready(function() {
	var roots = document.getElementsByClassName("vitals root");

	for (let root of roots) {
		var componentTemplate = undefined;

		for (var i = 0; i < root.childNodes.length; i++) {
			var className = root.childNodes[i].className;
			if (className != undefined && root.childNodes[i].className.includes("component")) {
				componentTemplate = root.childNodes[i];
			}
		}

		if (componentTemplate == undefined) {
			continue;
		}

		ComponentsCache[root.id] = [];

		for (let boneId in Config.BodyParts) {
			var bodyPart = Config.BodyParts[boneId];
			var component = componentTemplate.cloneNode(true);
			component.id = "bone";
			componentTemplate.parentNode.appendChild(component);

			setImage(component, bodyPart.id);

			ComponentsCache[root.id][boneId] = component;
		}

		// for (let partIndex in Config.OtherParts) {
		// 	var part = Config.OtherParts[partIndex];
		// 	var component = componentTemplate.cloneNode(true);
		// 	component.id = "armor";
		// 	componentTemplate.parentNode.appendChild(component);

		// 	if (part.opacity != null) {
		// 		component.style.opacity = part.opacity;
		// 	}

		// 	setImage(component, part.id);

		// 	ComponentsCache[root.id][part.id] = component;
		// }

		componentTemplate.remove();
	}

	var groupTemplateNode = $("#tool-group")[0];
	var toolTemplateNode = $("#tool-option")[0];

	for (let toolGroup in Config.Tools) {
		var groupNode = groupTemplateNode.cloneNode(true);
		groupNode.textContent = toolGroup;
		groupTemplateNode.parentNode.appendChild(groupNode);

		var tools = Config.Tools[toolGroup];
		for (let toolIndex in tools) {
			var tool = tools[toolIndex].name;
			var toolNode = toolTemplateNode.cloneNode(true);
			toolNode.textContent = tool;

			toolNode.onclick = function() {
				console.log("USE TOOL");
				return false;
			};

			toolTemplateNode.parentNode.appendChild(toolNode);
		}
	}

	$("#injury-option")[0].style.display = "none";
	$("#injury-group")[0].style.display = "none";

	groupTemplateNode.remove();
	toolTemplateNode.remove();

	$("#hud").fadeOut(0);

	// $("#hud").fadeIn(0);
	// addEffect("Hunger", 1.0);
	// addEffect("Thirst", 1.0);
});

function setImage(component, name) {
	component.style.setProperty("-webkit-mask-image", "url(images/" + name + ".png)");
	component.style.setProperty("-mask-image", "url(images/" + name + ".png)");
}

function showHud(isDead) {
	$("#hud").fadeIn(Config.FadeIn);

	if (FadeHandle != null) {
		clearTimeout(FadeHandle);
		FadeHandle = null;
	}

	if (!isDead) {
		FadeHandle = setTimeout(function() {
			$("#hud").fadeOut(Config.FadeOut);
		}, Config.FadeTimeout);
	}
}

function lerp(a, b, u) {
	return (1 - u) * a + u * b;
}

function lerpColor(from, to, amount) {
	color = {
		r: Math.round(lerp(from.r, to.r, amount)),
		g: Math.round(lerp(from.g, to.g, amount)),
		b: Math.round(lerp(from.b, to.b, amount)),
		a: from.a && to.a ? Math.round(lerp(from.a, to.a, amount)) : 1.0,
	};
	
	return color;
}

window.addEventListener("message", function(event) {
	if (event.data == null) {
		return;
	}

	var data = event.data;
	var isCheckup = data.check === true;

	if (data.health != undefined) {
		$("#health").css("top", ((1.0 - data.health) * 100.0) + "%");
	}

	if (isCheckup) {
		$("#check").css("display", "block");
	}

	if (data.addEffect != undefined) {
		addEffect(data.addEffect.name, data.addEffect.amount);
	}

	if (data.clearEffect != undefined) {
		clearEffect(data.clearEffect);
	}

	if (data.clearEffects != undefined) {
		clearEffects();
	}

	// if (data.armor != undefined) {
	// 	for (let root in ComponentsCache) {
	// 		var armorComponent = ComponentsCache[root]["Armor"];
	// 		var r = Math.round(lerp(Config.ArmorEmptyColor.r, Config.ArmorFullColor.r, data.armor || 0));
	// 		var g = Math.round(lerp(Config.ArmorEmptyColor.g, Config.ArmorFullColor.g, data.armor || 0));
	// 		var b = Math.round(lerp(Config.ArmorEmptyColor.b, Config.ArmorFullColor.b, data.armor || 0));

	// 		armorComponent.style.background = "rgba(" + r + ", " + g + ", " + b + ")";
	// 		armorComponent.style.opacity = data.armor > 0.01 ? 1.0 : 0.0;
	// 	}
	// }

	if (data.info != undefined && data.info.bones != undefined) {
		if (isCheckup) {
			for (let node of InjuryNodes) {
				node.remove();
			}
		}

		var groupNodeTemplate = isCheckup ? $("#injury-group")[0] : undefined;
		var injuryNodeTemplate = isCheckup ? $("#injury-option")[0] : undefined;

		for (let boneId in Config.BodyParts) {
			var partInfo = data.info.bones[boneId];
			var bodyPart = Config.BodyParts[boneId];

			for (let root in ComponentsCache) {
				var component = ComponentsCache[root][boneId];

				if (partInfo != undefined) {
					var damage = Math.min(partInfo.damage, 1.0) || 0;
					var armor = partInfo.armor;
					var color = { r: 0, g: 0, b: 0, a: 0.1 };

					if (armor != undefined && armor >= 0.001) {
						color = lerpColor(Config.ArmorEmptyColor, Config.ArmorFullColor, armor);
					} else if (damage <= 0.95) {
						color = lerpColor(Config.StartColor, Config.EndColor, damage / 0.95);
					}

					component.style.background = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a})`;
				} else {
					component.style.background = "green";
				}
			}

			if (isCheckup && partInfo != undefined && partInfo.injuries != undefined && Object.keys(partInfo.injuries).length > 0) {
				var groupNode = groupNodeTemplate.cloneNode(true);
				groupNode.id = "";
				groupNode.textContent = bodyPart.name;
				groupNode.style.display = "block";
				groupNodeTemplate.parentNode.appendChild(groupNode);
				InjuryNodes.push(groupNode);

				for (let injury in partInfo.injuries) {
					var injuryData = partInfo.injuries[injury];
					if (injuryData.text == undefined) {
						for (let occurrenceIndex in injuryData.occurrences) {
							createInjury(injuryData.occurrences[occurrenceIndex]);
						}
					} else {
						createInjury(injuryData);
					}
				}
			}
		}

		if (!isCheckup) {
			showHud(data.dead == true);
		}
	}
	// $("#main").css("display", data.hidden ? "none" : "initial");

	if (data.dead != undefined && IsDead != data.dead) {
		IsDead = data.dead;
		var startTime = new Date().getTime();

		if (data.dead) {
			var interval = setInterval(() => {
				if (!IsDead) {
					clearInterval(interval);
					return;
				}

				var time = new Date().getTime();
				var timeLeft = Config.RespawnTime - Math.round((time - startTime) / 1000);
				if (timeLeft <= 0) {
					$(".counter").text("You may now respawn! (/respawn)");
				} else {
					$(".counter").text(`You may respawn in ${timeLeft} seconds...`);
				}
			}, 1000);
		} else {
			$(".counter").text("");
		}
	}
});

document.getElementById("close").onclick = function() {
	$.post('http://health/closeMenu', JSON.stringify({}));
	$("#check").css("display", "none");
};

function createInjury(injuryData) {
	var injuryNodeTemplate = $("#injury-option")[0];
	var injuryNode = injuryNodeTemplate.cloneNode(true);
	injuryNode.id = "";
	injuryNode.textContent = injuryData.text || "Unknown";
	injuryNode.style.display = "block";
	injuryNode.style.backgroundColor = "rgba(200, 30, 30, " + Math.min(injuryData.damage || injuryData.totalDamage || 0.0, 1.0) * 0.5 + ")";

	injuryNode.onclick = function() {
		if (Selected != null) {
			Selected.style.borderLeft = "none";
		}
		Selected = injuryNode;
		injuryNode.style.borderLeft = "6px solid DodgerBlue";
	}

	injuryNodeTemplate.parentNode.appendChild(injuryNode);
	InjuryNodes.push(injuryNode);

	return injuryNode;
}

function clearEffects() {
	$("#icon").remove();
}

function clearEffect(name) {
	var effect = Effects[name];
	if (effect != undefined) {
		effect.remove();
		Effects[name] = undefined;
	}
}

function addEffect(name, amount) {
	if (amount <= 0.01) {
		clearEffect(name);
		return;
	}

	var template = document.querySelector("#icon-template");
	var instance = Effects[name] || template.cloneNode(true);
	instance.id = "icon";
	instance.style.display = "block";
	template.parentNode.appendChild(instance);

	var isPositive = Config.PositiveEffects[name] === true;
	var red = { r: 255, g: 0, b: 0 };
	var orange = { r: 255, g: 128, b: 0 };
	var yellow = { r: 255, g: 255, b: 0 };
	var green = { r: 0, g: 255, b: 0 };

	var color = isPositive ? red : green;

	if (amount >= 0.75) {
		color = isPositive ? green : red;
	} else if (amount >= 0.5) {
		color = lerpColor(isPositive ? yellow : orange, isPositive ? green : red, (amount - 0.5) / 0.25);
	} else if (amount >= 0.25) {
		color = lerpColor(isPositive ? orange : yellow, isPositive ? yellow : orange, (amount - 0.25) / 0.25);
	} else {
		color = lerpColor(isPositive ? red : green, isPositive ? orange : yellow, amount / 0.25);
	}

	// opacity = Math.min((amount - 0.1) / 0.9, 1.0);
	color.a = Math.min(amount / 1.0, 1.0);
	// opacity = 1.0

	var image = instance.querySelector(".icon-image");
	setImage(image, name);
	// image.style.background = color;
	image.style.background = `rgba(${color.r}, ${color.g}, ${color.b}, ${color.a})`;

	Effects[name] = instance;
}