#import emojis #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
#import datetime #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
import random, os, time #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'

#from getpass import getpass as input #'BLINDED DATA ENTRY'

os.system("clear")
#myNumber = random.randint(11,13)
my_intro = """ROI

⚔️ ☑ 🤤 🍭 ❣ 🐫 😍👍 🏆  💆 😎 🔥 👩‍🎨 💡 🏡 📈 🚀 💰 🛢 🔪 👋 ✔ 🔆 ⚡ ☕ 🙏 🏡 🚀 🚗  🎉 😅 🏠 🙅 💰 🎮 ☕️ 🤯 🤬 💰 😐 😭 💸🦌 ☠💋🌈👽🍩🧁🌻☀️💦💋☠ ❤️ 🏃‍♂️ 🥊 🥑  🦋 ☕  🎵 ✂️ 🍒🍊🍉🥝 ★ ⚠ ⛈️ 🍀 🌷 🦅 👉 🚧 🚗 🏆  ⚠️ Dangerous Curves Ahead ⚠️ ("🐮 Moo") ("🐷 Oink") ("🐑 Baaa") ("🦆 Quack") ("🐶 Woof") ("🐱 Meow") ✈️ - 👢Country lover - ⛳Golfer - 💪Fitness 🍾 '\VANTA BLACK AS BACKGROUND'  Anastacia🌷 Ice Spice ☆ @icespicee_ fap  ⚓️ ★  🐍

Do for #WCE is delicious!!!"""

print()#print(myNumber)
print("""\033[5;33;40m""",my_intro,"""\033[0m""")
#print("\033[5;33;40m" + my_intro + "\033[0m") #AGGREAGTION ATTEMPTED ... WORKS WITH [string] NOT [int]
print()
time.sleep(1)

initial_investment = float(input("What is your Investment Amount $?: "))
expected_roi = float(input("Expected ROI (Return on Investment as an Annual % Rate)?: "))
mpr = expected_roi / 12 / 100 #MONTHLY APR %
apr = expected_roi / 100 #MONTHLY APR %
num_years = 3 #int(input("How many years is the investment for?: "))
num_months = num_years*12

print("""\033[5;33;40m With an Initial Investment of \033[0m : $""",round(initial_investment,2),"""\033[5;33;40m at an APR of \033[0m :""",expected_roi,"""%""",""" \033[5;33;40mfor\033[0m""",num_years,"""\033[5;33;40mYear(s)\033[0m""")
time.sleep(1)
print(f"Initial Investment: ${initial_investment}")
print(f"Expected Annual ROI: {expected_roi}%")

interest_earned = 0
for month in range(num_months):
  interest_this_month = initial_investment * mpr  
  interest_earned += interest_this_month
  initial_investment += interest_this_month
print(f"Total interest earned: ${round(interest_earned,2)}")  #'f' STRING() 







#import emojis #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
#import datetime #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
import random, os, time #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'

#from getpass import getpass as input #'BLINDED DATA ENTRY'

os.system("clear")
#myNumber = random.randint(11,13)
my_intro = """The POWER OF COMPOUND INT (MONTHLY)

⚔️ ☑ 🤤 🍭 ❣ 🐫 😍👍 🏆  💆 😎 🔥 👩‍🎨 💡 🏡 📈 🚀 💰 🛢 🔪 👋 ✔ 🔆 ⚡ ☕ 🙏 🏡 🚀 🚗  🎉 😅 🏠 🙅 💰 🎮 ☕️ 🤯 🤬 💰 😐 😭 💸🦌 ☠💋🌈👽🍩🧁🌻☀️💦💋☠ ❤️ 🏃‍♂️ 🥊 🥑  🦋 ☕  🎵 ✂️ 🍒🍊🍉🥝 ★ ⚠ ⛈️ 🍀 🌷 🦅 👉 🚧 🚗 🏆  ⚠️ Dangerous Curves Ahead ⚠️ ("🐮 Moo") ("🐷 Oink") ("🐑 Baaa") ("🦆 Quack") ("🐶 Woof") ("🐱 Meow") ✈️ - 👢Country lover - ⛳Golfer - 💪Fitness 🍾 '\VANTA BLACK AS BACKGROUND'  Anastacia🌷 Ice Spice ☆ @icespicee_ fap  ⚓️ ★  🐍

Do for #WCE is delicious!!!"""

