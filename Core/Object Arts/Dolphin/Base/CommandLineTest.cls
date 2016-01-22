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

	| commandLine x |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-b').
	self 
		assert: (x := commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') == $b;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7');
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
		assert: commandLine arguments = #('DPRO.img7');
		yourself.!

test_getOpt_04
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7');
		yourself.!

test_getOpt_05
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-cfoo').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7');
		yourself.!

test_getOpt_06
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7' 'arg1');
		yourself.!

test_getOpt_07
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7' 'arg1');
		yourself.!

test_getOpt_08
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo' 'arg1').
	self 
		assert: (commandLine getOpt: 'abc:') == $c;
		assert: commandLine optArg = 'foo';
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7' 'arg1');
		yourself.!

test_getOpt_09
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '--' '-b').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7' '-b');
		yourself.!

test_getOpt_10
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-').
	self 
		assert: (commandLine getOpt: 'abc:') == $a;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7' '-');
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
		should: [commandLine arguments] raise: CommandLineError;
		yourself.!

test_getOpt_12
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing required option argument"

	| commandLine x |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c').
	self 
		assert: (x := commandLine getOpt: 'abc:') == $?;
		assert: commandLine optOpt = $c;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		should: [commandLine arguments] raise: CommandLineError;
		yourself.!

test_getOpt_13
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing optional option argument"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c').
	self 
		assert: (commandLine getOpt: 'abc::') == $c;
		assert: commandLine optOpt isNil;
		assert: commandLine optArg isNil;
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7');
		yourself.!

test_getOpt_14
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Double dash indicates to treat remainder as arguments, not options"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--' '-a' '-b' '-c').
	self 
		assert: (commandLine getOpt: 'abc:') isNil;
		assert: commandLine arguments = #('DPRO.img7' '-a' '-b' '-c');
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
		assert: arguments = #('DPRO.img7' 'bar');
		yourself.!

testBlockNoArgument

	| foundFoo |
	foundFoo := false.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionNamed: 'foo' whenPresentDo: [foundFoo := true];
		valueBlocks.
	self assert: foundFoo.
!

testBlockOptionalArgumentAbsent

	| fooValue barValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' '--bar'))
		addOptionAllowingArgumentNamed: 'foo' whenPresentDo: [:value | fooValue := value];
		addOptionAllowingArgumentNamed: 'bar' whenPresentDo: [:value | barValue := value];
		valueBlocks.
	self
		assert: fooValue isNil;
		assert: barValue isNil;
		yourself.!

testBlockOptionalArgumentPresent

	| fooValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionAllowingArgumentNamed: 'foo' whenPresentDo: [:value | fooValue := value];
		valueBlocks.
	self assert: fooValue = 'bar'.!

testBlockRequiredArgumentPresent

	| fooValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionRequiringArgumentNamed: 'foo' whenPresentDo: [:value | fooValue := value];
		valueBlocks.
	self assert: fooValue = 'bar'.
!

testLongAmbiguousOption

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--a'))
		addOptionNamed: 'aa';
		addOptionNamed: 'ab';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testLongEquals

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo=bar'))
		addOptionRequiringArgumentNamed: 'foo';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #('foo');
		assert: (options at: 'foo') = 'bar';
		assert: arguments = #('DPRO.img7');
		yourself.!

testLongMissingRequiredArgument

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo'))
		addOptionRequiringArgumentNamed: 'foo';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testLongNoArgument

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionNamed: 'foo';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #('foo');
		assert: (options at: 'foo') isNil;
		assert: arguments = #('DPRO.img7' 'bar');
		yourself.!

testLongOptionalArgumentAbsent

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' '--bar'))
		addOptionAllowingArgumentNamed: 'foo';
		addOptionAllowingArgumentNamed: 'bar';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #('bar' 'foo');
		assert: (options at: 'bar') isNil;
		assert: (options at: 'foo') isNil;
		assert: arguments = #('DPRO.img7');
		yourself.!

testLongOptionalArgumentPresent

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionAllowingArgumentNamed: 'foo';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #('foo');
		assert: (options at: 'foo') = 'bar';
		assert: arguments = #('DPRO.img7');
		yourself.!

testLongRequiredArgumentPresent

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionRequiringArgumentNamed: 'foo';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #('foo');
		assert: (options at: 'foo') = 'bar';
		assert: arguments = #('DPRO.img7');
		yourself.!

