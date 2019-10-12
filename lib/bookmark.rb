# frozen_string_literal: true

require_relative 'record'
require_relative 'database_connection'

class Bookmark < Record
  DATABASE = 'bookmark_manager'
  TABLE = 'bookmarks'
  PRIMARY_KEY_COLUMN = 'id'
  COLUMNS = 'url, title'

  # class methods
  def self.all
    all_data = DatabaseConnection.all_records(database: DATABASE, table: TABLE )
    all_data.map do |record|
      new(
        id: record['id'],
        url: record['url'],
        title: record['title']
      )
    end
  end

  def self.create_db_record(url:, title:)
    db_response = DatabaseConnection.add(
      database: DATABASE,
      table: TABLE,
      columns: COLUMNS,
      values: "'#{url}', '#{title}'"
    )
  end

  def self.create(url:, title:)
    db_response = create_db_record(url: url, title: title)
    new(
      id: db_response[0]['id'],
      url: db_response[0]['url'],
      title: db_response[0]['title']
    )
  end
  
  def self.edit(id: , url: nil, title: nil )
    record = new(
      id: id,
      url: url,
      title: title
    )
    record.update_url unless id.nil?
    record.update_title unless id.nil?
  end
  
  def self.delete(id:)
    record = new(id: id)
    DatabaseConnection.delete(record: record)
  end
  
  def self.get(id:)
    db_response = DatabaseConnection.get(
      database: DATABASE,
      table: TABLE, 
      key: id
    )
    new(
      id: db_response[0]['id'],
      url: db_response[0]['url'],
      title: db_response[0]['title']
    )
  end
        
  def update_url
    @columns = "url"
    @values = "'#{@url}'"
    DatabaseConnection.update(record: self)
  end

  def update_title
    @columns = "title"
    @values = "'#{@title}'"
    DatabaseConnection.update(record: self)
  end

  public

  attr_reader :id, :url, :title, :database, :table, :key_column, :primary_key, :columns, :values

  def initialize(id:, url: nil, title: nil)
    @database = DATABASE
    @table = TABLE
    @key_column = PRIMARY_KEY_COLUMN
    @columns = COLUMNS
    @primary_key = id
    @id = id
    @url = url
    @title = title
  end
end
