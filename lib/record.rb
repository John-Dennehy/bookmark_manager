require_relative 'database_connection'

class Record
  attr_reader :database, :table, :key_column, :primary_key, :columns, :values

  def initialize(database:, table:, key_column:, primary_key: nil, columns:, values:)
    @database = database
    @table = table
    @key_column = key_column
    @primary_key = primary_key
    @columns = columns
    @values = values
  end

  def add
    return false if @values_hash.nil
    db_response = DatabaseConnection.db_add(self)
    update_self(pg_result: db_response)
    return self
  end

  def update
    return false if @primary_key.nil
    db_response = DatabaseConnection.db_update(self)
    update_self(pg_result: db_response)
    return self
  end

  def delete
    return false if @primary_key.nil
    DatabaseConnection.db_delete(self)
    return true
  end

  def convert_to_record(pg_result:)
    return false if pg_result.class != PG::Result

    pg_result.fields.each do |field|
      puts field
    end

  end

end
