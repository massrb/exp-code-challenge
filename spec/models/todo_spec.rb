require 'rails_helper'

RSpec.describe Todo, type: :model do
  let!(:data) { nil }
  before do
    data = JSON.parse(file_fixture("data.json").read)
    allow(Todo).to receive(:get_json).and_return(data)
    Todo.load_json
  end

  it "data produces users" do
    expect(User.count).to eq(10)
  end

  context "valid user" do
    let(:users) { User.all.order("percent_complete DESC") }
    let!(:first_user) { users.first }
    let!(:last_user) { users.last }
    
    it "has valid users" do
      expect(first_user.percent_complete).to eq(60.0)
      expect(last_user.percent_complete).to eq(30.0)
      expect(last_user.todos.where(completed:true).count).to eq(6)
      expect(last_user.todos.count).to eq(20)
    end
  end
end
