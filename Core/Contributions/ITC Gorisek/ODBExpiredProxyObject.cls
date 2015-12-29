"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBExpiredProxyObject
	instanceVariableNames: 'oid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBExpiredProxyObject guid: (GUID fromString: '{330E7373-8AC4-4BF6-B5AD-9C46C8271B6D}')!
ODBExpiredProxyObject comment: ''!
!ODBExpiredProxyObject categoriesForClass!Kernel-Objects! !
!ODBExpiredProxyObject methodsFor!

odbBasicSerialize: serializer 
	OmniBase 
		signalError: 'This object can not be serialized. The transaction in which this proxy was loaded is already aborted.'!

odbSerialize: serializer 
	OmniBase 
		signalError: 'This object can not be serialized. The transaction in which this proxy was loaded is already aborted.'!

oid: anODBObjectID 
	oid := anODBObjectID!

printOn: aStream 
	aStream nextPutAll: 'Expired OmniBase proxy object of OID='.
	oid printOn: aStream!

value
	^self! !
!ODBExpiredProxyObject categoriesFor: #odbBasicSerialize:!private! !
!ODBExpiredProxyObject categoriesFor: #odbSerialize:!private! !
!ODBExpiredProxyObject categoriesFor: #oid:!public! !
!ODBExpiredProxyObject categoriesFor: #printOn:!public! !
!ODBExpiredProxyObject categoriesFor: #value!private! !

!ODBExpiredProxyObject class methodsFor!

on: oid 
	^self new oid: oid! !
!ODBExpiredProxyObject class categoriesFor: #on:!public! !

