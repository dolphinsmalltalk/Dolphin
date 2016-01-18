"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SmalltalkSystemTest
	instanceVariableNames: 'devsys'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkSystemTest guid: (GUID fromString: '{8CE20F6C-CCC5-4249-85E0-EF3888D589D7}')!
SmalltalkSystemTest comment: ''!
!SmalltalkSystemTest categoriesForClass!Unclassified! !
!SmalltalkSystemTest methodsFor!

setUp
	devsys := Smalltalk developmentSystem!

testBuildSimpleSignature
	self assert: (devsys buildSimpleSignatureFor: #=) = '= arg1'.
	self assert: (devsys buildSimpleSignatureFor: #x) = 'x'.
	self assert: (devsys buildSimpleSignatureFor: #x:) = 'x: arg1'.
	self assert: (devsys buildSimpleSignatureFor: #x:y:) = 'x: arg1 y: arg2'.
!

testDefaultInspectorClass
	"#1399"

	| class |
	self assert: devsys defaultInspectorClass == FlipperInspector.
	devsys defaultInspectorClass: nil.
	class := 1 inspectorClass.
	self assert: class == FlipperInspector.
	
	[| inspector |
	devsys defaultInspectorClass: BasicInspector.
	self assert: 1 inspectorClass == BasicInspector.
	inspector := 1 inspect.
	self assert: (inspector isKindOf: BasicInspector).
	inspector topShell exit] 
			ensure: [devsys defaultInspectorClass: nil]!

testNameForArgument
	self assert: (devsys nameForArgument: 1 -> 2) = 'anAssociation'.
	self assert: (devsys nameForArgument: 1) = 'anInteger'.
	self assert: (devsys nameForArgument: SmallInteger maximum + 1) = 'anInteger'.
	self assert: (devsys nameForArgument: true) = 'aBoolean'.
	self assert: (devsys nameForArgument: false) = 'aBoolean'.
	self assert: (devsys nameForArgument: nil) = 'anUndefinedObject'.
	self assert: (devsys nameForArgument: Object) = 'aClass'.
	self assert: (devsys nameForArgument: Class) = 'aClass'.
	self assert: (devsys nameForArgument: Behavior) = 'aClass'.
	self assert: (devsys nameForArgument: Object class) = 'aMetaclass'.
	self assert: (devsys nameForArgument: #(1 2 3)) = 'anArrayOfInteger'.
	self assert: (devsys nameForArgument: #(##(1 -> 2) ##(3 -> 4))) = 'anArrayOfAssociation'.
	self assert: (devsys nameForArgument: #(16r80000000 1)) = 'anArrayOfInteger'.
	self assert: (devsys nameForArgument: #(1 16r80000000 2.0)) = 'anArrayOfNumber'.
	self assert: (devsys nameForArgument: #('abc' #abc)) = 'anArrayOfString'.
	self assert: (devsys nameForArgument: #(#abc 'abc')) = 'anArrayOfString'.
	self assert: (devsys nameForArgument: #('abc' #abc 123)) = 'anArray'.
	self assert: (devsys nameForArgument: #(true false)) = 'anArrayOfBoolean'.
	self assert: (devsys nameForArgument: #(nil)) = 'anArray'.
	self assert: (devsys nameForArgument: []) = 'aNiladicValuable'.
	self assert: (devsys nameForArgument: [:a |]) = 'aMonadicValuable'.
	self assert: (devsys nameForArgument: [:a :b |]) = 'aDyadicValuable'.
	self assert: (devsys nameForArgument: [:a :b :c |]) = 'aValuable'.
	self assert: (devsys nameForArgument: 'abc') = 'aString'.
	self assert: (devsys nameForArgument: #[1 2 3]) = 'aByteArray'.	
	self assert: (devsys nameForArgument: Object yourAddress asExternalAddress) = 'anExternalAddress'.	



!

testWrapText
	| formatter wrapped |
	(devsys respondsTo: #wrapText:toWidth:indent:tabWidth:) ifFalse: [^self].
	formatter := devsys formatterClass.
	wrapped := devsys 
				wrapText: 'abc d'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped = 'abc d'.
	wrapped := devsys 
				wrapText: 'abc de'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped = 'abc
de'.
	wrapped := devsys 
				wrapText: 'abcde f'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped = 'abcde
f'.
	wrapped := devsys 
				wrapText: 'abcdef g'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped = 'abcdef
g'.
	wrapped := devsys 
				wrapText: 'a bcdefg h'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped = 'a
bcdefg
h'.
	wrapped := devsys 
				wrapText: 'abcde fghijk lmnop'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped = 'abcde
fghijk
lmnop'.
	wrapped := devsys 
				wrapText: 'abcde6 fghijk6 x  lmnop6
		y'
				toWidth: 5
				indent: 1
				tabWidth: 8.
	self assert: wrapped = 'abcde6
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
	self assert: wrapped = 'abc


fg hi

lmnop6

wxy'.
	wrapped := devsys 
				wrapText: 'abc def g'
				toWidth: 6
				indent: 2
				tabWidth: 8.
	self assert: wrapped = 'abc
 def g'.
	wrapped := devsys 
				wrapText: 'abc def gh'
				toWidth: 8 + 5
				indent: 9
				tabWidth: 8.
	self assert: wrapped = 'abc
	def
	gh'.
	wrapped := devsys 
				wrapText: 'abc defghi jkl mn op q'
				toWidth: 8 + 5
				indent: 9
				tabWidth: 8.
	self assert: wrapped = 'abc
	defghi
	jkl
	mn op
	q'! !
!SmalltalkSystemTest categoriesFor: #setUp!public!Running! !
!SmalltalkSystemTest categoriesFor: #testBuildSimpleSignature!public!unit tests! !
!SmalltalkSystemTest categoriesFor: #testDefaultInspectorClass!public!unit tests! !
!SmalltalkSystemTest categoriesFor: #testNameForArgument!public!unit tests! !
!SmalltalkSystemTest categoriesFor: #testWrapText!public!unit tests! !

