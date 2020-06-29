"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMUPDOWN
	instanceVariableNames: 'allow'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iDelta' -> 16r10.
		'_OffsetOf_iPos' -> 16rC
	}!
NMUPDOWN guid: (GUID fromString: '{425d0ea7-542e-11d3-998b-d5ca2c3c1d61}')!
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
	"Answer the <Integer> value of the receiver's 'iDelta' field."

	^bytes sdwordAtOffset: _OffsetOf_iDelta!

iPos
	"Answer the <Integer> value of the receiver's 'iPos' field."

	^bytes sdwordAtOffset: _OffsetOf_iPos!

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
		defineField: #iDelta type: SDWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iPos #iDelta)! !
!NMUPDOWN class categoriesFor: #defineFields!public!template definition! !
!NMUPDOWN class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

