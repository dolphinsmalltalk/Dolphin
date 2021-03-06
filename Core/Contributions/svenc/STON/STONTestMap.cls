﻿"Filed out from Dolphin Smalltalk 7"!

Dictionary variableSubclass: #STONTestMap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONTestMap guid: (GUID fromString: '{588069da-7c8c-4590-b393-27c089007c6a}')!
STONTestMap comment: ''!
!STONTestMap categoriesForClass!Unclassified! !
!STONTestMap methodsFor!

printElementsOn: stream
	stream
		nextPut: $(;
		nextPut: $#;
		print: self size;
		nextPut: $)! !
!STONTestMap categoriesFor: #printElementsOn:!public! !

!STONTestMap class methodsFor!

classTree
	^ self classTree: Object!

classTree: topClass
	| map |
	map := IdentityDictionary new.
	topClass withAllSubclasses do: [ :eachClass | | info |
		(info := self new)
			at: #name put: eachClass name asString;
			at: #comment put: eachClass comment;
			at: #isMeta put: eachClass isMeta;
			at: #methods put: eachClass selectors.		
		map at: eachClass put: info ].
	map keysAndValuesDo: [ :eachClass :eachInfo |
		eachClass == topClass
			ifFalse: [ eachInfo at: #superclass put: (map at: eachClass superclass) ].
		eachInfo at: #subclasses put: (eachClass subclasses collect: [ :subClass | map at: subClass ]) ].
	^ map at: topClass!

classTreeExtended
	^ self classTreeExtended: Object!

classTreeExtended: topClass
	| map |
	map := IdentityDictionary new.
	topClass withAllSubclasses do: [ :eachClass | | info methodsInfo |
		(info := self new)
			at: #name put: eachClass name asString;
			at: #comment put: eachClass comment;
			at: #isMeta put: eachClass isMeta;
			at: #methods put: (methodsInfo := self new).
		eachClass methods do: [ :eachMethod | | methodInfo |
			(methodInfo := self new)
				at: #name put: eachMethod selector;
				at: #numArgs put: eachMethod numArgs;
				at: #class put: info.
			methodsInfo at: eachMethod selector put: methodInfo ].
		map at: eachClass put: info ].
	map keysAndValuesDo: [ :eachClass :eachInfo |
		eachClass == topClass 
			ifFalse: [ eachInfo at: #superclass put: (map at: eachClass superclass) ].
		eachInfo at: #subclasses put: (eachClass subclasses collect: [ :subClass | map at: subClass ]) ].
	^ map at: topClass!

sizeFor: anInteger
	"STON-Core tests involving hashed collections tend to have the flaw of being sensitive to the order of the elements, which is unstable in such unordered hashed collections.
	The default new Dictionary size in Pharo is larger than in Dolphin, so this is one immediate source of problems."

	anInteger < 3 ifTrue: [^5].
	^super sizeFor: anInteger!

stonName
	^ #TestMap! !
!STONTestMap class categoriesFor: #classTree!public!ston/core! !
!STONTestMap class categoriesFor: #classTree:!public!ston/core! !
!STONTestMap class categoriesFor: #classTreeExtended!public!ston/core! !
!STONTestMap class categoriesFor: #classTreeExtended:!public!ston/core! !
!STONTestMap class categoriesFor: #sizeFor:!instance creation!private! !
!STONTestMap class categoriesFor: #stonName!public!ston/core! !

