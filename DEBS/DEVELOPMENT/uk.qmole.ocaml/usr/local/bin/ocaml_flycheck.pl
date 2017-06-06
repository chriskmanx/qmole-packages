#!/usr/bin/env perl
# ocaml_flycheck.pl

### Please rewrite the following 2 variables 
### ($ocamlc, @ocamlc_options)

$ocamlc = '/usr/local/bin/ocamlc'; # where is ocamlc
@ocamlc_options  = ('-c -thread unix.cma threads.cma graphics.cma');   # e.g. ('-fglasgow-exts')

### the following should not been edited ###

use File::Temp qw /tempfile tempdir/;
File::Temp->safe_level( File::Temp::HIGH );

($source, $base_dir) = @ARGV;

@command = ($ocamlc);

while(@ocamlc_options) {
    push(@command, shift @ocamlc_options);
}

push (@command,    $source);

while(@ocamlc_packages) {
    push(@command, '-package');
    push(@command, shift @ocamlc_packages);
}

$dir = tempdir( CLEANUP => 1 );
($fh, $filename) = tempfile( DIR => $dir );

system("@command >$filename 2>&1");

open(MESSAGE, $filename); 
while(<MESSAGE>) {
  # example message  {File "robocupenv.ml", line 133, characters 6-10:
  if(/^File "(\S+\.ml[yilp]?)", line (\d+), characters (\d+)-\d+:\s?(.*)/) {
	$error = (<MESSAGE>); # get the next line
	print "\n"; 
	print "$1:$2:$3:";
	if ($error =~ /Warning(.*)/) {
	    print "$error";
	}
	else {
	    print "$error ";
	}
	    next;
    }
    if(/\s+(.*)/) {
	$rest = $1;
        chomp $rest;
	print $rest;
        print " ";
	next;
    }
}
close($fh);
print "\n";
