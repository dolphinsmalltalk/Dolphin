"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SmalltalkSystemTest
	instanceVariableNames: 'devsys'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkSystemTest guid: (GUID fromString: '{8ce20f6c-ccc5-4249-85e0-ef3888d589d7}')!
SmalltalkSystemTest comment: ''!
!SmalltalkSystemTest categoriesForClass!Unclassified! !
!SmalltalkSystemTest methodsFor!

setUp
	devsys := Smalltalk developmentSystem!

testBuildSimpleSignature
	self assert: (devsys buildSimpleSignatureFor: #=) equals: '= arg1'.
	self assert: (devsys buildSimpleSignatureFor: #x) equals: 'x'.
	self assert: (devsys buildSimpleSignatureFor: #x:) equals: 'x: arg1'.
	self assert: (devsys buildSimpleSignatureFor: #x:y:) equals: 'x: arg1 y: arg2'!

testDefaultInspectorClass
	"#1399"

	| class |
	self assert: devsys defaultInspectorClass identicalTo: FlipperInspector.
	devsys defaultInspectorClass: nil.
	class := 1 inspectorClass.
	self assert: class identicalTo: FlipperInspector.
	
	[| inspector |
	devsys defaultInspectorClass: BasicInspector.
	self assert: 1 inspectorClass identicalTo: BasicInspector.
	inspector := 1 inspect.
	self assert: inspector isKindOf: BasicInspector.
	inspector topShell exit]
			ensure: [devsys defaultInspectorClass: nil]!

testNameForArgument
	self assert: (devsys nameForArgument: 1 -> 2) equals: 'anAssociation'.
	self assert: (devsys nameForArgument: 1) equals: 'anInteger'.
	self assert: (devsys nameForArgument: SmallInteger maximum + 1) equals: 'anInteger'.
	self assert: (devsys nameForArgument: true) equals: 'aBoolean'.
	self assert: (devsys nameForArgument: false) equals: 'aBoolean'.
	self assert: (devsys nameForArgument: nil) equals: 'anUndefinedObject'.
	self assert: (devsys nameForArgument: Object) equals: 'aClass'.
	self assert: (devsys nameForArgument: Class) equals: 'aClass'.
	self assert: (devsys nameForArgument: Behavior) equals: 'aClass'.
	self assert: (devsys nameForArgument: Object class) equals: 'aMetaclass'.
	self assert: (devsys nameForArgument: #(1 2 3)) equals: 'anArrayOfInteger'.
	self assert: (devsys nameForArgument: #(##(1 -> 2) ##(3 -> 4))) equals: 'anArrayOfAssociation'.
	self assert: (devsys nameForArgument: #(16r80000000 1)) equals: 'anArrayOfInteger'.
	self assert: (devsys nameForArgument: #(1 16r80000000 2.0)) equals: 'anArrayOfNumber'.
	self assert: (devsys nameForArgument: #('abc' #abc)) equals: 'anArrayOfString'.
	self assert: (devsys nameForArgument: #(#abc 'abc')) equals: 'anArrayOfString'.
	self assert: (devsys nameForArgument: #('abc' #abc 123)) equals: 'anArray'.
	self assert: (devsys nameForArgument: #(true false)) equals: 'anArrayOfBoolean'.
	self assert: (devsys nameForArgument: #(nil)) equals: 'anArray'.
	self assert: (devsys nameForArgument: []) equals: 'aNiladicValuable'.
	self assert: (devsys nameForArgument: [:a | ]) equals: 'aMonadicValuable'.
	self assert: (devsys nameForArgument: [:a :b | ]) equals: 'aDyadicValuable'.
	self assert: (devsys nameForArgument: [:a :b :c | ]) equals: 'aValuable'.
	self assert: (devsys nameForArgument: 'abc') equals: 'anAnsiString'.
	self assert: (devsys nameForArgument: #[1 2 3]) equals: 'aByteArray'.
	self assert: (devsys nameForArgument: Object yourAddress asExternalAddress)
		equals: 'anExternalAddress'!

testWrapText
	| formatter wrapped |
	(devsys respondsTo: #wrapText:toWidth:indent:tabWidth:) ifFalse: [^self].
	formatter := devsys formatterClass.
	wrapped := devsys
				wrapText: 'abc d'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'abc d'.
	wrapped := devsys
				wrapText: 'abc de'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'abc
de'.
	wrapped := devsys
				wrapText: 'abcde f'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'abcde
f'.
	wrapped := devsys
				wrapText: 'abcdef g'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'abcdef
g'.
	wrapped := devsys
				wrapText: 'a bcdefg h'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'a
bcdefg
h'.
	wrapped := devsys
				wrapText: 'abcde fghijk lmnop'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'abcde
fghijk
lmnop'.
	wrapped := devsys
				wrapText: 'abcde6 fghijk6 x  lmnop6
		y'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'abcde6
fghijk6
x
lmnop6
y'.
	wrapped := devsys
				wrapText: 'abc


fg hi 

lmnop6

wxy'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped equals: 'abc


fg hi

lmnop6

wxy'.
	wrapped := devsys
				wrapText: 'abc def g'
				toWidth: 6
				indent: 2
				tabWidth: 8.
	self assert: wrapped equals: 'abc
 def g'.
	wrapped := devsys
				wrapText: 'abc def gh'
				toWidth: 8 + 5
				indent: 9
				tabWidth: 8.
	self assert: wrapped equals: 'abc
	def
	gh'.
	wrapped := devsys
				wrapText: 'abc defghi jkl mn op q'
				toWidth: 8 + 5
				indent: 9
				tabWidth: 8.
	self assert: wrapped equals: 'abc
	defghi
	jkl
	mn op
	q'! !
!SmalltalkSystemTest categoriesFor: #setUp!public!Running! !
!SmalltalkSystemTest categoriesFor: #testBuildSimpleSignature!public!unit tests! !
!SmalltalkSystemTest categoriesFor: #testDefaultInspectorClass!public!unit tests! !
!SmalltalkSystemTest categoriesFor: #testNameForArgument!public!unit tests! !
!SmalltalkSystemTest categoriesFor: #testWrapText!public!unit tests! !

