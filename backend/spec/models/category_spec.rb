require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is valid with a name" do
    category = Category.new(name: "Travel")
    expect(category).to be_valid
  end

  it "is not valid without a name" do
    category = Category.new(name: "")
    expect(category).not_to be_valid
    expect(category.errors[:name]).to include("can't be blank")
  end

  it "is not valid with a duplicate name" do
    Category.create!(name: "Groceries")
    duplicate = Category.new(name: "Groceries")

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include("has already been taken")
  end
end
