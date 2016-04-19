class Politician < Person
  attr_accessor :party
  @@parties = ["Republican", "Democrat", "Independent"]
  def initialize(name, party = nil)
    super(name)
    @party = party
  end
  def self.list_parties
    return @@parties.join(", ")
  end
  def self.check_party(new_party)
    if (new_party == "")
      return false
    end
    @@parties.each do |availparty|
      if availparty.slice(0, new_party.length).downcase == new_party.downcase
        return availparty
      end
    end
    return false
  end
end