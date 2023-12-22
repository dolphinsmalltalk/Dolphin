"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Kernel.Tests.CommandLineTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CommandLineTest guid: (Core.GUID fromString: '{3a8a3bc5-3ef6-46c1-933b-754c6b06457e}')!
Kernel.Tests.CommandLineTest comment: ''!
!Kernel.Tests.CommandLineTest categoriesForClass!SUnit! !
!Kernel.Tests.CommandLineTest methodsFor!

dolphinLauncherExe
	^SessionManager current argv first!

dproImageName
	^File splitFilenameFrom: SessionManager current imageFileName!

expectError: aString parsing: commandLine
	| filter |
	filter := [:ex | ex description beginsWith: aString].
	self
		should: [commandLine options]
			raise: CommandLineError
			matching: filter;
		should: [commandLine arguments]
			raise: CommandLineError
			matching: filter;
		yourself!

test_getOpt_01
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine optionChar |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName}.
	optionChar := commandLine getOpt: 'abc:'.
	self assertIsNil: optionChar	"No options provided"!

test_getOpt_02
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-a'. '-b'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assert: (commandLine getOpt: 'abc:') identicalTo: $b;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName};
		yourself!

test_getOpt_03
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-ab'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assert: (commandLine getOpt: 'abc:') identicalTo: $b;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName};
		yourself!

test_getOpt_04
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-c'. 'foo'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $c;
		assert: commandLine optArg equals: 'foo';
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName};
		yourself!

test_getOpt_05
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-cfoo'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $c;
		assert: commandLine optArg equals: 'foo';
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName};
		yourself!

test_getOpt_06
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. 'arg1'}.
	self
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName. 'arg1'};
		yourself!

test_getOpt_07
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-a'. 'arg1'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName. 'arg1'};
		yourself!

test_getOpt_08
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-c'. 'foo'. 'arg1'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $c;
		assert: commandLine optArg equals: 'foo';
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName. 'arg1'};
		yourself!

test_getOpt_09
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-a'. '--'. '-b'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName. '-b'};
		yourself!

test_getOpt_10
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-a'. '-'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName. '-'};
		yourself!

test_getOpt_11
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Unexected option"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-x'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $?;
		assert: commandLine optOpt equals: $x;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		should: [commandLine arguments] raise: CommandLineError matching: [:ex | ex description beginsWith: 'Unrecognized option: x'];
		yourself!

test_getOpt_12
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing required option argument"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-c'}.
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $?;
		assert: commandLine optOpt equals: $c;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		should: [commandLine arguments] raise: CommandLineError matching: [:ex | ex description beginsWith: 'Missing required argument for option c'];
		yourself!

test_getOpt_13
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing optional option argument"

	| commandLine |
	commandLine := CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-c'}.
	self
		assert: (commandLine getOpt: 'abc::') identicalTo: $c;
		assertIsNil: commandLine optOpt;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {self dproImageName};
		yourself!

test_getOpt_14
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Double dash indicates to treat remainder as arguments, not options"

	| commandLine |
	commandLine := CommandLine
				argv: {self dolphinLauncherExe. 'aa'. '--'. '-a'. '-b'. '-c'}.
	self
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: {'aa'. '-a'. '-b'. '-c'};
		yourself!

testAccessors
	| commandLine options arguments |
	commandLine := (CommandLine
				argv: {self dolphinLauncherExe. self dproImageName. '-a'. '-b'. '-c'. 'foo'. 'bar'})
				options: 'abc:';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #($a $b $c);
		assertIsNil: (options at: $a);
		assertIsNil: (options at: $b);
		assert: (options at: $c) equals: 'foo';
		assert: arguments equals: {self dproImageName. 'bar'};
		yourself!

testBlockNoArgument
	| foundFoo |
	foundFoo := false.
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. 'bar'})
		addOption: 'foo' whenPresentDo: [foundFoo := true];
		processOptions.
	self assert: foundFoo!

testBlockOptionalArgumentAbsent
	| fooValue barValue |
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. '--bar'})
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooValue := value];
		addOptionAllowingArgument: 'bar' whenPresentDo: [:value | barValue := value];
		processOptions.
	self
		assertIsNil: fooValue;
		assertIsNil: barValue;
		yourself!

