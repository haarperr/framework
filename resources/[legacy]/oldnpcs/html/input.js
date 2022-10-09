$("input").keyup(function(event) {
	if (event.key == "Enter") 
	{
		$.post("http://oldnpcs/input", JSON.stringify({
			value: event.target.value,
		}));

		event.value = "";
	}
}); 