"Filed out from Dolphin Smalltalk X6.2"!

LookupTable variableSubclass: #ItcLookupTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcLookupTable guid: (GUID fromString: '{C6EE2DBA-51D3-422B-A879-9D42DEB9E80D}')!
ItcLookupTable comment: ''!
!ItcLookupTable categoriesForClass!Unclassified! !
!ItcLookupTable methodsFor!

at: key 
	| index |
	index := self findKeyOrNil: key.
	^(self basicAt: index) isNil ifFalse: [values basicAt: index]!

odbBasicSerialize: serializer 
	self class == ItcLookupTable ifFalse: [^super odbBasicSerialize: serializer].
	(serializer stream)
		putByte: 86;
		putPositiveInteger: self size.
	self keysAndValuesDo: 
			[:key :value | 
			key odbSerialize: serializer.
			value odbSerialize: serializer]! !
!ItcLookupTable categoriesFor: #at:!public! !
!ItcLookupTable categoriesFor: #odbBasicSerialize:!OmniBase!public! !

