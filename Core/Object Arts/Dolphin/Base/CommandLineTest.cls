"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #CommandLineTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLineTest guid: (GUID fromString: '{3A8A3BC5-3EF6-46C1-933B-754C6B06457E}')!
CommandLineTest comment: ''!
!CommandLineTest categoriesForClass!SUnit! !
!CommandLineTest methodsFor!

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
		assert: commandLine arguments isEmpty;
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
		assert: commandLine arguments isEmpty;
		yourself.!

test_getOpt_04
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments isEmpty;
		yourself.!

test_getOpt_05
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-cfoo').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments isEmpty;
		yourself.!

test_getOpt_06
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('arg1');
		yourself.!

test_getOpt_07
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('arg1');
		yourself.!

test_getOpt_08
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('arg1');
		yourself.!

test_getOpt_09
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '--' '-b').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('-b');
		yourself.!

test_getOpt_10
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('-');
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
		assert: commandLine arguments isEmpty;
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
		assert: commandLine arguments isEmpty;
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
		assert: commandLine arguments isEmpty;
		yourself.!

test_getOpt_14
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Double dash indicates to treat remainder as arguments, not options"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--' '-a' '-b' '-c').
	self 
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('-a' '-b' '-c');
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
!CommandLineTest categoriesFor: #test_getOpt_01!public! !
!CommandLineTest categoriesFor: #test_getOpt_02!public! !
!CommandLineTest categoriesFor: #test_getOpt_03!public! !
!CommandLineTest categoriesFor: #test_getOpt_04!public! !
!CommandLineTest categoriesFor: #test_getOpt_05!public! !
!CommandLineTest categoriesFor: #test_getOpt_06!public! !
!CommandLineTest categoriesFor: #test_getOpt_07!public! !
!CommandLineTest categoriesFor: #test_getOpt_08!public! !
!CommandLineTest categoriesFor: #test_getOpt_09!public! !
!CommandLineTest categoriesFor: #test_getOpt_10!public! !
!CommandLineTest categoriesFor: #test_getOpt_11!public! !
!CommandLineTest categoriesFor: #test_getOpt_12!public! !
!CommandLineTest categoriesFor: #test_getOpt_13!public! !
!CommandLineTest categoriesFor: #test_getOpt_14!public! !
!CommandLineTest categoriesFor: #testAccessors!public! !
!CommandLineTest categoriesFor: #testSlashPrefix!public! !

