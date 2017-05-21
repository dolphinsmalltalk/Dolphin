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
				= anInteger.
	self assert: (ARGB fromArray: anArray) asParameter = anInteger.
	self 
		assert: (ARGB 
				a: anArray first
				r: anArray second
				g: anArray third
				b: anArray fourth) asParameter 
				= anInteger!

testConstructionCommon
	model := ARGB stdColor: #red.
	self assert: model asParameter = 4294901760	"16rFFFF0000"!

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
			self assert: (ARGB fromInteger: each second) red = values second.
			self assert: (ARGB fromInteger: each second) green = values third.
			self assert: (ARGB fromInteger: each second) blue = values fourth]!

testEquality
	model := ARGB stdColor: #red.
	self assert: model = (ARGB stdColor: #red).
	self deny: model = (ARGB stdColor: #blue).
	model hash!

testPrintString
	model := ARGB fromArray: #(1 2 3 4).
	self assert: model printString = '(ARGB alpha: 1 red: 2 green: 3 blue: 4)'! !
!ARGBTest categoriesFor: #assertComponents:isCode:!asserting!public! !
!ARGBTest categoriesFor: #testConstructionCommon!public!unit tests! !
!ARGBTest categoriesFor: #testConstructionValues!public!unit tests! !
!ARGBTest categoriesFor: #testEquality!public!unit tests! !
!ARGBTest categoriesFor: #testPrintString!public!unit tests! !