print()#print(myNumber)
print("""\033[5;33;40m""",my_intro,"""\033[0m""")
#print("\033[5;33;40m" + my_intro + "\033[0m") #AGGREAGTION ATTEMPTED ... WORKS WITH [string] NOT [int]
print()
time.sleep(1)

initial_investment = random.randint(5000,5000) #5000 #float(input("What is your Investment Amount $?: "))
expected_roi = random.randint(10,20) #20 #float(input("Expected ROI (Return on Investment as an Annual % Rate)?: "))
mpr = expected_roi / 12 / 100 #MONTHLY APR %
apr = expected_roi / 100 #MONTHLY APR %
num_years = 3 #int(input("How many years is the investment for?: "))
num_months = num_years*12

print("""\033[5;33;40m With an Initial Investment of \033[0m : $""",round(initial_investment,2),"""\033[5;33;40m at an APR of \033[0m :""",expected_roi,"""%""",""" \033[5;33;40mfor\033[0m""",num_years,"""\033[5;33;40mYear(s)\033[0m""")
print()
for flwl in range(0,num_months): #PYTHON FOR LOOP() v WHILE LOOP() ... IMPLICIT '<' LESS THAN

  initial_investment += (initial_investment*mpr)
  print("Month", flwl+1, "BAL() is $", round(initial_investment,2))







#import emojis #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
#import datetime #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
import random, os, time #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'

#from getpass import getpass as input #'BLINDED DATA ENTRY'

os.system("clear")
#myNumber = random.randint(11,13) 
my_intro = """The POWER OF COMPOUND INT (ANNUALLY)
⚔️ ☑ 🤤 🍭 ❣ 🐫 😍👍 🏆  💆 😎 🔥 👩‍🎨 💡 🏡 📈 🚀 💰 🛢 🔪 👋 ✔ 🔆 ⚡ ☕ 🙏 🏡 🚀 🚗  🎉 😅 🏠 🙅 💰 🎮 ☕️ 🤯 🤬 💰 😐 😭 💸🦌 ☠💋🌈👽🍩🧁🌻☀️💦💋☠ ❤️ 🏃‍♂️ 🥊 🥑  🦋 ☕  🎵 ✂️ 🍒🍊🍉🥝 ★ ⚠ ⛈️ 🍀 🌷 🦅 👉 🚧 🚗 🏆  ⚠️ Dangerous Curves Ahead ⚠️ ("🐮 Moo") ("🐷 Oink") ("🐑 Baaa") ("🦆 Quack") ("🐶 Woof") ("🐱 Meow") ✈️ - 👢Country lover - ⛳Golfer - 💪Fitness 🍾 '\VANTA BLACK AS BACKGROUND'  Anastacia🌷 Ice Spice ☆ @icespicee_ fap  ⚓️ ★  🐍

Do for #WCE is delicious!!!"""

print()#print(myNumber)
print("""\033[5;33;40m""",my_intro,"""\033[0m""")
#print("\033[5;33;40m" + my_intro + "\033[0m") #AGGREAGTION ATTEMPTED ... WORKS WITH [string] NOT [int]
print()
time.sleep(1)

initial_investment = random.randint(5000,5000) #5000 #float(input("What is your Investment Amount $?: "))
expected_roi = random.randint(10,20) #20 #float(input("Expected ROI (Return on Investment as an Annual % Rate)?: "))
mpr = expected_roi / 12 / 100 #MONTHLY APR %
apr = expected_roi / 100 #MONTHLY APR %
num_years = 3 #int(input("How many years is the investment for?: "))
num_months = num_years*12

print("""\033[5;33;40m With an Initial Investment of \033[0m : $""",round(initial_investment,2),"""\033[5;33;40m at an APR of \033[0m :""",expected_roi,"""%""",""" \033[5;33;40mfor\033[0m""",num_years,"""\033[5;33;40mYear(s)\033[0m""")
print()
for flwl in range(0,num_years): #PYTHON FOR LOOP() v WHILE LOOP() ... IMPLICIT '<' LESS THAN

  initial_investment += (initial_investment*apr)
  print("Year", flwl+1, "BAL() is $", round(initial_investment,2))
  