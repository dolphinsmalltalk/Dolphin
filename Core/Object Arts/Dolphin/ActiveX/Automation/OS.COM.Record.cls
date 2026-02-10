"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.COM.Record'
	instanceVariableNames: 'recordInfo'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Record guid: (Core.GUID fromString: '{4c783c74-4472-47ad-901f-ceb9de79dd8b}')!

OS.COM.Record comment: ''!

!OS.COM.Record methodsFor!

basicFree
	"Private - Free external resources owned by the receiver.
	This is a default implementation which relieves subclasses from
	the responsibility of providing both class (freeElement:) and instance 
	side (#basicFree) methods."

	self isPointerStruct
		ifTrue: [recordInfo RecordDestroy: self]
		ifFalse: [recordInfo RecordClear: self]!

byteSize
	"Answer the <integer> size in bytes of the structure wrapped by the receiver."

	^recordInfo byteSize!

copyBytes: aByteObject
	recordInfo RecordCopy: aByteObject pvNew: bytes.
	^self!

create
	bytes := recordInfo RecordCreate.
	super initialize!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	We use the name of the record as supplied by its IRecordInfo implementation."

	| name |
	name := recordInfo name.
	aPuttableStream
		nextPutAll: (name first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: name!

doesNotUnderstand: aMessage
	"Sent to the receiver by the VM when a message sent to the receiver was 
	not implemented by the receiver or its superclasses. In this case then the 
	selector of aMessage is looked up in the receiver's class' template, and 
	if found the appropriate field is retrieved/set."

	| selector args argc |
	args := aMessage arguments.
	(argc := args size) > 1 ifTrue: [^self basicDoesNotUnderstand: aMessage].
	selector := aMessage selector.
	argc == 0
		ifTrue: [^self getField: selector ifAbsent: [self basicDoesNotUnderstand: aMessage]]
		ifFalse: 
			[self
				setField: selector allButLast
				value: args first
				ifAbsent: [self basicDoesNotUnderstand: aMessage]]!

getField: fieldNameString
	"Answer the value of the named field of the receiver,
	or if there is no such field then raise a NotFoundError."

	^self getField: fieldNameString ifAbsent: [self errorNotFound: fieldNameString]!

getField: fieldNameString ifAbsent: exceptionHandler
	"Answer the value of the named field of the receiver,
	or if there is no such field then the result of evaluating the 
	<niladicValuable>, exceptionHandler."

	^recordInfo getField: fieldNameString from: self ifAbsent: exceptionHandler!

getValidFields
	"Private - Answer a <sequencedReadableCollection> of the fields defined 
	in the receiver's template, sorted in ascending order of offset from the start of the
	structure."

	^recordInfo getFieldNames!

initialize
	recordInfo RecordInit: bytes.
	super initialize!

initializeBuffer: bufferClass size: anInteger
	"Private - Ask the receiver's <IRecordInfo> to create a record buffer for the receiver. The arguments are ignored."

	"We don't know the required byteSize on the class side"
	super initializeBuffer: bufferClass size: self byteSize!

initializePointer
	"Private - Perform any initialization required for the receiver
	which is specific to the reference form. Answer the receiver.
	To perform value specific initialization, override #initialize."

	owner isNil ifTrue: [self beFinalizable]!

isFieldBrowsable: aString 
	^true!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources. Instances will always be pointer instances whether owned-internal, internal references, or external references. The resources for owned (e.g. internally created) references are allocated through IRecordInfo::RecordCreate. Internal value records are allocated as ByteArrays. Internally owned <Record>s, whether internal or external, need to be freed. Instances that reference records with another owner must not be freed. Consequently we must free if there is no other owner."

	^owner isNil and: [self notNull]!

recordClass
	"Answer an <externalStructure class> that describes the receiver's type."

	^RecordClass recordInfo: recordInfo!

recordInfo
	"Answer the receiver's <IRecordInfo> instance variable."

	^recordInfo!

setField: aString value: anObject 
	"Set the value of the named field of the receiver,
	or if there is no such field then raise a NotFoundError."

	self 
		setField: aString
		value: anObject
		ifAbsent: [self errorNotFound: aString]!

setField: fieldNameString value: newValue ifAbsent: exceptionHandler
	"Set the value of the named field of the receiver, to the
	variant value of the <variantCompatible> object, newValue,
	or if there is no such field then evaluate the <niladicValuable>, 
	exceptionHandler."

	recordInfo 
		setField: fieldNameString 
		value: newValue 
		into: self
		ifAbsent: exceptionHandler!

setRecordInfo: anIRecordInfo
	recordInfo := anIRecordInfo.
	^self! !

!OS.COM.Record categoriesForMethods!
basicFree!private!realizing/unrealizing! !
byteSize!accessing!public! !
copyBytes:!copying!private! !
create!private!realizing/unrealizing! !
displayOn:!displaying!public! !
doesNotUnderstand:!exceptions!public! !
getField:!accessing!public! !
getField:ifAbsent:!accessing!public! !
getValidFields!accessing!private! !
initialize!initializing!public! !
initializeBuffer:size:!initializing!private! !
initializePointer!initializing!private! !
isFieldBrowsable:!public! !
needsFree!private!realizing/unrealizing! !
recordClass!accessing!public! !
recordInfo!accessing!public! !
setField:value:!accessing!public! !
setField:value:ifAbsent:!accessing!public! !
setRecordInfo:!initializing!private! !
!

!OS.COM.Record class methodsFor!

clear: addressOrBytes
	"We can't free an arbitrary structure given its address, because we need to pass it back to its originating <IRecordInfo>, therefore these structures can't be stored in as values in a <StructureArray>."

	^self shouldNotImplement!

createWithInfo: anIRecordInfo
	"Answer a new instance of the receiver that wraps a structure as described by the <IRecordInfo> argument. The memory for the structure itself (not necessarily any resources it may reference) will be allocated from the Dolphin object memory as a ByteArray."

	^self basicNew
		setRecordInfo: anIRecordInfo;
		create;
		yourself!

fromAddress: anAddress owner: anObject
	"Not implementable as a <IRecordInfo> describing the receiver's layout is required. Use #fromAddress:recordInfo:"

	^self shouldNotImplement!

fromAddress: anAddress recordInfo: recInfo owner: dataOwner
	"Answer a new instance of the receiver which references the structure in memory at the <Address> 1st argument, with format described by the <IRecordInfo> 2nd argument, and which is owned by the <Object> 3rd argument."

	anAddress isNull ifTrue: [^nil].
	^self basicNew
		setRecordInfo: recInfo;
		initializeAtAddress: anAddress owner: dataOwner;
		yourself!

fromBytes: aByteObject
	"Not implementable as a <IRecordInfo> describing the receiver's layout is required. Use #fromAddress:recordInfo:"

	self shouldNotImplement!

fromBytes: aByteObject recordInfo: anIRecordInfo
	"Answer a new instance of the receiver that wraps a structure as described by the <IRecordInfo> argument with contents copied from aByteObject"

	^(self newWithInfo: anIRecordInfo)
		copyBytes: aByteObject;
		yourself!

newBuffer
	"Not implementable as a <IRecordInfo> describing the receiver's layout is required. Use #newWithInfo:"

	^self shouldNotImplement!

newWithInfo: anIRecordInfo
	"Answer a new instance of the receiver that wraps a structure as described by the <IRecordInfo> argument. The memory for the structure itself (not necessarily any resources it may reference) will be allocated from the Dolphin object memory as a ByteArray."

	^self basicNew
		setRecordInfo: anIRecordInfo;
		initializeBuffer: self bufferClass size: 0;
		yourself!

shouldRegister
	^false! !

!OS.COM.Record class categoriesForMethods!
clear:!public!realizing/unrealizing! !
createWithInfo:!instance creation!public! !
fromAddress:owner:!instance creation!public! !
fromAddress:recordInfo:owner:!instance creation!public! !
fromBytes:!instance creation!public! !
fromBytes:recordInfo:!instance creation!public! !
newBuffer!instance creation!public! !
newWithInfo:!instance creation!public! !
shouldRegister!private!testing! !
!

