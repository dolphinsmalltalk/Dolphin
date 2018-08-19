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
	"Test the multiple constructors"

	self
		assert: (ARGB
				alpha: anArray first
				red: anArray second
				green: anArray third
				blue: anArray fourth) asParameter
		equals: anInteger.
	self assert: (ARGB fromArray: anArray) asParameter equals: anInteger.
	self
		assert: (ARGB
				a: anArray first
				r: anArray second
				g: anArray third
				b: anArray fourth) asParameter
		equals: anInteger!

testConstructionCommon
	model := ARGB named: #red.
	self assert: model asParameter equals: 16rFFFF0000!

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
			| values |
			values := each first.
			self assertComponents: values isCode: each second.
			self assert: (ARGB fromInteger: each second) red equals: values second.
			self assert: (ARGB fromInteger: each second) green equals: values third.
			self assert: (ARGB fromInteger: each second) blue equals: values fourth]!

testEquality
	model := ARGB named: #red.
	self assert: model equals: (ARGB named: #red).
	self deny: model equals: (ARGB named: #blue).
	model hash!

testPrintString
	model := ARGB fromArray: #(1 2 3 4).
	self assert: model printString equals: '(ARGB a: 1 r: 2 g: 3 b: 4)'! !
!ARGBTest categoriesFor: #assertComponents:isCode:!asserting!public! !
!ARGBTest categoriesFor: #testConstructionCommon!public!unit tests! !
!ARGBTest categoriesFor: #testConstructionValues!public!unit tests! !
!ARGBTest categoriesFor: #testEquality!public!unit tests! !
!ARGBTest categoriesFor: #testPrintString!public!unit tests! !

