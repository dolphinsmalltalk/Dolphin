"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ENHMETARECORD
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_iType _OffsetOf_nSize RecordTypes'
	poolDictionaries: 'EnhancedMetafileRecordTypes'
	classInstanceVariableNames: ''!

ENHMETARECORD guid: (GUID fromString: '{5a360b92-6a3d-40d5-9d88-972ffd1416e6}')!

ENHMETARECORD addClassConstant: '_OffsetOf_iType' value: 16r0!
ENHMETARECORD addClassConstant: '_OffsetOf_nSize' value: 16r4!

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

!ENHMETARECORD categoriesForMethods!
getField:!accessing!private! !
iType!**compiled accessors**!public! !
iType:!**compiled accessors**!public! !
nSize!**compiled accessors**!public! !
nSize:!**compiled accessors**!public! !
!

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

	^(Array 
		with: EMR_ABORTPATH
		with: EMR_BEGINPATH
		with: EMR_ENDPATH
		with: EMR_CLOSEFIGURE
		with: EMR_FLATTENPATH) , (Array 
					with: EMR_WIDENPATH
					with: EMR_SETMETARGN
					with: EMR_SAVEDC
					with: EMR_REALIZEPALETTE)!

registerRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: self]!

uninitializeBeforeRemove
	"Perform any pre-removal uninitialisation for the class."

	self unregisterRecordTypes.
	super uninitializeBeforeRemove!

unregisterRecordTypes
	self iTypes do: [:each | RecordTypes at: each put: nil]! !

!ENHMETARECORD class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!public! !
initializeAfterLoad!initializing!public! !
iTypes!constants!public! !
registerRecordTypes!initializing!private! !
uninitializeBeforeRemove!class hierarchy-removing!public! !
unregisterRecordTypes!accessing!private! !
!

