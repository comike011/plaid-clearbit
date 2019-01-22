class Company
  attr_accessor :name, :logo, :domain, :enriched_data, :description

  def initialize(plaid_name)
    @name = plaid_name
    @domain = domain_from_name(self.name)
    @enriched_data = enrichment_values(self.domain)
    @logo = self.enriched_data.fetch(:logo, 'notfound.png') || 'notfound.png'
    @description = self.enriched_data.fetch(:description, "Company information could not be found for #{self.name}.")
  end

  private

  def domain_from_name(name)
    domain = Clearbit::NameDomain.find(name: name)
    domain.fetch(:domain, 'Unavailable')
  rescue => e
    return 'Unavailable'
  end

  def enrichment_values(domain)
    return {} if domain.empty? || domain == 'Unavailable'
    enriched_data = Clearbit::Enrichment::Company.find(domain: domain)
  rescue => e
    return {}
  end

end
