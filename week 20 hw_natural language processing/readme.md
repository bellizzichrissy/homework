# How to Run catcount.py app from Comand Line

## 1) Open a command line window
- On Mac OS, this is Terminal (which can be found under Applications -> Utilities, or by searching for "Terminal" in Finder)
- On Windows, you can use a GUI application as git BASH (can download from https://gitforwindows.org).  If you wish to use the default Windows command prompt, open cmd.exe

## 2) In your command line window, navigate to the folder containing catcount.py
- This folder should also contain your cat_txt.txt file
- Use the change directory command (cd) to navigate to the folder
- Shortcut: drag and drop folder into command line window
- Example code:
    cd /Users/chrissy/Documents/CG_Data_Science/Data-Science-Assignments/course_material/week_20 

## 3) Use the python command to run catcount.py app
- Example code:
    python3 catcount.py

## 4) Save output to a text file (optional)
- By default, the catcount.py app will execute in the command line window
- If you wish to save your results in a text file for future reference, add "> output.txt" to your python command (can alter file name in your command to whatever you like - ex. "> cats.txt")
- This will save your word counts for the cat_txt.txt file into its own text file.  Nice!
- Example code:
   python3 > output.txt

## Why does this matter?
Word frequency can give you some preprocessing/initial insights into a text.  For the cats_txt.txt file, "domestic" appears fairly frequently (53 times), so one might reasonably conclude that this Wikipedia article talks more about the household pet than its wild counterparts.  You can get an even clearer feel of the text's contents if you remove stopwords from the picture (ex. the article "a" appears 208 times in the cat text, but is surely less important to the text's meaning than "domestic").