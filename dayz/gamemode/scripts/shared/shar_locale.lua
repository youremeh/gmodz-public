Locales = {}
function _(str,...)
	if Locales[Language] ~= nil then
		if Locales[Language][str] ~= nil then
			return string.format(Locales[Language][str], ...)
		else
			return 'Translation ['..Language..']['..str..'] does not exist'
		end
	else
		return 'Language ['..Language..'] does not exist'
	end
end

function _U(str,...)
	return tostring(_(str,...):gsub("^%l", string.upper))
end