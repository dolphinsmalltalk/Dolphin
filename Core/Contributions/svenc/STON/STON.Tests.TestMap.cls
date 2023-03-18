"Filed out from Dolphin Smalltalk"!

Core.Dictionary
	variableSubclass: #'STON.Tests.TestMap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.TestMap guid: (Core.GUID fromString: '{588069da-7c8c-4590-b393-27c089007c6a}')!
STON.Tests.TestMap comment: ''!
!STON.Tests.TestMap methodsFor!

printElementsOn: stream
	stream
		nextPut: $(;
		nextPut: $#;
		print: self size;
		nextPut: $)! !
!STON.Tests.TestMap categoriesForMethods!
printElementsOn:!public! !
!

!STON.Tests.TestMap class methodsFor!

classTree
	^self classTree: Object!

classTree: topClass
	| map |
	map := IdentityDictionary new.
	topClass withAllSubclasses do: 
			[:eachClass |
			| info |
			(info := self new)
				at: #name put: eachClass name asString;
				at: #comment put: eachClass comment;
				at: #isMeta put: eachClass isMeta;
				at: #methods put: eachClass selectors.
			map at: eachClass put: info].
	map keysAndValuesDo: 
			[:eachClass :eachInfo |
			eachClass == topClass ifFalse: [eachInfo at: #superclass put: (map at: eachClass superclass)].
			eachInfo at: #subclasses put: (eachClass subclasses collect: [:subClass | map at: subClass])].
	^map at: topClass!

classTreeExtended
	^self classTreeExtended: Object!

classTreeExtended: topClass
	| map |
	map := IdentityDictionary new.
	topClass withAllSubclasses do: 
			[:eachClass |
			| info methodsInfo |
			(info := self new)
				at: #name put: eachClass name asString;
				at: #comment put: eachClass comment;
				at: #isMeta put: eachClass isMeta;
				at: #methods put: (methodsInfo := self new).
			eachClass methods do: 
					[:eachMethod |
					| methodInfo |
					(methodInfo := self new)
						at: #name put: eachMethod selector;
						at: #numArgs put: eachMethod numArgs;
						at: #class put: info.
					methodsInfo at: eachMethod selector put: methodInfo].
			map at: eachClass put: info].
	map keysAndValuesDo: 
			[:eachClass :eachInfo |
			eachClass == topClass ifFalse: [eachInfo at: #superclass put: (map at: eachClass superclass)].
			eachInfo at: #subclasses put: (eachClass subclasses collect: [:subClass | map at: subClass])].
	^map at: topClass!

sizeFor: anInteger
	"STON-Core tests involving hashed collections tend to have the flaw of being sensitive to the order of the elements, which is unstable in such unordered hashed collections.
	The default new Dictionary size in Pharo is larger than in Dolphin, so this is one immediate source of problems."

	anInteger < 3 ifTrue: [^5].
	^super sizeFor: anInteger!

stonName
	^ #TestMap! !
!STON.Tests.TestMap class categoriesForMethods!
classTree!public!ston/core! !
classTree:!public!ston/core! !
classTreeExtended!public!ston/core! !
classTreeExtended:!public!ston/core! !
sizeFor:!instance creation!private! !
stonName!public!ston/core! !
!

