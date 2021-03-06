<p align="center">
  <img  src="http://i.imgur.com/OUfhqcz.png" alt="Food Locker Logo"/>
</p>

----------

*This is a project originally made by Edoardo Bini, Federico Guidi and Chiara Navarra for the course "Software Architecture and Cybersecurity Lab" and its teachers Leonardo Querzoni and Massimo Mecella, based at Sapienza - University of Rome.*

----------

### **What is Food Locker?**

Food Locker is a web app written in Ruby on Rails (5.1.2). It's a sort of social network where the main focus is your lifestyle: you can keep track of how healthy you eat, how much water you drink and how much you exercise. In addition to this, you can search original recipes through the database, where you can find recipes written by other users, look for a park, a gym or a supermarket thanks to Google Maps and have a personal diary where you can comment your day and see how many kcal you have taken.

### **How to run Food Locker**
```
git clone https://github.com/FedericoGuidi/FoodLocker
cd FoodLocker
bundle install
rails db:reset
bundle exec cucumber
bundle exec rspec
```

If installing gem pg 0.18.4 fails, try these steps: 
```
sudo apt-get update
sudo apt-get install libpq-dev
```
