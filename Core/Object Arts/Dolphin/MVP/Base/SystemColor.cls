"Filed out from Dolphin Smalltalk"!

Color subclass: #SystemColor
	instanceVariableNames: 'id'
	classVariableNames: 'ColorsById NamesById'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

SystemColor guid: (GUID fromString: '{87b4c53c-026e-11d3-9fd7-00a0cc3e4a32}')!

SystemColor comment: '`SystemColor` instances represent the logical colours defined by the current Windows colour scheme, for example the colour of dialog backgrounds, window captions, etc.

SystemColors are usually accessed by name, either through a specific instance creation method of the `Color` superclass, e.g. `Color window` or by request by symbolic name, e.g. `Color named: #inactiveCaption`. They can also be accessed by their COLOR_XXX code, e.g. `SystemColor withIndex: Win32Constants.COLOR_SCROLLBAR`

## Instance Variables:
  `id`		`<integer>` from the COLOR_xxxx enumeration which is the Windows identifier for this logical colour.

## Class Variables:
  `ColorsById`		`Array`
  `NamesById`		`<Dictionary>`

'!

!SystemColor categoriesForClass!Drawing! !

!SystemColor methodsFor!

asParameter
	"Answer the receiver in a form suitable for an API call."

	^self rgbCode!

asRGB
	"Answer the receiver as an RGB"

	^Color fromRgbCode: self rgbCode!

brushClass
	"Private - Answer the class of Brush to be used in conjunction with the receiver."

	^SysColorBrush!

id
	"Private - Answer the system id of the receiver"

	^id!

name
	"Answer the symbolic name of the receiver."

	^NamesById lookup: id!

printOn: aPuttableStream
	"Append, to the <puttableStream>, target, a string whose characters are a the same as those
	which would result from sending a #printString message to the receiver."

	self name
		ifNil: 
			[aPuttableStream
				nextPut: $(;
				print: self class;
				space;
				display: #withIndex:;
				space;
				print: id;
				nextPut: $)]
		ifNotNil: 
			[:name |
			(Color class canUnderstand: name)
				ifTrue: 
					[aPuttableStream
						print: Color;
						space;
						display: name]
				ifFalse: 
					[aPuttableStream
						nextPut: $(;
						print: Color;
						space;
						display: #named:;
						space;
						print: name.
					aPuttableStream nextPut: $)]]!

rgbCode
	"Answer the receiver's color value in 24-bit RGB encoding with 8-bits per component in (blue, green, red) order."

	^UserLibrary default getSysColor: self id!

setId: anInteger
	"Private - Set the receiver's index to anInteger."

	id := anInteger!

shallowCopy
	"The receiver's instances are unique for each named value."

	^self! !

!SystemColor categoriesForMethods!
asParameter!converting!public! !
asRGB!converting!public! !
brushClass!constants!private! !
id!accessing!private! !
name!accessing!public! !
printOn:!development!printing!public! !
rgbCode!converting!public! !
setId:!accessing!private! !
shallowCopy!copying!public! !
!

!SystemColor class methodsFor!

initialize
	| namesById colorsById |
	namesById := IdentityDictionary new.
	#('scrollbar' 'desktop' 'caption' 'inactiveCaption' 'menu' 'window' 'windowFrame' 'menuText' 'windowText' 'captionText' 'activeBorder' 'inactiveBorder' 'applicationWorkspace' 'highlight' 'highlightText' 'face3d' 'shadow3d' 'grayText' 'buttonText' 'inactiveCaptionText' 'highlight3d' 'buttonHighlight' 'darkShadow3d' 'light3d' 'tooltip' 'tooltipText' 'hotlight' 'gradientActiveCaption' 'gradientInactiveCaption' 'menuHilight' 'menuBar')
		keysAndValuesDo: [:k :v | namesById at: k - 1 put: v asSymbol].
	colorsById := (COLOR_SCROLLBAR to: COLOR_MENUBAR) collect: 
					[:each |
					| syscolor |
					syscolor := self basicNew setId: each.
					syscolor isImmutable: true.
					self addNamed: (namesById at: each) color: syscolor.
					syscolor].
	self addClassConstant: 'NamesById' value: namesById.
	self addClassConstant: 'ColorsById' value: colorsById.
	Color addClassConstant: 'Face3d' value: (self named: #face3d).
	Color addClassConstant: 'Window' value: (self named: #window).
	Color addClassConstant: 'WindowText' value: (self named: #windowText)!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using a proxy"

	| answer ref |
	anSTBInFiler version < 3 ifTrue: [anSTBInFiler stream skip: 4].
	"Make a placeholder for the Color"
	ref := anSTBInFiler register: nil.
	answer := self withIndex: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer!

withIndex: anInteger
	"Answer an instance whose index is anInteger, e.g.
		SystemColor withIndex: COLOR_WINDOW
	"

	^ColorsById at: anInteger + 1! !

!SystemColor class categoriesForMethods!
initialize!class initialization!development!public! !
stbReadFrom:format:!binary filing!public! !
withIndex:!instance creation!public! !
!

