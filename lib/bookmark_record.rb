# frozen_string_literal: true
require_relative 'record'

class BookmarkRecord < Record
  DATABASE = "bookmark_manager"
  TABLE = "bookmark"
  PRIMARY_KEY = 'id'

  def self.add_bookmark(url:, title:)
    DatabaseConnection.add_record(
      table: TABLE,
      columns: 'url, title',
      values: "'#{url}', '#{title}'"
    )
  end

  def self.update_bookmark(id:, url: nil, title: nil)
    self.update_bookmark_url(id: id, url: url) unless id.nil
    self.update_bookmark_title(id: id, title: title) unless id.nil
  end
  
  def self.update_bookmark_url(id:, url:)
    DatabaseConnection.edit_record(
      table: TABLE,
      key_column: PRIMARY_KEY,
      key: id,
      set_column: 'url'
      to_value: url
    )
  end

  def self.update_bookmark_title(id:, title:)
    DatabaseConnection.edit_record(
      table: TABLE,
      key_column: PRIMARY_KEY,
      key: id,
      set_column: 'title'
      to_value: title
    )
  end

  def self.delete_bookmark(id:)
    DatabaseConnection.delete_record(
      table: TABLE,
      key_column: PRIMARY_KEY,
      key: id
    )
  end

  def self.all_bookmarks
    DatabaseConnection.all_records(
      table: TABLE
      )
  end

  def self.get_bookmark(id:)
    DatabaseConnection.get_record(
      table: TABLE,
      primary_key: id)
  end

end

