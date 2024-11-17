import random
from selenium import webdriver

def get_chrome_options():
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")  # Run in headless mode
    options.add_argument("--disable-gpu")  # Disable GPU rendering
    options.add_argument("--disable-notifications")  # Disable notifications
    options.add_argument("--start-maximized")  # Start maximized
    return options

class HelpLib():

    def return_years_only(self, dateList):
        yearsOnly = []
        trueYears = []

        for a in dateList:
            yearsOnly.append(a[5:])

        for n in yearsOnly:
            trueYears.append(float(n))

        return trueYears

    def return_price_only(self, priceAll):
        priceList = []
        new_numbers = []

        for a in priceAll:
            priceList.append(a[ :-3])

        for n in priceList:
             new_numbers.append(float(n))
            
        return new_numbers
    
    def registration(self, trueYears):
        for i in trueYears:
            if i > 2014 :
                return True
            else:
                return False
  
    def sorted_List(self, price):
        if (price[::-1] == sorted(price)):
            return True
        else:
            return False



