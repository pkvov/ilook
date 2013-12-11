ThinkingSphinx::Index.define :news, :with => :active_record do
  indexes title, :sortable => true
  indexes brief
  indexes content
  
  has source, created_at, updated_at
end