testBlockOptionalArgumentPresent
	| fooValue |
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. 'bar'})
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooValue := value];
		processOptions.
	self assert: fooValue equals: 'bar'!

testBlockRequiredArgumentPresent
	| fooValue |
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. 'bar'})
		addOptionRequiringArgument: 'foo' whenPresentDo: [:value | fooValue := value];
		processOptions.
	self assert: fooValue equals: 'bar'!

testEmptyArguments
	| commandLine |
	commandLine := (CommandLine
				argv: { self dolphinLauncherExe. self dproImageName. ''. '-a'. 'bb'. '' })
				addOption: $a;
				yourself.
	self assert: commandLine arguments equals: { self dproImageName. ''. 'bb'. '' }!

testLongAmbiguousOption
	| commandLine |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--a'})
				addOption: 'aa';
				addOption: 'ab';
				yourself.
	self expectError: 'Ambiguous option ''a''' parsing: commandLine!

testLongEquals
	| commandLine options arguments |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo=bar'})
				addOptionRequiringArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: {self dproImageName};
		yourself!

testLongMissingRequiredArgument
	| commandLine |
	commandLine := (CommandLine argv: { self dolphinLauncherExe. self dproImageName. '--foo' })
				addOptionRequiringArgument: 'foo';
				yourself.
	self expectError: 'Missing required argument for option ''foo''' parsing: commandLine!

testLongNoArgument
	| commandLine options arguments |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. 'bar'})
				addOption: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assertIsNil: (options at: 'foo');
		assert: arguments equals: {self dproImageName. 'bar'};
		yourself!

testLongOptionalArgumentAbsent
	| commandLine options arguments |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. '--bar'})
				addOptionAllowingArgument: 'foo';
				addOptionAllowingArgument: 'bar';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('bar' 'foo');
		assertIsNil: (options at: 'bar');
		assertIsNil: (options at: 'foo');
		assert: arguments equals: {self dproImageName};
		yourself!

testLongOptionalArgumentPresent
	| commandLine options arguments |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. 'bar'})
				addOptionAllowingArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: {self dproImageName};
		yourself!

testLongOptionEmptyArgument
	| commandLine options |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo='})
				addOptionRequiringArgument: 'foo';
				yourself.
	options := commandLine options.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: '';
		yourself!

testLongRequiredArgumentPresent
	| commandLine options arguments |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. 'bar'})
				addOptionRequiringArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: {self dproImageName};
		yourself!

testLongUnexpectedArgument
	| commandLine |
	commandLine := (CommandLine argv: { self dolphinLauncherExe. self dproImageName. '--foo=bar' })
				addOption: 'foo';
				yourself.
	self expectError: 'Option ''foo'' has unexpected argument of ''bar''' parsing: commandLine!

testLongUnexpectedOption
	| commandLine |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--bar'})
				addOptionRequiringArgument: 'foo';
				yourself.
	self expectError: 'Unrecognized option ''bar''' parsing: commandLine!

testMissingRequiredArgument
	| commandLine |
	commandLine := (CommandLine argv: { self dolphinLauncherExe. self dproImageName. '-c' })
				options: 'abc:';
				yourself.
	self expectError: 'Missing required argument for option c' parsing: commandLine!

testPartialLong
	| commandLine options arguments |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--fo'. 'bar'})
				addOptionRequiringArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: {self dproImageName};
		yourself!

testRepeatBlockOptionalArgumentAbsent
	| fooCount barCount |
	fooCount := 0.
	barCount := 0.
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. '--bar'. '--foo'})
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooCount := fooCount + 1];
		addOptionAllowingArgument: 'bar' whenPresentDo: [:value | barCount := barCount + 1];
		processOptions.
	self
		assert: fooCount equals: 2;
		assert: barCount equals: 1;
		yourself!

testRepeatBlockOptionalArgumentPresent
	| fooValue |
	fooValue := ''.
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '--foo'. 'bar'. '--foo'. 'BAR'})
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooValue := fooValue , value];
		processOptions.
	self assert: fooValue equals: 'barBAR'!

