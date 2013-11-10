class UpdatePageContents
  def perform(**opts)
    ids = opts[:published].map(&:id)
    { updated: PageContent.where(id: ids).update_all(published: true) }
  end
end
