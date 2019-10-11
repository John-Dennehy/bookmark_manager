require 'pg'

# A basic database engine
class DatabaseConnection
  TEST_SUFFIX = '_test'
  
  def self.setup(database:)
    @db_name = database
    @db_name += TEST_SUFFIX if test?
  end

  def self.all_records(table:)
    sql = "SELECT * FROM #{table};"
    data = run_sql(sql: sql)
  end

  def self.add_record(table:, add_values:, in_columns:, return_data: true)
    sql = "INSERT INTO #{table} (#{in_columns}) VALUES (#{add_values})"
    sql += " RETURNING *" if return_data == true
    run_sql(sql: sql)
  end

  def self.delete_record(table:, where_column:, contains_value:)
    sql = "DELETE FROM #{table} WHERE #{where_column} = #{contains_value};"
    run_sql(sql: sql)
  end

  def self.edit_record(table:, where_id:, url:, title:)
    sql = "UPDATE #{table} SET title = '#{title}', url = '#{url}' WHERE id = '#{where_id}'"
    run_sql(sql: sql)
  end

  def self.get_record(table:, where_id:)
    sql = "SELECT * FROM #{table} WHERE id = '#{where_id}'"
    run_sql(sql: sql).first
  end

  private

  def self.run_sql(sql:)
    @connection ||= PG.connect(dbname: @db_name)
    @connection.exec(sql)
  end

  # Method requires the text enviromant will be called 'test'
  def self.test?
    ENV['ENVIRONMENT'].downcase == 'test'
  end
end
