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

def alternate_colors(str, *colors)
  arr = str.chars
  buf = ""
  if colors == []
  	colors = [:none]
  end
  arr.length.times do |idx|
  	buf += "#{COLORS[colors[idx % colors.length]]}#{arr[idx]}"
  end
  return buf + COLORS[:none]
end