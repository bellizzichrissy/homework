import string

#open, read file
text = open("cats_txt.txt", "r")

#create dictionary
cat_dict = dict()

#loop through text file
for line in text:
    line = line.strip()

    #make everything lowercase for consistency
    line = line.lower()

    #remove punctuation
    line = line.translate(line.maketrans("", "", string.punctuation))

    #split into individual words
    words = line.split(" ")

    #iterate over words in lines
    for word in words:
        #is word already in dictionary?
        if word in cat_dict:
            #add 1 to word count
            cat_dict[word] = cat_dict[word] + 1
        else:
            #insert new work into dictionary
            cat_dict[word] = 1

#print dictionary
for key in list(cat_dict.keys()):
    print(key, ":", cat_dict[key])