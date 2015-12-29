"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #Xml_error
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Xml_error guid: (GUID fromString: '{7E913D96-5F75-43D3-A963-8410C627C14E}')!
Xml_error comment: '<Xml_error> is an <ExternalStructure> class to wrap the struct ''MSXML2.xml_error'' from type information in the ''Microsoft XML, v4.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagxml_error {
	unsigned int _nLine;
	BSTR _pchBuf;
	unsigned int _cchBuf;
	unsigned int _ich;
	BSTR _pszFound;
	BSTR _pszExpected;
	unsigned long _reserved1;
	unsigned long _reserved2;
} xml_error;
'!
!Xml_error categoriesForClass!MSXML2-Structs! !
!Xml_error methodsFor!

_cchBuf
	"Answer the receiver's _cchBuf field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

_cchBuf: anObject
	"Set the receiver's _cchBuf field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

_ich
	"Answer the receiver's _ich field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

_ich: anObject
	"Set the receiver's _ich field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

_nLine
	"Answer the receiver's _nLine field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

_nLine: anObject
	"Set the receiver's _nLine field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

_pchBuf
	"Answer the receiver's _pchBuf field as a Smalltalk object."

	^(bytes dwordAtOffset: 4) asExternalAddress!

_pchBuf: anObject
	"Set the receiver's _pchBuf field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

_pszExpected
	"Answer the receiver's _pszExpected field as a Smalltalk object."

	^(bytes dwordAtOffset: 20) asExternalAddress!

_pszExpected: anObject
	"Set the receiver's _pszExpected field to the value of anObject."

	bytes dwordAtOffset: 20 put: anObject!

_pszFound
	"Answer the receiver's _pszFound field as a Smalltalk object."

	^(bytes dwordAtOffset: 16) asExternalAddress!

_pszFound: anObject
	"Set the receiver's _pszFound field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

_reserved1
	"Answer the receiver's _reserved1 field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

_reserved1: anObject
	"Set the receiver's _reserved1 field to the value of anObject."

	bytes dwordAtOffset: 24 put: anObject!

_reserved2
	"Answer the receiver's _reserved2 field as a Smalltalk object."

	^(bytes dwordAtOffset: 28)!

_reserved2: anObject
	"Set the receiver's _reserved2 field to the value of anObject."

	bytes dwordAtOffset: 28 put: anObject! !
!Xml_error categoriesFor: #_cchBuf!**compiled accessors**!public! !
!Xml_error categoriesFor: #_cchBuf:!**compiled accessors**!public! !
!Xml_error categoriesFor: #_ich!**compiled accessors**!public! !
!Xml_error categoriesFor: #_ich:!**compiled accessors**!public! !
!Xml_error categoriesFor: #_nLine!**compiled accessors**!public! !
!Xml_error categoriesFor: #_nLine:!**compiled accessors**!public! !
!Xml_error categoriesFor: #_pchBuf!**compiled accessors**!public! !
!Xml_error categoriesFor: #_pchBuf:!**compiled accessors**!public! !
!Xml_error categoriesFor: #_pszExpected!**compiled accessors**!public! !
!Xml_error categoriesFor: #_pszExpected:!**compiled accessors**!public! !
!Xml_error categoriesFor: #_pszFound!**compiled accessors**!public! !
!Xml_error categoriesFor: #_pszFound:!**compiled accessors**!public! !
!Xml_error categoriesFor: #_reserved1!**compiled accessors**!public! !
!Xml_error categoriesFor: #_reserved1:!**compiled accessors**!public! !
!Xml_error categoriesFor: #_reserved2!**compiled accessors**!public! !
!Xml_error categoriesFor: #_reserved2:!**compiled accessors**!public! !

!Xml_error class methodsFor!

defineFields
	"Define the fields of the xml_error structure.
		Xml_error compileDefinition
	
		typedef 
		struct tagxml_error {
			unsigned int _nLine;
			BSTR _pchBuf;
			unsigned int _cchBuf;
			unsigned int _ich;
			BSTR _pszFound;
			BSTR _pszExpected;
			unsigned long _reserved1;
			unsigned long _reserved2;
		} xml_error;
"

	self
		defineField: #_nLine type: DWORDField new offset: 0;
		defineField: #_pchBuf type: LPVOIDField new offset: 4;
		defineField: #_cchBuf type: DWORDField new offset: 8;
		defineField: #_ich type: DWORDField new offset: 12;
		defineField: #_pszFound type: LPVOIDField new offset: 16;
		defineField: #_pszExpected type: LPVOIDField new offset: 20;
		defineField: #_reserved1 type: DWORDField new offset: 24;
		defineField: #_reserved2 type: DWORDField new offset: 28.
	self byteSize: 32! !
!Xml_error class categoriesFor: #defineFields!**auto generated**!initializing!public! !

