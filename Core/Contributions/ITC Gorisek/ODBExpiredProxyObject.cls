"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBExpiredProxyObject
	instanceVariableNames: 'oid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBExpiredProxyObject guid: (GUID fromString: '{330e7373-8ac4-4bf6-b5ad-9c46c8271b6d}')!
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

