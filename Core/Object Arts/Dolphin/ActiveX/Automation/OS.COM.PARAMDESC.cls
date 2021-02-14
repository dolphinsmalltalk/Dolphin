"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.PARAMDESC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_pparamdescex' -> 16r0.
		'_OffsetOf_wParamFlags' -> 16r4
	}!
OS.COM.PARAMDESC guid: (Core.GUID fromString: '{c06f3b73-0868-11d3-93af-00a024ca708a}')!
OS.COM.PARAMDESC comment: 'PARAMDESC is an <ExternalStructure> to represent the AX Automation structure of the same name.

The PARAMDESC structure is used, one per argument, to describe the parameters to a function belonging to either an [disp]interface or a module in a type library. The information includes certain (but not all) IDL flags, as well as the argument
type and default value, if any.

Fields:
	pparamdescex	<PARAMDESCEX*> pointer to a struct with default value for the parameter, if any.
	wParamFlags	<WORD> various flags describing the parameter, such as whether it is [in] or [out].'!
!OS.COM.PARAMDESC categoriesForClass!External-Data-Structured-COM! !
!OS.COM.PARAMDESC methodsFor!

defaultValue
	"Answer the <VARIANT> default value for the receiver,
	or nil if the receiver doesn't have a default value."

	^self hasDefaultValue ifTrue: [self pparamdescex varDefaultValue]!

directionFlags
	^self wParamFlags bitAnd: ##(PARAMFLAG_FIN | PARAMFLAG_FOUT)!

hasDefaultValue
	"Answer whether the receiver has a default value."

	^self wParamFlags anyMask: PARAMFLAG_FHASDEFAULT!

isIn
	"Answer whether the receiver is describing an input argument.
	Note that it is possible for the direction not to be specified, in which case one
	must assume both."

	| flags |
	flags := self directionFlags.
	^flags == PARAMFLAG_NONE or: [flags anyMask: PARAMFLAG_FIN]!

isOptional
	"Answer whether the receiver is describing a an optional parameter."

	^self wParamFlags anyMask: PARAMFLAG_FOPT!

isOut
	"Answer whether the receiver is describing an output argument.
	Note that it is possible for the direction not to be specified, in which case we
	assume that it is for input only (is this right?)"

	| flags |
	flags := self directionFlags.
	^flags anyMask: PARAMFLAG_FOUT!

isRetVal
	"Answer whether the receiver is describing a retval (i.e. return value) argument."

	^self wParamFlags anyMask: PARAMFLAG_FRETVAL!

pparamdescex
	"Answer the <PARAMDESCEX> value of the receiver's 'pparamdescex' field."

	^PARAMDESCEX fromAddress: (bytes intPtrAtOffset: _OffsetOf_pparamdescex)!

wParamFlags
	"Answer the <Integer> value of the receiver's 'wParamFlags' field."

	^bytes wordAtOffset: _OffsetOf_wParamFlags! !
!OS.COM.PARAMDESC categoriesFor: #defaultValue!accessing!public! !
!OS.COM.PARAMDESC categoriesFor: #directionFlags!public!testing! !
!OS.COM.PARAMDESC categoriesFor: #hasDefaultValue!public!testing! !
!OS.COM.PARAMDESC categoriesFor: #isIn!public!testing! !
!OS.COM.PARAMDESC categoriesFor: #isOptional!public!testing! !
!OS.COM.PARAMDESC categoriesFor: #isOut!public!testing! !
!OS.COM.PARAMDESC categoriesFor: #isRetVal!public!testing! !
!OS.COM.PARAMDESC categoriesFor: #pparamdescex!**compiled accessors**!public! !
!OS.COM.PARAMDESC categoriesFor: #wParamFlags!**compiled accessors**!public! !

!OS.COM.PARAMDESC class methodsFor!

defineFields
	"Define the fields of the PARAMDESC structure.

		PARAMDESC compileDefinition.

		struct PARAMDESC
		{
			LPPARAMDESCEX pparamdescex;
			USHORT wParamFlags;
		};
	"

	self
		defineField: #pparamdescex type: (PointerField type: PARAMDESCEX) beReadOnly;
		defineField: #wParamFlags type: WORDField readOnly!

getFieldNames
	^#(#pparamdescex #wParamFlags)! !
!OS.COM.PARAMDESC class categoriesFor: #defineFields!public!template definition! !
!OS.COM.PARAMDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

