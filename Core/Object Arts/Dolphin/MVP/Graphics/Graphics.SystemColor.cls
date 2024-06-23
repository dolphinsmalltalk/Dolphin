"Filed out from Dolphin Smalltalk"!

Graphics.Color
	subclass: #'Graphics.SystemColor'
	instanceVariableNames: 'id'
	classVariableNames: 'ColorsById'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
			'NamesById'
				-> (IdentityDictionary withAll: {
								16r0 -> #scrollbar.
								16r1 -> #desktop.
								16r2 -> #caption.
								16r3 -> #inactiveCaption.
								16r4 -> #menu.
								16r5 -> #window.
								16r6 -> #windowFrame.
								16r7 -> #menuText.
								16r8 -> #windowText.
								16r9 -> #captionText.
								16rA -> #activeBorder.
								16rB -> #inactiveBorder.
								16rC -> #applicationWorkspace.
								16rD -> #highlight.
								16rE -> #highlightText.
								16rF -> #face3d.
								16r10 -> #shadow3d.
								16r11 -> #grayText.
								16r12 -> #buttonText.
								16r13 -> #inactiveCaptionText.
								16r14 -> #highlight3d.
								16r15 -> #buttonHighlight.
								16r16 -> #darkShadow3d.
								16r17 -> #light3d.
								16r18 -> #tooltip.
								16r19 -> #tooltipText.
								16r1A -> #hotlight.
								16r1B -> #gradientActiveCaption.
								16r1C -> #gradientInactiveCaption.
								16r1D -> #menuHilight.
								16r1E -> #menuBar
							})
		}!

Graphics.SystemColor guid: (Core.GUID fromString: '{87b4c53c-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.SystemColor comment: '`SystemColor` instances represent the logical colours defined by the current Windows colour scheme, for example the colour of dialog backgrounds, window captions, etc.

SystemColors are usually accessed by name, either through a specific instance creation method of the `Color` superclass, e.g. `Color window` or by request by symbolic name, e.g. `Color named: #inactiveCaption`. They can also be accessed by their COLOR_XXX code, e.g. `SystemColor withIndex: Win32Constants.COLOR_SCROLLBAR`

## Instance Variables:
  `id`		`<integer>` from the COLOR_xxxx enumeration which is the Windows identifier for this logical colour.

## Class Variables:
  `ColorsById`		`Array`
  `NamesById`		`<Dictionary>`

'!

!Graphics.SystemColor categoriesForClass!Drawing! !

!Graphics.SystemColor methodsFor!

asParameter
	"Answer the receiver in a form suitable for an API call."

	^self rgbCode!

brushClass
	"Private - Answer the class of Brush to be used in conjunction with the receiver."

	^SysColorBrush!

id
	"Answer the identifier of the receiver from the Windows COLOR_xxxx enumeration, e.g. COLOR_WINDOW."

	^id!

isSymbolic
	"Answer whether the receiver is the symbolic <Color> that does not correspond to a fixed RGB(A) value."

	^true!

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
	"Answer the receiver's <integer> color value in 24-bit RGB encoding with 8-bits per component in COLORREF order (red as low-order byte, green 2nd byte, and blue 3rd byte)."

	^User32 getSysColor: id!

setId: anInteger
	"Private - Set the receiver's index to anInteger."

	id := anInteger!

shallowCopy
	"The receiver's instances are unique for each named value."

	^self! !

!Graphics.SystemColor categoriesForMethods!
asParameter!converting!public! !
brushClass!constants!private! !
id!accessing!public! !
isSymbolic!public!testing! !
name!accessing!public! !
printOn:!development!printing!public! !
rgbCode!converting!public! !
setId:!accessing!private! !
shallowCopy!copying!public! !
!

!Graphics.SystemColor class methodsFor!

initialize
	| namesById colorsById |
	namesById := IdentityDictionary new.
	#('scrollbar' 'desktop' 'caption' 'inactiveCaption' 'menu' 'window' 'windowFrame' 'menuText' 'windowText' 'captionText' 'activeBorder' 'inactiveBorder' 'applicationWorkspace' 'highlight' 'highlightText' 'face3d' 'shadow3d' 'grayText' 'buttonText' 'inactiveCaptionText' 'highlight3d' 'buttonHighlight' 'darkShadow3d' 'light3d' 'tooltip' 'tooltipText' 'hotlight' 'gradientActiveCaption' 'gradientInactiveCaption' 'menuHilight' 'menuBar')
		keysAndValuesDo: [:k :v | namesById at: k - 1 put: v asSymbol].
	colorsById := (COLOR_SCROLLBAR to: COLOR_MENUBAR) collect: 
					[:each |
					| syscolor |
					syscolor := self basicNew setId: each.
					syscolor beImmutableObject.
					self addNamed: (namesById at: each) color: syscolor.
					syscolor].
	self addClassConstant: 'NamesById' value: namesById.
	self addClassVariable: 'ColorsById' value: colorsById.
	Color addClassVariable: 'Face3d' value: (self named: #face3d).
	Color addClassVariable: 'Window' value: (self named: #window).
	Color addClassVariable: 'WindowText' value: (self named: #windowText)!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using a proxy"

	| answer ref |
	ref := anSTBInFiler register: nil.
	answer := self withIndex: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer!

withIndex: anInteger
	"Answer an instance whose index is anInteger, e.g.
		SystemColor withIndex: COLOR_WINDOW
	"

	^ColorsById at: anInteger + 1! !

!Graphics.SystemColor class categoriesForMethods!
initialize!class initialization!development!public! !
stbReadFrom:format:size:!binary filing!public! !
withIndex:!instance creation!public! !
!

