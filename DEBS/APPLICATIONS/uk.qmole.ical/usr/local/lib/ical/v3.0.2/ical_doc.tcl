proc ical_doc {text} {
wm title [winfo toplevel $text] {ical - An X based Calendar Program}
$text insert insert {Synopsis} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical} {italic indent0}
$text insert insert { provides an X interface for maintaining a calendar. A calendar is basically just a set of items. An item is either an appointment, or a notice. An } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {appointment} {ref indent0}
$text tag add ref_appts $_html_tmp insert
$text insert insert { starts at a particular time of the day, and finishes at a particular time of the day. A } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {notice} {ref indent0}
$text tag add ref_notes $_html_tmp insert
$text insert insert { does not have any starting or ending time. Notices are useful for marking certain days as special. For example, a calendar may contain a notice for April 15th indicating that taxes are due. When the documentation below refers to an } {norm indent0}
$text insert insert {item} {italic indent0}
$text insert insert {, it applies both to notices and appointments. The main features of } {norm indent0}
$text insert insert {ical} {italic indent0}
$text insert insert { are: } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert { * } {norm indent1h}
$text insert insert { Items can be created and edited easily. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert { Items can be } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {cut, copied and pasted} {ref indent1}
$text tag add ref_editing $_html_tmp insert
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert { Items can be made to } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {repeat} {ref indent1}
$text tag add ref_repeat $_html_tmp insert
$text insert insert { in various ways. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert { Ical will generate } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {alarms} {ref indent1}
$text tag add ref_alarms $_html_tmp insert
$text insert insert { for upcoming appointments. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert { Users can view many calendars at a time. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert { Calendars can be } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {shared} {ref indent1}
$text tag add ref_shared $_html_tmp insert
$text insert insert { by many users. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert { * } {norm indent1h}
$text insert insert { Related items can be grouped in their own calendar. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Invocation} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {You can specify various command line options to control } {norm indent0}
$text insert insert {ical} {italic indent0}
$text insert insert {. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {General Options} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following options can be used even when you are not logged in on an X display. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {-calendar } {bold indent1h}
$text insert insert {file-name} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The calendar is read from the specified file. See the description of } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {calendar files} {ref indent1}
$text tag add ref_calendar_file $_html_tmp insert
$text insert insert { for more information. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-date } {bold indent1h}
$text insert insert {date} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Set the starting date for item listings or window display to the specified date. For example: } {norm indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
     ical -date 1/aug/1997
     } {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {
} {pre indent1}
$text insert insert {-list } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Print a listing of the starting date's items and exit immediately. See the description of } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {listing items} {ref indent1}
$text tag add ref_listing $_html_tmp insert
$text insert insert { for details on the actual items printed by this option. The starting date is usually today, but may be changed with the -date option. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-show +} {bold indent1h}
$text insert insert {days} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Print a listing for items in the range } {norm indent1}
$text insert insert {[starting date...(starting date + days - 1)]} {fixed indent1}
$text insert insert { and exit immediately. See the description of } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {listing items} {ref indent1}
$text tag add ref_listing $_html_tmp insert
$text insert insert { for details on the actual items printed by this option. The starting date is usually today, but may be changed with the -date option. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-print } {bold indent1h}
$text insert insert {1|2|4|8|10|month} {fixed indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Generate postscript on standard output for range of days and exit. The starting date is usually today, but may be changed with the -date option. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {X Options} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following options are valid only if you are logged in on an X display. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {-iconic } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Start up with the main window iconified. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-iconposition } {bold indent1h}
$text insert insert {x} {italic indent1h}
$text insert insert {,} {bold indent1h}
$text insert insert {y} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Icon is placed at the specified position. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-popup } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Popup a window containing a listing of the starting date's items and exit as soon as the window is dismissed. See the description of } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {listing items} {ref indent1}
$text tag add ref_listing $_html_tmp insert
$text insert insert { for details on the actual items printed by this option. The starting date is usually today, but may be changed with the -date option. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-geometry } {bold indent1h}
$text insert insert {geometry} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Use } {norm indent1}
$text insert insert {geometry} {italic indent1}
$text insert insert { as the geometry for the main window. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-fg } {bold indent1h}
$text insert insert {color} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Use } {norm indent1}
$text insert insert {color} {italic indent1}
$text insert insert { as the foreground for all windows. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-bg } {bold indent1h}
$text insert insert {color} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Use } {norm indent1}
$text insert insert {color} {italic indent1}
$text insert insert { as the background for all windows. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {-display } {bold indent1h}
$text insert insert {display} {italic indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Run } {norm indent1}
$text insert insert {ical} {italic indent1}
$text insert insert { on the specified X display. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Windows} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The main calendar window displays the appointments and notices for a particular date. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Date Selector } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The top left portion of the window contains a date selector. You can click on the various arrows to change the month or the year. The day of the month can be selected by clicking on the appropriate day in the month display. The date selector contains various other buttons for convenient date selection. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Notice Window } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The bottom left portion of the window contains the notices for the selected date. A scroll bar is provided if all of the notices for the selected date do not fit into the notice window. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Appointment Window } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The right portion of the window contains the appointments for the selected day. You can scroll this region by using the scroll bar, or by dragging with the middle mouse button in the background. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Menubar } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {A menubar runs along the top of the calendar window. The } {norm indent1}
$text insert insert {File menu} {italic indent1}
$text insert insert { allows you to create and destroy application windows. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Status Line } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The bottom portion of the window contains a status line. This status line indicates the calendar from which the selected item comes and whether or not the selected item repeats. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Calendar Files} {header1 indent0}
$text mark set label_calendar_file $_html_tmp
$text tag bind ref_calendar_file <1> {%W yview label_calendar_file; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {A calendar is stored in a calendar file. The default calendar file is named } {norm indent0}
$text insert insert {.calendar} {fixed indent0}
$text insert insert { and is kept in the user's home directory. If the } {norm indent0}
$text insert insert {CALENDAR} {fixed indent0}
$text insert insert { environment variable is set, its value is used as the name of the calendar file. The } {norm indent0}
$text insert insert {CALENDAR} {fixed indent0}
$text insert insert { environment variable and the default can both be overridden by specifying a file name on the command line as follows -- } {norm indent0}
$text insert insert {
} {pre indent0}
$text insert insert {
} {pre indent0}
$text insert insert {
        ical -calendar file-name.
        } {pre indent0}
$text insert insert {
} {pre indent0}
$text insert insert {
} {pre indent0}
$text insert insert {Ical} {italic indent0}
$text insert insert { periodically saves any modifications made to a calendar to the corresponding calendar file. It also periodically incorporates changes made to a shared calendar file by other instances of ical. You can explicitly trigger these periodic saves and reads by using the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {File menu} {ref indent0}
$text tag add ref_file_menu $_html_tmp insert
$text insert insert {. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Including and Sharing Calendars} {header2 indent0}
$text mark set label_shared $_html_tmp
$text tag bind ref_shared <1> {%W yview label_shared; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {You can include other calendars into your private calendar. This facility is mainly useful for allowing a group of people to share a common set of items. For example, members of a particular group might have a calendar that contains the birthdays for each member of the group. This calendar can be included in each group member's private calendar. Use the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {File menu} {ref indent0}
$text tag add ref_file_menu $_html_tmp insert
$text insert insert { to include and exclude shared calendars. Use the } {norm indent0}
$text insert insert {Move Item To ...} {italic indent0}
$text insert insert { entry from the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Item menu} {ref indent0}
$text tag add ref_item_menu $_html_tmp insert
$text insert insert { to move items between calendars. Use the } {norm indent0}
$text insert insert {From Calendar ...} {italic indent0}
$text insert insert { entry in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {List menu} {ref indent0}
$text tag add ref_list_menu $_html_tmp insert
$text insert insert { to list all items a particular calendar. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Items} {header1 indent0}
$text mark set label_items $_html_tmp
$text tag bind ref_items <1> {%W yview label_items; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Notices} {header2 indent0}
$text mark set label_notes $_html_tmp
$text tag bind ref_notes <1> {%W yview label_notes; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {You can enter notices by clicking in the background in the bottom-left portion of the main calendar window. This click will create a new notice for the selected date. You can enter text into the notice by typing into it while it is selected (selected notices are highlighted by being displayed in different colors). A notice can be selected for editing by clicking with left button. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Appointments} {header2 indent0}
$text mark set label_appts $_html_tmp
$text tag bind ref_appts <1> {%W yview label_appts; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {You can enter appointments by left-clicking in the background in the right portion of the main calendar window. This click will create a new appointment for the selected date. The start time for this appointment is determined by the click location. You can move the appointment by dragging it with the middle mouse button held down. The appointment can be resized by dragging with the right mouse button held down. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Appointment text can be edited by typing into the appointment window while it is selected. If the appointment text you are typing in does not fit into the appointment area, then it will overflow out of the appointment area, but will be editable normally. If you do not like overflowing text, you should turn off the } {norm indent0}
$text insert insert {Allow Text Overflow} {italic indent0}
$text insert insert { option in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Options menu} {ref indent0}
$text tag add ref_option_menu $_html_tmp insert
$text insert insert { . With this option turned off, if the current text completely fills the area allocated to the appointment, then any attempts to add to the appointment text will be ignored until the appointment is enlarged with the right mouse button. Likewise, the right mouse button will refuse to shrink an appointment window if the appointment text completely fills the appointment window. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Alarms} {header2 indent0}
$text mark set label_alarms $_html_tmp
$text tag bind ref_alarms <1> {%W yview label_alarms; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical} {italic indent0}
$text insert insert { generates alarms for appointments. By default, the first alarm is generated fifteen minutes before the appointment is supposed to start and successive alarms are generated every five minutes until the appointment actually starts. You can change this default behavior by selecting the } {norm indent0}
$text insert insert {Default Alarms} {italic indent0}
$text insert insert { entry from the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Options menu} {ref indent0}
$text tag add ref_option_menu $_html_tmp insert
$text insert insert {. You can also change the timings of these alarms on an appointment-by-appointment basis by double-clicking on the appointment, or by selecting the appointment and then chosing the } {norm indent0}
$text insert insert {Properties} {italic indent0}
$text insert insert { entry in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Item menu} {ref indent0}
$text tag add ref_item_menu $_html_tmp insert
$text insert insert {. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Repeating Items} {header2 indent0}
$text mark set label_repeat $_html_tmp
$text tag bind ref_repeat <1> {%W yview label_repeat; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Items can be made to repeat in various ways. Item repetition can be controlled by using the entries in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Repeat menu} {ref indent0}
$text tag add ref_repeat_menu $_html_tmp insert
$text insert insert {. These entries make the item repeat in certain frequently used ways. For example, the } {norm indent0}
$text insert insert {Monthly} {italic indent0}
$text insert insert { entry makes the selected item repeat once per month and the } {norm indent0}
$text insert insert {Weekly} {italic indent0}
$text insert insert { entry makes the selected item repeat once per week. The } {norm indent0}
$text insert insert {Edit Monthly} {italic indent0}
$text insert insert {... and } {norm indent0}
$text insert insert {Edit Weekly} {italic indent0}
$text insert insert {... entries can be used to make items that repeat in more complex ways: for example, an item that occurs on the last Friday of each month, or an item that occurs on Monday, Wednesday, and Friday every week. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {In addition to making an item repeat in one of the pre-defined ways, you can also restrict an item's starting and finishing date by selecting the } {norm indent0}
$text insert insert {Set Range} {italic indent0}
$text insert insert {... entry from the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Repeat menu.} {ref indent0}
$text tag add ref_repeat_menu $_html_tmp insert
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Normally, a modification to a repeating item applies to all occurrences of that item. A single occurrence of a repeating item can be modified by selecting the occurrence and then choosing the } {norm indent0}
$text insert insert {Make} {italic indent0}
$text insert insert {Unique} {italic indent0}
$text insert insert { entry from the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Repeat menu} {ref indent0}
$text tag add ref_repeat_menu $_html_tmp insert
$text insert insert {. The selected occurrence can now be modified independently of the repeating item. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Todo Items} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Items can be marked as } {norm indent0}
$text insert insert {todo} {italic indent0}
$text insert insert { items by selecting the } {norm indent0}
$text insert insert {Todo} {italic indent0}
$text insert insert { entry in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Item menu} {ref indent0}
$text tag add ref_item_menu $_html_tmp insert
$text insert insert {. A } {norm indent0}
$text insert insert {todo} {italic indent0}
$text insert insert { item is automatically moved forward to today's date every day until the item is deleted or marked as done. An item can be marked as done by clicking in the little check-box right next to the displayed item. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Highlighting} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {By default, if any item occurs on a date, then the date is highlighted in the date selector located in the top-left corner of the calendar window. You can use the } {norm indent0}
$text insert insert {Highlight} {italic indent0}
$text insert insert { entries in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Item menu} {ref indent0}
$text tag add ref_item_menu $_html_tmp insert
$text insert insert { to control this highlighting behavior on an item-by-item basis. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Key Bindings} {header1 indent0}
$text mark set label_keys $_html_tmp
$text tag bind ref_keys <1> {%W yview label_keys; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {This section is currently incomplete.} {italic indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Editing} {header1 indent0}
$text mark set label_editing $_html_tmp
$text tag bind ref_editing <1> {%W yview label_editing; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Dragging with the left mouse button in a selected appointment or notice sets the X selection. The } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Edit menu} {ref indent0}
$text tag add ref_edit_menu $_html_tmp insert
$text insert insert { provides commands for dealing with the X selection. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical also has a clipboard that can store a single item. The } {norm indent0}
$text insert insert {Copy} {italic indent0}
$text insert insert { entry in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Edit menu} {ref indent0}
$text tag add ref_edit_menu $_html_tmp insert
$text insert insert { copies the selected item into the clipboard. The } {norm indent0}
$text insert insert {Cut} {italic indent0}
$text insert insert { entry does the same, but it also deletes the item from the calendar. If the selected item repeats, then the } {norm indent0}
$text insert insert {Cut} {italic indent0}
$text insert insert { command allows the user to delete all occurrences of the item, or just the selected occurrence. However, if the selected item does not belong to you, then } {norm indent0}
$text insert insert {Cut} {italic indent0}
$text insert insert { just hides the item from you. Other people will still see the item. An item in the clipboard can be inserted into the current day by selecting } {norm indent0}
$text insert insert {Paste} {italic indent0}
$text insert insert { entry. The newly pasted item loses all repetition information, and occurs just on the day in which it was pasted. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Listing Items} {header1 indent0}
$text mark set label_listing $_html_tmp
$text tag bind ref_listing <1> {%W yview label_listing; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {You can generate listings of imminent items by selecting one of the listing options in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {List menu} {ref indent0}
$text tag add ref_list_menu $_html_tmp insert
$text insert insert {. You can also use the command line options } {norm indent0}
$text insert insert {-list} {fixed indent0}
$text insert insert {, } {norm indent0}
$text insert insert {-show} {fixed indent0}
$text insert insert {, or } {norm indent0}
$text insert insert {-popup} {fixed indent0}
$text insert insert { to generate item listings. The command line options are most useful in } {norm indent0}
$text insert insert {.login} {fixed indent0}
$text insert insert { files. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {By default an item is included in a listing for a particular date if it occurs either on that date, or on the very next day. You can control this feature of item listings with the } {norm indent0}
$text insert insert {List item} {italic indent0}
$text insert insert { entry in the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Item menu.} {ref indent0}
$text tag add ref_item_menu $_html_tmp insert
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Printing} {header1 indent0}
$text mark set label_print $_html_tmp
$text tag bind ref_print <1> {%W yview label_print; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Calendar contents can be printed by selecting the } {norm indent0}
$text insert insert {Print} {italic indent0}
$text insert insert { option from the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {File menu} {ref indent0}
$text tag add ref_file_menu $_html_tmp insert
$text insert insert {. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Customization} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Some of } {norm indent0}
$text insert insert {ical's} {italic indent0}
$text insert insert { behavior can be customized via the } {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {Options menu} {ref indent0}
$text tag add ref_option_menu $_html_tmp insert
$text insert insert {. Other aspects of ical's behavior can be controlled via X Resources. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {X Resources} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Behavior} {header3 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following X resources can be used to control various aspects of ical's behavior. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical.pollSeconds } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Shared calendars are checked for changes made by other people once every } {norm indent1}
$text insert insert {pollSeconds} {italic indent1}
$text insert insert { seconds. The default value is 120. If } {norm indent1}
$text insert insert {ical} {italic indent1}
$text insert insert { appears sluggish, or if it is using too much CPU time, increase this value. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.saveSeconds } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Calendar files are saved once every } {norm indent1}
$text insert insert {saveSeconds} {italic indent1}
$text insert insert { seconds. The default value is 30. If } {norm indent1}
$text insert insert {ical} {italic indent1}
$text insert insert { appears sluggish, or if it is using too much CPU time, increase this value. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Dimensions} {header3 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following X resources can be used to control various dimensions of ical's appearance. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical.itemSelectWidth } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The border width of selected items is set to the value of this option to display the selected status of the item to to the user. On color displays, the default value of this option is 1 because on color displays selection is indicated by changing the color of the selected item. On monochrome displays, the default value of } {norm indent1}
$text insert insert {itemSelectWidth} {italic indent1}
$text insert insert { is 4. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.Dayview.geometry } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {X geometry specification for main calendar window. Usually, you will just specify the window position here. The size of the window is easier to control via the } {norm indent1}
$text insert insert {Options} {italic indent1}
$text insert insert { menu. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.Reminder.geometry } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {X geometry specification for alarms. Usually, you will just specify the window position here. The window size will be calculated automatically. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.Listing.geometry } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {X geometry specification for item listings. Usually, you will just specify the window position here. The window size will be calculated automatically. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Colors} {header3 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following X resources can be used to customize ical's use of colors. If ical windows show up with illegible colors (not enough distinction between background and foreground), it may be because your X resources contain definitions for } {norm indent0}
$text insert insert {*foreground} {fixed indent0}
$text insert insert { or } {norm indent0}
$text insert insert {*background} {fixed indent0}
$text insert insert { that conflict with ical colors. In general, it is a bad idea to define } {norm indent0}
$text insert insert {*foreground} {fixed indent0}
$text insert insert { and } {norm indent0}
$text insert insert {*background} {fixed indent0}
$text insert insert { in your resources because it will break a number of programs. You will be better off defining resources on an application by application basis. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical*Foreground/Ical*Background } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Foreground and background colors for most of ical's windows. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical*disabledForeground } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Foreground color assigned to disabled buttons and menu entries. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.itemFg/Ical.itemBg } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Foreground and background colors for unselected items. The default foreground is black and the default background is gray. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.itemSelectFg/Ical.itemSelectBg } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Foreground and background colors for selected items. The default foreground is black and the default background is SlateBlue1. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.itemOverflowColor/Ical.itemOverflowStipple } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Background color and stippling used for appointment text that overflows out of the appointment area. On color displays, the default overflow background is SlateBlue3 and no stippling is done (specified by an empty stipple option). On monochrome displays, the default overflow background is black, and the default overflow stippling is gray50. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.apptLineColor } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The color for the background lines and times displayed in the appointment window. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.weekdayColor } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The color used to display days of the week. The default is black. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.weekendColor } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The color used to display weekends. The default is red. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.interestColor } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The color used to highlight interesting dates. The default is blue. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.weekendInterestColor } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The color used to highlight interesting dates on weekends and holidays. The default is purple. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Fonts} {header3 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {The following resources can be used to customize ical's use of fonts. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical.fontFamily } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Preferred font family. Fonts for various purposes are obtained from this family unless overridden with one of the specifications below. The default font family is } {norm indent1}
$text insert insert {times} {fixed indent1}
$text insert insert {. Some other font families you can specify here are } {norm indent1}
$text insert insert {charter} {fixed indent1}
$text insert insert {, } {norm indent1}
$text insert insert {new century schoolbook} {fixed indent1}
$text insert insert {, and } {norm indent1}
$text insert insert {helvetica} {fixed indent1}
$text insert insert {. My personal favorite is } {norm indent1}
$text insert insert {new century schoolbook} {fixed indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.fixedFontFamily } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Preferred font family for fixed-width fonts. Fixed-width fonts for various purposes are obtained from this family unless overridden with one of the specifications below. The default font family is } {norm indent1}
$text insert insert {courier} {fixed indent1}
$text insert insert {. Some other font families you can specify here are } {norm indent1}
$text insert insert {fixed} {fixed indent1}
$text insert insert { and } {norm indent1}
$text insert insert {terminal} {fixed indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.fontSize } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font sizes used for ical. Use the value } {norm indent1}
$text insert insert {small} {fixed indent1}
$text insert insert { to use small font sizes everywhere. Any other value for this option defaults to the normal fonts. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical*itemFont } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used to display item contents. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.weekdayFont } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used for displaying days of the week. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.weekendFont } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used for displaying weekends. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.interestFont } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used to highlight interesting dates. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.weekendInterestFont } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used to highlight interesting dates on weekends and holidays. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.smallHeadingFont } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used for small headings. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical.largeHeadingFont } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used for large headings. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ical*} {bold indent1h}
$text insert insert {<} {bold indent1h}
$text insert insert {class} {italic indent1h}
$text insert insert {>} {bold indent1h}
$text insert insert {*font: } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Font used for windows of a certain class. Possible values for } {norm indent1}
$text insert insert {<} {norm indent1}
$text insert insert {class} {italic indent1}
$text insert insert {>} {norm indent1}
$text insert insert { are } {norm indent1}
$text insert insert {Dialog} {fixed indent1}
$text insert insert {, } {norm indent1}
$text insert insert {Button} {fixed indent1}
$text insert insert {, } {norm indent1}
$text insert insert {Label} {fixed indent1}
$text insert insert {, } {norm indent1}
$text insert insert {Menubutton} {fixed indent1}
$text insert insert {, } {norm indent1}
$text insert insert {Menu} {fixed indent1}
$text insert insert {, } {norm indent1}
$text insert insert {Listbox} {fixed indent1}
$text insert insert {, and } {norm indent1}
$text insert insert {Reminder} {fixed indent1}
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Tcl Code} {header2 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Users can also customize ical by writing tcl code and storing it in the file } {norm indent0}
$text insert insert {~/.tk/ical/user.tcl} {fixed indent0}
$text insert insert {. The code stored in this file is executed when ical starts up. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical also looks for site-specific customizations at startup. These customizations can be placed in the file } {norm indent0}
$text insert insert {site.tcl} {fixed indent0}
$text insert insert { in either the ical library directory, or its parent directory. (By default, ical looks for site.tcl in } {norm indent0}
$text insert insert {/usr/local/lib/ical/v[version]/} {fixed indent0}
$text insert insert {, and } {norm indent0}
$text insert insert {/usr/local/lib/ical/} {fixed indent0}
$text insert insert {, but these directories may be located elsewhere on your system.) The site specific files will be loaded in before any user specific customization file is loaded in. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {See the "Tcl Interface to Ical" document available via the Ical help menu. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical can run even when X is not available, therefore customization files should be written so that they will function even when Tk commands are not available.} {bold indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Menus} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
set _html_tmp [$text index insert]
$text insert insert {File Menu} {header2 indent0}
$text mark set label_file_menu $_html_tmp
$text tag bind ref_file_menu <1> {%W yview label_file_menu; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Save } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Save any modifications to the appropriate calendar files. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Re-Read } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Read any changes made to a shared calendar by another user or another instance of ical. Ical will automatically invoke this function periodically. It is provided as a menu entry only so for people who do not want to wait for ical's periodic checks. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Print } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Print calendar contents. The user has the option of saving the print-out to a file, pre viewing the print-out by specifying a PostScript displaying program, or sending the print-out directly to a PostScript printer by specifying a printing command. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Include Calendar } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Select a calendar to include into your private calendar. Included calendars are normally used to share calendars between different users. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Remove Include } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Remove a previously included calendar from your private calendar. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {New Window } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Open a new calendar window. This new window can be used to view the items for a different date than the original window. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Close Window } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Close the selected window. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Exit } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Save any changes and kill ical. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Edit Menu} {header2 indent0}
$text mark set label_edit_menu $_html_tmp
$text tag bind ref_edit_menu <1> {%W yview label_edit_menu; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Cut Item } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Delete the currently selected item and store it in the } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {clipboard} {ref indent1}
$text tag add ref_editing $_html_tmp insert
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Copy Item } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Copy selected item to the } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {clipboard} {ref indent1}
$text tag add ref_editing $_html_tmp insert
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Paste Item } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Paste item from } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {clipboard} {ref indent1}
$text tag add ref_editing $_html_tmp insert
$text insert insert { into calendar. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Delete Text } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Delete the currently selected text from the selected item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Insert Text } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Insert the current X selection into the selected item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Import Text } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Import the current X selection as a new item into the calendar. The date and time of this new item are parsed from the X selection if possible. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Item Menu} {header2 indent0}
$text mark set label_item_menu $_html_tmp
$text tag bind ref_item_menu <1> {%W yview label_item_menu; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Todo } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Toggle the item between being a todo item and not being a todo item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Always Highlight } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The item always causes the corresponding date to be highlighted. This is the default behavior. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Never Highlight } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The item never causes the corresponding date to be highlighted. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Highlight Future } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The item causes the corresponding date to be highlighted if and only if the date is not in the past. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Holiday } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {The item causes the corresponding date to be highlighted as a holiday. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Change Alarms } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {This item pops up a dialog box that allows you to edit the alarm times for an appointment.} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Note that this will only change the alarm times for the selected appointments. You can make this change for all appointments that do not have special alarm times by using the } {norm indent1}
$text insert insert {Default Alarms} {italic indent1}
$text insert insert { entry in the } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Options menu} {ref indent1}
$text tag add ref_option_menu $_html_tmp insert
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Early Warning } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {By default an item is included in a listing for a particular date if it occurs either on that date, or on the very next day. Sometimes, you may want to include an item in listings for earlier dates. For example, if you have an item reminding you of a birthday on March 17th, you might want this item to be included in all listings from March 7th to March 17th so that you will have enough time to go out and buy a present. You can achieve this effect by selecting this menu entry and then entering "10 days" into the resulting dialog.} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Note that this will only change the listing behavior for the selected item. You can make this change for all items you create from now on by using the } {norm indent1}
$text insert insert {Default Listings} {italic indent1}
$text insert insert { entry in the } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Options menu} {ref indent1}
$text tag add ref_option_menu $_html_tmp insert
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Properties ... } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Edit various item properties, including the calendar to which the item belongs, highlighting information, early warning options, alarm times, and starting and ending times for appointments. You can also double-click on an item to pop up the property editing dialog. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Search Forward } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Search forward looking for an item that contains a user specified string. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Search Backward } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Search backward looking for an item that contains a user specified string. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Repeat Menu} {header2 indent0}
$text mark set label_repeat_menu $_html_tmp
$text tag bind ref_repeat_menu <1> {%W yview label_repeat_menu; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Don't Repeat } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the selected item a non-repeating item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Daily } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the item repeat every day. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Weekly } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the item repeat once every week. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Monthly } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the item repeat once every month. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Annually } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the item repeat once every year. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Edit Weekly } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the item repeat on a weekly basis in a complicated fashion. For example, on Tuesday and Thursday every week. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Edit Monthly } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the item repeat on a monthly basis in a complicated fashion. For example, on the third Sunday in June, or the last working day of each month. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Set Range... } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Restrict the range for a repeating item. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Last Occurrence } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Make the current occurrence the last occurrence of the selected item. I.e., remove any occurrences after the current date. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Make Unique } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {If you want to modify just a single occurrence of a repeating item, select the item occurrence you want to modify and then activate this menu entry. Now all modifications to this item occurrence will only affect this particular occurrence. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {List Menu} {header2 indent0}
$text mark set label_list_menu $_html_tmp
$text tag bind ref_list_menu <1> {%W yview label_list_menu; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {One Day } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List the item occurrences for one day. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Seven Days } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List the item occurrences for the next seven days. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Ten Days } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List the item occurrences for the next ten days. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Thirty Days } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List the item occurrences for the next thirty days. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Week } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List the item occurrences for this week. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Month } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List the item occurrences for this month. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Year } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List the item occurrences for this year. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {From Calendar ... } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {List all item occurrences from a selected calendar. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Option Menu} {header2 indent0}
$text mark set label_option_menu $_html_tmp
$text tag bind ref_option_menu <1> {%W yview label_option_menu; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Appointment Range } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Controls the subset of a day displayed by default in the appointment listing. The factory settings display 8:00am to 6:00pm. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Notice Window Height } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {This entry can be used to change the height of the notice window. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Item Width } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {This entry can be used to change the width of displayed appointments and notices. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Allow Text Overflow } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {If this option is selected, then you can type in any amount of text into an appointment. The part of the text that does not fit into the appointment will be allowed to overflow out of the appointment. If you do not like text overflowing out of an appointment, then you should turn off this option. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Display Am/Pm } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {If this option is selected, time will be printed in twelve hour mode with } {norm indent1}
$text insert insert {am} {fixed indent1}
$text insert insert { or } {norm indent1}
$text insert insert {pm} {fixed indent1}
$text insert insert { indicators. Otherwise, time will be printed in twenty-four hour mode. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Start Week on Monday } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {If this option is selected, month displays will start each week off on a Monday. Otherwise, each week will start on a Sunday. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Default Alarms } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Use this menu entry to change the time intervals at which alarms go off. The factory settings cause alarms to be triggered fifteen minutes before each appointment, and then once every five minutes until the appointment actually starts. This menu entry changes the default alarm behavior for all appointments. You can override this default behavior on an appointment-by-appointment basis by selecting an appointment and then selecting the } {norm indent1}
$text insert insert {Change} {italic indent1}
$text insert insert {Alarms} {italic indent1}
$text insert insert { entry in the } {norm indent1}
$text insert insert {item} {italic indent1}
$text insert insert { menu. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Default Listings } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {This menu can be used to select the default listing behavior for newly created items. If the } {norm indent1}
$text insert insert {On Occurrence} {italic indent1}
$text insert insert { entry is selected, then a newly created item will only be shown in the listing of the day on which the item occurs. If the } {norm indent1}
$text insert insert {A Day Early} {italic indent1}
$text insert insert { entry is selected, then a new item will be shown in listings starting a day before the item occurrence. Similarly, the other menu entries can be selected to make new items show up in listings a number of days before their actual occurrence. This menu selects the default behavior for new items. Individual item behavior can be controlled by similar entries in the } {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Item menu} {ref indent1}
$text tag add ref_item_menu $_html_tmp insert
$text insert insert {. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
set _html_tmp [$text index insert]
$text insert insert {Help Menu} {header2 indent0}
$text mark set label_help_menu $_html_tmp
$text tag bind ref_help_menu <1> {%W yview label_help_menu; catch {%W mark unset anchor}}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {About Ical } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Displays ical version number and author information. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {User Guide } {bold indent1h}
$text insert insert {
} {norm indent1}
$text insert insert {Displays this document. } {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {
} {norm indent1}
$text insert insert {Author} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Sanjay Ghemawat (sanjay@pa.dec.com) } {norm indent0}
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
$text insert insert {Copyright (c) 1993 by Sanjay Ghemawat. Permission is granted to make and distribute verbatim copies of this manual provided the copyright notice and this permission notice are preserved on all copies. } {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {See Also} {header1 indent0}
$text insert insert {
} {norm indent0}
$text insert insert {
} {norm indent0}
$text insert insert {Ical } {norm indent0}
$text insert insert {http://www.research.digital.com/SRC/personal/Sanjay_Ghemawat/ical/home.html} {norm indent0}
catch {unset _html_tmp}
}
