# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'cucumber/rails'

# Capybara defaults to CSS3 selectors rather than XPath.
# If you'd prefer to use XPath, just uncomment this line and adjust any
# selectors in your step definitions to use the XPath syntax.
# Capybara.default_selector = :xpath
# Capybara.javascript_driver = :webkit

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as Cucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

Before do
    Site.create!(id: "1", suspended: "false")
    
    # Test Admin creation
    User.create!(name: "Admin User",
             email: "admin@foodlocker.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
    Diary.create!(user_id: 1)
    Day.create!(diary_id: 1)
    
    #Test user creation
    User.create!(name:  "Prova",
                 email: "food-1@locker.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now)
    Quiz.create!(user_id: 2, id: 2, name: "Pippo",
                gender: "M",
                height: "1.70",
                weight: "65",
                age: "20",
                water: "3",
                sport: true,
                sport_time: "45",
                target_weight: "60",
                kcal: "1300")
    Diary.create!(user_id: 2, id: 2)
    Day.create!(diary_id: 2, date: DateTime.new(2017,10,22))
    
    User.create!(name:  "Privato",
                 email: "food-2@locker.com",
                 password: "password",
                 password_confirmation: "password",
                 activated: true,
                 activated_at: Time.zone.now,
                 is_private: true)
    
    # Follow relationships
    user1 = User.first
    user2 = User.find(2)
    user1.follow(user2)
    user2.follow(user1)
    
    # Demo recipe
    Recipe.create!(user_id: 1, 
                   title: "Spiedini di frutta e cioccolato",
                   kcal: "266",
                   ingredients: " 100 g di ananas fresco – 1 banana – 25 g burro – 200 g cioccolato fondente – 300 g fragole.",
                   directions: "(x 6 persone) infilzare alternativamente fragole, rondelle di banane e cubetti di ananas su uno spiedino di legno. Fondere il cioccolato fondente a bagnomaria insieme al burro. Immergere gli spiedini di frutta nel cioccolato fuso, quindi lasciarli asciugare su un piano ricoperto da carta forno fino a che il cioccolato non si sarà indurito. Possono essere serviti sia a temperatura ambiente che freddi e possono essere preparati anche usando tutti i tipi di frutta che desiderate come per esempio uva, melone, anguria, pesche, pesche noci, spicchi di agrumi (mandarino e mandarancio). Il cioccolato delle ricetta può essere sostituito con un mix di succhi di frutta senza zucchero, succo di limone, arancia e/o pompelmo. Preparate questo “condimento” in un contenitore dalla forma di allungata (per esempio una caraffa) e gustate gli spiedini di frutta dopo averli immersi nel vostro succo dalla miscela segreta!")
    
end
