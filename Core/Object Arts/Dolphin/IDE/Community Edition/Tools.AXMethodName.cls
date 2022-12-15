"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Tools.AXMethodName'
	instanceVariableNames: 'keywords argumentNames indices'
	classVariableNames: ''
	imports: #(#{OS.COM private})
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

	| argc |
	argc := argumentNames size.
	aPuttableStream nextPutAll: keywords first.
	argc == 0 ifTrue: [^self].
	aPuttableStream
		space;
		display: argumentNames first.
	2 to: argc
		do: 
			[:i |
			aPuttableStream
				space;
				nextPutAll: (keywords at: i);
				space;
				display: (argumentNames at: i)]!

selector
	| stream |
	stream := String smalltalkWriteStream: 80.
	self printSelectorOn: stream.
	^stream contents asSymbol!

setKeywords: keywordsCollection argumentNames: argsCollection indices: indexCollection 
	self assert: 
			[keywordsCollection size = argsCollection size or: 
					[argsCollection isEmpty 
						and: [keywordsCollection size = 1 and: [keywordsCollection first lastCodeUnit ~~ $:]]]].
	keywords := keywordsCollection.
	argumentNames := argsCollection.
	indices := indexCollection.
	^self! !
!Tools.AXMethodName categoriesForMethods!
argumentCount!accessing!public! !
argumentNames!accessing!public! !
indices!accessing!public! !
keywords!accessing!public! !
primary!accessing!public! !
printOn:!printing!public! !
printSelectorOn:!printing!public! !
printSignatureOn:!printing!public! !
selector!accessing!public! !
setKeywords:argumentNames:indices:!initializing!private! !
!

!Tools.AXMethodName class methodsFor!

icon
	"Answers an <Icon> that can be used to represent this class"

	^TypeLibraryAnalyzer icon!

keywords: keywordsCollection argumentNames: argumentsCollection indices: indexCollection
	^self new 
		setKeywords: keywordsCollection
		argumentNames: argumentsCollection
		indices: indexCollection! !
!Tools.AXMethodName class categoriesForMethods!
icon!constants!public! !
keywords:argumentNames:indices:!instance creation!public! !
!

