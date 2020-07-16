# Mastermind
Mastermind is a game where one player sets a code (this is the codemaker) and the other play tries to break that code (this is the codebreaker). This implementation includes a computer player that can either set or break the code.

The real focus here is on the AI for the computer. While there are algorithms that can easily crack the codemaker's code in Mastermind (see Donald Knuth's Five Guess Algorithm), I built the AI here to act like a player who doesn't know about any fancy algorithms, but can still make educated guesses and eliminate possibilities. The AI builds a model of all the possible colors and their positions, and then adjusts the confidence levels of them based on the feedback that the game provides.

Using the same code as the codemaker to test the AI, the AI was able to break the code 6/10 times.

# Installation
After you've cloned the project, you can navigate into the root folder of the project and run:

```ruby ./lib/mastermind.rb```

If you have `rspec` installed, you can run the tests by simply running `rspec` in the root of project.