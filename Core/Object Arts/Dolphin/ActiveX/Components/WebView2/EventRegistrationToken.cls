"Filed out from Dolphin Smallalk"!

ExternalStructure subclass: #EventRegistrationToken
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_value'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EventRegistrationToken guid: (GUID fromString: '{39b36683-b3d3-4776-ad98-768489ab53fd}')!
EventRegistrationToken addClassConstant: '_OffsetOf_value' value: 16r0!
EventRegistrationToken comment: '`EventRegistrationToken` is an `ExternalStructure` class to wrap the struct ''WebView2.EventRegistrationToken'' from type information in the '''' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagEventRegistrationToken {
	__int64 value;
} EventRegistrationToken;
```
'!
!EventRegistrationToken categoriesForClass!WebView2-Structs! !
!EventRegistrationToken methodsFor!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes sqwordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes sqwordAtOffset: _OffsetOf_value put: anInteger! !
!EventRegistrationToken categoriesForMethods!
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!EventRegistrationToken class methodsFor!

defineFields
	"Define the fields of the EventRegistrationToken structure.

	EventRegistrationToken compileDefinition

		typedef 
		struct tagEventRegistrationToken {
			__int64 value;
		} EventRegistrationToken;
"

	self
		defineField: #value type: SQWORDField new offset: 0.
	self byteSize: 8!

getFieldNames
	^#(#value)! !
!EventRegistrationToken class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

