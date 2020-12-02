"Filed out from Dolphin Smalltalk 7"!

Notification subclass: #CompilerNotification
	instanceVariableNames: 'position ranges line extras methodClass source selector offset'
	classVariableNames: 'ErrorFormats'
	imports: #(#{SmalltalkParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
CompilerNotification guid: (GUID fromString: '{87b4c56d-026e-11d3-9fd7-00a0cc3e4a32}')!
CompilerNotification isAbstract: true!
CompilerNotification comment: 'CompilerNotification is the abstract class of <Notification>s used to represent lexical, syntax, and semantic errors and warnings detected by the Dolphin <Compiler>, <SmalltalkParser>, and <StSemanticChecker>.

Instance Variables:
	position		<integer>. Position in source text at which error detected. Not necessarily the same as range start.
	range		<Interval>. Range of the source text to which the error applies (e.g. used to select offending text in browser)
	line			<integer>. Line number on which error detected.
	extras		<Array> of <Object>. Extra values used to parameterise the error message text
	methodClass	<ClassDescription>. Class in the context of which the method is being compiled.
	source		<String>. Method/expression source code
	selector		<Symbol>. Selector of the method being compiled, if available

N.B. The inherited''''tag'''' instance variable is used to hold the <integer> error code, but the inherited ''''messageText'''' instance variable is unused.'''!
!CompilerNotification categoriesForClass!System-Compiler! !
!CompilerNotification methodsFor!

_descriptionArguments
	"Answer the arguments to be substituted into the receiver's Win32 description format String."

	^{self severityName. self methodClass name. self selector. self line. self errorMessage}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%1: %2>>%3 at line %4!!d!!: %5'!

code: anInteger in: aString for: aClass selector: aSymbol position: posInteger line: lineInteger ranges: aCollectionOfInterval extras: anArray 
	"Private - Initialize the receiver's instance variables. Answer the receiver."

	self tag: anInteger.
	source := aString.
	methodClass := aClass.
	selector := aSymbol.
	position := posInteger.
	line := lineInteger.
	ranges := aCollectionOfInterval.
	extras := anArray.
	offset := 0!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: self severityName;
		nextPutAll: ': ';
		nextPutAll: self errorMessage!

errorCode
	^self tag!

errorMessage
	"Answer a <String> describing the nature of the notification."

	^(self class errorFormats lookup: self errorCode)
		ifNil: ['Unknown Compiler <1s>: <2p>' expandMacrosWith: self severityName with: self errorCode]
		ifNotNil: 
			[:format |
			| r |
			r := self range.
			format expandMacrosWithArguments: {self source copyFrom: r start to: r stop} , extras
				locale: Locale smalltalk]!

extras
	^extras!

line
	"Answer the line in the text from where the notification originated."

	^line!

methodClass
	"Answer the Class context which the code was being compiled in."

	^methodClass!

offset
	"Anwser the offset of the start of the receiver's error range relative to the original
	method source code. This is zero in all cases except for errors arising parsing a static
	expression, i.e. ##(<static expression>)"

	^offset!

offset: anInteger 
	"Set the offset of the start of the receiver's error range relative to the original
	method source code."

	offset := anInteger!

position
	^position!

range
	"Answer the <Interval> of character positions in the original source code in respect of
	which the notification was raised."

	| range |
	range := ranges first start to: ranges last stop.
	range stop isNil ifTrue: [range stop: range start].
	"The range always specifies from the start of the source text, regardless of expression offset"
	^range!

ranges
	"Answer an <sequencedReadableCollection> of <Interval> being the ranges of character
	positions in the original source code in respect of which the notification was raised."

	^ranges!

selector
	"Answer the selector of the code which raised the notification."

	^selector!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^self class severity!

severityName
	^self severityClass name!

source
	"Answer the <readableString> of code which caused this notification to be raised while it
	was being compiled."

	^source ?? ''! !
!CompilerNotification categoriesFor: #_descriptionArguments!displaying!public! !
!CompilerNotification categoriesFor: #_descriptionFormat!displaying!public! !
!CompilerNotification categoriesFor: #code:in:for:selector:position:line:ranges:extras:!initializing!private! !
!CompilerNotification categoriesFor: #displayOn:!displaying!public! !
!CompilerNotification categoriesFor: #errorCode!accessing!public! !
!CompilerNotification categoriesFor: #errorMessage!accessing!public! !
!CompilerNotification categoriesFor: #extras!accessing!public! !
!CompilerNotification categoriesFor: #line!accessing!public! !
!CompilerNotification categoriesFor: #methodClass!accessing!public! !
!CompilerNotification categoriesFor: #offset!private! !
!CompilerNotification categoriesFor: #offset:!private! !
!CompilerNotification categoriesFor: #position!accessing!public! !
!CompilerNotification categoriesFor: #range!accessing!public! !
!CompilerNotification categoriesFor: #ranges!accessing!public! !
!CompilerNotification categoriesFor: #selector!accessing!public! !
!CompilerNotification categoriesFor: #severity!constants!public! !
!CompilerNotification categoriesFor: #severityName!displaying!public! !
!CompilerNotification categoriesFor: #source!accessing!public! !

