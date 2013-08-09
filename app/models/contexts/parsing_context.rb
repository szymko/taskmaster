class ParsingContext < Context
  has_many :page_parsing_context_relations
  has_many :pages, :through => :page_parsing_context_relations
  has_many :page_parsings
end