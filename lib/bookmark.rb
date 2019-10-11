require_relative 'database_connection'

class Bookmark
  DEFAULT_TABLE = 'bookmarks'

  # class methods
  def self.all
    all_data = self.sql_all_records
    all_data.map do |record| 
      self.new(
        id: record['id'],
        url: record['url'],
        title: record['title'],) 
    end
  end
  
  def self.create(url:, title:)
    db_response = self.sql_add_record(url: url, title: title)
    self.new(
      id: db_response[0]['id'], 
      url: db_response[0]['url'], 
      title: db_response[0]['title'])
  end
  
  def self.delete(id:)
    self.sql_delete_record(id: id)
  end
  
  def self.edit(id:, title: nil, url: nil)
    return false if title.nil? && url.nil?

    bookmark  = self.get_bookmark(id: id)
    return false if title == bookmark.title && url = bookmark.url

    self.sql_edit_record(id: id, title: title, url: url)
  end

  private

  def self.get_bookmark(id:)
    record = self.sql_get_record(id: id)
    bookmark = self.new(id: record['id'], title: record['title'], url: record['url'])
  end

  def self.sql_edit_record(id:, url:, title:)
    DatabaseConnection.edit_record(
      table: DEFAULT_TABLE, 
      where_id: id, 
      title: title, 
      url: url)
  end

  def self.sql_all_records
    DatabaseConnection.all_records(table: DEFAULT_TABLE)
  end

  def self.sql_get_record(id:)
    DatabaseConnection.get_record(table: DEFAULT_TABLE, where_id: id)
  end

  def self.sql_add_record(url:, title:)
    DatabaseConnection.add_record(
      table: DEFAULT_TABLE, 
      in_columns: 'url, title', 
      add_values: "'#{url}', '#{title}'")
  end

  def self.sql_delete_record(id:)
    DatabaseConnection.delete_record(
      table: DEFAULT_TABLE, 
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
