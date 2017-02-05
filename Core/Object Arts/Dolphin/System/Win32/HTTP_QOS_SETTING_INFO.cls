"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_QOS_SETTING_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_QOS_SETTING_INFO guid: (GUID fromString: '{A0BCEFE3-D299-4E8A-9C7A-6E753A441AD6}')!
HTTP_QOS_SETTING_INFO comment: '<HTTP_QOS_SETTING_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_QOS_SETTING_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains information about a QOS setting."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A0BCEFE3-D299-4E8A-9C7A-6E753A441AD6), helpstring("Contains information about a QOS setting.")]
struct tagHTTP_QOS_SETTING_INFO {
	HTTP_QOS_SETTING_TYPE QosType;
	void* QosSetting;
} HTTP_QOS_SETTING_INFO;
'!
!HTTP_QOS_SETTING_INFO categoriesForClass!Win32-Structs! !
!HTTP_QOS_SETTING_INFO methodsFor!

QosSetting
	"Answer the receiver's QosSetting field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #QosSetting)) asExternalAddress!

QosSetting: anObject
	"Set the receiver's QosSetting field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #QosSetting) put: anObject!

QosType
	"Answer the receiver's QosType field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

QosType: anObject
	"Set the receiver's QosType field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosSetting!**compiled accessors**!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosSetting:!**compiled accessors**!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosType!**compiled accessors**!public! !
!HTTP_QOS_SETTING_INFO categoriesFor: #QosType:!**compiled accessors**!public! !

!HTTP_QOS_SETTING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_QOS_SETTING_INFO structure.

	HTTP_QOS_SETTING_INFO  compileDefinition

		typedef [uuid(A0BCEFE3-D299-4E8A-9C7A-6E753A441AD6), helpstring('Contains information about a QOS setting.')]
		struct tagHTTP_QOS_SETTING_INFO {
			HTTP_QOS_SETTING_TYPE QosType;
			void* QosSetting;
		} HTTP_QOS_SETTING_INFO;
"

	self
		defineField: #QosType type: SDWORDField new offset: 0;
		defineField: #QosSetting type: LPVOIDField new offset: 4.
	self byteSize: 8! !
!HTTP_QOS_SETTING_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

