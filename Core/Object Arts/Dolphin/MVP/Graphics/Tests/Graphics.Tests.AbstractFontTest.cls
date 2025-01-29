"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.AbstractFontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'LogFontIndex' -> 16r3 }!

Graphics.Tests.AbstractFontTest guid: (Core.GUID fromString: '{8a4906fc-95c2-4d0c-af13-60c309d9ada0}')!

Graphics.Tests.AbstractFontTest isNonInstantiable: true!

Graphics.Tests.AbstractFontTest comment: ''!

!Graphics.Tests.AbstractFontTest methodsFor!

canonicalSubject
	^self subclassResponsibility!

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

testTextMetrics
	| tm subject |
	subject := self canonicalSubject.
	tm := subject textMetrics.
	"This is a bit of a kick-the-tyres test. We are just checking we get back some valid looking metrics really, since the values may obviously vary according to the test font."
	self assert: tm tmBreakChar isSeparator.
	self assert: tm tmDigitizedAspectX equals: tm tmDigitizedAspectY.
	self assert: tm tmHeight equals: tm tmAscent + tm tmDescent!

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

!Graphics.Tests.AbstractFontTest categoriesForMethods!
canonicalSubject!helpers!private! !
stbRoundTripBlock!constants!private! !
stlRoundTripBlock!constants!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testStlRoundTrip!public!unit tests! !
testTextMetrics!public!unit tests! !
verifyStxRoundTrip:!helpers!private! !
!

!Graphics.Tests.AbstractFontTest class methodsFor!

initialize
	self addClassConstant: 'LogFontIndex' value: (Font indexOfInstVar: 'logfont')! !

!Graphics.Tests.AbstractFontTest class categoriesForMethods!
initialize!class initialization!public! !
!

