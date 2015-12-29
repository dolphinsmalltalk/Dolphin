"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #ScintillaAttribute
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: 'attributes'!
ScintillaAttribute guid: (GUID fromString: '{B73F94FE-0BB9-4C23-AEE5-E77B3CF408AF}')!
ScintillaAttribute comment: 'ScintillaAttribute is the abstract superclass of objects that wrap various attributes of <ScintillaView>s. It provides a generic mechanism for setting the attribute value into the underlying control.

Instance Variables:
	id		<integer>. Identifier of the attribute instance.

Class Instance Variables:
	setMessages	<IdentityDictionary>



'!
!ScintillaAttribute categoriesForClass!MVP-Views-Support! !
!ScintillaAttribute methodsFor!

= aScintillaAttribute 
	^self class == aScintillaAttribute and: [self name = aScintillaAttribute name]!

applyToView: aScintillaView 
	self view: aScintillaView.
	self attributes 
		ifNotNil: 
			[:map | 
			map keysAndValuesDo: 
					[:eachGetter :eachSetMessage | 
					(self perform: eachGetter) 
						ifNotNil: 
							[:value | 
							aScintillaView 
								sendMessage: eachSetMessage
								wParam: self asParameter
								lParam: value asUIntPtr]]]!

applyToView: aScintillaView at: anInteger 
	self basicId: anInteger.
	self applyToView: aScintillaView!

asParameter
	^self basicId!

attributes
	^self class attributes!

basicId
	^id!

basicId: anInteger 
	id := anInteger!

hash
	^self name hash!

id
	^self basicId ifNil: [0] ifNotNil: [:definedId | definedId bitAnd: 16rFF]!

id: anInteger 
	self basicId: anInteger!

name
	^self id!

printableAttributes
	^self attributes keys!

printAttributesOn: aStream 
	self printableAttributes do: 
			[:each | 
			(self perform: each) 
				ifNotNil: 
					[:attrib | 
					aStream
						nextPutAll: ', ';
						nextPutAll: each;
						nextPutAll: '=';
						print: attrib]]!

printOn: aStream 
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self id;
		nextPut: $:;
		print: self name.
	self printAttributesOn: aStream.
	aStream nextPut: $)!

storeableAttributes
	^(Array with: #basicId) , self class attributes keys asArray!

storeOn: aStream 
	"Append to the <puttableStream> argument an expression which when evaluated will answer a
	collection similar to the receiver."

	aStream
		nextPutAll: '((';
		print: self class;
		nextPutAll: ' new)';
		space.
	self storeableAttributes do: 
			[:each | 
			(self perform: each) 
				ifNotNil: 
					[:attrib | 
					aStream
						display: each;
						nextPut: $:;
						space.
					attrib storeOn: aStream.
					aStream
						nextPut: $;;
						space]].
	aStream
		display: #yourself;
		nextPut: $)!

updateViewAttribute: aSymbol 
	self view 
		ifNotNil: 
			[:scintilla | 
			scintilla 
				sendMessage: (self attributes at: aSymbol)
				wParam: self asParameter
				lParam: (self perform: aSymbol) asUIntPtr]!

view
	^nil!

view: aScintillaView 
	^self! !
!ScintillaAttribute categoriesFor: #=!comparing!public! !
!ScintillaAttribute categoriesFor: #applyToView:!helpers!private! !
!ScintillaAttribute categoriesFor: #applyToView:at:!helpers!private! !
!ScintillaAttribute categoriesFor: #asParameter!converting!public! !
!ScintillaAttribute categoriesFor: #attributes!constants!private! !
!ScintillaAttribute categoriesFor: #basicId!accessing!private! !
!ScintillaAttribute categoriesFor: #basicId:!accessing!private! !
!ScintillaAttribute categoriesFor: #hash!comparing!public! !
!ScintillaAttribute categoriesFor: #id!accessing!public! !
!ScintillaAttribute categoriesFor: #id:!accessing!public! !
!ScintillaAttribute categoriesFor: #name!accessing!public! !
!ScintillaAttribute categoriesFor: #printableAttributes!development!helpers!printing!private! !
!ScintillaAttribute categoriesFor: #printAttributesOn:!development!helpers!printing!private! !
!ScintillaAttribute categoriesFor: #printOn:!development!printing!public! !
!ScintillaAttribute categoriesFor: #storeableAttributes!development!printing!private! !
!ScintillaAttribute categoriesFor: #storeOn:!development!printing!public! !
!ScintillaAttribute categoriesFor: #updateViewAttribute:!helpers!private! !
!ScintillaAttribute categoriesFor: #view!accessing!private! !
!ScintillaAttribute categoriesFor: #view:!accessing!private! !

!ScintillaAttribute class methodsFor!

attributes
	^attributes!

icon
	^ScintillaView icon!

sortByIdBlock
	^[:a :b | a basicId ifNil: [true] ifNotNil: [:aId | b basicId ifNil: [false] ifNotNil: [:bId | aId <= bId]]]! !
!ScintillaAttribute class categoriesFor: #attributes!constants!private! !
!ScintillaAttribute class categoriesFor: #icon!constants!development!public! !
!ScintillaAttribute class categoriesFor: #sortByIdBlock!constants!public! !

