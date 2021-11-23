# cleanup
##### A bash cleanup utility that safely discards temporary files (that were created from a script).


### WHAT IS THIS CLEANUP UTILITY?

This cleanup utility takes care of removing temporary files that were created through the process of a script.

Ideally when scripting, any temporary files you create would be recorded and removed in a safe and controlled manner every time the script exits (for whatever reason it exits). A list of files would be compiled and then individually checked for their existence before attempting to remove them. You pass the filepaths to this utility and it does the checking and removing of files.


### WHY IS THIS UTILITY NEEDED?

When I create temporary files, I store the filepath of the temp file in a unique variable. Ideally I would just get the name of every temp file variable and put it all in one trap command for trap to remove each temp file that each variable references when the script exits.

This would mean having to update the trap command every time I created a new temp file. If I didn't update the trap command as I created temp files, the trap command would be referencing variables or files that haven't yet been created, which would throw an error. I try to create all temp files at the beginning of my scripts so I can reference all of them in one trap command at the very start to avoid issues, but this isn't always possible. Checking the existence of each temp file first before removing so as to only remove the existing temporary files is another feature of this utility.

With this utility, you simply initialise a TMP_FILES variable at the beginning of your script, create a trap command to feed the TMP_FILES variable into the cleanup utility when the script receives an exit signal, and then update the TMP_FILES variable with the temp file filepaths as you create them.

This means one trap command at the beginning of your script, and all temporary files safely discarded regardless of when or how your script exits.


### HOW DO I IMPLEMENT THIS INTO MY OWN SCRIPTS?

###### Put the location of the cleanup utility into a variable for ease, and initialise the TMP_FILES variable
```
CLEANUP_UTILITY="/XYZ/XYZ/cleanup.sh"
TMP_FILES=""
```

###### Use the 'trap' command to run the cleanup utility when the script receives any exit signal
```
trap "{ bash $CLEANUP_UTILITY $TMP_FILES ; }" SIGINT SIGTERM ERR EXIT
```

###### Update the TMP_FILES variable with the full filepath of the temporary files as you create them, with a whitespace between each filepath
```
TMP_FILES=""$SCRIPT_IN_PROGRESS_FILE" "$RESULTS_FILE" "$ANOTHER_TEMP_FILE""
```
