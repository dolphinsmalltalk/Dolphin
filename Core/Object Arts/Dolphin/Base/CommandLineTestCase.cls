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

test_getOpt_01
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine optionChar |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7').
	optionChar := commandLine getOpt: 'abc:'.
	self assert: optionChar isNil.	"No options provided"!

test_getOpt_02
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-b').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') == $b;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		yourself.!

test_getOpt_03
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-ab').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') == $b;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		yourself.!

test_getOpt_04
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		yourself.!

test_getOpt_05
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-cfoo').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		yourself.!

test_getOpt_06
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine optInd == 3;
		yourself.!

test_getOpt_07
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine optInd == 4;
		yourself.!

test_getOpt_08
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine optInd == 5;
		yourself.!

test_getOpt_09
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '--' '-b').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine optInd == 5;
		yourself.!

test_getOpt_10
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine optInd == 4;
		yourself.!

test_getOpt_11
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Unexected option"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-x').
	self 
		assert: (commandLine getOpt: 'abc:') == $?;
		assert: commandLine optOpt = $x;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		yourself.!

test_getOpt_12
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing required option argument"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c').
	self 
		assert: (commandLine getOpt: 'abc:') == $?;
		assert: commandLine optOpt = $c;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		yourself.!

test_getOpt_13
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing optional option argument"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c').
	self 
		assert: (commandLine getOpt: 'abc::') == $c;
		assert: commandLine optOpt isNil;
		assert: commandLine optArg isEmpty;
		assert: (commandLine getOpt: 'abc:') isNil;
		yourself.!

testAccessors

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-b' '-c' 'foo' 'bar'))
		options: 'abc:';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #($a $b $c);
		assert: (options at: $a) isNil;
		assert: (options at: $b) isNil;
		assert: (options at: $c) = 'foo';
		assert: arguments = #('bar');
		yourself.!

testSlashPrefix

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '/a' '/b' '/c' 'foo' 'bar'))
		options: 'abc:';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #($a $b $c);
		assert: (options at: $a) isNil;
		assert: (options at: $b) isNil;
		assert: (options at: $c) = 'foo';
		assert: arguments = #('bar');
		yourself.! !
!CommandLineTestCase categoriesFor: #test_getOpt_01!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_02!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_03!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_04!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_05!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_06!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_07!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_08!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_09!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_10!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_11!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_12!public! !
!CommandLineTestCase categoriesFor: #test_getOpt_13!public! !
!CommandLineTestCase categoriesFor: #testAccessors!public! !
!CommandLineTestCase categoriesFor: #testSlashPrefix!public! !

