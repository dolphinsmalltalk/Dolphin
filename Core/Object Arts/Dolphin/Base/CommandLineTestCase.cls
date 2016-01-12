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

test_getOpt_1
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine optionChar |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7').
	optionChar := commandLine getOpt: 'abc:'.
	self assert: optionChar isNil.	"No options provided"!

test_getOpt_2
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine optionChar |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-b').
	optionChar := commandLine getOpt: 'abc:'.
	self 
		assert: optionChar == $a;
		yourself.! !
!CommandLineTestCase categoriesFor: #test_getOpt_1!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_2!public! !