!CompilerNotification class methodsFor!

beep
	"Sound a beep describing the severity of the notification."

	self severityClass beep!

classForCode: anInteger 
	^anInteger < CWarnFirst 
		ifTrue: [CompilerErrorNotification]
		ifFalse: 
			[(Compiler isWarningDisabled: anInteger) 
				ifTrue: [DeafObject current]
				ifFalse: 
					[anInteger < CInfoFirst ifTrue: [CompilerWarningNotification] ifFalse: [CompilerInfoNotification]]]!

code: codeInteger in: aString for: aClass selector: aSymbol position: posInteger line: lineInteger range: anInterval extras: anArray
	^self
		code: codeInteger
		in: aString
		for: aClass
		selector: aSymbol
		position: posInteger
		line: lineInteger
		ranges: {anInterval}
		extras: anArray!

code: codeInteger in: aString for: aClass selector: aSymbol position: posInteger line: lineInteger ranges: aCollectionOfInterval extras: anArray 
	^((self classForCode: codeInteger) new)
		code: codeInteger
			in: aString
			for: aClass
			selector: aSymbol
			position: posInteger
			line: lineInteger
			ranges: aCollectionOfInterval
			extras: anArray;
		yourself!

errorFormats
	^ErrorFormats ifNil: [LookupTable new]!

