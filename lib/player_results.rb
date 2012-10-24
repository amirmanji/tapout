class PlayerResults
  include Enumerable

  attr_reader :records

  def initialize(query)
    @query    = query
    @records  = []
    @executed = false
  end

  def execute
    @executed = true
    @records = Player.connection.select_all(@query)
  end

  def each(&blk)
    execute if @executed == false

    @records.map! do |record|
      # Tap kind of works like yield in this case!
      Player.instantiate(record).tap(&blk)
    end
  end
end

