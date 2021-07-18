$("input").keyup(function(event) {
	if (event.key == "Enter") 
	{
		$.post("http://npcs/input", JSON.stringify({
			value: event.target.value,
		}));

		event.value = "";
	}
}); 