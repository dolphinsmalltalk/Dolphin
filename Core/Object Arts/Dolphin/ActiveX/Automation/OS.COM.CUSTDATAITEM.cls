"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.CUSTDATAITEM'
	instanceVariableNames: 'key value'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_CUSTDATAITEM_Size' -> 16r20.
			'_OffsetOf_guid' -> 16r0.
			'_OffsetOf_varValue' -> 16r10
		}!

OS.COM.CUSTDATAITEM guid: (Core.GUID fromString: '{a72e70d7-34d7-4c65-9b12-5941c51fa3c2}')!

OS.COM.CUSTDATAITEM comment: '<CUSTDATAITEM> is an <ExternalStructure> class to wrap the struct ''OAIDL.CUSTDATAITEM'' from type information in the ''Ole Automation Type Library'' library.

CUSTDATAITEM is used to represent blocks of custom data stored in a type library.'!

!OS.COM.CUSTDATAITEM categoriesForClass!OAIDL-Structs! !

!OS.COM.CUSTDATAITEM methodsFor!

= anAssociation
	"Answer whether the receiver is equal to the argument."

	^self == anAssociation or: 
			[self species == anAssociation species
				and: [self key = anAssociation key and: [self value = anAssociation value]]]!

asObject
	^self!

guid
	"Answer the <GUID> value of the receiver's 'guid' field."

	^GUID fromAddress: bytes yourAddress!

hash
	"Answer the hash value of the receiver's key."

	^self key hash
!

key
	^key
		ifNil: 
			[| id |
			id := self guid.
			key := CUSTDATA.WellKnownCustomAttributes at: id ifAbsent: id]!

species
	^Association!

value
	^value ifNil: [value := self varValue value]!

varValue
	"Answer the <VARIANT> value of the receiver's 'varValue' field."

	^VARIANT fromAddress: bytes yourAddress + _OffsetOf_varValue! !

!OS.COM.CUSTDATAITEM categoriesForMethods!
=!comparing!public! !
asObject!public! !
guid!**compiled accessors**!public! !
hash!comparing!public! !
key!accessing!public! !
species!accessing!public! !
value!accessing!public! !
varValue!**compiled accessors**!public! !
!

!OS.COM.CUSTDATAITEM class methodsFor!

byteSize
	^_CUSTDATAITEM_Size!

defineFields
	"Define the fields of the CUSTDATAITEM structure.
		CUSTDATAITEM compileDefinition
	
		typedef 		struct tagCUSTDATAITEM {
			GUID guid;
			VARIANT varValue;
		} CUSTDATAITEM;

	"

	self
		defineField: #guid type: (StructureField type: GUID) beReadOnly;
		defineField: #varValue type: (StructureField type: VARIANT) beReadOnly!

getFieldNames
	^#(#guid #varValue)! !

!OS.COM.CUSTDATAITEM class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

