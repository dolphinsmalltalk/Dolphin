"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #ENHMETARECORD
	instanceVariableNames: ''
	classVariableNames: 'RecordTypes'
	poolDictionaries: 'EnhancedMetafileRecordTypes'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_iType' -> 16r0.
		'_OffsetOf_nSize' -> 16r4
	}!
ENHMETARECORD guid: (GUID fromString: '{5a360b92-6a3d-40d5-9d88-972ffd1416e6}')!
ENHMETARECORD comment: '<ENHMETARECORD> is an <ExternalStructure> class to wrap the base struct for all the Enhanced Metafile record structs.'!
!ENHMETARECORD categoriesForClass!Win32-Structs! !
!ENHMETARECORD methodsFor!

getField: fieldNameString 
	"Private - Answer the value of the named field of the receiver,
	or if there is no such field then raise an exception."

	| selector |
	selector := fieldNameString asSymbol.
	selector == #iType 
		ifTrue: [(EnhancedMetafileRecordTypes keyAtValue: self iType ifAbsent: []) ifNotNil: [:name | ^name]].
	^self perform: selector!

iType
	"Answer the <Integer> value of the receiver's 'iType' field."

	^bytes dwordAtOffset: _OffsetOf_iType!

iType: anInteger
	"Set the receiver's 'iType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_iType put: anInteger!

nSize
	"Answer the <Integer> value of the receiver's 'nSize' field."

	^bytes dwordAtOffset: _OffsetOf_nSize!

nSize: anInteger
	"Set the receiver's 'nSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nSize put: anInteger! !
!ENHMETARECORD categoriesFor: #getField:!accessing!private! !
!ENHMETARECORD categoriesFor: #iType!**compiled accessors**!public! !
!ENHMETARECORD categoriesFor: #iType:!**compiled accessors**!public! !
!ENHMETARECORD categoriesFor: #nSize!**compiled accessors**!public! !
!ENHMETARECORD categoriesFor: #nSize:!**compiled accessors**!public! !

!ENHMETARECORD class methodsFor!

defineFields
	"Define the fields of the EMR structure.

	self  compileDefinition

		typedef [uuid(5A360B92-6A3D-40D5-9D88-972FFD1416E6)]
		struct tagEMR {
			[helpstring('Enhanced metafile record type')] DWORD iType;
			[helpstring('Length of the record in bytes. This must be a multiple of 4.')] DWORD nSize;
		} EMR;
"

	self
		defineField: #iType type: DWORDField new offset: 0;
		defineField: #nSize type: DWORDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#iType #nSize)!

initialize
	RecordTypes := Array new: EMR_MAX!

initializeAfterLoad
	"Perform any post-load initialisation for the class.
	In this case we set up the function table now to avoid overhead of lazy init. test
	init. on every virtual function callback."

	super initializeAfterLoad.
	"Record any newly loaded subclass in the record types table"
	self == ##(self) ifFalse: [self registerRecordTypes]!

iTypes
	"Answer an collection of the integer enhanced metafile record type ids that this class can represent."

	^{EMR_ABORTPATH. EMR_BEGINPATH. EMR_ENDPATH. EMR_CLOSEFIGURE. EMR_FLATTENPATH}
		, {EMR_WIDENPATH. EMR_SETMETARGN. EMR_SAVEDC. EMR_REALIZEPALETTE}!

registerRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: self]!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class."

	self unregisterRecordTypes.
	super uninitializeBeforeRemove!

unregisterRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: nil]! !
!ENHMETARECORD class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!ENHMETARECORD class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!ENHMETARECORD class categoriesFor: #initialize!public! !
!ENHMETARECORD class categoriesFor: #initializeAfterLoad!initializing!public! !
!ENHMETARECORD class categoriesFor: #iTypes!constants!public! !
!ENHMETARECORD class categoriesFor: #registerRecordTypes!initializing!private! !
!ENHMETARECORD class categoriesFor: #uninitializeBeforeRemove!class hierarchy-removing!public! !
!ENHMETARECORD class categoriesFor: #unregisterRecordTypes!accessing!private! !