testRepeatShortBlockNoArgument
	| fooCount |
	fooCount := 0.
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-f'. 'bar'. '-f'})
		addOption: $f whenPresentDo: [fooCount := fooCount + 1];
		processOptions.
	self assert: fooCount equals: 2!

testShortBlockNoArgument
	| foundFoo |
	foundFoo := false.
	(CommandLine argv: {'Dolphin7.exe'. self dproImageName. '-f'. 'bar'})
		addOption: $f whenPresentDo: [foundFoo := true];
		processOptions.
	self assert: foundFoo!

testShortBlockOptionalArgumentAbsent
	| fooValue barValue |
	fooValue := Object new.
	barValue := Object new.
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-f'. '-b'})
		addOptionAllowingArgument: $f whenPresentDo: [:value | fooValue := value];
		addOptionAllowingArgument: $b whenPresentDo: [:value | barValue := value];
		processOptions.
	self
		assertIsNil: fooValue;
		assertIsNil: barValue;
		yourself!

testShortBlockRequiredArgumentPresent
	| fooValue |
	(CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-f'. 'bar'})
		addOptionRequiringArgument: $f whenPresentDo: [:value | fooValue := value];
		processOptions.
	self assert: fooValue equals: 'bar'!

testSlashPrefix
	| commandLine options arguments |
	commandLine := (CommandLine
				argv: {self dolphinLauncherExe. self dproImageName. '/a'. '/b'. '/c'. 'foo'. 'bar'})
				options: 'abc:';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #($a $b $c);
		assertIsNil: (options at: $a);
		assertIsNil: (options at: $b);
		assert: (options at: $c) equals: 'foo';
		assert: arguments equals: {self dproImageName. 'bar'};
		yourself!

testUnrecognizedOption
	| commandLine |
	commandLine := (CommandLine argv: {self dolphinLauncherExe. self dproImageName. '-d'})
				options: 'abc:';
				yourself.
	self expectError: 'Unrecognized option: d' parsing: commandLine! !
!Kernel.Tests.CommandLineTest categoriesForMethods!
dolphinLauncherExe!private! !
dproImageName!private! !
expectError:parsing:!helpers!private! !
test_getOpt_01!getopt protocol!public! !
test_getOpt_02!getopt protocol!public! !
test_getOpt_03!getopt protocol!public! !
test_getOpt_04!getopt protocol!public! !
test_getOpt_05!getopt protocol!public! !
test_getOpt_06!getopt protocol!public! !
test_getOpt_07!getopt protocol!public! !
test_getOpt_08!getopt protocol!public! !
test_getOpt_09!getopt protocol!public! !
test_getOpt_10!getopt protocol!public! !
test_getOpt_11!getopt protocol!public! !
test_getOpt_12!getopt protocol!public! !
test_getOpt_13!getopt protocol!public! !
test_getOpt_14!getopt protocol!public! !
testAccessors!public! !
testBlockNoArgument!block!public! !
testBlockOptionalArgumentAbsent!block!public! !
testBlockOptionalArgumentPresent!block!public! !
testBlockRequiredArgumentPresent!block!public! !
testEmptyArguments!errors!public! !
testLongAmbiguousOption!errors!public! !
testLongEquals!long tests!public! !
testLongMissingRequiredArgument!errors!public! !
testLongNoArgument!long tests!public! !
testLongOptionalArgumentAbsent!long tests!public! !
testLongOptionalArgumentPresent!long tests!public! !
testLongOptionEmptyArgument!errors!public! !
testLongRequiredArgumentPresent!long tests!public! !
testLongUnexpectedArgument!errors!public! !
testLongUnexpectedOption!errors!public! !
testMissingRequiredArgument!errors!public! !
testPartialLong!long tests!public! !
testRepeatBlockOptionalArgumentAbsent!block!public! !
testRepeatBlockOptionalArgumentPresent!block!public! !
testRepeatShortBlockNoArgument!block!public! !
testShortBlockNoArgument!block!public! !
testShortBlockOptionalArgumentAbsent!block!public! !
testShortBlockRequiredArgumentPresent!block!public! !
testSlashPrefix!public! !
testUnrecognizedOption!errors!public! !
!

