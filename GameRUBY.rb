class Game
  attr_accessor :player_name, :player_role, :player_location, :grade, :money, :promotion, :classes_attended, :items, :cheat_enabled

  def initialize
    @player_name = ""
    @player_role = ""
    @player_location = ""
    @grade = ""
    @money = 0
    @promotion = ""
    @classes_attended = 0
    @items = {}
    @cheat_enabled = false
  end

  def start
    puts "Welcome to the School Simulator!"
    puts "What is your name?"
    @player_name = gets.chomp.capitalize
    puts "Are you a student or a teacher?"
    @player_role = gets.chomp.downcase
    puts "Welcome, #{@player_name}!"
    if @player_role == "student"
      @grade = generate_starting_grade
      puts "Your starting grade is: #{@grade}"
    elsif @player_role == "teacher"
      @money = 500
      puts "Your starting salary is: $#{@money}"
    else
      puts "Invalid role. Please start again."
      start
    end

    @player_location = "classroom" if @player_role == "student"
    @player_location = "teacher's lounge" if @player_role == "teacher"
    player_actions
  end

  def player_actions
    puts "\nYou are currently in #{@player_location}. What would you like to do?"
    puts "1. Attend class" if @player_role == "student"
    puts "1. Teach class" if @player_role == "teacher"
    puts "2. Go home"
    puts "3. Visit the store" if @player_location != "store"
    puts "4. Enable Cheat Menu"
    puts "5. Quit game"
    choice = gets.chomp.to_i
    case choice
    when 1
      attend_class if @player_role == "student"
      teach_class if @player_role == "teacher"
    when 2
      go_home
    when 3
      visit_store if @player_location != "store"
    when 4
      enable_cheat_menu
    when 5
      quit_game
    else
      puts "Invalid choice. Please try again."
      player_actions
    end
  end

  def attend_class
    puts "\nYou are attending class."
    if @cheat_enabled
      puts "Cheat Menu Enabled! You can get answers for the questions."
    else
      puts "Cheat Menu Disabled."
    end

    # Code for class-related activities goes here.
    # Example: do_homework, study, interact with classmates, etc.

    # Perform equations and determine final grade
    correct_answers = perform_equations
    final_grade = calculate_final_grade(correct_answers)

    # Update grade
    @grade = final_grade

    puts "Your final grade is: #{@grade}"

    @classes_attended += 1

    if @classes_attended == 3
      puts "It's lunchtime! Let's grab some food."
      have_lunch
      @classes_attended = 0
    end

    player_actions
  end

  def teach_class
    puts "\nYou are teaching class."
    if @cheat_enabled
      puts "Cheat Menu Enabled! You can get answers for the questions."
    else
      puts "Cheat Menu Disabled."
    end

    # Code for teaching activities goes here.
    # Example: grade_papers, prepare lessons,interact with students, etc.

    # Solve a problem for a student
    student_problem = generate_random_problem
    if @cheat_enabled
      puts "Cheat Menu Enabled! The problem is: #{student_problem}"
      puts "Please provide the solution to the problem:"
      solution = gets.chomp
      if solve_problem(student_problem, solution)
        increase_paycheck(50)
      else
        decrease_paycheck(25)
      end
    else
      puts "Student's problem: #{student_problem}"
      puts "Please provide the solution to the problem:"
      solution = gets.chomp
      if solve_problem(student_problem, solution)
        increase_paycheck(50)
      else
        decrease_paycheck(25)
      end
    end

    check_promotion

    player_actions
  end

  def go_home
    puts "\nYou are going home."
    # Code for home-related activities goes here.
    # Example: relax, eat, sleep, etc.

    if @player_role == "student"
      @grade = decrease_grade(@grade, 10)
      puts "Your grade went down to: #{@grade}"
    elsif @player_role == "teacher"
      decrease_paycheck(50)
    end

    player_actions
  end

  def visit_store
    puts "\nYou are visiting the store."
    # Code for store-related activities goes here.
    # Example: buy_items, check_inventory, etc.

    available_items = {
      "Notebook" => 20,
      "Pencil" => 5,
      "Calculator" => 100,
      "Textbook" => 50
    }

    puts "Available items:"
    available_items.each do |item, price|
      puts "#{item}: $#{price}"
    end

    puts "Your money: $#{@money}"

    puts "Enter the name of the item you want to buy (or 'exit' to leave the store):"
    item_name = gets.chomp.capitalize

    if item_name == "Exit"
      puts "You left the store."
    elsif available_items.key?(item_name)
      item_price = available_items[item_name]
      if @money >= item_price
        @money -= item_price
        @items[item_name] ||= 0
        @items[item_name] += 1
        puts "You bought #{item_name} for $#{item_price}."
      else
        puts "You don't have enough money to buy #{item_name}."
      end
    else
      puts "Invalid item. Please try again."
    end

    player_actions
  end

  def enable_cheat_menu
    puts "\nCheat Menu Enabled!"
    @cheat_enabled = true
    player_actions
  end

  def check_promotion
    case @promotion
    when ""
      if @money >= 500
        @promotion = "Assistant Principal"
        puts "Congratulations! You have been promoted to Assistant Principal!"
      end
    when "Assistant Principal"
      if @money >= 1000
        @promotion = "Principal"
        puts "Congratulations! You have been promoted to Principal!"
      end
    end
  end

  def quit_game
    puts "\nThank you for playing. Goodbye!"
  end

  private

  def generate_starting_grade
    grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F+", "F", "F-"]
    grades.sample
  end

  def increase_grade(current_grade, points)
    grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F+", "F", "F-"]
    index = grades.index(current_grade)
    new_index = index - (points / 10)
    new_index = 0 if new_index < 0
    grades[new_index]
  end

  def decrease_grade(current_grade, points)
    grades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F+", "F", "F-"]
    index = grades.index(current_grade)
    new_index = index + (points / 10)
    new_index = grades.size - 1 if new_index >= grades.size
    grades[new_index]
  end

  def perform_equations
    questions = [
      "What is 2 + 2?",
      "Solve for x: 3x - 7 = 8",
      "What is the capital of France?",
      "Calculate the area of a square with side length 5",
      "Who wrote the novel 'Pride and Prejudice'?"
    ]

    correct_answers = 0

    questions.each do |question|
      puts "\n#{question}"
      print "Your answer: "
      answer = gets.chomp.downcase

      case question
      when "What is 2 + 2?"
        correct_answers += 1 if answer == "4"
      when "Solve for x: 3x - 7 = 8"
        correct_answers += 1 if answer == "5"
      when "What is the capital of France?"
        correct_answers += 1 if answer == "paris"
      when "Calculate the area of a square with side length 5"
        correct_answers += 1 if answer == "25"
      when "Who wrote the novel 'Pride and Prejudice'?"
        correct_answers += 1 if answer == "jane austen"
      end
    end

    correct_answers
  end

  def calculate_final_grade(correct_answers)
    case correct_answers
    when 0..1
      decrease_grade(@grade, 20)
    when 2..3
      decrease_grade(@grade, 10)
    else
      increase_grade(@grade, 10)
    end
  end

  def have_lunch
    food_options = ["Pizza", "Burger", "Sandwich", "Salad"]
    drink_options = ["Water", "Soda", "Juice", "Iced Tea"]

    puts "\nChoose your lunch option:"
    food_options.each_with_index { |option, index| puts "#{index + 1}. #{option}" }
    food_choice = gets.chomp.to_i - 1

    puts "Choose your drink option:"
    drink_options.each_with_index { |option, index| puts "#{index + 1}. #{option}" }
    drink_choice = gets.chomp.to_i - 1

    chosen_food = food_options[food_choice]
    chosen_drink = drink_options[drink_choice]

    puts "You had #{chosen_food} for lunch with #{chosen_drink} as your drink."
  end

  def generate_random_problem
    problems = [
      "Solve for x: 2x + 5 = 15",
      "Calculate the perimeter of a rectangle with length 6 and width 4",
      "Simplify the expression: 3(2x + 4)",
      "What is the capital of Australia?",
      "Find the value of y in the equation: 3y- 2 = 7"
    ]

    problems.sample
  end

  def solve_problem(problem, solution)
    case problem
    when "Solve for x: 2x + 5 = 15"
      solution == "5"
    when "Calculate the perimeter of a rectangle with length 6 and width 4"
      solution == "20"
    when "Simplify the expression: 3(2x + 4)"
      solution == "6x + 12"
    when "What is the capital of Australia?"
      solution.downcase == "canberra"
    when "Find the value of y in the equation: 3y - 2 = 7"
      solution == "3"
    end
  end

  def increase_paycheck(amount)
    @money += amount
    puts "Your paycheck increased by $#{amount}. Your current salary is: $#{@money}"
  end

  def decrease_paycheck(amount)
    @money -= amount
    puts "Your paycheck decreased by $#{amount}. Your current salary is: $#{@money}"
  end

  def enable_cheat_menu
    puts "\nCheat Menu Enabled!"
    @cheat_enabled = true
    player_actions
  end

  def check_promotion
    case @promotion
    when ""
      if @money >= 500
        @promotion = "Assistant Principal"
        puts "Congratulations! You have been promoted to Assistant Principal!"
      end
    when "Assistant Principal"
      if @money >= 1000
        @promotion = "Principal"
        puts "Congratulations! You have been promoted to Principal!"
      end
    end
  end

  def quit_game
    puts "\nThank you for playing. Goodbye!"
  end
end

# Start the game
game = Game.new
game.start
