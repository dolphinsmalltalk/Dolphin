"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMUPDOWN
	instanceVariableNames: 'allow'
	classVariableNames: '_OffsetOf_iDelta _OffsetOf_iPos'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMUPDOWN guid: (GUID fromString: '{425d0ea7-542e-11d3-998b-d5ca2c3c1d61}')!

NMUPDOWN addClassConstant: '_OffsetOf_iDelta' value: 16r10!
NMUPDOWN addClassConstant: '_OffsetOf_iPos' value: 16rC!

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

!NMUPDOWN categoriesForMethods!
allow!accessing!public! !
allow:!accessing!public! !
iDelta!**compiled accessors**!public! !
iPos!**compiled accessors**!public! !
newPosition!accessing!public! !
!

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

!NMUPDOWN class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

