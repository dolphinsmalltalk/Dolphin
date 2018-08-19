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

	{Color none. Color default} do: [:each | self should: [each asRGB] raise: Error].
	"Try a few standard colours"
	(OrderedCollection new
		add: Color white -> (RGB
							r: 255
							g: 255
							b: 255);
		add: Color black -> (RGB
							r: 0
							g: 0
							b: 0);
		add: Color red -> (RGB
							r: 255
							g: 0
							b: 0);
		add: Color green -> (RGB
							r: 0
							g: 255
							b: 0);
		add: Color blue -> (RGB
							r: 0
							g: 0
							b: 255);
		add: Color brown -> (RGB
							r: 128
							g: 128
							b: 0);
		yourself) do: 
				[:each |
				| rgb |
				rgb := each key asRGB.
				self assert: rgb isKindOf: RGB.
				self assert: rgb red equals: each value red.
				self assert: rgb green equals: each value green.
				self assert: rgb blue equals: each value blue.
				self assert: rgb asIndexedColor identicalTo: each key.
				self assert: (Color fromInteger: each key asParameter) identicalTo: each key.
				self assert: (RGB named: each key name) equals: each key asRGB].
	"For system colours we don't know what the RGB values are, so not much we can check."
	self assert: Color menu asRGB isKindOf: RGB!

testHls
	| hls rgb expected |
	Color.NamedColors do: 
			[:each |
			hls := each hls.
			rgb := RGB
						hue: hls first
						luminance: hls second
						saturation: hls third.
			"Sound rounding error is possible in the conversion"
			expected := each asRGB.
			self assert: (rgb red - expected red) abs < 3.
			self assert: (rgb green - expected green) abs < 3.
			self assert: (rgb blue - expected blue) abs < 3]!

testRGBNamedColors
	self assert: RGB brown equals: (RGB r: 128 g: 128 b: 0).
	self assert: RGB red isImmutable!

testSingletons
	| subject1 subject2 subject3 dehydrated rehydrated array |
	subject1 := Color window.
	subject2 := Color menu.
	subject3 := Color magenta.
	self assert: subject1 identicalTo: Color window.
	self assert: subject1 identicalTo: (SystemColor withIndex: Win32Constants.COLOR_WINDOW).
	self deny: subject1 identicalTo: Color windowText.
	self assert: subject1 copy identicalTo: subject1.
	self assert: subject1 shallowCopy identicalTo: subject1.
	self assert: subject1 deepCopy identicalTo: subject1.
	self assert: subject2 identicalTo: (SystemColor withIndex: Win32Constants.COLOR_MENU).
	self assert: subject3 identicalTo: (IndexedColor withIndex: Color magenta index).
	array := {subject1. subject2. subject3. subject1. subject2. subject3}.
	dehydrated := array binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: dehydrated.
	self assert: rehydrated first identicalTo: subject1.
	self assert: rehydrated second identicalTo: subject2.
	self assert: rehydrated third identicalTo: subject3.
	self assert: rehydrated fourth identicalTo: subject1.
	self assert: rehydrated fifth identicalTo: subject2.
	self assert: rehydrated sixth identicalTo: subject3.
	dehydrated := array literalStoreArray.
	rehydrated := Object fromLiteralStoreArray: dehydrated.
	self assert: rehydrated first identicalTo: subject1.
	self assert: rehydrated second identicalTo: subject2.
	self assert: rehydrated third identicalTo: subject3.
	self assert: rehydrated fourth identicalTo: subject1.
	self assert: rehydrated fifth identicalTo: subject2.
	self assert: rehydrated sixth identicalTo: subject3.! !
!ColorTest categoriesFor: #testConversions!public!unit tests! !
!ColorTest categoriesFor: #testHls!public!unit tests! !
!ColorTest categoriesFor: #testRGBNamedColors!public!unit tests! !
!ColorTest categoriesFor: #testSingletons!public!unit tests! !

