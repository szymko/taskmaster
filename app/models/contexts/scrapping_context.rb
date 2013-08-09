class ScrappingContext < Context
  has_many :page_scrapping_context_relations
  has_many :pages, :through => :page_scrapping_context_relations
  has_many :page_contents
end