"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #AbstractFontTest
	instanceVariableNames: ''
	classVariableNames: 'LogFontIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractFontTest guid: (GUID fromString: '{52dfbdb3-a15d-476a-83d0-c8fb03685b56}')!

AbstractFontTest isAbstract: true!

AbstractFontTest addClassConstant: 'LogFontIndex' value: 16r3!

AbstractFontTest comment: ''!

!AbstractFontTest categoriesForClass!Unclassified! !

!AbstractFontTest methodsFor!

canonicalSubject
	self subclassResponsibility!

stbRoundTripBlock
	^[:object | Object fromBinaryStoreBytes: object binaryStoreBytes]!

stlRoundTripBlock
	^[:object | Object fromLiteralStoreArray: object literalStoreArray]!

testAtDpi
	self subclassResponsibility!

testComparing
	self subclassResponsibility!

testStbRoundTrip
	self verifyStxRoundTrip: self stbRoundTripBlock!

testStlRoundTrip
	self verifyStxRoundTrip: self stlRoundTripBlock!

verifyStxRoundTrip: aMonadicValuable
	| array deserialized subject150 subject original |
	subject := self canonicalSubject.
	subject150 := subject atDpi: subject dpi * 3 / 2.
	self assert: subject150 series identicalTo: subject series.
	original := { subject150. subject. subject. subject150 }.
	array := aMonadicValuable value: original.
	self assert: array asIdentitySet size equals: 1.
	deserialized := array first.
	self deny: deserialized identicalTo: subject.
	self assert: deserialized equals: subject.
	self deny: deserialized series identicalTo: subject series.
	self assert: deserialized dpi equals: subject dpi! !

!AbstractFontTest categoriesForMethods!
canonicalSubject!helpers!private! !
stbRoundTripBlock!constants!private! !
stlRoundTripBlock!constants!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testStlRoundTrip!public!unit tests! !
verifyStxRoundTrip:!helpers!private! !
!

!AbstractFontTest class methodsFor!

initialize
	self addClassConstant: 'LogFontIndex' value: (Font indexOfInstVar: 'logfont')! !

!AbstractFontTest class categoriesForMethods!
initialize!class initialization!public! !
!

