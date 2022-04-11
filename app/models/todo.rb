require 'net/http'

class Todo < ApplicationRecord
  JsonUrl = "https://jsonplaceholder.typicode.com/todos"

  belongs_to :user, primary_key: :number, foreign_key: :user_number, optional: true
  after_commit :create_user, unless: :user_exists?

  def self.percentages
    query = %Q(
      SELECT 
        a.user_number, 
        (CAST((SELECT COUNT() FROM todos AS b 
          WHERE completed IS true AND a.user_number = b.user_number) AS real) 
         / 
         CAST((SELECT COUNT(*) FROM todos AS c 
           WHERE a.user_number = c.user_number) AS real)) 
      * 100 AS percent 
      FROM todos AS a GROUP BY user_number
      )
      ActiveRecord::Base.connection.execute(query)
  end

  def self.load_json
    get_json.each do |rec|
      fields = rec.transform_keys { |key| key.to_s.underscore }
      fields["user_number"] = fields["user_id"]
      fields.delete("user_id")
      todo = Todo.create(fields)
    end
    percentages.each do |perc|
      user = User.find_by(number: perc["user_number"])
      if user
        user.percent_complete = perc["percent"].round(3)
        user.save!
      end
    end
  end

  private

  def self.get_json
    resp = Net::HTTP.get_response(URI.parse(JsonUrl))
    data = resp.body
    result = JSON.parse(data)    
  end

  def create_user
    User.create!(number: self.user_number)
  end

  def user_exists?
    self.user.present?
  end

end
