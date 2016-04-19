COLORS = { 			none: "\033[0m",
								black: "\033[0;30m",
								red: "\033[0;31m",
								green: "\033[0;32m",
								brown: "\033[0;33m",
								blue: "\033[0;34m",
								purple: "\033[0;35m",
								cyan: "\033[0;36m",
								lightgray: "\033[0;37m",
								darkgray: "\033[1;30m",
								lightred: "\033[1;31m",
								lightgreen: "\033[1;32m",
								yellow: "\033[1;33m",
								lightblue: "\033[1;34m",
								lightpurple: "\033[1;35m",
								lightcyan: "\033[1;36m",
								white: "\033[1;37m" }

def alternate_colors(str, color1, color2)
  arr = str.chars
  alt = false
  arr.map! do |letter|
  	alt = !alt
  	if (alt)
  		"#{COLORS[color1]}#{letter}"
  	else
  		"#{COLORS[color2]}#{letter}"
  	end
  end
  return arr.join + COLORS[:none]
end