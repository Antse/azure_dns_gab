#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install apache2 -y
sudo cat < "EOF" > /www/html/index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>My App Web Site</title>
  </head>
  <body style="background-color: #333;color:#EEE;">
    <center><h1 style="font-family: sans-serif;">Welcome on My Site !!!</h1></center>
    <p>Declaring yourself to be operating by "Crocker's Rules" means that other people are allowed to optimize their messages for information, not for being nice to you.  Crocker's Rules means that you have accepted full responsibility for the operation of your own mind - if you're offended, it's your fault.  Anyone is allowed to call you a moron and claim to be doing you a favor.  (Which, in point of fact, they would be.  One of the big problems with this culture is that everyone's afraid to tell you you're wrong, or they think they have to dance around it.)  Two people using Crocker's Rules should be able to communicate all relevant information in the minimum amount of time, without paraphrasing or social formatting.  Obviously, don't declare yourself to be operating by Crocker's Rules unless you have that kind of mental discipline.
Note that Crocker's Rules does not mean you can insult people; it means that other people don't have to worry about whether they are insulting you.  Crocker's Rules are a discipline, not a privilege.  Furthermore, taking advantage of Crocker's Rules does not imply reciprocity.  How could it?  Crocker's Rules are something you do for yourself, to maximize information received - not something you grit your teeth over and do as a favor.

"Crocker's Rules" are named after Lee Daniel Crocker.</p>

  </body>
</html>
EOF
sudo service apache2 restart
