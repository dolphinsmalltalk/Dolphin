"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'OS.COM.RecordClass'
	instanceVariableNames: 'recordInfo'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.RecordClass guid: (Core.GUID fromString: '{84cd04d7-31b6-48dd-b68f-05ab27312826}')!

OS.COM.RecordClass comment: ''!

!OS.COM.RecordClass methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument are considered equivalent."

	^anObject == self or: [anObject species == self species and: [anObject guid = self guid]]!

alignment
	"Answer the natural alignment for instances of the receiver when embedded in arrays or other structures. This should be the natural alignment of the largest field in the receiver."

	^recordInfo typeInfo
		ifNil: 
			[#todo.	"Can we do better here"
			4]
		ifNotNil: [:typeInfo | typeInfo attributes cbAlignment]!

atAddress: anAddress owner: anObject
	"Answer a new instance of the receiver instantiated from the	data at the specified address. This will be a 'reference' instance of <Record>, that points at the data embedded at the specified address."

	^self fromAddress: anAddress owner: anObject!

clear: addressOrBytes
	"Finalize an instance of the structure which instances of the receiver wrap which resides at the specified address. Note that this is typically not about freeing the specified memory block, but any resources which it references."

	recordInfo RecordClear: addressOrBytes!

elementSize
	"Answer the <integer> size in bytes of the structure described by the receiver."

	^recordInfo byteSize!

fromAddress: anAddress
	"Answer a new instance that points to the ExternalAddress respresented by anAddress (which responds to the protocol #isNull and #asExternalAddress). The new instance will be considered to own the referenced memory. If anAddress is the null pointer then the answer is nil. This behaviour is useful when referencing an ExternalStructure from a PointerField, since such pointers are commonly Null."
	
	^self fromAddress: anAddress owner: anAddress!

fromAddress: anAddress owner: anObject
	"Answer a new Record for the receiver's <IRecordInfo> that points to the ExternalAddress respresented by anAddress (which responds to the protocol #isNull and #asExternalAddress). The new instance will be a reference structure pointing at resources owned by anObject."

	^Record
		fromAddress: anAddress
		recordInfo: recordInfo
		owner: anObject!

fromBytes: aByteObject
	"Answer a new Record for the receiver's <IRecordInfo> with contents copied from aByteObject. The new instance will own the new record."

	^Record fromBytes: aByteObject recordInfo: recordInfo!

guid
	"Answer the <GUID> of the structure the receiver describes."

	^recordInfo guid!

hash
	"Answer the <integer> hash value for the receiver. By default use the identity hash assigned
	at object creation time, which is temporally invariant. See #identityHash for more details."

	^self guid hash!

init: addressOrBytes
	"Initialize a buffer (or buffer at the specified address) to hold an instance of the record type described by the receiver. Assumes that the memory is completely uninitialized."

	recordInfo RecordInit: addressOrBytes!

marshal: aRecord 
	aRecord recordInfo guid = self guid ifFalse: [HRESULTError signalWith: AutomationErrors.DISP_E_TYPEMISMATCH].
	^aRecord!

name
	"Answer a <readableString> that is the name of the record class described by the receiver."

	^recordInfo name!

newBuffer
	"Answer a new Record for the receiver's <IRecordInfo> containing its own buffer."

	^Record newWithInfo: recordInfo!

recordInfo
	^recordInfo!

recordInfo: anIRecordInfo
	recordInfo := anIRecordInfo!

requiresFinalization
	"Answer whether instances of the receiver that own their own resources will require free'ing either explicitly or by finalization.
	Internally owned instances will require `RecordClear`."

	^true!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's type when represented in a <VARIANT>."

	^VT_RECORD! !

!OS.COM.RecordClass categoriesForMethods!
=!comparing!public! !
alignment!accessing!public! !
atAddress:owner:!instance creation!public! !
clear:!public!realizing/unrealizing! !
elementSize!accessing!public! !
fromAddress:!instance creation!public! !
fromAddress:owner:!instance creation!public! !
fromBytes:!instance creation!public! !
guid!accessing!public! !
hash!comparing!public! !
init:!initializing!public! !
marshal:!instance creation!public! !
name!accessing!public! !
newBuffer!instance creation!public! !
recordInfo!accessing!private! !
recordInfo:!initializing!private! !
requiresFinalization!public!testing! !
vt!public! !
!

OS.COM.RecordClass methodProtocol: #'externalStructure class' attributes: #(#readOnly) selectors: #(#alignment #atAddress:owner: #byteSize #clear: #elementSize #fromAddress: #fromAddress:owner: #fromBytes: #guid #init: #name #newBuffer #requiresFinalization)!

!OS.COM.RecordClass class methodsFor!

recordInfo: anIRecordInfo
	^self new
		recordInfo: anIRecordInfo;
		yourself! !

!OS.COM.RecordClass class categoriesForMethods!
recordInfo:!accessing!public! !
!

