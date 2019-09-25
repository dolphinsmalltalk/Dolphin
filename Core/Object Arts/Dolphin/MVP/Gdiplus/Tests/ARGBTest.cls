"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #ARGBTest
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
	model := ARGB r: 255 g: 0 b: 0.
	self assert: model equals: (ARGB r: 255 g: 0 b: 0).
	self deny: model equals: (ARGB a: 1 r: 255 g: 0 b: 0).
	model hash!

testPrintString
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
	self assert: model printString equals: 'Color red'! !
!ARGBTest categoriesFor: #assertComponents:isCode:!asserting!public! !
!ARGBTest categoriesFor: #testConstructionValues!public!unit tests! !
!ARGBTest categoriesFor: #testEquality!public!unit tests! !
!ARGBTest categoriesFor: #testPrintString!public!unit tests! !

