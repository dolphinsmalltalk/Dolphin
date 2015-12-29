"Filed out from Dolphin Smalltalk X6"!

OLEStructure subclass: #BIND_OPTS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BIND_OPTS guid: (GUID fromString: '{87B4C5B3-026E-11D3-9FD7-00A0CC3E4A32}')!
BIND_OPTS comment: 'BIND_OPTS is an external structure class to represent the OLE moniker structure of the same name.

BIND_OPTS is used to specify options to be taken account of when a moniker is being bound. These options are set into the bind context with IBindCtx:::SetBindOptions, and retrived with IBindCtx::GetBindOptions.

BIND_OPTS has been superceded by BIND_OPTS2 with the advent of DCOM.'!
!BIND_OPTS categoriesForClass!External-Data-Structured-COM! !
!BIND_OPTS methodsFor!

dwSize: anObject
	"Set the receiver's dwSize field to the value of anObject.
	This method has been automatically generated from the class' structure template.
	Any modifications you make will be lost the next time it is so generated."

	bytes dwordAtOffset: 0 put: anObject!

dwTickCountDeadline
	"Answer the receiver's dwTickCountDeadline field as a Smalltalk object.
	This method has been automatically generated from the class' structure template.
	Any modifications you make will be lost the next time it is so generated."

	^(bytes dwordAtOffset: 12)!

dwTickCountDeadline: anObject
	"Set the receiver's dwTickCountDeadline field to the value of anObject.
	This method has been automatically generated from the class' structure template.
	Any modifications you make will be lost the next time it is so generated."

	bytes dwordAtOffset: 12 put: anObject!

grfFlags
	"Answer the receiver's grfFlags field as a Smalltalk object.
	This method has been automatically generated from the class' structure template.
	Any modifications you make will be lost the next time it is so generated."

	^(bytes dwordAtOffset: 4)!

grfFlags: anObject
	"Set the receiver's grfFlags field to the value of anObject.
	This method has been automatically generated from the class' structure template.
	Any modifications you make will be lost the next time it is so generated."

	bytes dwordAtOffset: 4 put: anObject!

grfMode
	"Answer the receiver's grfMode field as a Smalltalk object.
	This method has been automatically generated from the class' structure template.
	Any modifications you make will be lost the next time it is so generated."

	^(bytes dwordAtOffset: 8)!

grfMode: anObject
	"Set the receiver's grfMode field to the value of anObject.
	This method has been automatically generated from the class' structure template.
	Any modifications you make will be lost the next time it is so generated."

	bytes dwordAtOffset: 8 put: anObject! !
!BIND_OPTS categoriesFor: #dwSize:!**compiled accessors**!public! !
!BIND_OPTS categoriesFor: #dwTickCountDeadline!**compiled accessors**!public! !
!BIND_OPTS categoriesFor: #dwTickCountDeadline:!**compiled accessors**!public! !
!BIND_OPTS categoriesFor: #grfFlags!**compiled accessors**!public! !
!BIND_OPTS categoriesFor: #grfFlags:!**compiled accessors**!public! !
!BIND_OPTS categoriesFor: #grfMode!**compiled accessors**!public! !
!BIND_OPTS categoriesFor: #grfMode:!**compiled accessors**!public! !

!BIND_OPTS class methodsFor!

defineFields
	"Define the fields of the BIND_OPTS structure.

		BIND_OPTS compileDefinition.

		struct  BIND_OPTS
		{
			DWORD cbStruct;
			DWORD grfFlags;
			DWORD grfMode;
			DWORD dwTickCountDeadline;
		};
	"

	self
		"Use standard name for structure size member"
		defineField: #dwSize				type: DWORDField writeOnly beOverride;
		defineField: #grfFlags				type: DWORDField new;
		defineField: #grfMode				type: DWORDField new;
		defineField: #dwTickCountDeadline	type: DWORDField new! !
!BIND_OPTS class categoriesFor: #defineFields!initializing!public! !

