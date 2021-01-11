"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'WebView2.EventRegistrationToken'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_value' -> 16r0
	}!
WebView2.EventRegistrationToken guid: (Core.GUID fromString: '{cdf4d17f-a0a2-49eb-b754-e21f0502ac91}')!
WebView2.EventRegistrationToken comment: '`EventRegistrationToken` is an `External.Structure` class to wrap the struct ''WebView2.EventRegistrationToken'' from type information in the '''' library.

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
!WebView2.EventRegistrationToken categoriesForClass!WebView2-Structs! !
!WebView2.EventRegistrationToken methodsFor!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes sqwordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes sqwordAtOffset: _OffsetOf_value put: anInteger! !
!WebView2.EventRegistrationToken categoriesFor: #value!**compiled accessors**!public! !
!WebView2.EventRegistrationToken categoriesFor: #value:!**compiled accessors**!public! !

!WebView2.EventRegistrationToken class methodsFor!

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
!WebView2.EventRegistrationToken class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WebView2.EventRegistrationToken class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

