require 'rails_helper'

RSpec.describe "Api::Categories", type: :request do
  describe "GET /api/categories" do
    let!(:food) { Category.create!(name: "Food") }
    let!(:transport) { Category.create!(name: "Transport") }
    let!(:supplies) { Category.create!(name: "Supplies") }

    it "returns all categories" do
      get "/api/categories"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.map { |c| c["name"] }).to include("Food", "Transport", "Supplies")
    end

    it "returns categories in alphabetical order" do
      get "/api/categories"

      json = JSON.parse(response.body)
      expect(json.map { |c| c["name"] }).to eq([ "Food", "Supplies", "Transport" ])
    end
  end

  describe "POST /api/categories" do
    it "creates a category with valid parameters" do
      post "/api/categories", params: { category: { name: "Utilities" } }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Utilities")
      expect(Category.find_by(name: "Utilities")).not_to be_nil
    end

    it "returns errors when category name is missing" do
      post "/api/categories", params: { category: { name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Name can't be blank")
    end

    it "returns errors when category name is not unique" do
      Category.create!(name: "Food")

      post "/api/categories", params: { category: { name: "Food" } }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Name has already been taken")
    end
  end

  describe "PATCH /api/categories/:id" do
    let!(:category) { Category.create!(name: "Bills") }

    it "renames a category" do
      patch "/api/categories/#{category.id}", params: { category: { name: "Utilities" } }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Utilities")
      expect(category.reload.name).to eq("Utilities")
    end

    it "returns errors for invalid category name" do
      patch "/api/categories/#{category.id}", params: { category: { name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Name can't be blank")
    end
  end

  describe "DELETE /api/categories/:id" do
    it "deletes a category with no linked expenses" do
      category = Category.create!(name: "Subscriptions")

      delete "/api/categories/#{category.id}"

      expect(response).to have_http_status(:no_content)
      expect(Category.find_by(id: category.id)).to be_nil
    end

    it "returns error when category has linked expenses" do
      category = Category.create!(name: "Groceries")
      Expense.create!(description: "Lunch", amount: 20.0, category: category, date: Date.today)

      delete "/api/categories/#{category.id}"

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Cannot delete category with linked expenses")
      expect(Category.find_by(id: category.id)).not_to be_nil
    end
  end
end
