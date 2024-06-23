"Filed out from Dolphin Smalltalk"!

OS.NMHDR
	subclass: #'OS.NMUPDOWN'
	instanceVariableNames: 'allow'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_NMUPDOWN_Size' -> 16r14. '_OffsetOf_iDelta' -> 16r10. '_OffsetOf_iPos' -> 16rC }!

OS.NMUPDOWN guid: (Core.GUID fromString: '{425d0ea7-542e-11d3-998b-d5ca2c3c1d61}')!

OS.NMUPDOWN comment: '<NMUPDOWN> is an <ExternalStructure> class to wrap the struct ''UpDownLib.NMUPDOWN'' from type information in the ''Microsoft Windows Up-Down Control'' library.

NMUPDOWN accompanies the UDN_DELTAPOS notifications that are sent by an up-down control to its parent when it has been nudged and is about to change its value. The notification is forwarded as a #nudge: event off the <SpinButton> view''s presenter.

IDL definition follows:

typedef struct tagNMUPDOWN {
	nmhdr hdr;
	int iPos;
	int iDelta;
} NMUPDOWN;
'!

!OS.NMUPDOWN categoriesForClass!External-Data-Structured-Win32! !

!OS.NMUPDOWN methodsFor!

allow
	"Answer whether the action associated with this notification should be permitted to proceed."

	^allow!

allow: aBoolean 
	"Set whether the action associated with this notification should be permitted to proceed."

	allow := aBoolean!

iDelta
	"Answer the <Integer> value of the receiver's 'iDelta' field."

	^bytes int32AtOffset: _OffsetOf_iDelta!

iPos
	"Answer the <Integer> value of the receiver's 'iPos' field."

	^bytes int32AtOffset: _OffsetOf_iPos!

newPosition
	"Answer the position at which the <SpinButton> will end up should the nudge described by the
	receiver be accepted."

	^self iPos + self iDelta! !

!OS.NMUPDOWN categoriesForMethods!
allow!accessing!public! !
allow:!accessing!public! !
iDelta!**compiled accessors**!public! !
iPos!**compiled accessors**!public! !
newPosition!accessing!public! !
!

!OS.NMUPDOWN class methodsFor!

byteSize
	^_NMUPDOWN_Size!

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
		defineField: #iPos type: Int32Field readOnly;
		defineField: #iDelta type: Int32Field readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iPos #iDelta)! !

!OS.NMUPDOWN class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