initialize
	"
	self initialize
	"

	| formats codesPool codes |
	formats := LookupTable new.
	formats
		at: LErrBadChar put: 'illegal character ''<2d>''';
		at: LErrCommentNotClosed put: 'comment not closed';
		at: LErrStringNotClosed put: 'literal string not closed';
		at: LErrExpectConst put: 'constant expected';
		at: LErrExpectExtendedLiteral put: 'extended literal expected';
		at: LErrExpectMetaVariable put: 'meta variable expected';
		at: LErrExpectChar put: 'character expected';
		at: LErrBadNumber put: 'illegal number';
		at: LErrExpectCodePoint put: 'hex code point expected';
		at: LErrBadCodePoint put: 'invalid code point <1s>'.

	"'Unmatched ' in string literal.'"
	formats
		at: CErrTempListNotClosed put: 'temporary list not closed';
		at: CErrInvalExprStart put: 'invalid expression start';
		at: CErrNonsenseAtMethodEnd put: 'nonsense at end of method';
		at: CErrNonsenseAtExprEnd put: 'nonsense at end of expression';
		at: CErrBraceNotClosed put: 'expecting ''}''';
		at: CErrParenNotClosed put: 'expecting '')''';
		at: CErrExpectMessage put: 'expecting message';
		at: CErrUnterminatedStatement put: 'no period at end of statement';
		at: CErrExpectVariable put: 'variable name expected';
		at: CErrBlockArgListNotClosed put: 'block argument list not closed';
		at: CErrBlockNotClosed put: 'expecting '']''';
		at: CErrExpectPrimIdx put: 'primitive index expected';
		at: CErrBadPrimIdx put: 'primitive index <1s> out of range';
		at: CErrExpectCloseTag put: 'expecting ''>''';
		at: CErrBadPrimCallType put: 'invalid primitive call type <1p>';
		at: CErrUnsupportedCallConv put: 'unsupported calling convention <1p>';
		at: CErrExpectFnName put: 'function name or ordinal expected';
		at: CErrExpectExtType put: 'external type expected';
		at: CErrArgTypeCannotBeVoid put: 'argument type can''t be void';
		at: CErrNotIndirectable put: 'too many indirections for type <2d>';
		at: CErrUndefinedClass put: 'undefined class <1p>';
		at: CErrInvalidStructArg put: 'invalid structure class type <1p>';
		at: CErrBadExtTypeQualifier put: 'invalid external type qualifier';
		at: CErrInsufficientArgTypes put: 'insufficient argument types';
		at: CErrTooManyArgTypes put: 'too many argument types';
		at: CErrBadVfn put: 'virtual function index out of range (1..1024)';
		at: CErrExpectVfn put: 'virtual function number expected';
		at: CErrBadTokenInArray put: 'illegal text <1p> in literal array';
		at: CErrBadValueInByteArray put: 'illegal value <1p> in byte array';
		at: CErrByteArrayNotClosed put: 'literal byte array not closed';
		at: CErrArrayNotClosed put: 'literal array not closed';
		at: CErrErrorInStaticExpression put: 'error evaluating static expression';
		at: CErrTooManyIfNotNilBlockArgs put: '#ifNotNil: block must have 0 or 1 arguments';
		at: CErrInternal put: 'Internal Error, see debug output. Please report to Object Arts support';
		at: CErrAssignmentToArgument put: 'illegal assignment to argument <2p>';
		at: CErrTooManyArgs put: 'too many arguments';
		at: CErrTooManyTemps put: 'too many temporaries';
		at: CErrRedefiningPseudoVar put: 'cannot redefine pseudo variable';
		at: CErrUndeclared put: 'undeclared <1p>';
		at: CErrAssignConstant put: 'illegal assignment to constant <2p>';
		at: CErrBadSelector put: 'illegal message selector <1p>';
		at: CErrBadContext put: 'invalid compilation context';
		at: CErrIncorrectBlockArgCount put: 'incorrect number of arguments for optimized block';
		at: CErrExpectLiteralBlock put: 'expecting literal block';
		at: CErrMethodTooLarge put: 'method too large';
		at: CErrTooManyLiterals put: 'too many literals';
		at: CErrBlockNestingTooDeep put: 'maximum block nesting exceeded';
		at: CErrBadPools put: 'The workspace pools array is invalid';
		at: CErrDuplicateTempName put: 'duplicate temporary variable name <1p>';
		at: CErrDuplicateArgName put: 'duplicate argument name <1p>';
		at: CErrRedefiningArg put: 'redefining argument <1p>';
		at: CErrStaticExprNotClosed put: 'static expression not closed';
		at: CErrEmptyConditionBlock put: 'condition block of <2p> cannot be empty';
		at: CErrQualifiedRefNotClosed put: 'qualified reference not closed';
		yourself.

	formats
		at: CWarnRedefiningArg put: 'redefining argument <1p>';
		at: CWarnRedefiningTemp put: 'redefining temporary variable <1p>';
		at: CWarnRedefiningInstVar put: 'redefining instance variable <1p>';
		at: CWarnRedefiningStatic put: 'redefining static variable <1p>';
		at: CWarnMsgUnimplemented put: 'message sent to <3s> is not understood by <4p>: <2p>';
		at: CWarnUndefinedSelector put: 'undefined selector <2p>';
		at: CWarnRestrictedSelector
			put: 'overridding or redefining an optimized selector may have no effect';
		at: CWarnExpectNiladicBlockArg put: 'can''t optimize <2p> (requires niladic block argument)';
		at: CWarnExpectMonadicBlockArg put: 'can''t optimize <2p> (requires monadic block argument)';
		at: CWarnExpectMonadicOrNiladicBlockArg put: '<2p> expects niladic or monadic block argument';
		at: CWarnUnreferencedTemp put: 'unreferenced temporary <1p>';
		at: CWarnExpectNiladicBlockReceiver put: 'niladic block expected as receiver of <2p>';
		at: CWarnReadBeforeWritten put: 'temporary <1p> is possibly read before written';
		at: CWarnReadNotWritten put: 'temporary <1p> is read but not written';
		at: CWarnWrittenNotRead put: 'temporary <1p> is assigned but never used';
		at: CWarnUnreachable put: 'unreachable code';
		at: CWarnUnimplementedAbstractMethod put: 'subclass <4p> does not implement <3p>';
		at: CWarnUsesBooleanClass put: 'references boolean class <1p> rather than its instance <2p>';
		at: CWarnMutableIgnored put: '%<mutable> attribute ignored in non-mutator method';
		yourself.
	formats
		at: CInfoUnreferencedArg put: 'unreferenced argument <1p>';
		at: CInfoSupersendsOther put: 'supersends other message <2p>';
		at: CInfoHardBreakpoint put: 'contains hardcoded breakpoint';
		yourself.
	codesPool := #{SmalltalkParseErrorCodes} value.
	codes := Set new.
	codesPool bindingsDo:  [:binding | self assert: [formats includesKey: binding value]. codes add: binding value].
	formats keysDo:  [:each | self assert: [codes includes: each]].
	self addClassConstant: 'ErrorFormats' value: formats!

severity
	"Answer an integer severity level; 2 for errors, 1 for warnings, and 0 for info. Useful for
	sorting compilation issues by severity."

	^self subclassResponsibility! !
!CompilerNotification class categoriesFor: #beep!parping!public! !
!CompilerNotification class categoriesFor: #classForCode:!private! !
!CompilerNotification class categoriesFor: #code:in:for:selector:position:line:range:extras:!instance creation!private! !
!CompilerNotification class categoriesFor: #code:in:for:selector:position:line:ranges:extras:!instance creation!private! !
!CompilerNotification class categoriesFor: #errorFormats!accessing!private! !
!CompilerNotification class categoriesFor: #initialize!development!initializing!public! !
!CompilerNotification class categoriesFor: #severity!constants!public! !

