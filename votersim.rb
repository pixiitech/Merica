require "./person.rb"
require "./voter.rb"
require "./politician.rb"
require "./colors.rb"

SEPARATOR = "#{COLORS[:red]}=#{COLORS[:white]}=#{COLORS[:blue]}=" * 24 + "#{COLORS[:none]}"
SEPARATOR_GR = "#{COLORS[:green]}=" * 72 + "#{COLORS[:none]}"
GREETING = 	alternate_colors("How are you today? ", :lightblue, :white) + "#{COLORS[:white]}Are you ready for some patriotism?!\n" + alternate_colors("Register here, be ", :white, :lightblue) + "#{COLORS[:lightred]}American, and then go and VOTE!#{COLORS[:none]}\n" + alternate_colors("Don't be a COMMIE.", :lightblue, :white) + "#{COLORS[:white]} Don't be evil. When you vote,\n#{COLORS[:lightred]}you become more American. These colors don't run\n#{COLORS[:white]}from evil, and sure as hell don't run from the\n#{COLORS[:lightred]}voting booth. Every time you vote, the terrorists\n#{COLORS[:white]}feel pain. Support democracy and CHECK THOSE BOXES!#{COLORS[:none]}"

class DB
	attr_accessor :voters
	attr_accessor :politicians
	def initialize
		@voters = []
		@politicians = []
		@password = "chad"
	end
	def list(type)
    case type
    when "v"
			@voters.each do |voter|
				puts "#{COLORS[:lightblue]}Name: #{voter.name} *** Affiliation: #{voter.affiliation}#{COLORS[:none]}"
			end
		when "p"
			@politicians.each do |pol|
				puts "#{COLORS[:yellow]}Name: #{pol.name} *** Party: #{pol.party}#{COLORS[:none]}"
		  end
		end
	end

	# find_name - looks up a name depending on type
	#     Accepts two strings, type and name
	#     if type is "v", searches for and returns the Voter object with the given name
	#     if type is "p", searches for and returns the Politican object with the given name
	#     if name is "", return nil (used for exiting)
	#     if name is not found in the respective database, returns false
  def find_name(type, name)
  	#puts "Looking for #{type}, #{name}"
  	if name == ""
  		return nil
  	elsif type == "v"
  		idx = @voters.index { |voter| voter.name.downcase.strip == name.downcase.strip }
  		if (idx)
  			return @voters[idx]
  		end
  	elsif type == "p"
  		idx = @politicians.index { |pol| pol.name.downcase.strip == name.downcase.strip }
  		if (idx)
  			return @politicians[idx]
  		end
  	end
  	if (idx == nil)
  		return false
  	end
  end

	# get_name - accepts input of a name from the user depending on type
	#     Accepts a strings, type
	#     if type is "v", check voter database if name already exists. If it does, ask if
	#        user wants to update the registration. If it doesn't exist, return the name
	#     if type is "p", check politician database if name already exists. If it does, ask if
	#        user wants to update the registration. If it doesn't exist, return the name
	#     if name is "", return nil (used for exiting)
	#     if name is not found in the respective database, returns false
	def get_name(type)
		puts "Enter name (enter to cancel):"
		name = gets.chomp
		if name.nil?
			return nil
		else
			validation = !find_name(type, name)
			if (validation == false)
				puts "That name is already registered. Do you wish to update the registration? (Y/N)"
				option = gets.chomp.downcase
				if (option == 'y')
					update(type, name)
				end
				return nil
			end
			if (validation.nil?)
				return nil
			end
			return name
		end
	end

	# Get a voter affiliation from the user, and validate the input based on the list
	# of affiliations from class Voter
	def get_voter_affiliation
		validaff = false
		while (validaff == false)
			puts "Which party are you registering as? (" + Voter.list_affiliations + ")?"
			puts "(hit enter to cancel)"
			newaff = gets.chomp
			validaff = Voter.check_affiliation(newaff)
			if (validaff == false)
				puts "That is not a valid affiliation."
				next
			end
			if (validaff.nil?)
				return nil
			end
			return validaff
		end
	end

	# Get a political party from the user, and validate the input based on the list
	# of parties from class Politician
	def get_politician_party
		validparty = false
		while (validparty == false)
			puts "Which party are you registering for? (" + Politician.list_parties + ")?"
			puts "(hit enter to cancel)"
			newparty = gets.chomp
			validparty = Politician.check_party(newparty)
			if (validparty == false)
				puts "That is not a valid political party."
			end
			if (validparty.nil?)
				return nil
			end
		end
		return validparty
	end

	def register_voter
		puts "Register new voter:"
		newname = get_name("v")
		if newname == nil
			return
		end
		newvoter = Voter.new(newname)
		aff = get_voter_affiliation
		if aff.nil?
			return
		end
		newvoter.affiliation = aff
		@voters << newvoter
		puts "\n#{COLORS[:lightblue]}#{newname} is now registered as #{aff}.#{COLORS[:none]}\n"
  end

  def register_politician
  	puts "Register new politician:"
		newname = get_name("p")
		if newname == nil
			return
		end
		newpolitician = Politician.new(newname)
		party = get_politician_party
		if party.nil?
			return
		end
		newpolitician.party = party
		@politicians << newpolitician
		puts "\n#{COLORS[:yellow]}#{newname} is now registered as #{party}.#{COLORS[:none]}\n"
  end

  def delete(type)
  	print "#{COLORS[:green]}Deleting "
  	print (type == "v" ? "voter registration" : "politician registration")
		puts "\n#{COLORS[:none]}Enter name to delete (enter to cancel):"
		name = gets.chomp
		if name == nil
			return nil
		end
		record = find_name(type, name)
		if (!record)
			puts "Could not find #{name}."
		  return nil
		end
		print (type == "v" ? "#{COLORS[:lightblue]}" : "#{COLORS[:yellow]}")
		print "Are you sure you want to delete"
		print (type == "v" ? " voter" : " politician")
		print " #{record.name}? (Y/N)#{COLORS[:none]}"
		option = gets.chomp.slice(0,1).downcase
		case option
		when "y"
			case type
			when "v"
				@voters.delete(record)
				puts "#{COLORS[:lightblue]}Voter #{record.name} deleted.#{COLORS[:none]}"
			when "p"
				@politicians.delete(record)
				puts "#{COLORS[:yellow]}Politician #{record.name} deleted.#{COLORS[:none]}"
			end
		end
	end

  def update(type, name=nil)
  	print "#{COLORS[:green]}Updating "
  	puts (type == "v" ? "voter registration" : "politician registration")
		if (!name)
		  puts "\n#{COLORS[:none]}Enter name (enter to cancel):"
		  name = gets.chomp
		end
		if name == nil
			return nil
		end
		record = find_name(type, name)
		if (!record)
			puts "Could not find #{name}."
		  return nil
		end
		puts "For #{record.name} do you want to update (N)ame or (P)arty affiliation?"
		option = gets.chomp.slice(0, 1).downcase
		case option
		when "n"
			newname = get_name(type)
			if (newname)
			  puts "Name #{record.name} changed to #{newname}"
			  record.name = newname
			end
		when "p"
			case type
			when "v"
				newaff = get_voter_affiliation
				if (newaff)
				  record.affiliation = newaff
				  puts "#{COLORS[:lightblue]}Affiliation changed to #{newaff}#{COLORS[:none]}"
				end
			when "p"
				newparty = get_politician_party
				if (newparty)
					record.party = newparty
				  puts "#{COLORS[:yellow]}Party changed to #{newparty}#{COLORS[:none]}"
				end
			else
				return
			end
		end
	end

	def public_menu
		puts GREETING
	  loop do
	    puts SEPARATOR
	    puts "Electronic Voting Register"
	    puts SEPARATOR
	  	puts "(R)egister to vote"
	  	puts "(U)pdate your name or affiliation"
	  	puts "(L)ist candidates running for office"
	  	puts "(A)dministration menu"
	  	puts SEPARATOR
	    response = gets.chomp.downcase.slice(0,1)
	    case (response)
    	when "r"
    		register_voter
    	when "u"
    		update("v")
    	when "l"
    		list_politicians
    	when "a"
    		validinput = true
    		powerdown = admin_menu
    		if powerdown
    			puts "#{COLORS[:green]} Powering system down...#{COLORS[:none]}"
    			3.times do
	    			sleep(1)
	    			puts "..."
	    		end
    			break
    		end
	    end
	  end
  end
  def admin_menu
  	loop do
			puts SEPARATOR_GR
			puts "Administration menu"
			puts "Enter Password: ****"
			puts "Verified."
			puts SEPARATOR_GR
			puts "(V)oter database"
			puts "(P)olitician database"
			puts "(S)hutdown machine"
			puts "(Q)uit admin menu"
			puts SEPARATOR_GR
	    response = gets.chomp.downcase.slice(0,1)

	    case (response)
	    when "v"
	    	loop do
	    	  puts SEPARATOR_GR
	    	  puts "Voter Admin Menu"
	    	  puts SEPARATOR_GR
	    	  puts "(L)ist voters"
	    	  puts "(C)reate voter"
	    	  puts "(U)pdate voter"
	    	  puts "(D)elete voter"
	    	  puts "(Q)uit"
				  puts SEPARATOR_GR
	    	  response = gets.chomp.downcase.slice(0,1)
	    	  case response
	    	  when "l"
	    	  	list("v")
	    	  when "c"
	    	  	register_voter
	    	  when "u"
	    	  	update("v")
	    	  when "d"
	    	  	delete("v")
	    	  when "q"
	    	  	break
	    	  end
	    	end
	    when "p"
	    	loop do
	    	  puts SEPARATOR_GR
	    	  puts "Politician Admin Menu"
	    	  puts SEPARATOR_GR
	    	  puts "(L)ist Politicians"
	    	  puts "(C)reate Politicians"
	    	  puts "(U)pdate Politicians"
	    	  puts "(D)elete Politicians"
	    	  puts "(Q)uit"
	    	  puts SEPARATOR_GR
	    	  response = gets.chomp.downcase.slice(0,1)
	    	  case response
	    	  when "l"
	    	  	list("p")
	    	  when "c"
	    	  	register_politician
	    	  when "u"
	    	  	update("p")
	    	  when "d"
	    	  	delete("p")
	    	  when "q"
	    	  	break
	    	  end
	    	end
	    when "s"
	    	return true
	    when "q"
	    	break
	  	end
    end
  end
end

america = DB.new
america.politicians = [
Politician.new("Tronald Dump", "Republican"),
Politician.new("Cattie Felirona", "Republican"),
Politician.new("Billary Crinton", "Democrat"),
Politician.new("Burntie Smellers", "Democrat"),
Politician.new("Osama Bin Liftin", "Independent")
]
america.public_menu