testLongUnexpectedArgument

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo=bar'))
		addOptionNamed: 'foo';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testLongUnexpectedOption

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--bar'))
		addOptionRequiringArgumentNamed: 'foo';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testMissingRequiredArgument

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c'))
		options: 'abc:';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testPartialLong

	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--fo' 'bar'))
		addOptionRequiringArgumentNamed: 'foo';
		yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self 
		assert: options class == Dictionary;
		assert: options keys asSortedCollection asArray = #('foo');
		assert: (options at: 'foo') = 'bar';
		assert: arguments = #('DPRO.img7');
		yourself.!

testRepeatBlockOptionalArgumentAbsent

	| fooCount barCount |
	fooCount := 0.
	barCount := 0.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' '--bar' '--foo'))
		addOptionAllowingArgumentNamed: 'foo' whenPresentDo: [:value | fooCount := fooCount + 1];
		addOptionAllowingArgumentNamed: 'bar' whenPresentDo: [:value | barCount := barCount + 1];
		valueBlocks.
	self
		assert: fooCount = 2;
		assert: barCount = 1;
		yourself.!

testRepeatBlockOptionalArgumentPresent

	| fooValue |
	fooValue := ''.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar' '--foo' 'BAR'))
		addOptionAllowingArgumentNamed: 'foo' whenPresentDo: [:value | fooValue := fooValue , value];
		valueBlocks.
	self assert: fooValue = 'barBAR'.!

testRepeatShortBlockNoArgument

	| fooCount |
	fooCount := 0.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' 'bar' '-f'))
		addOptionNamed: $f whenPresentDo: [fooCount := fooCount + 1];
		valueBlocks.
	self assert: fooCount = 2.
!

testShortBlockNoArgument

	| foundFoo |
	foundFoo := false.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' 'bar'))
		addOptionNamed: $f whenPresentDo: [foundFoo := true];
		valueBlocks.
	self assert: foundFoo.
!

testShortBlockOptionalArgumentAbsent

	| fooValue barValue |
	fooValue := Object new.
	barValue := Object new.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' '-b'))
		addOptionAllowingArgumentNamed: $f whenPresentDo: [:value | fooValue := value];
		addOptionAllowingArgumentNamed: $b whenPresentDo: [:value | barValue := value];
		valueBlocks.
	self
		assert: fooValue isNil;
		assert: barValue isNil;
		yourself.!

testShortBlockRequiredArgumentPresent

	| fooValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' 'bar'))
		addOptionRequiringArgumentNamed: $f whenPresentDo: [:value | fooValue := value];
		valueBlocks.
	self assert: fooValue = 'bar'.
!

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
		assert: arguments = #('DPRO.img7' 'bar');
		yourself.!

testUnrecognizedOption

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-d'))
		options: 'abc:';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
! !
!CommandLineTest categoriesFor: #test_getOpt_01!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_02!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_03!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_04!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_05!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_06!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_07!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_08!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_09!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_10!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_11!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_12!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_13!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_14!getopt protocol!public! !
!CommandLineTest categoriesFor: #testAccessors!public! !
!CommandLineTest categoriesFor: #testBlockNoArgument!block!public! !
!CommandLineTest categoriesFor: #testBlockOptionalArgumentAbsent!block!public! !
!CommandLineTest categoriesFor: #testBlockOptionalArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testBlockRequiredArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testLongAmbiguousOption!errors!public! !
!CommandLineTest categoriesFor: #testLongEquals!long tests!public! !
!CommandLineTest categoriesFor: #testLongMissingRequiredArgument!errors!public! !
!CommandLineTest categoriesFor: #testLongNoArgument!long tests!public! !
!CommandLineTest categoriesFor: #testLongOptionalArgumentAbsent!long tests!public! !
!CommandLineTest categoriesFor: #testLongOptionalArgumentPresent!long tests!public! !
!CommandLineTest categoriesFor: #testLongRequiredArgumentPresent!long tests!public! !
!CommandLineTest categoriesFor: #testLongUnexpectedArgument!errors!public! !
!CommandLineTest categoriesFor: #testLongUnexpectedOption!errors!public! !
!CommandLineTest categoriesFor: #testMissingRequiredArgument!errors!public! !
!CommandLineTest categoriesFor: #testPartialLong!long tests!public! !
!CommandLineTest categoriesFor: #testRepeatBlockOptionalArgumentAbsent!block!public! !
!CommandLineTest categoriesFor: #testRepeatBlockOptionalArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testRepeatShortBlockNoArgument!block!public! !
!CommandLineTest categoriesFor: #testShortBlockNoArgument!block!public! !
!CommandLineTest categoriesFor: #testShortBlockOptionalArgumentAbsent!block!public! !
!CommandLineTest categoriesFor: #testShortBlockRequiredArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testSlashPrefix!public! !
!CommandLineTest categoriesFor: #testUnrecognizedOption!errors!public! !

