Feature: Notification
As a user
I want to have a notification center
So that I can reminders about to drink

Scenario: A user sets a drinking reminder
Given the user logged in
When I go to personal profile
Then I should be able to set notification about drinking
