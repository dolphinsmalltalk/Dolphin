"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBDeserializer
	instanceVariableNames: 'classArray classes classesCounter classManager counter objects stream referenceManager transaction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'classArray'!
ODBDeserializer guid: (GUID fromString: '{8162edd7-0fb8-11d4-b091-000000000000}')!
ODBDeserializer comment: ''!
!ODBDeserializer categoriesForClass!No category! !
!ODBDeserializer methodsFor!

deserializeFrom: aStream referenceManager: aReferenceManager classManager: aClassManager 
	stream := aStream.
	referenceManager := aReferenceManager.
	classManager := aClassManager.
	classArray := self class classArray.
	objects := Array new: stream getLong.
	classes := OrderedCollection new: 30.
	counter := 0.
	classesCounter := 0.
	^self odbNextObject!

deserializeFrom: aStream referenceManager: aReferenceManager transaction: aTransaction 
	stream := aStream.
	referenceManager := aReferenceManager.
	classManager := aTransaction environment classManager.
	transaction := aTransaction.
	classArray := self class classArray.
	objects := Array new: stream getLong.
	classes := OrderedCollection new: 30.
	counter := 0.
	classesCounter := 0.
	^self odbNextObject!

existingObject
	^objects at: stream getPositiveInteger!

loadError
	| id |
	stream position: stream position - 1.
	id := stream getByte.
	OmniBase 
		signalError: 'OmniBase deserializer: Unknown serialization id (' , id printString , ')'!

loadReference
	^self register: (referenceManager referenceAt: stream getPositiveInteger)!

newObjectNewClass
	| classInfo |
	classInfo := classManager classDescriptionAt: stream getPositiveInteger.
	classesCounter := classesCounter + 1.
	classes add: classInfo.
	^classInfo realClass odbLoadVariables: self classInfo: classInfo!

newObjectOldClass
	| classInfo |
	^(classInfo := classes at: stream getPositiveInteger) realClass odbLoadVariables: self
		classInfo: classInfo!

odbNextObject
	^(classArray at: stream getByteOr14forUndefinedObject) odbDeserialize: self!

register: anObject 
	^objects at: (counter := counter + 1) put: anObject!

stream
	^stream!

transaction
	^transaction! !
!ODBDeserializer categoriesFor: #deserializeFrom:referenceManager:classManager:!public! !
!ODBDeserializer categoriesFor: #deserializeFrom:referenceManager:transaction:!public! !
!ODBDeserializer categoriesFor: #existingObject!private! !
!ODBDeserializer categoriesFor: #loadError!private! !
!ODBDeserializer categoriesFor: #loadReference!private! !
!ODBDeserializer categoriesFor: #newObjectNewClass!private! !
!ODBDeserializer categoriesFor: #newObjectOldClass!private! !
!ODBDeserializer categoriesFor: #odbNextObject!private! !
!ODBDeserializer categoriesFor: #register:!private! !
!ODBDeserializer categoriesFor: #stream!public! !
!ODBDeserializer categoriesFor: #transaction!private! !

!ODBDeserializer class methodsFor!

classArray
	classArray isNil ifTrue: [self init].
	^classArray!

deserializeFromBytes: aByteArray 
	| memoryStream classManager |
	memoryStream := ODBMemoryReadStream new createOn: aByteArray.
	memoryStream getPositiveInteger = 0 ifFalse: [self error: 'External references not defined'].
	classManager := ODBClassManagerForSerialization new.
	classManager loadFromStream: memoryStream.
	^self new 
		deserializeFrom: memoryStream
		referenceManager: nil
		classManager: classManager!

deserializeFromBytes: aByteArray externalReferencesLoaderBlock: aBlock 
	| memoryStream referenceManager classManager |
	memoryStream := ODBMemoryReadStream new createOn: aByteArray.
	referenceManager := ODBReferenceManager new.
	referenceManager loadFromStream: memoryStream externalReferencesLoaderBlock: aBlock.
	classManager := ODBClassManagerForSerialization new.
	classManager loadFromStream: memoryStream.
	^self new 
		deserializeFrom: memoryStream
		referenceManager: referenceManager
		classManager: classManager!

