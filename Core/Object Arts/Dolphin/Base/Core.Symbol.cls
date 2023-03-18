"Filed out from Dolphin Smalltalk"!

Core.Utf8String
	variableByteSubclass: #'Core.Symbol'
	instanceVariableNames: ''
	classVariableNames: 'Table'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'CharClassifications'
				-> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #binary nil nil nil #binary #binary nil nil nil #binary #binary #binary #binary nil #binary #digit #digit #digit #digit #digit #digit #digit #digit #digit #digit #colon nil #binary #binary #binary #binary #binary #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic nil #binary nil nil #alphabetic nil #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic nil #binary nil #binary nil)
		}!
Core.Symbol guid: (Core.GUID fromString: '{87b4c51d-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Symbol isNullTerminated: true!
Core.Symbol comment: '`Symbol` is a class of interned `String`s that are guaranteed to be unique throughout the system.

`Symbol`s can contain any Unicode code points as they have the same representation as `Utf8String`s.

Symbol complies with the following ANSI protocols:
  <Object>
  <magnitude>
  <collection>
  <sequencedReadableCollection>
  <readableString>
  <symbol>'!
!Core.Symbol categoriesForClass!Collections-Text! !
!Core.Symbol methodsFor!

argumentCount
	"Answer the <integer> number of arguments required by a method with the receiver as its selector. The result is undefined if the receiver is not a valid selector."

	| len ch |
	len := self basicSize.
	len == 0 ifTrue: [^0].
	ch := self at: 1.
	^(ch isEnglishLetter or: [ch == $_])
		ifTrue: 
			[(self at: len) == $:
				ifTrue: [(self
						occurrencesOf: $:
						from: 1
						to: len - 1) + 1]
				ifFalse: [0]]
		ifFalse: [1]!

asString
	"Answer a new <String> containing the characters of the receiver."

	| len string |
	len := self size.
	string := Utf8String new: len.
	self
		replaceBytesOf: string
		from: 1
		to: len
		startingAt: 1.
	^string!

asSymbol
	"Answer the <symbol> containing the characters of the receiver
	(i.e. the receiver, since <symbol>s are unique)."

	^self!

copyEmpty: anInteger
	^self copyingClass new: anInteger!

copyFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of
	the receiver between the <integer> indices startInteger and stopInteger, inclusive, and in
	the same order."

	| len slice |
	slice := Utf8String new: (len := stopInteger - startInteger + 1).
	self
		replaceBytesOf: slice
		from: 1
		to: len
		startingAt: startInteger.
	^slice!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	"Symbols are immutable identity values; we can't have a direct copy of a symbol, and neither do we necessarily want to intern slices of a symbol."

	^Utf8String!

deepCopy
	"Answer the receiver - Symbols are unique, so a copy with the same characters
	must not exist.
	N.B. This implementation may cause problems in generic code which attempts to
	modify copies of Strings!!"
	
	^self!

displayString
	"Answer a String representation of the receiver in a form suitable for
	presentation to an end user.
	Implementation Note: Because our superclass implements #displayString to
	return self (for better performance), we must override back to a suitable
	implementation for Symbols which does not include the hash prefix."

	^self asString!

forwardTo: anObject
	"Send the <Object> argument the receiver as a niladic message,
	answering the result. Assumes the receiver is a unary selector."

	^anObject perform: self!

isAtomic
	"Answer whether or not the receiver is the single unique instance of its class that can
	represents its value."

	"The purpose of symbols is to be atomic strings."

	^true!

isInfix
	"Answer whether the receiver is valid as an infix message selector."

	^self ~~ #'' and: [self allSatisfy: [:each | '!!%&*+,-/<=>?@\|~' identityIncludes: each]]!

isSymbol
	"Dolphin doesn't usually include these type tests, but they are used by a number of add-on
	libraries, so we have begrudgingly accepted them into the base."

	^true!

keywords
	"Answer a <sequencedReadableCollection> of the receiver's keywords."

	| size keywords start end |
	size := self size.
	size == 0 ifTrue: [^#()].
	(self at: size) ~~ $:
		ifTrue: 
			["All well-formed multi-keyword selectors must end with a colon"
			^{self}].
	keywords := WriteStream on: (Array new: 3).
	end := self
				nextIndexOf: $:
				from: 1
				to: size.
	start := 1.
	
	[keywords nextPut: (self copyFrom: start to: end).
	start := end + 1.
	end := self
				nextIndexOf: $:
				from: start
				to: size.
	end == 0]
			whileFalse.
	^keywords contents!

mutableCopy
	"Answer a <sequencedReadableCollection> like the receiver, but which is a mutable copy with the same elements."

	^self asString!

numArgs
	^self argumentCount!

printArgumentTypeOn: aStream
	"Private - Append a compilable argument type name, which is the receiver, to aStream."

	self displayOn: aStream!

printOn: aStream
	"Append a textual description of the receiver to aStream. If the receiver includes
	embedded spaces, then quote it. This may need to be extended to include other
	whitespace/non-printing characters."

	aStream nextPut: $#.
	(self class isLiteralSymbol: self)
		ifTrue: [aStream nextPutAll: self]
		ifFalse: [super printOn: aStream]!

refersTo: anObject asLiteralOf: aCompiledMethod
	"Private - Answer whether the receiver is a reference to the literal argument.
	This assumes that the receiver is in the role of a literal."

	^self == anObject!

replaceFrom: start to: stop with: replacementCollection startingAt: repStart
	"Symbols are not mutable."

	^self shouldNotImplement
!

shallowCopy
	"Answer the receiver - Symbols are unique, so we must not create a copy
	with the same characters."

	^self!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm"
	
	self shouldNotImplement!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types. Symbols are equal to Strings in Dolphin, but we don't want them to be considered interchangeable as Symbols have a distinctly different purpose."

	^self class!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler
		writePreambleFor: self;
		writeInteger: self size.
	anSTBOutFiler stream nextPutAll: self asByteArray! !
!Core.Symbol categoriesForMethods!
argumentCount!accessing!public! !
asString!converting!public! !
asSymbol!converting!public! !
copyEmpty:!private! !
copyFrom:to:!copying!public! !
copyingClass!copying!private! !
deepCopy!copying!public! !
displayString!printing!public! !
forwardTo:!operations!public! !
isAtomic!public!testing! !
isInfix!public!testing! !
isSymbol!public!RefactoringBrowser! !
keywords!accessing!public! !
mutableCopy!copying!public! !
numArgs!accessing!public! !
printArgumentTypeOn:!printing!private! !
printOn:!printing!public! !
refersTo:asLiteralOf:!private!testing! !
replaceFrom:to:with:startingAt:!public!replacing! !
shallowCopy!copying!public! !
sortUsing:!public!sorting! !
species!accessing!public! !
stbSaveOn:!binary filing!public! !
!

Core.Symbol methodProtocol: #commandMessage attributes: #(#readOnly) selectors: #(#asSymbol #forwardTo:)!
Core.Symbol methodProtocol: #selector attributes: #(#ansi #readOnly) selectors: #()!
Core.Symbol methodProtocol: #symbol attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #asLowercase #asString #asSymbol #asUppercase #at: #at:ifAbsent: #before: #between:and: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #do: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #keysAndValuesDo: #last #max: #min: #reverse #reverseDo: #sameAs: #subStrings: #with:do:)!

!Core.Symbol class methodsFor!

addUnique: aSymbol
	"Private - Add the argument aSymbol as a new entry in the Symbol Table. This private method should only be 
	used for adding Symbols not already present in the symbol table. Please use Symbol>>intern: to obtain
	a Symbol from a String (or alternatively String>>asSymbol)."

	| bucketIndex |
	aSymbol isImmutable: true.
	bucketIndex := aSymbol hash \\ Table basicSize + 1.
	(Table basicAt: bucketIndex)
		ifNil: [Table basicAt: bucketIndex put: (WeakArray with: aSymbol)]
		ifNotNil: [:bucket | bucket replaceIdentity: DeadObject.Current with: aSymbol].
	^aSymbol!

allInstancesDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument for each and every interned Symbol."

	Table do: [:eachBucket | eachBucket notNil ifTrue: [eachBucket nonCorpsesDo: aMonadicValuable]]!

coerceString: aString
	"Answer a unique instance of the receiver whose contents are copied from aString."

	^self intern: aString!

findInterned: aString
	"Answer the unique <Symbol> for aString if already defined, else nil.	
	N.B. This method previously had the selector #symbolAt:, and was private,
	but has been renamed and made public for compatibility with VisualWorks."

	(Table at: aString hash \\ Table basicSize + 1)
		ifNotNil: 
			[:bucket |
			"Inline ArrayedCollection>>do: to avoid full block for best performance"
			1 to: bucket size
				do: 
					[:i |
					| each |
					each := bucket at: i.
					each = aString ifTrue: [^each]]].
	^nil!

fromAddress: anInteger
	^(String fromAddress: anInteger) ifNotNil: [:string | self intern: string]!

fromAddress: anInteger length: anInteger2
	^(String fromAddress: anInteger length: anInteger2)
		ifNotNil: [:string | self intern: string]!

initialize
	"Initialize class variables of the receiver.
	
	Table	-	An Array which is used as a hash table containing WeakArray buckets, in which the currently used
				instances of the receiver are kept."

	| classificationTable |
	self extraInstanceSpec: EncodingUtf8.
	Table isNil ifTrue: [Table := Array new: 3989].
	empty := #''.
	VM registryAt: #Symbol put: self.
	classificationTable := Array new: 128.
	'_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
		do: [:alpha | classificationTable at: alpha codePoint + 1 put: #alphabetic].
	'01234567890' do: [:digit | classificationTable at: digit codePoint + 1 put: #digit].
	'!!%&*+,-/<=>?@\~|' do: [:binary | classificationTable at: binary codePoint + 1 put: #binary].
	classificationTable at: $: codePoint + 1 put: #colon.
	self addClassConstant: 'CharClassifications' value: classificationTable!

intern: aString
	"Answer the unique Symbol for aString."

	^(self findInterned: aString) ifNil: [self addUnique: (aString asUtf8StringCopy becomeA: Symbol)]!

intern: aString cookie: cookie
	"Private - Callback from VM, returns the unique Symbol for aString.
	WARNING: Do not send this message from Smalltalk code. Do not modify or 
	remove this method."

	Processor callback: cookie evaluate: [self intern: aString]!

internCharacter: aCharacter
	"Answer the Character argument, aCharacter, as a single character unique symbol"

	^self intern: aCharacter asUtf8String!

isLiteralSymbol: aSymbol
	"Private - Answer whether the <Symbol> argument is representable as an unquoted literal
	symbol."

	| size class |
	size := aSymbol basicSize.
	size == 0 ifTrue: [^false].
	class := CharClassifications lookup: (aSymbol basicAt: 1) + 1.
	class == #binary
		ifTrue: 
			[2 to: size
				do: [:i | (CharClassifications lookup: (aSymbol basicAt: i) + 1) == #binary ifFalse: [^false]]]
		ifFalse: 
			[| includesColon initial |
			class == #alphabetic ifFalse: [^false].
			initial := false.
			includesColon := false.
			2 to: size
				do: 
					[:i |
					class := CharClassifications lookup: (aSymbol basicAt: i) + 1.
					initial
						ifTrue: 
							[class == #alphabetic ifFalse: [^false].
							initial := false]
						ifFalse: 
							[class == #colon
								ifTrue: [includesColon := initial := true]
								ifFalse: [(class == #alphabetic or: [class == #digit]) ifFalse: [^false]]]].
			(includesColon and: [class ~~ #colon]) ifTrue: [^false]].
	^true!

new: anInteger
	"Instances of the receiver can only be created by using the #intern: and #internCharacter:
	messages."

	^self shouldNotImplement!

readFrom: aStream
	^self intern: (Utf8String readFrom: aStream)!

resizeTable
	"Private - Remove unused Symbols from the system - must be done to the exclusion of other processes, e.g:
		[Symbol resizeTable] forkAt: Processor timingPriority.
	By default we select a symbol table bucket size of about 6. This is appropriate for a development image, which
	interns a lot of symbols, but a runtime image could easily accommodate larger buckets to reduce the symbol table
	size. Answers the new size of the table."

	^self resizeTable: 6
!

resizeTable: anInteger
	"Private - Change the size of the Symbol Table so that all of the existing symbols are in buckets
	the average length of which is approximately equal to the <integer> argument.
	N.B. The argument is not the size of the resulting symbol table, which is answered."

	| newSize insts |
	Table := nil.
	insts := self allInstances.
	newSize := (Integer primesUpTo: insts size // anInteger) last.
	Table := Array new: newSize.
	insts do: [:symbol | self addUnique: symbol].
	^newSize!

stats
	"Private - Answer a String containing some statistics about the Symbol table
		self stats
	"

	| empty full count maxLen aStream corpses |
	empty := 0.
	full := 0.
	count := 0.
	maxLen := 0.
	corpses := 0.
	1 to: Table basicSize
		do: 
			[:i |
			| l |
			(l := Table basicAt: i) isNil
				ifTrue: [empty := empty + 1]
				ifFalse: 
					[| len |
					full := full + 1.
					len := 0.
					l do: [:s | s == DeadObject current ifTrue: [corpses := corpses + 1] ifFalse: [len := len + 1]].
					count := count + len.
					maxLen := maxLen max: len]].
	aStream := String smalltalkWriteStream: 80.
	^aStream
		nextPutAll: 'Empty buckets:	';
		print: empty;
		cr;
		nextPutAll: 'Full buckets:	';
		print: full;
		cr;
		nextPutAll: 'Empty slots:	';
		print: corpses;
		cr;
		nextPutAll: 'Symbols:		';
		print: count;
		cr;
		nextPutAll: 'Max Bkt Len:	';
		print: maxLen;
		cr;
		nextPutAll: 'Avg Bkt Len:	';
		print: count / full asFloat;
		contents!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| stream answer stringClass |
	stringClass := anSTBInFiler version < 4
				ifTrue: 
					[anSTBInFiler version < 2 ifTrue: [^self stbReadFromProxy: anSTBInFiler].
					"Symbols would definitely have been ANSI encoded. Unfortunately there was no STB version change specifically for the switch to unicode, and because Symbol's are a built-in class they do not benefit from the normal STB versioning mechanism, so there is nothing we can do now to correct any misencodings read from Symbols in STB files created in versions of 7.0 post 7.0.30 up to the first 7.1 versions with Unicode."
					AnsiString]
				ifFalse: [Utf8String].
	stream := anSTBInFiler stream.
	answer := self intern: (stringClass fromByteArray: (stream next: anInteger)).
	anSTBInFiler register: answer.
	^answer!

stbReadFromProxy: anSTBInFiler
	"Read and answer a <Symbol> from the binary in-filer argument, which is attached to an old
	format STB stream which used a proxy to store symbols."

	| answer ref |
	ref := anSTBInFiler register: nil.
	"Then read the string and intern it"
	answer := anSTBInFiler basicNext asSymbol.
	anSTBInFiler fixup: ref to: answer.
	^answer!

with: aCharacter
	^self internCharacter: aCharacter!

withAll: anArrayOfCharacter
	^self intern: (String withAll: anArrayOfCharacter)! !
!Core.Symbol class categoriesForMethods!
addUnique:!accessing!private! !
allInstancesDo:!enumerating!public! !
coerceString:!instance creation!public! !
findInterned:!accessing!public! !
fromAddress:!instance creation!public! !
fromAddress:length:!instance creation!public! !
initialize!development!initializing!public! !
intern:!instance creation!public! !
intern:cookie:!not restartable!private!vm entry points! !
internCharacter:!instance creation!public! !
isLiteralSymbol:!parsing!private! !
new:!instance creation!public! !
readFrom:!instance creation!public! !
resizeTable!initializing!private! !
resizeTable:!initializing!private! !
stats!development!private! !
stbReadFrom:format:size:!binary filing!public! !
stbReadFromProxy:!binary filing!private! !
with:!instance creation!public! !
withAll:!instance creation!public! !
!

