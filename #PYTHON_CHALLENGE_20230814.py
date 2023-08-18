#import emojis #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
#import datetime #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
import random, os, time #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'

#from getpass import getpass as input #'BLINDED DATA ENTRY'

os.system("clear")
#myNumber = random.randint(5000,5000)
Name = input("Name please:\n")
my_intro = """JAH THANK YOU JAH 

⚔️  🃏 ☑ 🤤 🍭 ❣ 🐫 😍👍 🏆  💆 😎 🔥 👩‍🎨 💡 🏡 📈 🚀 💰 🛢 🔪 👋 ✔ 🔆 ⚡ ☕ 🙏 🏡 🚀 🚗  🎉 😅 🏠 🙅 💰 🎮 ☕️ 🤯 🤬 💰 😐 😭 💸🦌 ☠💋🌈👽🍩🧁🌻☀️💦💋☠ ❤️ 🏃‍♂️ 🥊 🥑  🦋 ☕  🎵 ✂️ 🍒🍊🍉🥝 ★ ⚠ ⛈️ 🍀 🌷 🦅 👉 🚧 🚗 🏆  ⚠️ Dangerous Curves Ahead ⚠️ ("🐮 Moo") ("🐷 Oink") ("🐑 Baaa") ("🦆 Quack") ("🐶 Woof") ("🐱 Meow") ✈️ - 👢Country lover - ⛳Golfer - 💪Fitness 🍾 '\VANTA BLACK AS BACKGROUND'  Anastacia🌷 Ice Spice ☆ @icespicee_ fap  ⚓️ 🐍

Do for #WCE is Delicious!!!"""

print()print(f"""\033[5;33;40m {my_intro} \033[0m \n""") #'f' STRING() WITH() ... {} ...
#print("""\033[5;33;40m""",my_intro,"""\033[0m \n""")
#print("\033[5;33;40m" + my_intro + "\033[0m \n") #AGGREAGTION ATTEMPTED ... WORKS WITH [string] NOT [int]

def colorChange(color): #SEVEN (7) COLOR(S)
  if color=="red":
    return ("\033[31m")
  elif color=="white":
    return ("\033[0m")
  elif color=="blue":
    return ("\033[34m")
  elif color=="yellow":
    return ("\033[33m")
  elif color == "green":
    return ("\033[32m")
  elif color == "purple":
    return ("\033[35m")
  elif color == "cyan":
    return ("\033[36m")

greetings = ["Welcome","Hello there!", "Konnichiwa", "Guten Tag!", "Bore Da!"] #PYTHON [LIST,,,]
index = random.randint(0,4)

print(f"""{colorChange('red')}={colorChange('white')}={colorChange('blue')}= {colorChange('white')} {greetings[index]} {colorChange('cyan')} {Name} {colorChange('blue')}={colorChange('white')}={colorChange('red')}={colorChange('yellow')}""") #'f' STRING() WITH() ... {} ...
print() #CONCLUDE ...

def rollDice(side):
  result = random.randint(1,side)
  return result
def health():
  healthStat = ((rollDice(6)*rollDice(12))/2)+10
  return healthStat
def strength():
  strengthStat = ((rollDice(6)*rollDice(8))/2)+12
  return strengthStat
print("⚔️ BATTLE TIME ⚔️")
print()
c1Name = Name
c1Type = input("Character Type (Human, Elf, Wizard, Orc):\n")
print()
print(c1Name)
c1Health = health()
c1Strength = strength()
print("HEALTH:", c1Health)
print("STRENGTH:", c1Strength)
print()
print("Who are they battling?")
print()
c2Name = input("Name your Legend:\n")
c2Type = input("Character Type (Human, Elf, Wizard, Orc):\n")
print()
print(c2Name)
c2Health = health()
c2Strength = strength()
print("HEALTH:", c2Health)
print("STRENGTH:", c2Strength)
print()
round = 1
winner = None
while True:
  time.sleep(1)
  os.system("clear")
  print("⚔️ BATTLE TIME ⚔️")
  print()
  print("The battle begins!")
  c1Dice = rollDice(6)
  c2Dice = rollDice(6)
  difference = abs(c1Strength - c2Strength) + 1
  if c1Dice > c2Dice:
    c2Health -= difference
    if round==1:
      print(c1Name, "wins the first blow")
    else:
      print(c1Name, "wins round", round)
  elif c2Dice > c1Dice:
    c1Health -= difference
    if round==1:
      print(c2Name, "wins the first blow")
    else:
      print(c2Name, "wins round", round)
  else:
    print("Their swords clash and they draw round", round)
  print()
  print(c1Name)
  print("HEALTH:", c1Health)
  print()
  print(c2Name)
  print("HEALTH:", c2Health)
  print()
  if c1Health<=0:
    print(c1Name, "has been whooped!")
    winner = c2Name
    break
  elif c2Health<=0:
    print(c2Name, "has been whooped!")
    winner = c1Name
    break
  else:
    print("And they're both standing for the next round")
    round += 1
    
time.sleep(1)
os.system("clear")
print("⚔️ BATTLE TIME ⚔️")
print()

print(f"""{colorChange('red')}={colorChange('white')}={colorChange('blue')}= {winner} {colorChange('blue')}={colorChange('white')}={colorChange('red')}={colorChange('yellow')} Is ALPHA in
      {colorChange('red')} {round} {colorChange('yellow')} rounds""") #'f' STRING()  WITH() ... {} ...
