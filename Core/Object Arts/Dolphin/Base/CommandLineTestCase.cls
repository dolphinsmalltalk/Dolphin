"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #CommandLineTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLineTestCase guid: (GUID fromString: '{3A8A3BC5-3EF6-46C1-933B-754C6B06457E}')!
CommandLineTestCase comment: ''!
!CommandLineTestCase categoriesForClass!SUnit! !
!CommandLineTestCase methodsFor!

test_getopt
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine test: #('Dolphin7.exe' 'DPRO.img7').
	! !
!CommandLineTestCase categoriesFor: #test_getopt!public! !

