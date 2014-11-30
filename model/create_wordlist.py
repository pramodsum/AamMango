import re

word_file = open("aammango_dic", "r") 
wlist = open("wlist", "w")

wordArr = word_file.readlines()
word_file.close()

wlist.write("var wordList = [")
gram_footer = "]};\n\n"
gram = ""
words = ""
grammars = "var grammars = [\n\t"

for word in wordArr:
  word = word.strip('\n')
  splitWord = word.split(',')
  print(splitWord)
  words += "[\"" + splitWord[0] + "\", \"" + splitWord[2] + "\"], "

wlist.write(words[:-2] + "];\n\n")

gram_lists = ["appetizer", "beverages", "breads", "curries", "desserts", "none", "number", "proteins", "rice", "sides", "south", "vegetables", "vegetarian"]

for category in gram_lists:
  word_file = open(category, "r") 
  wordArr = word_file.readlines()
  word_file.close()

  header = "var gram_" + category + " = {\n\tnumStates: 1, start: 0, end: 0, transitions: [\n\t"
  gram += header

  for word in wordArr:
    word = word.strip('\n')
    splitWord = word.split(',')
    print(splitWord)

    #separate grammar for each word
    # gram += "var gram_" + splitWord[0] + " = {\n\tnumStates: 1, start: 0, end: 0, transitions: [\n\t"

    #add each word to word list)
    words += "[\"" + splitWord[0] + "\", \"" + splitWord[2] + "\"], "
    gram += "{from: 0, to: 0, logp: -5, word: \"" + splitWord[0] + "\", text: \"" + splitWord[1] + "\"},\n\t"
    # gram += "{from: 0, to: 0, word: \"" + splitWord[0] + "\", text: \"" + splitWord[1] + "\"},\n" + gram_footer

    # grammars += "{title: \"" + splitWord[1] + "\", g: gram_" + splitWord[0] + "},\n\t"
    
  gram = gram[:-3] + "\n" + gram_footer

# gram += grammars[:-3] + "\n];"

wlist.write(gram)
wlist.close()