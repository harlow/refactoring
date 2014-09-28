class GridCountsQuery
  def self.run
    query.each_with_object(Hash.new) do |row, grid|
      grid[row['row']] ||= {}
      grid[row['row']][row['col']] = row['c']
    end
  end

  private

  def self.query
    Customer.connection.select_all sql
  end

  def self.sql
    # COLUMN_NUMBER - custom pg function, returns colmun number based on ranges of days since customer joined us "created_at - time.now"
    # ROW_NUMBER - ustom pg function, returns row number based on ranges of orders_count on customer
    <<-SQL.squish
      SELECT
        GRID_COLUMN_NUMBER(recency) as col,
        GRID_ROW_NUMBER(frequency) as row,
        count(*) as c,
        min(customer_id) as id
      FROM customers
      GROUP BY row, col
    SQL
  end
end
