"Filed out from Dolphin Smalltalk 7"!

LookupTable variableSubclass: #ItcLookupTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcLookupTable guid: (GUID fromString: '{c6ee2dba-51d3-422b-a879-9d42deb9e80d}')!
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

