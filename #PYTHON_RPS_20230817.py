import random, os, time #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
#import emojis #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'
#import datetime #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'

#from getpass import getpass as input #'BLINDED DATA ENTRY'

os.system("clear")
#myNumber = random.randint(5000,5000)
Name = input("Name please:\n")
my_intro = """JAH THANK YOU JAH 

⚔️  🃏 ☑ 🤤 🍭 ❣ 🐫 😍👍 🏆  💆 😎 🔥 👩‍🎨 💡 🏡 📈 🚀 💰 🛢 🔪 👋 ✔ 🔆 ⚡ ☕ 🙏 🏡 🚀 🚗  🎉 😅 🏠 🙅 💰 🎮 ☕️ 🤯 🤬 💰 😐 😭 💸🦌 ☠💋🌈👽🍩🧁🌻☀️💦💋☠ ❤️ 🏃‍♂️ 🥊 🥑  🦋 ☕  🎵 ✂️ 🍒🍊🍉🥝 ★ ⚠ ⛈️ 🍀 🌷 🦅 👉 🚧 🚗 🏆  ⚠️ Dangerous Curves Ahead ⚠️ ("🐮 Moo") ("🐷 Oink") ("🐑 Baaa") ("🦆 Quack") ("🐶 Woof") ("🐱 Meow") ✈️ - 👢Country lover - ⛳Golfer - 💪Fitness 🍾 '\VANTA BLACK AS BACKGROUND'  Anastacia🌷 Ice Spice ☆ @icespicee_ fap  ⚓️ 🐍

ROCK PAPER SCISSORS v A I"""

print()
print(f"""\033[5;33;40m {my_intro} \033[0m \n""") #'f' STRING() WITH() ... {} ...
#print("""\033[5;33;40m""",my_intro,"""\033[0m \n""")
#print("\033[5;33;40m" + my_intro + "\033[0m \n") #AGGREAGTION ATTEMPTED ... WORKS WITH [string] NOT [int]

def colorChange(color): #SEVEN (7) COLOR(S) #DEFINE THE 'SUBROUTINE'
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

greetings = ["Welcome","Hello there!", "Konnichiwa", "Guten Tag!", "Bore Da!"] #PYTHON LIST[]
index = random.randint(0,4)

print(f"""{colorChange('red')}={colorChange('white')}={colorChange('blue')}= {colorChange('white')} {greetings[index]} {colorChange('cyan')} {Name} {colorChange('blue')}={colorChange('white')}={colorChange('red')}={colorChange('yellow')} Care for a Game of Rock Paper Scissors?""") #'f' STRING() WITH() ... {} ...

time.sleep(1)
print()

OPTIONS = ["rock", "paper", "scissors","r","p","s"] #PYTHON LIST[]

def get_computer_choice(): #DEFINE THE 'SUBROUTINE'
  return random.choice(OPTIONS)

def get_player_choice(): #DEFINE THE 'SUBROUTINE'
  while True: #PYTHON FOR LOOP() v WHILE LOOP() ... IMPLICIT '<' LESS THAN
    choice = input("Enter your choice (rock, paper, scissors): ").lower()
    if choice in OPTIONS:
      return choice

def check_winner(player, computer): #DEFINE THE 'SUBROUTINE'
  if player == computer:
    return "Tie!"
  elif beats(player, computer):
    return "You won!"
  return "Computer won!"

def beats(one, two):
  wins = [('rock', 'scissors'), 
          ('paper', 'rock'),
          ('scissors', 'paper'),
		  ('r', 's'), 
          ('p', 'r'),
          ('s', 'p')]
  return (one, two) in wins

def play_game():
  while True:
    player = get_player_choice()
    computer = get_computer_choice()
    print("Computer played:", computer) 
    winner = check_winner(player, computer)
    print(winner)
    
    play_again = input("Play again? (y/n) ").lower()
    if play_again == 'n':
        return print(f"""{colorChange('red')}={colorChange('white')}={colorChange('blue')}= {colorChange('white')} Good day Beautiful {colorChange('blue')}={colorChange('white')}={colorChange('red')}={colorChange('yellow')}""")
    elif play_again != 'y':
        break

if __name__ == '__main__':
  play_game()
  
  #        print(f"""{colorChange('red')}={colorChange('white')}={colorChange('blue')}= {colorChange('white')} {greetings[index]} {colorChange('cyan')} Good day Beautiful {colorChange('blue')}={colorChange('white')}={colorChange('red')}={colorChange('yellow')}""")
  