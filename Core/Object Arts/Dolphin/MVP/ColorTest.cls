"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ColorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorTest guid: (GUID fromString: '{7b5098b5-74d7-46c5-99de-ae2e0558fe5c}')!
ColorTest comment: ''!
!ColorTest categoriesForClass!Unclassified! !
!ColorTest methodsFor!

testConversions
	"The virtual colours 'none' and 'default' do not relate to any particular colour in general, only in context."

	(Array with: Color none with: Color default) do: [:each | self should: [each asRGB] raise: Error].
	"Try a few standard colours"
	((OrderedCollection new)
		add: Color white -> (RGB 
							red: 255
							green: 255
							blue: 255);
		add: Color black -> (RGB 
							red: 0
							green: 0
							blue: 0);
		add: Color red -> (RGB 
							red: 255
							green: 0
							blue: 0);
		add: Color green -> (RGB 
							red: 0
							green: 255
							blue: 0);
		add: Color blue -> (RGB 
							red: 0
							green: 0
							blue: 255);
		add: Color brown -> (RGB 
							red: 128
							green: 128
							blue: 0);
		yourself) do: 
				[:each | 
				| rgb |
				rgb := each key asRGB.
				self assert: (rgb isKindOf: RGB).
				self assert: rgb red = each value red.
				self assert: rgb green = each value green.
				self assert: rgb blue = each value blue.
				self assert: rgb asIndexedColor == each key.
				self assert: (Color fromInteger: each key asParameter) == each key].
	"For system colours we don't know what the RGB values are, so not much we can check."
	self assert: (Color menu asRGB isKindOf: RGB)! !
!ColorTest categoriesFor: #testConversions!public! !