init
	classArray := Array new: 255.
	classArray
		at: 2 put: ODBNewObjectNewClass;
		at: 3 put: ODBNewObject;
		at: 4 put: ODBExistingObject;
		at: 5 put: ODBExternalReference;
		at: 6 put: ODBClassManagerForSerialization;
		at: 15 put: true;
		at: 16 put: false;
		at: 17 put: Message;
		at: 20 put: MessageSend;
		at: 19 put: Smalltalk;
		at: 22 put: Processor;
		at: 11 put: ODBLargePositiveInteger;
		at: 12 put: ODBLargeNegativeInteger;
		at: 13 put: Character;
		at: 29 put: ODBDoubleByteCharacter;
		at: 14 put: UndefinedObject;
		at: 10 put: DeadObject;
		at: 18 put: Symbol;
		at: 26 put: Class;
		at: 27 put: Metaclass;
		at: 28 put: LookupTable;
		at: 30 put: Set;
		at: 31 put: Association;
		at: 32 put: Date;
		at: 33 put: Time;
		at: 34 put: String;
		at: 35 put: Array;
		at: 36 put: UnicodeString;
		at: 37 put: Dictionary;
		at: 38 put: IdentityDictionary;
		at: 39 put: Fraction;
		at: 40 put: Float;
		at: 41 put: (ODBCopyValue value: 0.0);
		at: 42 put: (ODBCopyValue value: 1.0);
		at: 43 put: ODBFloatAsInteger;
		at: 44 put: ODBFloatAs100Integer;
		at: 45 put: ODB8ByteFloat;
		"tu je bil problem, ker je na VW 46 uporabljen za 4 byte float - scaled decimal se je tako moral migrirati na 47 za interoperability med dialekti"
		at: 46 put: ScaledDecimal;
		at: 47 put: ScaledDecimal;
		at: 50 put: 0;
		at: 51 put: 1;
		at: 52 put: 2;
		at: 53 put: 3;
		at: 54 put: 4;
		at: 55 put: 5;
		at: 56 put: 6;
		at: 57 put: 7;
		at: 58 put: 8;
		at: 59 put: 9;
		at: 60 put: 10;
		at: 61 put: 11;
		at: 62 put: 12;
		at: 63 put: 13;
		at: 64 put: 14;
		at: 65 put: 15;
		at: 66 put: 16;
		at: 67 put: -3;
		at: 68 put: -2;
		at: 69 put: -1;
		at: 70 put: ODBEmptyString;
		at: 71 put: ODB1CharacterString;
		at: 72 put: (ODBnCharacterString length: 2);
		at: 73 put: (ODBnCharacterString length: 3);
		at: 74 put: (ODBnCharacterString length: 4);
		at: 75 put: (ODBnCharacterString length: 5);
		at: 76 put: (ODBnCharacterString length: 6);
		at: 77 put: (ODBnCharacterString length: 7);
		at: 78 put: (ODBnCharacterString length: 8);
		at: 79 put: (ODBnCharacterString length: 9);
		at: 80 put: ByteArray;
		at: 81 put: OrderedCollection;
		at: 82 put: ODBIdentityDictionary;
		at: 83 put: ODBPersistentDictionary;
		at: 84 put: ODBTransaction;
		yourself
	"at: 85 put: OrPersistentObject"!

registerDeserializer: anObject withId: anInteger 
	self classArray at: anInteger put: anObject! !
!ODBDeserializer class categoriesFor: #classArray!private! !
!ODBDeserializer class categoriesFor: #deserializeFromBytes:!public! !
!ODBDeserializer class categoriesFor: #deserializeFromBytes:externalReferencesLoaderBlock:!public! !
!ODBDeserializer class categoriesFor: #init!private! !
!ODBDeserializer class categoriesFor: #registerDeserializer:withId:!public! !

