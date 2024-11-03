import csv, os, random, time #import emojis #'import' Library LIKE '%[sp]%' LIKE '%ENGINE%' LIKE '%SUBROUTINE%'

my_intro = """ROI ΜΟΛΩΝ ΛΑΒΕ (Molon labe) 'come and take it

🥊 🌧  🌎️  ⚔️  🃏 ☑ 🤤 🍭 ❣ 🐫 😍👍 🏆  💆 😎 🔥 👩 🎨 💡 🏡 📈 🚀 💰 🛢 🔪 👋 ✔ 🔆 ⚡ ☕ 🙏 🏡 🚀 🚗  🎉 😅 🏠 🙅 💰 🎮 ☕️ 🤯 🤬 💰 😐 😭 💸🦌 ☠💋🌈👽🍩🧁🌻☀️💦💋☠ ❤️ 🏃♂️ 🥊 🥑  🦋 ☕  🎵 ✂️ 🍒🍊🍉🥝 ★ ⚠ ⛈️ 🍀 🌷 🦅 👉 🚧 🚗 🏆  ⚠️ Dangerous Curves Ahead ⚠️ ("🐮 Moo") ("🐷 Oink") ("🐑 Baaa") ("🦆 Quack") ("🐶 Woof") ("🐱 Meow") ✈️ - 👢Country lover - ⛳Golfer - 💪Fitness 🍾 '\VANTA BLACK DARK THEME AS BACKGROUND'   LISTEN READ THINK WRITE ⚓️ 🐍 💰 🐻 💬 🧙🏾 🐶 ,'STAY READY' ⚔️ 👾 🎊 🌀 🏪 ♟️  🦋  📓  🌮   安野由美 'EMINENT DOMAIN PUBLIC DOMAIN' - 1ST FIRST PRINCIPLE ALGORITHM 🎓 💸 💲 🚀 🔊 🔆 ☘️ 🥊  🔋 🐟 🏥 🍹 💼 🚙  👑  🥇 🌲 ♾ 🎲 ⛏️ 🏰  👟 🦞 ☁️  🌴 

🦇🍂🎃     🎃🍂🦇
     🎃              🍂              🍁
     🍂 Happy October  🎃
        🍁            1st!         🦇
             🦇                  🍂        
                  🍂        🍁 
                         🎃
 
coco温美月大姐姐 @wenmeiyue520 30而立，coco香奈儿负责人，已婚人士👭，玩推特不久，想交灵魂摆渡人，人的精神世界需要有人来慰藉，高不高冷取决于你的素质，无聊的人请走开，有兴趣可私信

		⏎ Translated from Chinese by ... 30 years old, head of Coco Chanel, married 👭 , started using Twitter not long ago, looking for a soul ferryman, people spiritual world needs someone to comfort them, whether you are high and cold depends on your quality, boring people please stay away, if you are interested, you can send me a private message"""

def colorChange(color):
    """
    Change text color for terminal output.
    Supported colors: red, white, blue, yellow, green, purple, cyan.
    """
    colors = {
        "red": "\033[31m",
        "white": "\033[0m",
        "blue": "\033[34m",
        "yellow": "\033[33m",
        "green": "\033[32m",
        "purple": "\033[35m",
        "cyan": "\033[36m"
    }
    return colors.get(color, "\033[0m")  # Default to white if color not found

def clear_screen():
    """
    Clears the terminal screen.
    """
    os.system("clear" if os.name == "posix" else "cls")

def get_float_input(prompt):
    """
    Safely get a float input from the user.
    """
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("Please enter a valid number.")

def get_int_input(prompt):
    """
    Safely get an integer input from the user.
    """
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Please enter a valid integer.")

# Clear the screen
clear_screen()

# User Input
name = input("May I know your Name? ")

# GREETINGS
greetings = ["Hello", "Konnichiwa", "Guten Tag!", "Bore Da!", "Hola"]
index = random.randint(0, len(greetings) - 1)
print(f"{colorChange('red')}={colorChange('white')}={colorChange('blue')}= {colorChange('white')} {greetings[index]} {colorChange('cyan')} {name} {colorChange('blue')}={colorChange('white')}={colorChange('red')}=\n\n\033[5;33;40m {my_intro} \033[0m {colorChange('yellow')} \n") #'f' STRING() WITH() ... {} ...

# Investment Details Input with Error Handling
initial_investment = get_float_input("What is your Investment Amount $?: ")
expected_roi = get_float_input("Expected ROI (Return on Investment as an Annual % Rate)?: ")
num_years = get_int_input("How many years is the investment for?: ")

# Calculations
num_months = num_years * 12
mpr = expected_roi / 12 / 100  # Monthly Percentage % Rate
apr = expected_roi / 100       # Annual Percentage % Rate
monthly_interest = []
annual_interest = []
total_interest = 0

for month in range(num_months):
    interest_this_month = initial_investment * mpr  
    total_interest += interest_this_month
    initial_investment += interest_this_month
    monthly_interest.append(round(initial_investment, 2))
    if (month + 1) % 12 == 0:
        annual_interest.append(round(initial_investment, 2))

# Display Results
print(f"With an Initial Investment of: ${round(initial_investment, 2)} at an APR of: {expected_roi}% for {num_years} Year(s)")
print("\nMonthly Balances:")
for month, balance in enumerate(monthly_interest):
    print(f"Month {month + 1}: ${balance}")

print("\nEOY Annual Balances:")
for annum, balance in enumerate(annual_interest):
    print(f"Year {annum + 1}: ${balance}")

print(f"\nTotal Interest Earned Over Investment Period: ${round(total_interest, 2)}")
print()
# print(f"Final Balance: ${round(initial_investment, 2)}")
# print()
print(f"{colorChange('yellow')}Witness the POWER of COMPOUND INTEREST !!! {colorChange('white')}")
print()
