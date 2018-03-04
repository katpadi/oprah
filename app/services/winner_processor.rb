class WinnerProcessor
  attr_reader :collection, :prize, :user, :limit

  def initialize(collection, prize, user, limit = 1)
    @collection = collection
    @prize = prize
    @user = user
    @limit = limit
  end

  def process
    winning_entry.with_lock do
      winning_entry.update! won_at: Time.now.utc
      prize.winners.create! entry: winning_entry, user: user
    end
  end

  private

  # Right now always 1 winner :P
  def winning_entry
    @winning_entry ||= collection.limit(limit).order('RANDOM()').first
  end
end

