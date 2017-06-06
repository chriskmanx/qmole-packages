# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Bug Report dialog
#
# Commands
#
#       bug_notify <mailer> <email> <message>
#               Handle software error

# Hidden global variables
#
#       bug_done                Is bug interaction finished

set bug(done) no

proc bug_notify {mailer email message} {
    bug_make
    bug_interact $mailer $email $message
}

proc bug_make {} {
    global bug

    set f .bug_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f {Internal Error}
    wm protocol $f WM_DELETE_WINDOW {set bug(done) cancel}

    frame $f.top -class Pane
    frame $f.mid -class Pane

    make_buttons $f.bot 2 {
        {{Dismiss}              {set bug(done) cancel}}
        {{Save}                 {set bug(done) save}}
        {{Mail Report}          {set bug(done) send}}
    }

    label $f.icon -bitmap error
    message $f.warn -aspect 400 -text {Uninitialized message}

    set bug(message) [bug_textwin $f.message Message]
    set bug(edit)    [bug_textwin $f.edit    {User Notes}]

    $bug(message).text configure -state disabled
    $bug(edit).text configure -state normal

    pack $f.icon -in $f.top -side left -padx 5m -pady 5m
    pack $f.warn -in $f.top -side right -padx 5m -pady 5m -expand 1 -fill both

    pack $f.edit -in $f.mid -side top -padx 5m -pady 5m -expand 1 -fill both
    pack $f.message -in $f.mid -side top -padx 5m -pady 5m -expand 1 -fill both

    pack $f.top -side top -fill both
    pack $f.mid -side top -expand 1 -fill both
    pack $f.bot -side top -fill both

    # XXX What bindings should we add here?
    # bind $f <Control-c><Control-c> {set bug(done) cancel}

    wm withdraw $f
    update
}

proc bug_textwin {w l} {
    frame $w -class Inset
    make_scrolled_text $w.contents
    pack $w.contents -side top -expand 1 -fill both
    label_widget $w.contents $l
    $w.contents.text configure -width 40 -height 6 -wrap none
    return $w.contents
}

proc bug_interact {mailer email message} {
    global bug

    set f .bug_dialog

    # Configure notice
    $f.warn configure -text [format [join {
        "An internal error has occurred.  You can send a bug report to"
        "the author (%s) by clicking on the \"Mail Report\" button"
        "at the bottom of this dialog.  The text displayed in the text"
        "areas below will be the only information sent to the author."
        "If you do not want to send a bug report, click on the"
        "\"Dismiss\" button.  If you want to send extra comments to"
        "the author, type them into the area below."
    }] $email]

    set mtext $bug(message).text
    $mtext configure -state normal
    $mtext delete 1.0 end
    $mtext insert 1.0 $message
    $mtext configure -state disabled

    set etext $bug(edit).text
    $etext delete 1.0 end

    set bug(done) no
    dialog_run {} $f bug(done) $etext

    if ![string compare $bug(done) {cancel}] return

    set text [bug_extract]
    switch -exact -- $bug(done) {
        save {
            bug_save $email $text
        }
        send {
            # Try different ways of sending mail
            if [catch {bug_mail1 $mailer $email $text}] {
                catch {bug_mail2 $mailer $email $text}
            }
        }
    }
}

proc bug_extract {} {
    global bug

    set f .bug_dialog
    set text1 [$bug(edit).text get 1.0 end]
    set text2 [$bug(message).text get 1.0 end]

    return "$text1\n========\n$text2\n========"
}

proc bug_save {email text} {
    set msg {Select file to which message should be saved}
    if ![get_file_name {} {File} $msg file] return

    catch {
        set f [open $file w]
        catch {puts $f "To: $email"}
        catch {puts $f "Subject: Bug report"}
        catch {puts $f "--------"}
        catch {puts $f $text}
        close $f
    }
}
                
proc bug_mail1 {mailer email text} {
    set f .bug_dialog

    set mailproc [open [list | $mailer -s {Bug report} $email] w]
    catch {puts $mailproc $text}
    close $mailproc
}

proc bug_mail2 {mailer email text} {
    set f .bug_dialog

    set mailproc [open [list | $mailer $email] w]
    catch {puts $mailproc {Subject: Bug report}}
    catch {puts $mailproc $text}
    close $mailproc
}
