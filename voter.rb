class Voter < Person
	attr_accessor :affiliation
  @@affiliations = ["Republican", "Democrat", "Tea Party", "Green Party", "Libertarian", "Socialist", "Independent"]
	def initialize(name, affiliation = nil)
		super(name)
		@affiliation = affiliation
	end
	def self.list_affiliations
		return @@affiliations.join(", ")
	end
  def self.check_affiliation(new_aff)
    if (new_aff == "")
      return false
    end
  	@@affiliations.each do |availaff|
  		if availaff.slice(0, new_aff.length).downcase == new_aff.downcase
  			return availaff
  		end
  	end
  	return false
  end
end