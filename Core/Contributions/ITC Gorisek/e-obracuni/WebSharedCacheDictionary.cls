"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebSharedCacheDictionary
	instanceVariableNames: 'mutex cache'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebSharedCacheDictionary guid: (GUID fromString: '{BFF41E7B-B986-4FC1-875B-8EF7F579EAF0}')!
WebSharedCacheDictionary comment: ''!
!WebSharedCacheDictionary categoriesForClass!Unclassified! !
!WebSharedCacheDictionary methodsFor!

at: aKey 
	| value |
	mutex critical: [value := cache at: aKey ifAbsent: []].
	^value!

at: aKey ifAbsent: aBlock 
	| value |
	mutex critical: [value := cache at: aKey ifAbsent: []].
	^value isNil ifTrue: [aBlock value] ifFalse: [value]!

at: aKey ifAbsentPut: aBlock 
	| value |
	mutex critical: [value := cache at: aKey ifAbsent: []].
	value isNil 
		ifTrue: 
			[value := aBlock value.
			self at: aKey put: value].
	^value!

at: aKey put: value 
	mutex critical: [cache at: aKey put: value].
	^value!

initialize
	mutex := Semaphore forMutualExclusion.
	cache := LookupTable new!

releaseAllCachedData
	mutex critical: [cache := LookupTable new]!

removeKey: aKey ifAbsent: aBlock 
	| exists |
	exists := true.
	mutex critical: [cache removeKey: aKey ifAbsent: [exists := false]].
	^exists ifFalse: [aBlock value]! !
!WebSharedCacheDictionary categoriesFor: #at:!public! !
!WebSharedCacheDictionary categoriesFor: #at:ifAbsent:!public! !
!WebSharedCacheDictionary categoriesFor: #at:ifAbsentPut:!public! !
!WebSharedCacheDictionary categoriesFor: #at:put:!public! !
!WebSharedCacheDictionary categoriesFor: #initialize!public! !
!WebSharedCacheDictionary categoriesFor: #releaseAllCachedData!public! !
!WebSharedCacheDictionary categoriesFor: #removeKey:ifAbsent:!public! !

