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

= aFont
	"Answer true if aFont is equal to (has the same id as) the receiver."

	^aFont class == self class and: [id == aFont id]!

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
	lf := self logFont.
	logfont := nil.
	^Font fromLogFont: lf!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self class hash + id!

id
	"Private - Answer the stock font id of the receiver"

	^id!

shallowCopy
	^Font fromLogFont: self logFont!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. For systems fonts we do not want to persist the cached LOGFONT information."

	anSTBOutFiler override: logfont with: nil.
	super stbSaveOn: anSTBOutFiler.! !

!Graphics.SystemFont categoriesForMethods!
=!comparing!public! !
actualFont!public! !
clearCached!private!realizing/unrealizing! !
copy!copying!public! !
hash!comparing!public! !
id!accessing!private! !
shallowCopy!copying!public! !
stbSaveOn:!binary filing!public! !
!

