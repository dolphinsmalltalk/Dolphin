"Filed out from Dolphin Smalltalk 7"!

External.SWORD subclass: #'OS.COM.VARIANT_BOOL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.VARIANT_BOOL guid: (Core.GUID fromString: '{c06f3b75-0868-11d3-93af-00a024ca708a}')!
OS.COM.VARIANT_BOOL comment: 'VARIANT_BOOL is an <ExternalStructure> class to represent the Automation type, VARIANT_BOOL, which is VB''s boolean type.

VARIANT_BOOL is a 16-bit signed integer value where -1 is used to represent true, and 0 is used to represent false. This class has a slightly looser definition in that it maps any non-zero value to true on access, and any non-zero/true value to -1 on mutation.'!
!OS.COM.VARIANT_BOOL categoriesForClass!External-Data-Structured! !
!OS.COM.VARIANT_BOOL methodsFor!

asBoolean
	"Answer the receiver as a Smalltalk <Boolean> object (true OR false)."

	^self value!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	(self isNull ifFalse: [aPuttableStream locale variantBool: self value]) displayOn: aPuttableStream!

value
	"Answer the receiver's value field as a Smalltalk <Boolean>."

	^super value ~= 0!

value: anObject 
	"Set the receiver's value field to the VARIANT_BOOL equivalent
	(-1 for true, 0 for false)."

	super value: (anObject asBoolean ifTrue: [-1] ifFalse: [0])! !
!OS.COM.VARIANT_BOOL categoriesFor: #asBoolean!converting!public! !
!OS.COM.VARIANT_BOOL categoriesFor: #displayOn:!printing!public! !
!OS.COM.VARIANT_BOOL categoriesFor: #value!accessing!public! !
!OS.COM.VARIANT_BOOL categoriesFor: #value:!accessing!public! !

!OS.COM.VARIANT_BOOL class methodsFor!

icon
	"Answer a suitable iconic representation for the receiver."

	^Boolean icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

typeName
	"Private - Answer the Dolphin external type name for the receiver.
	There is an appropriate built-in type which we can substitute."

	^#varbool!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil!

vt
	"Private - Answer the VARIANT type required to represent the receiver."

	^AutomationConstants.VT_BOOL! !
!OS.COM.VARIANT_BOOL class categoriesFor: #icon!constants!public! !
!OS.COM.VARIANT_BOOL class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.VARIANT_BOOL class categoriesFor: #typeName!constants!private! !
!OS.COM.VARIANT_BOOL class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!OS.COM.VARIANT_BOOL class categoriesFor: #vt!constants!private! !

