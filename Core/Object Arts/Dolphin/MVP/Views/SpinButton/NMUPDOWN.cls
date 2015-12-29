"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #NMUPDOWN
	instanceVariableNames: 'allow'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMUPDOWN guid: (GUID fromString: '{425D0EA7-542E-11D3-998B-D5CA2C3C1D61}')!
NMUPDOWN comment: '<NMUPDOWN> is an <ExternalStructure> class to wrap the struct ''UpDownLib.NMUPDOWN'' from type information in the ''Microsoft Windows Up-Down Control'' library.

NMUPDOWN accompanies the UDN_DELTAPOS notifications that are sent by an up-down control to its parent when it has been nudged and is about to change its value. The notification is forwarded as a #nudge: event off the <SpinButton> view''s presenter.

IDL definition follows:

typedef struct tagNMUPDOWN {
	nmhdr hdr;
	int iPos;
	int iDelta;
} NMUPDOWN;
'!
!NMUPDOWN categoriesForClass!External-Data-Structured-Win32! !
!NMUPDOWN methodsFor!

allow
	"Answer whether the action associated with this notification should be permitted to proceed."

	^allow!

allow: aBoolean 
	"Set whether the action associated with this notification should be permitted to proceed."

	allow := aBoolean!

iDelta
	"Answer the receiver's iDelta field as a Smalltalk object."

	^(bytes sdwordAtOffset: 16)!

iPos
	"Answer the receiver's iPos field as a Smalltalk object."

	^(bytes sdwordAtOffset: 12)!

newPosition
	"Answer the position at which the <SpinButton> will end up should the nudge described by the
	receiver be accepted."

	^self iPos + self iDelta! !
!NMUPDOWN categoriesFor: #allow!accessing!public! !
!NMUPDOWN categoriesFor: #allow:!accessing!public! !
!NMUPDOWN categoriesFor: #iDelta!**compiled accessors**!public! !
!NMUPDOWN categoriesFor: #iPos!**compiled accessors**!public! !
!NMUPDOWN categoriesFor: #newPosition!accessing!public! !

!NMUPDOWN class methodsFor!

defineFields
	"Define the fields of the NMUPDOWN structure.
		NMUPDOWN compileDefinition
	
		typedef 		struct tagNMUPDOWN {
			nmhdr hdr;
			int iPos;
			int iDelta;
		} NMUPDOWN;
	"

	super defineFields.
	self
		defineField: #iPos type: SDWORDField readOnly;
		defineField: #iDelta type: SDWORDField readOnly! !
!NMUPDOWN class categoriesFor: #defineFields!initializing!public! !

