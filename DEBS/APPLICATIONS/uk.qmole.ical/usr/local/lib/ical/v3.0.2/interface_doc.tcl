proc interface_doc {text} {
wm title [winfo toplevel $text] {The Tcl Interface to Ical}
$text insert insert {The Tcl Interface to Ical} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This document contains a brief description of the Tcl interface to ical. Part of this interface is implemented in C++ and the rest is implemented by Tcl support libraries. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The C++ code exports calendar and item objects to tcl code. A number of operations are provided to create such objects and to manipulate dates and times. In addition, the calendar and item objects have various methods that can be called from tcl code. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Computation Model} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Calendars and items are stored persistently on file systems. Copies of these calendars and items are read into ical's address space. The Tcl code operates on these copies through well-defined interfaces. These interfaces contain special operations for saving pending modifications to persistent storage on the file system. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Each user has a main calendar. This main calendar is represented as a calendar object in Tcl code, and persistently as a file stored on the file system. The main calendar contains a list of names of included calendar files. The main calendar file and the included calendar files all contain items. Each item in the main calendar file and the included calendar files is visible as an item object to the Tcl code. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Calendars} {header1 indent0}
$text mark set label_sec:calendars $_html_tmp
$text tag bind ref_sec:calendars <1> {%W yview label_sec:calendars; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following calendar operations raise errors if the user does not have sufficient permission to perform the required operation. Errors are also raised if specified files do not contain a calendar. Some of these operations also take a calendar file name as an optional argument. If the file name is omitted, then the main calendar file is used. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Arguments named } {norm indent0}
$text insert insert {file} {italic indent0}
$text insert insert { in the following list are names of Unix files. Arguments named } {norm indent0}
$text insert insert {cal} {italic indent0}
$text insert insert { are calendar objects created by the ``calendar'' command. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Files and Includes} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section lists the operations for creating and deleting calendar objects from calendar files, and also operations for handling included calendars. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {calendar cal file} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Create a calendar object named } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert { with } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { as the main calendar file. The actual file named } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { contains a list of included calendar files. The files mentioned in this list are also incorporated into } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert {. Typically only one calendar object is created in an ical application. Included calendars are considered part of this one calendar object. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal delete} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Discard } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert { and all contained items from process memory. The underlying files are not destroyed and can be used to initialize a calendar object in another invocation. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal main} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return the name of the main calendar file for } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal include file} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Include } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { into } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert {. All items contained in } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { are made available as item objects to Tcl code. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal exclude file} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Exclude } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { from } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert {. All objects for items contained in } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { are removed from the Tcl interpreter and cannot be used by Tcl code any more. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal forincludes var body} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {For each include } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { in } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert {, set } {norm indent1}
$text insert insert {var} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { and execute } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Adding and Removing Items} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section describes the operations for adding and removing items from calendars. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {cal add item [file]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Add } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to the specified } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { in } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal remove item} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Remove } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { from } {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal hide item} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Hide } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { from this user. Other users will still see the item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Input and Output} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section describes the operations for reading and writing calendars to persistent storage. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {cal readonly [file]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff the user does not have permission to modify the specified } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal dirty [file]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Has the specified } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { been modified locally without being saved to persistent storage? } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal stale [file]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Has the specified } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { been modified by another user or process? } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal save [file]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Save any local changes made to } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { to persistent storage. For example, the following code saves all modifications: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  if [cal dirty [cal main]] {
      cal save [cal main]
  }

  cal forincludes file {
      if [cal dirty $file] {
          cal save $file
      }
  }
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal reread [file]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Incorporate any changes made to } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { by other users or processes. Any existing items objects from } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert { may be deleted and replaced by new item objects even if the file has not been modified recently. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {User Preferences} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Each calendar file contains a general mapping from option names to string values. This mapping is typically used to store user preferences for ical. Sometimes, however this mapping contains miscellaneous properties of the calendar file. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {cal option [-calendar file] name} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Look up the value associated with } {norm indent1}
$text insert insert {name} {italic indent1}
$text insert insert { in the named calendar } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert {. If no calendar file is specified, the value is looked up in the main calendar file. An error is raised if the named option does not exist in the calendar. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  set p "lpr"
  catch {set p [cal option PrintCmd]}
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal option [-calendar file] name value} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set the value of the option named } {norm indent1}
$text insert insert {name} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {value} {italic indent1}
$text insert insert { in the named calendar } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert {. If no calendar file is specified, the value is looked up in the main calendar file. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  cal option PrintCmd "lpr -m"
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal delete_option [-calendar file] name} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Remove the option named } {norm indent1}
$text insert insert {name} {italic indent1}
$text insert insert { from the named calendar } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert {. If no calendar file is specified, the option is removed from the main calendar file. An error is raised if the named option does not exist in the calendar. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  catch {cal delete_option PrintCmd}
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {Queries} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following operations can be used to get listings of various items in a calendar. The range of most of these queries can be controlled by specifying one of the following options: } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {-all} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Query ranges over all calendars and items. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {-calendar file} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Query ranges over the contents of the specified calendar file. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {-list item-list} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Query ranges over only the specified list of items. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {The actual query methods are as follows: } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {cal query [range options] start finish itemvar datevar body} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {For any item occurrence in the range } {norm indent1}
$text insert insert {start..finish} {italic indent1}
$text insert insert {, set } {norm indent1}
$text insert insert {itemvar} {italic indent1}
$text insert insert { to the item, set } {norm indent1}
$text insert insert {datevar} {italic indent1}
$text insert insert { to the date of the item occurrence, and then evaluate } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert {. The executions of } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert { are sorted by occurrence. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal listing [range options] start finish itemvar datevar body} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {For all items } {norm indent1}
$text insert insert {i} {italic indent1}
$text insert insert {, For each occurrence of } {norm indent1}
$text insert insert {i} {italic indent1}
$text insert insert { in } {norm indent1}
$text insert insert {start} {italic indent1}
$text insert insert {..(} {norm indent1}
$text insert insert {finish} {italic indent1}
$text insert insert {+[} {norm indent1}
$text insert insert {i} {italic indent1}
$text insert insert { earlywarning]), Set } {norm indent1}
$text insert insert {itemvar} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {i} {italic indent1}
$text insert insert {, } {norm indent1}
$text insert insert {datevar} {italic indent1}
$text insert insert { to the occurrence date and execute } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert {. The executions of } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert { are sorted by occurrence. This operation differs from ``} {norm indent1}
$text insert insert {cal} {italic indent1}
$text insert insert { query'' only in its handling of early warnings. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  cal listing $date [expr $date+9] i d {
      print_date $d
      print_item $i
  }
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal incalendar file itemvar body} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {For all items } {norm indent1}
$text insert insert {i} {italic indent1}
$text insert insert { in } {norm indent1}
$text insert insert {file} {italic indent1}
$text insert insert {, Set } {norm indent1}
$text insert insert {itemvar} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {i} {italic indent1}
$text insert insert { and execute } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert {. The executions of } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert { are sorted by date of first occurrence. This operation is equivalent to the ``query'' operation executed with a ``-calendar'' range option. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  cal incalendar [cal main] item {
      print_item $item
  }
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal loop_forward [range options] item date itemvar datevar body} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {For each item occurence that occurs after the specified } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { on the specified } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {, set } {norm indent1}
$text insert insert {itemvar} {italic indent1}
$text insert insert { and } {norm indent1}
$text insert insert {datevar} {italic indent1}
$text insert insert { to the item occurrence and execute } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert {. If } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is the empty string, then start yielding with the first item that occurs on } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. For example, the following code searches for the string ``birthday'': } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  cal loop_forward $item $date i d {
      if [string match "*birthday*" [$i text]] {
          ...
          break
      }
  }
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {cal loop_backward [range options] item date itemvar datevar body} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {For each item occurence that occurs before the specified } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { on the specified } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {, set } {norm indent1}
$text insert insert {itemvar} {italic indent1}
$text insert insert { and } {norm indent1}
$text insert insert {datevar} {italic indent1}
$text insert insert { to the item occurrence and execute } {norm indent1}
$text insert insert {body} {italic indent1}
$text insert insert {. If } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is the empty string, then start yielding with the last item that occurs on } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. For example, the following code searches for the string ``birthday'': } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  cal loop_backward $item $date i d {
      if [string match "*birthday*" [$i text]] {
          ...
          break
      }
  }
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
set _html_tmp [$text index insert]
$text insert insert {Items} {header1 indent0}
$text mark set label_sec:items $_html_tmp
$text tag bind ref_sec:items <1> {%W yview label_sec:items; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Item objects come in two flavors - appointments and notices. An appointment occurs at a specific time of the day. A notice does not have any associated time of day. For example, a meeting at 3pm on March 27th will be recorded as an appointment while somebody's birthday on March 28th will be recorded as a notice. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Each item object also has associated text and a set of dates on which the item occurs. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Creation and Deletion} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following operations can be used to create and delete items. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {notice} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Create a notice object with empty text and an empty set of dates. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appointment} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Create an appointment object with empty text and an empty set of dates. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item delete} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Remove } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { from any calendar that contains it and delete all storage required for the item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item clone} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Create and return a copy of } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Item Occurrences} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following operations can be used to manipulate and query the set of dates on which an item occurs. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {item contains date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { occurs on } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item empty} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { has no occurrences. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item repeats} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { occurs more than once. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item first} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the date of first occurrence of } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. Raises an error if } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { has no occurrences. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item next date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the date of the first occurrence of } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { after } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. Raises an error if } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { has no occurrences after } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item range startVar finishVar} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Sets } {norm indent1}
$text insert insert {startVar} {italic indent1}
$text insert insert { and } {norm indent1}
$text insert insert {finishVar} {italic indent1}
$text insert insert { to the repetition range for } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { and returns 1. Returns 0 if item does not have a range. (An item does not have a range iff it never occurs.) } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item type} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns a brief textual description of how the item repeats. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item describe_repeat [-terse]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Like ``} {norm indent1}
$text insert insert {item type} {bold indent1}
$text insert insert {'', except that it returns a more complete description of how the item repeats. If terse, returns the complete description of the repetition as } {norm indent1}
$text insert insert {start finish { deleted [ deleted ... ] } how...} {italic indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item date date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Modifies } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to occur exactly on } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item dayrepeat interval anchor} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Modifies } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to occur on all dates that are an integral multiple of } {norm indent1}
$text insert insert {interval} {italic indent1}
$text insert insert { days away from } {norm indent1}
$text insert insert {anchor} {italic indent1}
$text insert insert {. For example, the following code makes ``$item'' repeat every Saturday assuming that the anchor date occurs on a Saturday. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item dayrepeat 7 $anchor
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item monthrepeat interval anchor} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Modifies } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to occur on all dates that are an integral multiple of } {norm indent1}
$text insert insert {interval} {italic indent1}
$text insert insert { months away from } {norm indent1}
$text insert insert {anchor} {italic indent1}
$text insert insert {. For example, the following code makes ``$item'' repeat on the 23rd of February every year. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item monthrepeat 12 [date make 23 2 1994]
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item weekdays [weekday...]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Modifies } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to repeat on all specified } {norm indent1}
$text insert insert {weekdays} {italic indent1}
$text insert insert {. For example, the following code makes ``$item'' repeat on every Monday, Wednesday and Friday (Sunday is represented by 1, Monday is represented by 2, ...). } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item weekdays 2 4 6 
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item month_day n [anchor interval]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Modifies } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to repeat on the } {norm indent1}
$text insert insert {n} {italic indent1}
$text insert insert {th day of every month that is an integral number of } {norm indent1}
$text insert insert {interval} {italic indent1}
$text insert insert { months away from the date specified in } {norm indent1}
$text insert insert {anchor} {italic indent1}
$text insert insert {. If } {norm indent1}
$text insert insert {anchor} {italic indent1}
$text insert insert { and } {norm indent1}
$text insert insert {interval} {italic indent1}
$text insert insert { are not specified, then the } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { repeats every month. For example, the following code makes ``$item'' repeat on the 17th of every January because the anchor date is in January, and the interval is 12. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item month_day 17 [date make 1 1 1994] 12
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item month_last_day n [anchor interval]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Behaves like ``} {norm indent1}
$text insert insert {item month_day} {bold indent1}
$text insert insert {'' except that } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is made to repeat on the } {norm indent1}
$text insert insert {n} {italic indent1}
$text insert insert {th-last day of the month. For example, the following code makes ``$item'' repeat on the second last day of every month. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item month_last_day 2
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item month_work_day n [anchor interval]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Behaves like ``} {norm indent1}
$text insert insert {item month_day} {bold indent1}
$text insert insert {'' except that } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is made to repeat on the } {norm indent1}
$text insert insert {n} {italic indent1}
$text insert insert {th working day of the month. For example, the following code makes ``$item'' repeat on the first working day of each month. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item month_work_day 1
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item month_last_work_day n} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Behaves like ``} {norm indent1}
$text insert insert {item month_last_day} {bold indent1}
$text insert insert {'' except that } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is made to repeat on the } {norm indent1}
$text insert insert {n} {italic indent1}
$text insert insert {th-last working day of the month. For example, the following code makes ``$item'' repeat on the fourth-last working day of each month. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item month_last_work_day 4
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item month_week_day day n [anchor interval]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Behaves like ``} {norm indent1}
$text insert insert {item month_day} {bold indent1}
$text insert insert {'' except that } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is made to repeat on the } {norm indent1}
$text insert insert {n} {italic indent1}
$text insert insert {th occurrence of a particular day of the week of the month. The } {norm indent1}
$text insert insert {day} {italic indent1}
$text insert insert { argument should be an integer in the range $1 ... 7$. An argument of $1$ means that the item should repeat on the } {norm indent1}
$text insert insert {n} {italic indent1}
$text insert insert {th Sunday of the month. An argument of $7$ means that the item should repeat on the } {norm indent1}
$text insert insert {n} {italic indent1}
$text insert insert {th Saturday of the month. For example, the following code makes ``$item'' repeat on the third Thursday of every month. (Thursday is specified by the integer $5$). } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item month_week_day 5 3
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item month_last_week_day day n [anchor interval]} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Behaves like ``} {norm indent1}
$text insert insert {item month_week_day} {bold indent1}
$text insert insert {'' except that occurrences of } {norm indent1}
$text insert insert {day} {italic indent1}
$text insert insert { are counted from the end of the month. For example, the following code makes ``$item'' repeat on the last Friday of every month. (Friday is specified by the integer $6$.) } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item month_last_week_day 6 1
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item start date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Modifies } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { by removing all occurrences that occur before } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item finish date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Modifies } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { by removing all occurrences that occur after } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. For example, the following code restricts ``$item'' to occur only in 1994. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item start  [date make 1  1  1994]
  $item finish [date make 31 12 1994]
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item deleteon date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {If } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { occurs on } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {, removes that occurrence of } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. Otherwise leaves } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { unmodified. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Item Properties} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following operations can be used to examine and manipulate various properties of an item. The first few operations apply only to appointments. The remaining operations apply to both appointments and notices. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {appt length} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return } {norm indent1}
$text insert insert {appt} {italic indent1}
$text insert insert {'s length in minutes. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appt length length} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set } {norm indent1}
$text insert insert {appt} {italic indent1}
$text insert insert {'s length to } {norm indent1}
$text insert insert {length} {italic indent1}
$text insert insert { minutes. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appt starttime date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return the starting time for } {norm indent1}
$text insert insert {appt} {italic indent1}
$text insert insert { in minutes since midnight. Unless the } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert { is specified as } {norm indent1}
$text insert insert {native} {bold indent1}
$text insert insert {, the value is converted from the native item's time zone to the current system time zone for } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {.} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appt starttime date minutes} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set the starting time for } {norm indent1}
$text insert insert {appt} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {minutes} {italic indent1}
$text insert insert { after midnight. Unless the } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert { is specified as } {norm indent1}
$text insert insert {native} {bold indent1}
$text insert insert {, the value is interpreted in the current system time zone for } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {.} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appt timezone} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return the time zone for } {norm indent1}
$text insert insert {appt} {italic indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appt timezone -convert name} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set the time zone for } {norm indent1}
$text insert insert {appt} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {name} {italic indent1}
$text insert insert {. If } {norm indent1}
$text insert insert {-convert} {bold indent1}
$text insert insert { is specified the starting date and time are converted to the new time zone.} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appt alarms} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return a list of alarm times. For each entry } {norm indent1}
$text insert insert {t} {italic indent1}
$text insert insert { in this list, ical will generate an alarm } {norm indent1}
$text insert insert {t} {italic indent1}
$text insert insert { minutes before the appointment starts. All of the elements in this list are non-negative. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {appt alarms list} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set the list of alarm times for } {norm indent1}
$text insert insert {appt} {italic indent1}
$text insert insert {. All of the elements of this list should be non-negative. For example, the following code will remove all alarms from ``$appt''. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $appt alarms {}
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {The following code will set alarms to occur at the appointment start time, and also 5, 10, and 15 minutes before the appointment starts. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $appts alarms {0 5 10 15}
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item is appt} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is an appointment. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item is note} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is a notice. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item calendar} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {If } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is contained in a calendar, return the name of that calendar's file. Otherwise raise an error. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item text} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return text for } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item text text} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Replace } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {'s text with } {norm indent1}
$text insert insert {text} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item uid} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return unique identifier for } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item earlywarning} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Items start appearing in item listings some number of days before their actual occurrence. For example, a birthday notice may start appearing five days early to give you enough time to go buy a birthday card. This operation returns the number of days of early warning you get for } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item earlywarning days} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set the early warning for } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {days} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {days} {italic indent1}
$text insert insert { must be non-negative. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item owner} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return the name of } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {'s owner. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item owner o} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Make } {norm indent1}
$text insert insert {o} {italic indent1}
$text insert insert { the owner of } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item owned} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is owned by the current user. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item own} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Make the current user the owner of } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item hilite} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return the highlight mode for } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. ``always'' means all item occurrences should be highlighted. ``never'' means no item occurrences should be highlighted. ``expire means only occurrences on or after today should be highlighted. ``holiday'' means that all item occurrences should be highlighted, but as holidays. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item hilite mode} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set the highlight mode for } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {mode} {italic indent1}
$text insert insert {. For example, the following code will create an item for Christmas day and add it to the calendar. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  set i [notice]
  $i monthrepeat 12 [date make 25 12 1994]
  $i text {Christmas}
  $i hilite holiday
  cal add $i
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item todo} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical supports } {norm indent1}
$text insert insert {todo} {italic indent1}
$text insert insert { items. If a todo item occurs in the past, that occurrence is automatically moved forward to today every day until the item is deleted, or marked as a non-todo item. This operation returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is a todo item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item todo 1} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This operation makes } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { a todo item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item todo 0} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This operation makes } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { a non-todo item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item is_done} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This operation returns true iff } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { is a todo item that has been marked as done. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item done 1} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This operation makes } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { a todo item (if it isn't one already), and also marks it as done. A done todo item stops moving forward every day. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item done 0} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This operation marks the item as not done. If the item is also a todo item, it will now move forward every day. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item option name} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Look up the value associated with } {norm indent1}
$text insert insert {name} {italic indent1}
$text insert insert { in the named item } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. An error is raised if the named option does not exist in the item. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  set priority normal
  catch {set priority [$item option Priority]}
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item option name value} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set the value of the option named } {norm indent1}
$text insert insert {name} {italic indent1}
$text insert insert { to } {norm indent1}
$text insert insert {value} {italic indent1}
$text insert insert { in the named item } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  $item option Priority high
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item delete_option name} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Remove the option named } {norm indent1}
$text insert insert {name} {italic indent1}
$text insert insert { from the named item } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert {. An error is raised if the named option does not exist in the item. Example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  catch {$item delete_option Priority}
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {Dates} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Dates are represented in Tcl code as integers from some unspecified date. Therefore the ``expr'' command can be used to manipulate dates by addition and subtraction. Here is a list of other supported operations on dates. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {date make day month year} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the date for the specified } {norm indent1}
$text insert insert {day} {italic indent1}
$text insert insert {, } {norm indent1}
$text insert insert {month} {italic indent1}
$text insert insert {, and } {norm indent1}
$text insert insert {year} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {day} {italic indent1}
$text insert insert {, } {norm indent1}
$text insert insert {month} {italic indent1}
$text insert insert {, and } {norm indent1}
$text insert insert {year} {italic indent1}
$text insert insert { should all be integers. This operation raises an error if the date specification is invalid. Here is an example of a date creation: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  # March 5, 1994.
  set d [date make 5 3 1994]
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date today} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns today's date. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date first} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the first date that can be legally represented by the ical implementation. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date last} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the last date that can be legally represented by the ical implementation. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date monthsize date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Return the number of days in the month containing } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date monthday date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the day of the month component of } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert { as an integer in the range 1...31. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date weekday date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the day of the week component of } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert { as an integer in the range 1...7. One corresponds to Sunday, and Seven corresponds to Saturday. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date month date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the month component of } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert { as an integer in the range 1...12. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date year date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the year component of } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert { as an integer. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date split date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns a four element list of the components of } {norm indent1}
$text insert insert {date} {italic indent1}
$text insert insert {. The first element is the day of the month, the second element is the day of the week, the third element is the month, and the fourth element is the year. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {date extract s d pre post} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff a date specification is successfully parsed from } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert {. The parsed date is stored in the variable named by } {norm indent1}
$text insert insert {d} {italic indent1}
$text insert insert {. The portion of } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert { before the parsed date specification is stored in the variable named by } {norm indent1}
$text insert insert {pre} {italic indent1}
$text insert insert {, and the portion of } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert { after the parsed date specification is stored in the variable named by } {norm indent1}
$text insert insert {post} {italic indent1}
$text insert insert {. For example, the following code will store today's date in the variable ``date'', the string ``before'' in the variable ``pre'', and the string ``after'' in the variable ``post''. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  date extract {before today after} date pre post
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {Times} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Times are represented in Tcl code as real numbers that give the number of seconds since some unspecified time. Therefore the ``expr'' command can be used to manipulate time values by addition and subtraction. Here is a list of other supported operations on times. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time now} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the current time. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time date time} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the date on which } {norm indent1}
$text insert insert {time} {italic indent1}
$text insert insert { occurs. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time hour time} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the hour of the day represented by } {norm indent1}
$text insert insert {time} {italic indent1}
$text insert insert { as an integer in the range 0...23. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time minute time} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the minute of the hour represented by } {norm indent1}
$text insert insert {time} {italic indent1}
$text insert insert { as an integer in the range 0...59. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time second time} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the second of the minute represented by } {norm indent1}
$text insert insert {time} {italic indent1}
$text insert insert { as an integer in the range 0...59. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time millisecond time} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns the millisecond of the second represented by } {norm indent1}
$text insert insert {time} {italic indent1}
$text insert insert { as an integer in the range 0...999. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time split [-all] [-timezone name] time} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns eight (if } {norm indent1}
$text insert insert {-all} {bold indent1}
$text insert insert {) or four element list of the components of } {norm indent1}
$text insert insert {time} {italic indent1}
$text insert insert {. They are: the day of the month (1..31), the day of the week (1..7, for Sunday..Saturday), month (1..12), year (4-digit), hour, minute, second, millisecond. If } {norm indent1}
$text insert insert {-all} {bold indent1}
$text insert insert { is not specified, only the last four elements (hour...millisecond) are returned.  Unless the time zone is specified, the conversion takes place in the current system time zone.} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time extract_time s t pre post} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff a time of day specification is successfully parsed from } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert {. The parsed time is stored in the variable named by } {norm indent1}
$text insert insert {d} {italic indent1}
$text insert insert { as the number of seconds since midnight. The portion of } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert { before the parsed time is stored in the variable named by } {norm indent1}
$text insert insert {pre} {italic indent1}
$text insert insert {, and the portion of } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert { after the parsed time is stored in the variable named by } {norm indent1}
$text insert insert {post} {italic indent1}
$text insert insert {. For example, the following code will store 180 (for ``3am'') in the variable ``time, the string ``X'' in the variable ``pre'', and the string ``Y'' in the variable ``post''. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  ical_time extract_time {X 3am Y} time pre post
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical_time extract_range s start finish pre post} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Returns true iff a time range specification is successfully parsed from } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert {. The parsed time is stored in the variables named by } {norm indent1}
$text insert insert {start} {italic indent1}
$text insert insert { and } {norm indent1}
$text insert insert {finish} {italic indent1}
$text insert insert { as the number of seconds since midnight. The portion of } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert { before the parsed range is stored in the variable named by } {norm indent1}
$text insert insert {pre} {italic indent1}
$text insert insert {, and the portion of } {norm indent1}
$text insert insert {s} {italic indent1}
$text insert insert { after the parsed time is stored in the variable named by } {norm indent1}
$text insert insert {post} {italic indent1}
$text insert insert {. For example, the following code will store 180 in the variable ``s'', 240 in the variable ``f'', the string ``Meeting'' in the variable ``pre'', and the string ``in Room 419'' in the variable ``post''. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  ical_time extract_range {Meeting 3-4am in Room 419} s f pre post
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {Customization via Hooks} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical provides a number of hooks. Users can attach code to these hooks to customize ical behavior. Code is attached to hooks by one of the following commands. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {append-hook hook {varnames...} {code}} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Code} {italic indent1}
$text insert insert { will be executed when the named } {norm indent1}
$text insert insert {hook} {italic indent1}
$text insert insert { is invoked by ical. Ical will provide a number of arguments when it invokes } {norm indent1}
$text insert insert {hook} {italic indent1}
$text insert insert {. (The number of arguments will depend on the particular hook being invoked.) The variables named by } {norm indent1}
$text insert insert {varnames...} {italic indent1}
$text insert insert { will be assigned the arguments supplied in the hook invocation before } {norm indent1}
$text insert insert {code} {italic indent1}
$text insert insert { is executed. For example, ical calls the ``dayview-startup'' hook when it creates a new calendar window. The hook is supplied one argument, the window being created. The following code changes the window to have a vertical layout by moving the appointment sub-window from the right side of the window to the bottom. } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
  append-hook dayview-startup {w} {
      pack [$w window].al -side bottom
  }
  } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {prepend-hook hook {varnames...} {code}} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This command is very similar to ``append-hook''. The only difference is that the specified } {norm indent1}
