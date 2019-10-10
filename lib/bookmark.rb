require_relative 'database'

class Bookmark
  DATABASE = 'bookmark_manager'
  TABLE = 'bookmarks'
  PK_COL = 'id'

  # class methods
  def self.all
    all_data = Bookmark.sql_all_records
    all_data.map do |record| 
      Bookmark.new(
        id: record['id'],
        url: record['url'],
        title: record['title'],) 
    end
  end
  
  def self.create(url:, title:)
    db_response = Bookmark.sql_add_record(url: url, title: title)
    Bookmark.new(
      id: db_response[0]['id'], 
      url: db_response[0]['url'], 
      title: db_response[0]['title'])
  end
  
  def self.delete(id:)
    Bookmark.sql_delete_record(id: id)
  end
  
  def self.edit(id:, title: nil, url: nil)
    return false if title.nil? && url.nil?

    bookmark  = Bookmark.get_bookmark(id: id)
    return false if title == bookmark.title && url = bookmark.url

    Bookmark.sql_edit_record(id: id, title: title, url: url)
  end

  private

  def self.get_bookmark(id:)
    record = self.sql_get_record(id: id)
    bookmark = Bookmark.new(id: record['id'], title: record['title'], url: record['url'])
  end

  def self.sql_edit_record(id:, url:, title:)
    Database.edit_record(
      table: TABLE, 
      where_id: id, 
      title: title, 
      url: url)
  end

  def self.sql_all_records
    Database.all_records(table: TABLE)
  end

  def self.sql_get_record(id:)
    Database.get_record(table: TABLE, where_id: id)
  end

  def self.sql_add_record(url:, title:)
    Database.add_record(
      table: TABLE, 
      in_columns: 'url, title', 
      add_values: "'#{url}', '#{title}'")
  end

  def self.sql_delete_record(id:)
    Database.delete_record(
      table: TABLE, 
      where_column: 'id' , 
      contains_value: id)
  end

  # Instance Methods

  public

  attr_reader :id, :url, :title

  def initialize(id:, url:, title:)
    @id = id
    @url = url
    @title = title
  end
end
