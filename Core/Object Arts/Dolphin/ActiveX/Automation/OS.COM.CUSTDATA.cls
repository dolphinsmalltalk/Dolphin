"Filed out from Dolphin Smalltalk"!

OS.COM.FinalizableStructure
	subclass: #'OS.COM.CUSTDATA'
	instanceVariableNames: 'associations table'
	classVariableNames: 'WellKnownCustomAttributes'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_CUSTDATA_Size' -> 16r8.
			'_OffsetOf_cCustData' -> 16r0.
			'_OffsetOf_prgCustData' -> 16r4
		}!
OS.COM.CUSTDATA guid: (Core.GUID fromString: '{c06f3b7b-0868-11d3-93af-00a024ca708a}')!
OS.COM.CUSTDATA comment: '<CUSTDATA> is an <ExternalStructure> class to wrap the struct ''OAIDL.CUSTDATA'' from type information in the ''Ole Automation Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!OS.COM.CUSTDATA categoriesForClass!External-Data-Structured-COM! !
!OS.COM.CUSTDATA methodsFor!

associations
	"Answer a <Collection> containing the receiver's CUSTDATAITEMs, which are associations between a key and a value. The underlying keys are GUIDs. For some well known cases the GUIDs are mapped to symbols. The values are VARIANTs."

	^associations ifNil: [associations := self prgCustData asArray]!

at: aSymbolOrGuid
	"Answer the value at the specified <Object> key in the receiver, or if the key	is not found raise a <NotFoundError>."

	"Note that there can be multiple custom attributes with the same GUID in the cust data. Which of the values is returned when there are multiple occurrences of the same attribute is undefined."

	^self table at: aSymbolOrGuid!

at: aSymbolOrGuid ifAbsent: aNiladicValuable 
	"Answer the value named by the <Object> argument, key.  If key is not found, answer the result of evaluating the <niladicValuable>, operation."

	^self table at: aSymbolOrGuid ifAbsent: aNiladicValuable!

cCustData
	"Private - Answer the <Integer> value of the receiver's 'cCustData' field."

	^bytes uint32AtOffset: _OffsetOf_cCustData!

includesKey: aSymbolOrGuid
	"Answer whether the receiver has at least one attribute with the specified identifier."

	^self table includesKey: aSymbolOrGuid!

isEmpty
	"Answer whether the receiver contains no elements."

	^self cCustData == 0!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each key/value pair in the receiver.
	The key/values pairs are visited in an arbitray order.
	Implementation Note: Could use #associationsDo:, but performance important here."

	self associations do: [:each | operation value: each key value: each value]!

notEmpty
	"Answer whether the receiver contains any elements."

	^self isEmpty not!

prgCustData
	"Private - Answer the <StructureArray> value of the receiver's 'prgCustData' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_prgCustData)
		length: self cCustData
		elementClass: CUSTDATAITEM!

table
	^table ifNil: [table := Dictionary withAll: self associations]! !
!OS.COM.CUSTDATA categoriesForMethods!
associations!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
cCustData!**compiled accessors**!private! !
includesKey:!public!searching! !
isEmpty!public!testing! !
keysAndValuesDo:!enumerating!public! !
notEmpty!public!testing! !
prgCustData!**compiled accessors**!private! !
table!private! !
!

!OS.COM.CUSTDATA class methodsFor!

byteSize
	^_CUSTDATA_Size!

clear: addressOrBytes
	OleAut32 clearCustData: addressOrBytes!

defineFields
	"Define the fields of the CUSTDATA structure.
		CUSTDATA compileDefinition
	
		typedef 		struct tagCUSTDATA {
			unsigned long cCustData;
			CUSTDATAITEM* prgCustData;
		} CUSTDATA;

	"

	self
		defineField: #cCustData type: UInt32Field readOnly beNonBrowsable;
		defineField: #prgCustData
			type: (StructureArrayPointerField type: CUSTDATAITEM
					arrayLength: (ConformantArrayFieldLength lengthField: #cCustData)) beReadOnly!

getFieldNames
	^#(#cCustData #prgCustData)!

initialize
	"Define some custom attributes. This allows us to work around the limitiations of type libraries in not supporting certain key IDL attributes that are required to correctly describe C structures; size_is and length_is are not supported at all, and 'string' cannot be applied to fixed or conformant arrays of characters (only pointers). We can also use it to introduce some extra useful features, such as the ability to specify a method category for library functions.
		self initialize
	"

	WellKnownCustomAttributes := LookupTable new.
	WellKnownCustomAttributes
		at: (GUID fromString: '{664f8323-a768-4acc-a2c8-8fa05d138897}') put: #string;
		at: (GUID fromString: '{82a85647-bd20-4075-823b-d9758c4391eb}') put: #length_is;
		at: (GUID fromString: '{be29f9d9-7844-49e1-aacb-8e19386529df}') put: #size_is;
		at: (GUID fromString: '{8e229a94-5e3f-45bd-88bd-06d9f8fef430}') put: #__errno;
		at: (GUID fromString: '{905342e6-276b-4ca5-84cf-9e714b8e40e3}') put: #__category;
		shrink! !
!OS.COM.CUSTDATA class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!public! !
!