$text insert insert {code} {italic indent1}
$text insert insert { will be executed before any code that is currently attached to } {norm indent1}
$text insert insert {hook} {italic indent1}
$text insert insert {. (} {norm indent1}
$text insert insert {Code} {italic indent1}
$text insert insert { specified by an ``append-hook'' command is executed after code that is already attached to the hook.) } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {General Hooks} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Here is a list of some general hooks for ical. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {ical-startup} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked without any arguments when ical starts up. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {ical-exit} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked without any arguments just before ical exits. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {item-create item} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked when a new item is created. The created item is passed as the only argument to attached code. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {todo-item-done item} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked when a todo item is marked as done. The done item is passed as the only argument to attached code. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {alarm-fire appt} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked whenever an alarm is generated for an appointment. The appointment object for which the alarm is generated is passed as the only argument to the attached code. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Day Window Hooks} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following hooks are invoked when interesting things happen to a window that displays the items for a particular day. These windows are referred to as } {norm indent0}
$text insert insert {dayviews} {italic indent0}
$text insert insert { in the rest of the document. The object representing the dayview is passed as the first argument to these hooks. The } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {dayview interface} {ref indent0}
$text tag add ref_sec:dayview $_html_tmp insert
$text insert insert { is described in more detail later in this document. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {dayview-startup view} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked when a dayview is created. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {dayview-close view} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked just before a dayview is deleted. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {dayview-set-date view date} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked when the date displayed in a dayview is changed. The new date is passed as the second argument to the hook. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {dayview-focus view item} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked when an item displayed in a dayview is selected. The selected item is passed as the second argument to the hook. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert {dayview-unfocus view} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {This hook is invoked when an item displayed in a dayview is unselected. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Day Windows} {header1 indent0}
$text mark set label_sec:dayview $_html_tmp
$text tag bind ref_sec:dayview <1> {%W yview label_sec:dayview; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section is incomplete!} {italic indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section describes the operations available on objects that represent the main ical windows. These windows display the items for a particular day. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Common Editing Actions} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section is incomplete!} {italic indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section describes the common editing operations that can be invoked from user customizations. These operations build on the calendar and item interfaces described in earlier sections. Use these operations when you customize ical's user interface because these operations provide a consistent editing interface to the user. For example, the operations described in this section produce friendly messages if the user tries to edit an item in a read-only calendar. By contrast, the low-level interfaces described in the sections on } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {calendars} {ref indent0}
$text tag add ref_sec:calendars $_html_tmp insert
$text insert insert { and } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {items} {ref indent0}
$text tag add ref_sec:items $_html_tmp insert
$text insert insert { generate a stack trace if they are passed invalid arguments. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Miscellaneous Commands} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The C++ code exports a few miscellaneous commands to tcl code. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert {wbeep volume} {bold indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Produces a beep at the specified } {norm indent1}
$text insert insert {volume} {italic indent1}
$text insert insert {. The volume should be an integer in the range -100...100. A volume of -100 is the quietest. A volume of 100 is the loudest. This command is only available when ical is running on an X display. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {A few more commands are implemented in C++ to speed-up some frequent computations. The specifications for these commands are given in the C++ code itself. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Author} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Sanjay Ghemawat (sanjay@pa.dec.com)} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {http://www.research.digital.com/SRC/personal/Sanjay_Ghemawat/home.html} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Copyright} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Copyright (c) 1995 by Sanjay Ghemawat. Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {See Also} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical documentation at } {norm indent0}
$text insert insert {http://www.research.digital.com/SRC/personal/Sanjay_Ghemawat/ical/home.html} {norm indent0}
catch {unset _html_tmp}
}
