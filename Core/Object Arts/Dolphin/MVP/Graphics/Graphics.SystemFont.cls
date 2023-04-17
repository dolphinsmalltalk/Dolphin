﻿"Filed out from Dolphin Smalltalk"!

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

logFont
	"Answer the receiver's logical attributes."

	^self subclassResponsibility!

shallowCopy
	^Font fromLogFont: self logFont!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: logfont with: nil.
	super stbSaveOn: anSTBOutFiler.! !
!Graphics.SystemFont categoriesForMethods!
=!comparing!public! !
clearCached!private!realizing/unrealizing! !
copy!copying!public! !
hash!comparing!public! !
id!accessing!private! !
logFont!accessing!public! !
shallowCopy!copying!public! !
stbSaveOn:!binary filing!public! !
!
