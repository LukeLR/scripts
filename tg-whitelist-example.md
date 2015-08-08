#tg-whitelist instructions
This is an instruction on how to whitelist telegram users for communication with a `tg-cli` bot in lua script. The bot will only respond to people who are on the whitelist.

##Setup
1. Place the `check-string-in-file.lua` script at some location your instance of `tg-cli` has access to.
2. Create a text file which will be the whitelist for your telegram bot. You can freely choose filename and location, just choose some place that `tg-cli` has access to.
3. Edit the text file and include the id of any user you want to allow communication with your bot. Of course, multiple users are accepted, but only their ids, not their names or stuff, **because any person on the telegram network could claim the name of some white listed person on your bot and therefore communicate in that person's name. Therefore ids are required.** Use the following format.
  - Only enter one id in each line
  - decide on a separator character (e.g. ' ' (space))
  - put the seperator character after the id
  - after the seperator character you can place any text of your choice (for example the name of the person the id belongs to, to avoid confusion).
4. If you don't know the person's id that you want to be whitelisted, just execute an `user_info` on that person's contact in `tg-cli`.
5. Now, edit your `tg-lua.lua`-script (or whatever script you use for your `tg-cli`) as follows:
  1. Import the `check-string-in-file.lua`-library by adding a `dofile`-line at the top of your script, followed by the path of the library.
  2. Edit your `on_msg_receive`-method as follows:
     - Surround any commands regarding the parsing and answering of incoming messages with an if-clause which calls the 
