"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #GETTEXTEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GETTEXTEX guid: (GUID fromString: '{1ac7d35c-befe-4c13-b0b2-0c96f50feca0}')!
GETTEXTEX comment: ''!
!GETTEXTEX categoriesForClass!External-Data-Structured-Win32! !
!GETTEXTEX methodsFor!

cb
	"Answer the <Integer> value of the receiver's 'cb' field."

	^bytes dwordAtOffset: 0!

cb: anInteger
	"Set the receiver's 'cb' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

codepage: anInteger
	"Set the receiver's 'codepage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #codepage) put: anInteger!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger! !
!GETTEXTEX categoriesFor: #cb!**compiled accessors**!public! !
!GETTEXTEX categoriesFor: #cb:!**compiled accessors**!public! !
!GETTEXTEX categoriesFor: #codepage:!**compiled accessors**!public! !
!GETTEXTEX categoriesFor: #flags:!**compiled accessors**!public! !

!GETTEXTEX class methodsFor!

defineFields
	"Define the fields of the GETTEXTEX structure.
		self compileDefinition
	"

	self
		defineField: #cb type: DWORDField new;
		defineField: #flags type: DWORDField writeOnly;
		defineField: #codepage type: DWORDField writeOnly;
		defineField: #lpDefaultChar type: (PointerField type: String) beFiller;
		defineField: #lpUsedDefChar type: (PointerField type: BOOL) beFiller!

getFieldNames
	^#(#cb #flags #codepage)! !
!GETTEXTEX class categoriesFor: #defineFields!initializing!public! !
!GETTEXTEX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

