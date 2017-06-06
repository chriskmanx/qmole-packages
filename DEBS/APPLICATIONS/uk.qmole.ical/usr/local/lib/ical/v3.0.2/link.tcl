# Copyright (c) 1995 by Sanjay Ghemawat

#### Code to create and follow URI links from items ####

proc follow_link {uri} {
    if [regexp {^file://localhost/(.*)$} $uri junk filename] {
        follow_file_link /$filename
        return
    }
    if [regexp {^/} $uri] {
        follow_file_link $uri
        return
    }

    set w netscape
    catch {set w [cal option WebBrowser]}
    catch {exec $w $uri &}
    # this trick will reap a zombie left from the exec above
    after 60000 exec echo
}

proc follow_file_link {file} {
    if [catch {set text [file_read $file]} msg] {
        ical_error $msg
        return
    }

    set f [make_text_viewer $file [file tail $file]]
    $f.text config -state normal
    $f.text insert insert $text
    $f.text config -state disabled
}
