"Filed out from Dolphin Smalltalk"!

Graphics.AbstractFont
	subclass: #'Graphics.SystemFont'
	instanceVariableNames: 'id'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.SystemFont guid: (Core.GUID fromString: '{76463278-a324-4576-b9df-2537f18debbd}')!

Graphics.SystemFont isNonInstantiable: true!

Graphics.SystemFont comment: ''!

!Graphics.SystemFont methodsFor!

actualFont
	"Answer the actual Font that is the current setting of this system font."

	^self copy!

clearCached
	"Private - Clear down the receiver's cached information and handles.
	Should be overridden by subclasses which wish to clear down other
	handles and cached information."

	super clearCached.
	logfont := nil!

copy
	| lf |
	lf := self logFont copy.
	"If the font's height is specified as cell height, ensure translated to character height in the copy to allow for easier scaling."
	lf lfHeight: self pixelSize negated.
	^Font fromLogFont: lf dpi: dpi!

dpi: anInteger
	"Sets the logical pixels per inch of the receiver."

	"The dpi cannot be changed, so just ignore"

	!

id
	"Private - Answer the stock font id of the receiver"

	^id!

initialize
	"Initialise the receiver."

	super initialize.
	"The stock fonts are sized for the system (primary monitor) DPI."
	dpi := User32 getDpiForSystem! !

!Graphics.SystemFont categoriesForMethods!
actualFont!accessing!public! !
clearCached!private!realizing/unrealizing! !
copy!copying!public! !
dpi:!accessing!public!scaling! !
id!accessing!private! !
initialize!initializing!public! !
!

