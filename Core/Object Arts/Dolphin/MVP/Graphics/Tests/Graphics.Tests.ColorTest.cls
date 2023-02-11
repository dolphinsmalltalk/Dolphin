"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.ColorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.ColorTest guid: (Core.GUID fromString: '{7b5098b5-74d7-46c5-99de-ae2e0558fe5c}')!
Graphics.Tests.ColorTest comment: ''!
!Graphics.Tests.ColorTest methodsFor!

shouldRaiseNotARealColorError: aNiladicValuable
	self should: aNiladicValuable raise: Error matching: [:ex | ex description = 'Cannot convert to an RGB'].!

testActualColor
	| subject |
	self assert: Color red actualColor identicalTo: Color red.
	self assert: Color windowText actualColor identicalTo: Color windowText.
	subject := PluggableColor with: [Color purple].
	self assert: subject actualColor identicalTo: Color purple.
	subject := ThemeColor name: #test actualColor: subject.
	self assert: subject actualColor identicalTo: Color purple.
	subject := ThemeColor name: #test actualColor: subject.
	self assert: subject actualColor identicalTo: Color purple.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) actualColor
		equals: ((Color named: #gradientActiveCaption) asRGB alpha: 64)!

testAlpha
	self assert: Color red alpha equals: 255.
	self assert: Color none alpha equals: 0.
	self assert: (Color yellow alpha: 128) alpha equals: 128.
	self assert: IndexedColor brown alpha equals: 255.
	self shouldRaiseNotARealColorError: [Color default alpha].
	self assert: Color face3d alpha equals: 255.
	self assert: (Color face3d alpha: 123) alpha equals: 123!

testArgbCode
	self assert: Color white argbCode equals: 16rFFFFFFFF.
	self assert: Color black argbCode equals: 16rFF000000.
	self assert: Color none argbCode equals: 16rFFFFFF.
	self assert: Color orchid argbCode equals: 16rFFDA70D6.
	self assert: IndexedColor darkCyan isKindOf: IndexedColor.
	self assert: IndexedColor darkCyan argbCode equals: 16rFF008080.
	self assert: (Color orchid alpha: 64) argbCode equals: 16r40DA70D6.
	self assert: (Color fromArgbCode: 16rFFDA70D6) equals: Color orchid.
	self assert: (Color fromArgbCode: 16r40DA70D6) equals: (Color orchid alpha: 64).
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) argbCode
		equals: ((Color named: #gradientActiveCaption) asRGB alpha: 64) argbCode!

testAsColorRef
	self assert: Color orchid asColorRef identicalTo: Color orchid.
	self assert: IndexedColor brown asColorRef equals: Color olive.
	self assert: Color none asColorRef identicalTo: Color none.
	self assert: Color default asColorRef identicalTo: Color default.
	"Alpha of ARGB is lost"
	self assert: (Color orchid alpha: 99) asColorRef equals: Color orchid!

testAsCOLORREF
	"COLORREF is a BGR encoding with some special cases for CLR_NONE, CLR_DEFAULT, and indexed colours."

	self assert: Color orchid asCOLORREF equals: 16rD670DA.
	self assert: IndexedColor brown asCOLORREF equals: 16r1000003.
	self assert: Color none asCOLORREF equals: Win32Constants.CLR_NONE.
	self assert: Color default asCOLORREF equals: Win32Constants.CLR_DEFAULT.
	"Alpha of ARGB is lost"
	self assert: (Color orchid alpha: 99) asCOLORREF equals: 16rD670DA.
	self assert: ((Color named: #gradientActiveCaption) alpha: 100) asCOLORREF
		equals: (Color named: #gradientActiveCaption) asCOLORREF!

testAsRGB
	self assert: Color orchid asRGB identicalTo: Color orchid.
	self assert: IndexedColor brown asRGB equals: Color olive.
	self shouldRaiseNotARealColorError: [Color none asRGB].
	self shouldRaiseNotARealColorError: [Color default asRGB].
	"Alpha of ARGB is lost"
	self assert: (Color orchid alpha: 99) asRGB equals: Color orchid.
	self assert: ((Color named: #gradientActiveCaption) alpha: 100) asRGB
		equals: (Color named: #gradientActiveCaption) asRGB!

testBlue
	self assert: Color blue blue equals: 255.
	self assert: Color green blue equals: 0.
	self assert: (Color purple alpha: 100) blue equals: 128.
	self assert: IndexedColor darkBlue blue equals: 128.
	self shouldRaiseNotARealColorError: [Color default blue].
	self assert: Color none blue equals: 255.
	self assert: (Color named: #gradientActiveCaption) blue
		equals: (Color named: #gradientActiveCaption) asRGB blue.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) blue
		equals: (Color named: #gradientActiveCaption) blue!

testBrightness
	{Color white. Color red. Color blue. Color green. Color yellow. IndexedColor yellow. Color none}
		do: [:each | self assert: each brightness equals: 1.0].
	self assert: Color black brightness equals: 0.0.
	self assert: (Color gray brightness roundTo: 0.01) equals: 0.5.
	self assert: Color face3d brightness equals: Color face3d asRGB brightness.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) brightness
		equals: (Color named: #gradientActiveCaption) brightness!

testBrush
	| bmp rect current |
	bmp := DIBSection
				width: 8
				height: 8
				depth: 32.
	rect := 0 @ 0 corner: bmp extent.
	{Color white.
		Color yellow alpha: 100.
		Color black.
		Color orchid.
		IndexedColor brown.
		Color face3d.
		(Color named: #gradientActiveCaption) alpha: 64} do: 
				[:each |
				| brush |
				brush := each brush.
				bmp canvas fillRectangle: rect brush: brush.
				self assert: (bmp canvas pixelAt: 0 @ 0) equals: each asRGB].
	current := bmp canvas pixelAt: 0 @ 0.
	bmp canvas fillRectangle: rect brush: Color none brush.
	self assert: (bmp canvas pixelAt: 0 @ 0) equals: current.
	self shouldRaiseNotARealColorError: [Color default brush]!

testChroma
	{Color red. Color blue. Color green} do: [:each | self assert: each chroma equals: 1].
	{Color black. Color white. Color none. Color brightness: 0.5}
		do: [:each | self assert: each chroma equals: 0].
	{Color navy. Color commonGreen} do: [:each | self assert: (each chroma roundTo: 0.01) equals: 0.5].
	self shouldRaiseNotARealColorError: [Color default chroma].
	self assert: Color caption chroma equals: Color caption asRGB chroma.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) chroma
		equals: (Color named: #gradientActiveCaption) chroma!

testClassBlack
	self assert: Color black isKindOf: RGB.
	self assert: Color black code equals: 0.
	self assert: IndexedColor black isKindOf: IndexedColor.
	self assert: IndexedColor black rgbCode equals: 0!

testClassBrightness
	self assert: (Color brightness: 0.5) rgb equals: #(128 128 128).
	self assert: (Color brightness: 0) equals: Color black.
	self assert: (Color brightness: 1) equals: Color white.!

testClassFromArray
	"#fromArray: can be used to instantiate colours from [a], r, g, b components."

	self assert: (Color fromArray: #(16rDA 16r70 16rD6)) equals: Color orchid.
	self assert: (Color fromArray: #(16r1F 16rDA 16r70 16rD6)) equals: (Color orchid alpha: 16r1F).
	#(#() #(1) #(1 2)) do: [:each | self should: [Color fromArray: each] raise: BoundsError]!

testClassFromHtmlSpec
	#('' '#' '0' '#0' '#000000')
		do: [:each | self assert: (Color fromHTMLSpec: each) equals: Color black].
	self assert: (Color fromHTMLSpec: '#7F') equals: (Color r: 0 g: 0 b: 127).
	self assert: (Color fromHTMLSpec: '#7F00') equals: (Color r: 0 g: 127 b: 0).
	self assert: (Color fromHTMLSpec: '#7F0000') equals: (Color r: 127 g: 0 b: 0).
	#('14315734' '4292505814' '#DA70D6' '#FFDA70D6' '#1DA70D6')
		do: [:each | self assert: (Color fromHTMLSpec: each) equals: Color orchid]!

testClassWhite
	self assert: Color white isKindOf: RGB.
	self assert: Color white code equals: 16rFFFFFF.
	self assert: IndexedColor white isKindOf: IndexedColor.
	self assert: IndexedColor white rgbCode equals: 16rFFFFFF!

testConversions
	"The virtual colours 'none' and 'default' do not relate to any particular colour in general, only in context."

	{Color none. Color default} do: [:each | self shouldRaiseNotARealColorError: [each asRGB]].
	"Try a few standard colours"
	{Color white -> (RGB
					r: 255
					g: 255
					b: 255).
		Color black -> (RGB
					r: 0
					g: 0
					b: 0).
		Color red -> (RGB
					r: 255
					g: 0
					b: 0).
		Color green -> (RGB
					r: 0
					g: 255
					b: 0).
		Color blue -> (RGB
					r: 0
					g: 0
					b: 255).
		Color maroon -> (RGB
					r: 128
					g: 0
					b: 0).
		IndexedColor brown -> Color olive} do: 
				[:each |
				| rgb |
				rgb := each key asRGB.
				self assert: rgb isKindOf: RGB.
				self assert: rgb red equals: each value red.
				self assert: rgb green equals: each value green.
				self assert: rgb blue equals: each value blue.
				self assert: rgb asIndexedColor equals: each key.
				self assert: (Color fromInteger: each key asParameter) equals: each key.
				each key class == IndexedColor
					ifFalse: [self assert: (RGB named: each key name) equals: each key asRGB]].
	"For system colours we don't know what the RGB values are, so not much we can check."
	self assert: Color menu asRGB isKindOf: RGB!

testEquals
	Color commonColors do: 
			[:each |
			| argb |
			self assert: each equals: each asRGB.
			self assert: each asRGB equals: each.
			argb := ARGB fromArgbCode: each argbCode.
			self assert: each equals: argb.
			self assert: argb equals: each.
			self deny: each equals: Color default.
			self deny: Color default equals: each].
	self deny: Color red equals: Color none.
	self deny: Color none equals: Color red.
	self assert: Color none equals: Color none.
	self assert: ARGB none equals: ARGB none.
	self assert: ARGB none equals: Color none.
	self assert: Color none equals: ARGB none.
	self assert: Color default equals: Color default.
	self assert: IndexedColor yellow equals: Color yellow.
	self
		assert: (IndexedColor.InstancesByIndex allSatisfy: 
					[:each |
					each ~= Color default
						and: [Color default ~= each and: [each ~= Color none and: [Color none ~= each]]]]).
	self assert: ((Color named: #gradientActiveCaption) alpha: 63)
		equals: ((Color named: #gradientActiveCaption) asRGB alpha: 63).
	self deny: ((Color named: #gradientActiveCaption) alpha: 0) equals: Color none!

testFaded
	self assert: Color red faded
		equals: (RGB
				r: 255
				g: 128
				b: 128).
	self assert: Color orchid faded
		equals: (RGB
				r: 237
				g: 184
				b: 235).
	self assert: IndexedColor brown faded
		equals: (RGB
				r: 192
				g: 192
				b: 128).
	self assert: (Color orchid alpha: 100) faded
		equals: (ARGB
				a: 100
				r: 237
				g: 184
				b: 235).
	self assert: ((Color named: #gradientActiveCaption) alpha: 100) faded
		equals: ((Color named: #gradientActiveCaption) asRGB alpha: 100) faded!

testGreen
	self assert: Color green green equals: 255.
	self assert: Color blue green equals: 0.
	self assert: (Color yellow alpha: 128) green equals: 255.
	self assert: IndexedColor brown green equals: 128.
	self shouldRaiseNotARealColorError: [Color default green].
	self assert: Color none green equals: 255.
	self assert: (Color named: #gradientActiveCaption) green
		equals: (Color named: #gradientActiveCaption) asRGB green.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) green
		equals: (Color named: #gradientActiveCaption) green!

testHash
	| themeColor |
	Color commonColors do: 
			[:each |
			self assert: each hash equals: each asRGB hash.
			self assert: each hash equals: (ARGB fromArgbCode: each argbCode) hash].
	self assert: Color hotlight hash equals: Color hotlight asRGB hash.
	themeColor := Color named: #smalltalkSystem.
	self assert: themeColor hash equals: themeColor asRGB hash.
	self assert: Color none hash equals: ARGB none hash.
	self assert: (Color.NamedColors select: [:each | each hash = Color default hash]) keys asArray
		equals: #(#default).
	self assert: IndexedColor yellow hash equals: Color yellow hash.
	self assert: (IndexedColor.InstancesByIndex allSatisfy: [:each | each hash ~= Color default hash])!

testHls
	| hls actual |
	self assert: (Color
				h: 0
				s: 1
				l: 0.5)
		equals: Color red.
	self assert: (Color
				h: 0
				s: 1
				l: 0.5) hls equals: #(0.0 0.5 1.0).
	self shouldRaiseNotARealColorError: [Color default hls].
	self assert: (Color hsv: Color none hsv) equals: Color white.
	"Round trip all the named colours"
	(Color.NamedColors reject: [:each | each isDefault or: [each alpha ~~ 255]]) do: 
			[:each |
			hls := each hls.
			actual := Color hls: hls.
			self assert: actual equals: each].
	self assert: (Color hls: Color none hls) equals: Color white.

	self assert: ((Color named: #gradientActiveCaption) alpha: 100) hls
		equals: (Color named: #gradientActiveCaption) hls!

testHsv
	self assert: (Color
				h: 0
				s: 1
				v: 1)
		equals: Color red.
	self assert: ((Color
				h: 0
				s: 1
				v: 0.5) hsv collect: [:each | each roundTo: 0.01])
		equals: #(0.0 1.0 0.5).
	self shouldRaiseNotARealColorError: [Color default hsv].
	(Color.NamedColors reject: [:each | each isDefault or: [each alpha ~~ 255]]) do: 
			[:each |
			| hsv actual |
			hsv := each hsv.
			actual := Color hsv: hsv.
			self assert: actual equals: each].
	self assert: (Color hsv: Color none hsv) equals: Color white.
	self assert: (Color hsv: IndexedColor yellow hsv) equals: Color yellow.
	self assert: ((Color named: #gradientActiveCaption) alpha: 100) hsv
		equals: (Color named: #gradientActiveCaption) hsv!

testHue
	self assert: (Color
				r: 128
				g: 128
				b: 255) hue equals: 240.
	self assert: IndexedColor yellow hue equals: 60.0.
	self assert: ((Color named: #gradientActiveCaption) alpha: 100) hue
		equals: (Color named: #gradientActiveCaption) hue!

testIntensity
	| halfOrchid |
	self assert: (Color white intensity: 0.5) equals: Color gray.
	self assert: (Color black intensity: 0.5) equals: Color black.
	self assert: (Color orchid intensity: 1.0) equals: Color orchid.
	self assert: (Color orchid intensity: 0) equals: Color black.
	self assert: (Color red intensity: 0.5) equals: Color maroon.
	self assert: (Color blue intensity: 0.5) equals: Color navy.
	self assert: (Color green intensity: 0.5) equals: Color commonGreen.
	halfOrchid := Color fromArray: (Color orchid rgb collect: [:each | each // 2]).
	self assert: (Color orchid intensity: 0.5) equals: halfOrchid.
	self assert: ((Color orchid alpha: 100) intensity: 0.5) equals: (halfOrchid alpha: 100).
	self assert: (Color face3d intensity: 0.75) equals: (Color face3d asRGB intensity: 0.75).
	self assert: (IndexedColor yellow intensity: 0.5) equals: Color olive.
	self assert: (Color none intensity: 0.5) equals: (Color gray alpha: 0).
	self assert: (((Color named: #gradientActiveCaption) alpha: 100) intensity: 0.5)
		equals: ((Color named: #gradientActiveCaption) intensity: 0.5)!

testIsDefault
	self deny: Color orchid isDefault.
	self deny: Color none isDefault.
	self deny: IndexedColor gray isDefault.
	self deny: Color face3d isDefault.
	self assert: Color default isDefault.
	self deny: (Color named: #smalltalkSystem) isDefault.
	self deny: (Color orchid alpha: 100) isDefault.
	self deny: ((Color named: #gradientActiveCaption) alpha: 100) isDefault!

testIsGrayscale
	self assert: Color silver isGrayscale.
	self assert: Color gray isGrayscale.
	self assert: Color darkGray isGrayscale.
	self assert: (Color brightness: 0.61803399) isGrayscale.
	self assert: Color white isGrayscale.
	self assert: Color black isGrayscale.
	self assert: (Color lightGray alpha: 128) isGrayscale.
	self assert: Color none isGrayscale.
	self deny: Color red isGrayscale.
	self deny: Color red isGrayscale.
	self assert: IndexedColor darkGray isGrayscale.
	self deny: IndexedColor yellow isGrayscale.
	self shouldRaiseNotARealColorError: [Color default isGrayscale].
	"It isn't absolutely guaranteed that the SystemColor grayText is actually a gray, but it is a fairly safe assumption that is is."
	self assert: Color grayText isGrayscale.
	"Not absolutely guaranteed either, but we're unlikely to choose grey for the main Dolphin accent colour."
	self deny: (Color named: #smalltalkSystem) isGrayscale.
	self deny: ((Color named: #gradientActiveCaption) alpha: 64) isGrayscale!

testIsNone
	self deny: Color orchid isNone.
	self deny: IndexedColor white isNone.
	self deny: (Color black alpha: 0) isNone.
	self deny: (Color green alpha: 128) isNone.
	self deny: (Color blue alpha: 0) isNone.
	self deny: Color face3d isNone.
	self assert: Color none isNone.
	self deny: Color white isNone.
	self assert: (Color white alpha: 0) isNone.
	self assert: ARGB none isNone.
	self deny: (Color named: #smalltalkSystem) isNone.
	self deny: Color default isNone.
	self deny: ((Color named: #gradientActiveCaption) alpha: 64) isNone!

testIsSymbolic
	self assert: Color window isSymbolic.
	self assert: (Color named: #smalltalkWorkspace) isSymbolic.
	self assert: (PluggableColor with: [Color black]) isSymbolic.
	self deny: Color black isSymbolic.
	self deny: (Color purple alpha: 63) isSymbolic.
	self assert: ((Color named: #gradientActiveCaption) alpha: 100) isSymbolic!

testIsTransparent
	{Color red.
		IndexedColor yellow.
		Color named: #smalltalkWorkspace.
		Color chocolate alpha: 128.
		(Color named: #gradientActiveCaption) alpha: 64} do: [:each | self deny: each isTransparent].
	{Color chocolate alpha: 0.
		Color none.
		Color black alpha: 0.
		(Color named: #gradientActiveCaption) alpha: 0} do: [:each | self assert: each isTransparent]!

testName
	self assert: Color highlight name identicalTo: #highlight.
	self assertIsNil: Color highlight asRGB name.
	self assertIsNil: (Color highlight alpha: 63) name!

testNormalizedAlpha
	self assert: Color red normalizedAlpha equals: 1.
	self assert: Color none normalizedAlpha equals: 0.
	self assert: (Color yellow alpha: 128) normalizedAlpha equals: 128 / 255.
	self assert: IndexedColor brown normalizedAlpha equals: 1.
	self shouldRaiseNotARealColorError: [Color default normalizedAlpha].
	self assert: Color face3d normalizedAlpha equals: 1.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) normalizedAlpha equals: 64 / 255!

testNormalizedBlue
	self assert: Color blue normalizedBlue equals: 1.
	self assert: Color green normalizedBlue equals: 0.
	self assert: (Color purple alpha: 100) normalizedBlue equals: 128 / 255.
	self assert: IndexedColor darkBlue normalizedBlue equals: 128 / 255.
	self shouldRaiseNotARealColorError: [Color default normalizedBlue].
	self assert: (Color named: #gradientActiveCaption) normalizedBlue
		equals: (Color named: #gradientActiveCaption) asRGB normalizedBlue.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) normalizedBlue
		equals: (Color named: #gradientActiveCaption) asRGB normalizedBlue!

testNormalizedGreen
	self assert: Color green normalizedGreen equals: 1.
	self assert: Color blue normalizedGreen equals: 0.
	self assert: (Color yellow alpha: 128) normalizedGreen equals: 1.
	self assert: IndexedColor brown normalizedGreen equals: 128 / 255.
	self assert: (Color named: #gradientActiveCaption) normalizedGreen
		equals: (Color named: #gradientActiveCaption) asRGB normalizedGreen.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) normalizedGreen
		equals: (Color named: #gradientActiveCaption) asRGB normalizedGreen!

testNormalizedRed
	self assert: Color red normalizedRed equals: 1.
	self assert: Color blue normalizedRed equals: 0.
	self assert: (Color yellow alpha: 128) normalizedRed equals: 1.
	self assert: IndexedColor brown normalizedRed equals: 128 / 255.
	self shouldRaiseNotARealColorError: [Color default normalizedRed].
	self assert: (Color named: #gradientActiveCaption) normalizedRed
		equals: (Color named: #gradientActiveCaption) asRGB normalizedRed.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) normalizedRed
		equals: (Color named: #gradientActiveCaption) asRGB normalizedRed!

testPen
	| bmp rect |
	bmp := DIBSection
				width: 8
				height: 8
				depth: 32.
	rect := 0 @ 0 corner: bmp extent.
	{Color white.
		Color yellow alpha: 100.
		Color black.
		Color orchid.
		IndexedColor brown.
		Color face3d.
		(Color named: #gradientActiveCaption) alpha: 64} do: 
				[:each |
				| pen |
				pen := each pen.
				bmp canvas
					pen: pen;
					lineFrom: 0 @ 0 to: 7 @ 7.
				self assert: (bmp canvas pixelAt: 1 @ 1) equals: each asRGB].
	bmp canvas fillRectangle: rect brush: Color red brush.
	bmp canvas
		pen: Color none pen;
		lineFrom: 0 @ 0 to: 7 @ 7.
	"Drawing with the null pen should do not change the bitmap"
	self assert: (bmp canvas pixelAt: 1 @ 1) equals: Color red.
	"Default color is not a real Color and only meaningful as an instruction to some control to use its default colour. It cannot be used to create a Pen."
	self shouldRaiseNotARealColorError: [Color default pen]!

testPrintString
	self assert: Color red printString equals: 'Color red'.
	self assert: IndexedColor green printString equals: 'IndexedColor green'.
	self assert: (Color red fadedBy: 2) printString equals: '(Color r: 255 g: 128 b: 128)'.
	self assert: (Color orchid alpha: 100) printString equals: '(Color a: 100 r: 218 g: 112 b: 214)'.
	self assert: Color face3d printString equals: 'Color face3d'.
	self assert: (Color named: #smalltalkSystem) printString equals: '(Color named: #smalltalkSystem)'.
	self assert: (PluggableColor with: ##([Color orchid alpha: 64])) printString
		equals: 'PluggableColor with: [Color orchid alpha: 64]'.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) printString
		equals: '((Color named: #gradientActiveCaption) alpha: 64)'.
	self assert: (Color brightness: 248 / 255) printString equals: '(Color brightness: 248/255)'!

testRed
	self assert: Color red red equals: 255.
	self assert: Color blue red equals: 0.
	self assert: (Color yellow alpha: 100) red equals: 255.
	self assert: IndexedColor brown red equals: 128.
	self shouldRaiseNotARealColorError: [Color default red].
	self assert: Color none red equals: 255.
	self assert: (Color named: #gradientActiveCaption) red
		equals: (Color named: #gradientActiveCaption) asRGB red.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) red
		equals: (Color named: #gradientActiveCaption) red!

testRgb
	self assert: Color white rgb equals: #(255 255 255).
	self assert: Color orchid rgb equals: #(16rDA 16r70 16rD6).
	self assert: Color none rgb equals: Color white rgb.
	self shouldRaiseNotARealColorError: [Color default rgb].
	self assert: IndexedColor darkCyan rgb equals: #(16r00 16r80 16r80).
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) rgb
		equals: (Color named: #gradientActiveCaption) rgb!

testRgbaCode
	self assert: Color white rgbaCode equals: 16rFFFFFFFF.
	self assert: Color black rgbaCode equals: 16rFF000000.
	self assert: Color none rgbaCode equals: 16rFFFFFF.
	self assert: Color orchid rgbaCode equals: 16rFFD670DA.
	self assert: IndexedColor darkCyan isKindOf: IndexedColor.
	self assert: IndexedColor darkCyan rgbaCode equals: 16rFF808000.
	self assert: (Color orchid alpha: 64) rgbaCode equals: 16r40D670DA.
	self assert: (Color fromRgbaCode: 16rFFD670DA) equals: Color orchid.
	self assert: (Color fromRgbaCode: 16r40D670DA) equals: (Color orchid alpha: 64).
	self assert: (PluggableColor with: [Color orchid alpha: 64]) rgbaCode
		equals: (Color orchid alpha: 64) rgbaCode.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) rgbaCode
		equals: ((Color named: #gradientActiveCaption) asRGB alpha: 64) rgbaCode!

testRgbCode
	self assert: Color white rgbCode equals: 16rFFFFFF.
	self assert: Color black rgbCode equals: 0.
	self assert: Color none rgbCode equals: Color white rgbCode.
	self shouldRaiseNotARealColorError: [Color default rgbCode].
	"The encoding is actually BGR"
	self assert: Color orchid rgbCode equals: 16rD670DA.
	self assert: IndexedColor white isKindOf: IndexedColor.
	self assert: IndexedColor white rgbCode equals: 16rFFFFFF.
	self assert: IndexedColor darkCyan rgbCode equals: 16r808000.
	self assert: (Color fromRgbCode: 16rD670DA) equals: Color orchid.
	self assert: (Color fromRgbCode: 16rFFD670DA) equals: Color orchid.
	self assert: (PluggableColor with: [Color orchid]) rgbCode equals: Color orchid rgbCode.
	self assert: ((Color named: #gradientActiveCaption) alpha: 64) rgbCode
		equals: (Color named: #gradientActiveCaption) rgbCode!

testRGBNamedColors
	self assert: Color magenta equals: (Color r: 255 g: 0 b: 255).
	self assert: Color red isImmutable!

testSingletons
	| subject1 subject2 subject3 |
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
	self assert: subject3 identicalTo: Color magenta!

testSingletonSerialisationToStb
	| subject1 subject2 subject3 dehydrated rehydrated array |
	subject1 := Color window.
	subject2 := Color menu.
	subject3 := Color magenta.
	array := {subject1. subject2. subject3. subject1. subject2. subject3}.
	dehydrated := array binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: dehydrated.
	self assert: rehydrated first identicalTo: subject1.
	self assert: rehydrated second identicalTo: subject2.
	self assert: rehydrated third identicalTo: subject3.
	self assert: rehydrated fourth identicalTo: subject1.
	self assert: rehydrated fifth identicalTo: subject2.
	self assert: rehydrated sixth identicalTo: subject3! !
!Graphics.Tests.ColorTest categoriesForMethods!
shouldRaiseNotARealColorError:!helpers!private! !
testActualColor!public!unit tests! !
testAlpha!public!unit tests! !
testArgbCode!public!unit tests! !
testAsColorRef!public!unit tests! !
testAsCOLORREF!public!unit tests! !
testAsRGB!public!unit tests! !
testBlue!public!unit tests! !
testBrightness!public!unit tests! !
testBrush!public!unit tests! !
testChroma!public!unit tests! !
testClassBlack!public!unit tests! !
testClassBrightness!public!unit tests! !
testClassFromArray!public! !
testClassFromHtmlSpec!public! !
testClassWhite!public!unit tests! !
testConversions!public!unit tests! !
testEquals!public!unit tests! !
testFaded!public!unit tests! !
testGreen!public!unit tests! !
testHash!public!unit tests! !
testHls!public!unit tests! !
testHsv!public!unit tests! !
testHue!public!unit tests! !
testIntensity!public!unit tests! !
testIsDefault!public!unit tests! !
testIsGrayscale!public!unit tests! !
testIsNone!public!unit tests! !
testIsSymbolic!public! !
testIsTransparent!public!unit tests! !
testName!public! !
testNormalizedAlpha!public!unit tests! !
testNormalizedBlue!public!unit tests! !
testNormalizedGreen!public!unit tests! !
testNormalizedRed!public!unit tests! !
testPen!public!unit tests! !
testPrintString!public!unit tests! !
testRed!public!unit tests! !
testRgb!public!unit tests! !
testRgbaCode!public!unit tests! !
testRgbCode!public!unit tests! !
testRGBNamedColors!public!unit tests! !
testSingletons!public!unit tests! !
testSingletonSerialisationToStb!public!unit tests! !
!

