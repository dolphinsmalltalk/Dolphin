"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ARGBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ARGBTest guid: (GUID fromString: '{b9d1b1c9-fb62-46e9-a7d5-6807f64e5314}')!
ARGBTest comment: ''!
!ARGBTest categoriesForClass!Unclassified! !
!ARGBTest methodsFor!

assertComponents: anArray isCode: anInteger
	"Private - Test the multiple constructors"

	self
		assert: (Color
				alpha: anArray first
				red: anArray second
				green: anArray third
				blue: anArray fourth) argbCode
		equals: anInteger.
	self assert: (Color fromArray: anArray) argbCode equals: anInteger.
	self
		assert: (Color
				a: anArray first
				r: anArray second
				g: anArray third
				b: anArray fourth) argbCode
		equals: anInteger!

testConstructionValues
	"#(
	#(#(0 0 0 0) 16r000000) 
	#(#(16rFF 0 0 0) 16rFF000000)
	#(#(16rFF 16rFF 0 0) 16rFFFF0000)
	#(#(16rFF 16rFF 16rFF 0) 16rFFFFFF00)
	#(#(16rFF 16rFF 16rFF 16rFF) 16rFFFFFFFF)
	)"

	#(#(#(0 0 0 0) 0) #(#(255 0 0 0) 4278190080) #(#(255 255 0 0) 4294901760) #(#(255 255 255 0) 4294967040) #(#(255 255 255 255) 4294967295))
		do: 
			[:each |
			| values subject |
			values := each first.
			self assertComponents: values isCode: each second.
			subject := ARGB fromArgbCode: each second.
			self assert: subject red equals: values second.
			self assert: subject green equals: values third.
			self assert: subject blue equals: values fourth]!

testEquality
	| model |
	model := ARGB r: 255 g: 0 b: 0.
	self assert: model equals: (ARGB r: 255 g: 0 b: 0).
	self deny: model equals: (ARGB a: 1 r: 255 g: 0 b: 0).
	model hash!

testFromArgbCode
	| argb1 argb2 originalMethod testMethod |
	argb1 := ARGB fromArgbCode: 16rDEADBEEF.
	self assert: argb1
		equals: (ARGB
				a: 16rDE
				r: 16rAD
				g: 16rBE
				b: 16rEF).
	originalMethod := ARGB class compiledMethodAt: #fromArgbCode:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	argb2 := testMethod value: ARGB withArguments: #(16rDEADBEEF).
	self assert: argb2 equals: argb1!

testPrintString
	| model |
	model := ARGB
				a: 1
				r: 2
				g: 3
				b: 4.
	self assert: model printString equals: '(Color a: 1 r: 2 g: 3 b: 4)'.
	model := ARGB
				a: 255
				r: 1
				g: 2
				b: 3.
	self assert: model printString equals: '(Color r: 1 g: 2 b: 3)'.
	model := ARGB
				a: 255
				r: 218
				g: 165
				b: 32.
	self assert: model printString equals: 'Color goldenrod'.
	model := ARGB red.
	self assert: model printString equals: 'Color red'!

testStbRoundTrip
	| subject bytes rehydrated |
	subject := Color antiqueWhite alpha: 99.
	bytes := subject binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated class identicalTo: ARGB.
	self assert: rehydrated equals: subject! !
!ARGBTest categoriesForMethods!
assertComponents:isCode:!asserting!private! !
testConstructionValues!public!unit tests! !
testEquality!public!unit tests! !
testFromArgbCode!public!unit tests! !
testPrintString!public!unit tests! !
testStbRoundTrip!public!unit tests! !
!

