# frozen_string_literal: true
require 'pg'

# A basic database engine
class DatabaseConnection

  attr_reader :database
  TEST_SUFFIX = '_test'

  def self.add(database: @database, table:, columns:, values: )
    sql = "INSERT INTO #{table} (#{columns}) VALUES (#{values})"
    run_sql(database: database, sql: sql)
  end
  
  def self.update(record:)
    sql = "UPDATE #{record.table} SET #{record.columns} = #{record.values} WHERE #{record.key_column} = #{record.primary_key}"
    run_sql(database: record.database, sql: sql)
  end
  
  def self.delete(record:)
    sql = "DELETE FROM #{record.table} WHERE #{record.key_column} = #{record.primary_key}"
    run_sql(database: record.database, sql: sql)
  end
  
  def self.get(database:, table:, key:)
    sql = "SELECT * FROM #{record.table} WHERE id = '#{key}'"
    run_sql(database: record.database, sql: sql).first
  end
  
  def self.all_records(database:, table:)
    sql = "SELECT * FROM #{table}"
    data = run_sql(database: database, sql: sql, return_data: false)
  end

  private

  def self.run_sql(database:, sql:, return_data: true)
    @database = database
    @database += TEST_SUFFIX if test?    
    sql += ' RETURNING *' if return_data == true

    @connection ||= PG.connect(dbname: @database)
    @connection.exec(sql)
  end

  # Method requires the text enviromant will be called 'test'
  def self.test?
    ENV['ENVIRONMENT'] == 'test'
  end
end
