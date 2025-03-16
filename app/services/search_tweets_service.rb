def self.search(search)
  if search != ""
    search = "%#{search}%"
    Tweet.find_by_sql(["select * from tweets where text like ? ", search])
  else
    Tweet.all
  end
end