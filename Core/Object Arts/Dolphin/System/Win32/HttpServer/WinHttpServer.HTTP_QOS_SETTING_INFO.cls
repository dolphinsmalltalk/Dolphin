"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_QOS_SETTING_INFO'
	instanceVariableNames: 'setting'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_QosSetting' -> 16r4.
		'_OffsetOf_QosType' -> 16r0
	}!
WinHttpServer.HTTP_QOS_SETTING_INFO guid: (Core.GUID fromString: '{a0bcefe3-d299-4e8a-9c7a-6e753a441ad6}')!
WinHttpServer.HTTP_QOS_SETTING_INFO comment: '`HTTP_QOS_SETTING_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_QOS_SETTING_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Contains information about a QOS setting."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(a0bcefe3-d299-4e8a-9c7a-6e753a441ad6), helpstring("Contains information about a QOS setting.")]
struct tagHTTP_QOS_SETTING_INFO {
	HTTP_QOS_SETTING_TYPE QosType;
	PVOID QosSetting;
} HTTP_QOS_SETTING_INFO;
```
'!
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_QOS_SETTING_INFO methodsFor!

printFields: aCollection on: aStream
	self value ifNotNil: [:val | val printFieldsOn: aStream]!

propertyId
	^self class propertyId!

QosSetting
	"Answer the <Address> value of the receiver's 'QosSetting' field."

	^(bytes uintPtrAtOffset: _OffsetOf_QosSetting) asExternalAddress!

QosSetting: anAddress
	"Set the receiver's 'QosSetting' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_QosSetting put: anAddress!

QosType
	"Answer the <Integer> value of the receiver's 'QosType' field."

	^bytes sdwordAtOffset: _OffsetOf_QosType!

QosType: anInteger
	"Set the receiver's 'QosType' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_QosType put: anInteger!

value
	^setting
		ifNil: 
			[setting := (##({HTTP_BANDWIDTH_LIMIT_INFO. HTTP_CONNECTION_LIMIT_INFO. HTTP_FLOWRATE_INFO})
						at: self QosType + 1) fromAddress: self QosSetting]!

value: aHttpQosPropertyInfo
	setting := aHttpQosPropertyInfo.
	self
		QosType: aHttpQosPropertyInfo qosType;
		QosSetting: aHttpQosPropertyInfo yourAddress! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #printFields:on:!development!printing!private! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #propertyId!constants!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #QosSetting!**compiled accessors**!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #QosSetting:!**compiled accessors**!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #QosType!**compiled accessors**!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #QosType:!**compiled accessors**!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #value!accessing!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO categoriesFor: #value:!accessing!public! !

!WinHttpServer.HTTP_QOS_SETTING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_QOS_SETTING_INFO structure.

	HTTP_QOS_SETTING_INFO compileDefinition

		typedef [uuid(a0bcefe3-d299-4e8a-9c7a-6e753a441ad6), helpstring('Contains information about a QOS setting.')]
		struct tagHTTP_QOS_SETTING_INFO {
			HTTP_QOS_SETTING_TYPE QosType;
			PVOID QosSetting;
		} HTTP_QOS_SETTING_INFO;
"

	self
		defineField: #QosType type: SDWORDField new offset: 0;
		defineField: #QosSetting type: LPVOIDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#QosType #QosSetting)!

maxBandwidth: anInteger
	^self qosSetting: (HTTP_BANDWIDTH_LIMIT_INFO maxBandwidth: anInteger)!

maxConnections: anInteger
	^self qosSetting: (HTTP_CONNECTION_LIMIT_INFO maxConnections: anInteger)!

propertyId
	^HttpServerQosProperty!

qosSetting: anHttpQosSetting
	^(self new)
		value: anHttpQosSetting;
		yourself! !
!WinHttpServer.HTTP_QOS_SETTING_INFO class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_QOS_SETTING_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!WinHttpServer.HTTP_QOS_SETTING_INFO class categoriesFor: #maxBandwidth:!instance creation!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO class categoriesFor: #maxConnections:!instance creation!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO class categoriesFor: #propertyId!constants!public! !
!WinHttpServer.HTTP_QOS_SETTING_INFO class categoriesFor: #qosSetting:!instance creation!public! !

