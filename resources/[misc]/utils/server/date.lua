function DateFromTime(time)
	local dob = time / 1000.0
	local offset = 0

	if dob < 0 then
		dob = dob + 4070912400
		offset = 129
	end
	
	local date = os.date("*t", dob)
	if not date then return end

	return ("%d/%02d/%02d"):format(date.year - offset, date.month, date.day), os.date("%Y", os.time()) - date.year + offset
end