"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.AXMethodName'
	instanceVariableNames: 'keywords argumentNames indices'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AXMethodName guid: (Core.GUID fromString: '{fdfdeb82-6021-4e02-9882-cc75d3a22b22}')!
Tools.AXMethodName comment: ''!
!Tools.AXMethodName categoriesForClass!Kernel-Objects! !
!Tools.AXMethodName methodsFor!

argumentCount
	^argumentNames size!

argumentNames
	^argumentNames!

indices
	^indices!

keywords
	^keywords!

primary
	^keywords first!

printOn: aPuttableStream
	aPuttableStream basicPrint: self; nextPut: $(.
	self printSignatureOn: aPuttableStream.
	aPuttableStream nextPut: $)!

printSelectorOn: aPuttableStream
	keywords do: [:each | aPuttableStream nextPutAll: each]!

printSignatureOn: aPuttableStream
	"Emit the method signature described by the receiver to the <puttableStream> argument."

	argumentNames isEmpty 
		ifTrue: 
			["Unary selector"

			aPuttableStream nextPutAll: keywords first]
		ifFalse: 
			[| first |
			first := true.
			keywords with: argumentNames
				do: 
					[:eachKeyword :eachArgument | 
					first ifTrue: [first := false] ifFalse: [aPuttableStream space].
					aPuttableStream
						nextPutAll: eachKeyword;
						space;
						display: eachArgument]]!

selector
	| stream |
	stream := String smalltalkWriteStream: 80.
	self printSelectorOn: stream.
	^stream contents asSymbol!

setKeywords: keywordsCollection argumentNames: argsCollection indices: indexCollection 
	self assert: 
			[keywordsCollection size = argsCollection size or: 
					[argsCollection isEmpty 
						and: [keywordsCollection size = 1 and: [keywordsCollection first last ~~ $:]]]].
	keywords := keywordsCollection.
	argumentNames := argsCollection.
	indices := indexCollection.
	^self! !
!Tools.AXMethodName categoriesFor: #argumentCount!accessing!public! !
!Tools.AXMethodName categoriesFor: #argumentNames!accessing!public! !
!Tools.AXMethodName categoriesFor: #indices!accessing!public! !
!Tools.AXMethodName categoriesFor: #keywords!accessing!public! !
!Tools.AXMethodName categoriesFor: #primary!accessing!public! !
!Tools.AXMethodName categoriesFor: #printOn:!printing!public! !
!Tools.AXMethodName categoriesFor: #printSelectorOn:!printing!public! !
!Tools.AXMethodName categoriesFor: #printSignatureOn:!printing!public! !
!Tools.AXMethodName categoriesFor: #selector!accessing!public! !
!Tools.AXMethodName categoriesFor: #setKeywords:argumentNames:indices:!initializing!private! !

!Tools.AXMethodName class methodsFor!

icon
	"Answers an <Icon> that can be used to represent this class"

	^Smalltalk.AXTypeLibraryAnalyzer icon!

keywords: keywordsCollection argumentNames: argumentsCollection indices: indexCollection
	^self new 
		setKeywords: keywordsCollection
		argumentNames: argumentsCollection
		indices: indexCollection! !
!Tools.AXMethodName class categoriesFor: #icon!constants!public! !
!Tools.AXMethodName class categoriesFor: #keywords:argumentNames:indices:!instance creation!public! !

