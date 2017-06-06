Summary: An X Window System-based calendar program.
Name: ical 
Version: 2.2
#Release: 26
Release: 27
Source: http://www.research.digial.com/SRC/personal/Sanjay_Ghemawat/ical/icalbins/ical-%{PACKAGE_VERSION}.tar.gz
Patch0: ical-2.2-newtcl.patch
Patch1: ical-2.2-tcl823.patch
Patch2: ical-2.2-hack.patch
Patch3: ical-2.2-ia64.patch
Patch4: ical-2.2-glibc22.patch
Patch5: ical-2.2-print.patch
Patch6: ical-2.2-findscr.patch
Url: http://www.research.digital.com/SRC/personal/Sanjay_Ghemawat/ical/home.html
License: distributable
Group: Applications/Productivity
BuildRoot: %{_tmppath}/%{name}-root
Packager: Tom Bennet <bennet@mc.edu>, starting with the RH 7.3 package.

%description
Ical is an X Window System based calendar program. Ical will
create/edit/delete entries, create repeating entries, remind you about
upcoming appointments, print and list item occurrences, and allow
shared calendars between different users.

%prep
%setup -q
%patch0 -p1 -b .newtcl
%patch1 -p1 -b .tcl823
%patch2 -p1 -b .hack
%ifarch alpha ia64
%patch3 -p1 -b .ia64
%endif
%patch4 -p1 -b .glibc22
%patch5 -p0 -b .print
# TWB: Another patch to configure.in to allow config of the tcl and tk
# script directory, which RH seems to have put in some odd place.  Un-fixed
# config just dies.
%patch6 -p0 -b .findscr

# XXX patch0 changes configure.in
# Need to find out the right way to do this.
autoconf
# XXX drill out duplicate libs
perl -pi -e 's/ \@TCL_LIBS\@//' Makefile.in

%build
./configure --with-tclsh=%{_bindir}/tclsh --with-tclconfig=/usr/lib --with-tclscripts=/usr/share/tcl8.3 --with-tkscripts=/usr/share/tk8.3
make OPTF="$RPM_OPT_FLAGS" CXXFLAGS="$RPM_OPT_FLAGS"

%install
rm -rf ${RPM_BUILD_ROOT}
 mkdir -p ${RPM_BUILD_ROOT}%{_mandir}/man1

%makeinstall MANDIR=${RPM_BUILD_ROOT}%{_mandir}

strip ${RPM_BUILD_ROOT}%{_bindir}/ical-*

mkdir -p ${RPM_BUILD_ROOT}%{_sysconfdir}/X11/applnk/Applications
cat > ${RPM_BUILD_ROOT}%{_sysconfdir}/X11/applnk/Applications/ical.desktop <<EOF
[Desktop Entry]
Name=Ical
Name[sv]=Ical
Type=Application
Description=calendar and scheduling program with group calendar capabilities
Description[sv]=kalender- och schemaläggningsprogram med gruppkalendermöjligheter
Exec=ical
EOF

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc doc/ical.html doc/ical.doc 
%doc doc/interface.html doc/interface.doc
%{_bindir}/ical*
%{_mandir}/man1/ical.1*
%{_prefix}/lib/ical
%{_sysconfdir}/X11/applnk/Applications/ical.desktop

%changelog
* Tue Aug 19 2003 Tom Bennet <bennet@mc.edu>
- Attempt to build an rpm for RH 9.0 386.

* Wed Sep 12 2001 Tim Powers <timp@redhat.com>
- rebuild with new gcc and binutils

* Tue Jul 31 2001 Than Ngo <than@redhat.com>
- fix bug #50485

* Sun Jun 24 2001 Elliot Lee <sopwith@redhat.com>
- Bump release + rebuild.

* Sun Apr 29 2001 Bill Nottingham <notting@redhat.com>
- rebuild for C++ exception handling on ia64
- fix build

* Tue Oct 24 2000 Than Ngo <than@redhat.com>
- fixed ical -print option broken, thanks to wtanaka@yahoo.com (Bug #19627)
- used RPM_OPT_FLAGS

* Wed Oct 18 2000 Than Ngo <than@redhat.com>
- rebuilt against gcc-2.96-60 

* Sat Aug 05 2000 Than Ngo <than@redhat.de>
- add swedish translation (Bug #15311)

* Thu Jul 13 2000 Prospector <bugzilla@redhat.com>
- automatic rebuild

* Tue Jul  4 2000 Jakub Jelinek <jakub@redhat.com>
- Rebuild with new C++

* Thu Jun 15 2000 Bill Nottingham <notting@redhat.com>
- rebuild to fix dependencies

* Sat Jun  3 2000 Jeff Johnson <jbj@redhat.com>
- rebuild against tcltk-8.3.1.
- diddle the ia64 patch to build against glibc-2.2.

* Sat May 20 2000 Ngo Than <than@redhat.de>
- put man pages in /usr/share/man/*

* Sat May  6 2000 Bill Nottingham <notting@redhat.com>
- fixes for ia64 compilation

* Sun Mar 19 2000 Jeff Johnson <jbj@redhat.com>
- hack: add char * cast to compile with glibc-2.95.

* Sat Mar 18 2000 Jeff Johnson <jbj@redhat.com>
- rebuild against tcl-8.2.3.

* Thu Feb 03 2000 Preston Brown <pbrown@redhat.com>
- convert wmconfig to .desktop
- strip man page

* Sat May 15 1999 Jeff Johnson <jbj@redhat.com>
- Mark /etc/X11/wmconfig/ical as %config (#31)

* Sun Mar 21 1999 Cristian Gafton <gafton@redhat.com> 
- auto rebuild in the new build environment (release 9)

* Wed Feb 24 1999 Preston Brown <pbrown@redhat.com>
- Injected new description and group.

* Thu Sep 24 1998 Cristian Gafton <gafton@redhat.com>
- patch to build against the latest tcltk

* Thu Aug 13 1998 Jeff Johnson <jbj@redhat.com>
- build root

* Thu May 07 1998 Prospector System <bugs@redhat.com>
- translations modified for de, fr, tr

* Thu Oct 30 1997 Otto Hammersmith <otto@redhat.com>
- fixed wmconfig entry

* Thu Oct 23 1997 Otto Hammersmith <otto@redhat.com>
- replaced references to the version number with %{PACKAGE_VERSION}

* Wed Oct 22 1997 Otto Hammersmith <otto@redhat.com>
- updated to version 2.2, which is supposed to work with Tcl/Tk 8.0
- added wmconfig entry

* Mon Oct 20 1997 Otto Hammersmith <otto@redhat.com>
- Update version

* Tue Sep 30 1997 Erik Troan <ewt@redhat.com>
- build against tcl/tk 8.0

* Fri Aug 22 1997 Erik Troan <ewt@redhat.com>
- built against glibc
