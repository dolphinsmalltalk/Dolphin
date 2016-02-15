"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaAttribute
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: 'applyMap'!
ScintillaAttribute guid: (GUID fromString: '{B73F94FE-0BB9-4C23-AEE5-E77B3CF408AF}')!
ScintillaAttribute comment: 'ScintillaAttribute is the abstract superclass of objects that wrap various attributes of <ScintillaView>s. It provides a generic mechanism for setting the attribute value into the underlying control.

Instance Variables:
	id		<integer>. Identifier of the attribute instance.

Class Instance Variables:
	applyMap	<IdentityDictionary> mapping from the get selector on the subclass to the windows message used to set the property of the associated Scintilla control.



'!
!ScintillaAttribute categoriesForClass!MVP-Views-Support! !
!ScintillaAttribute methodsFor!

= aScintillaAttribute 
	^self class == aScintillaAttribute and: [self name = aScintillaAttribute name]!

applyMap
	^self class applyMap!

applyMapDo: aMonadicValuable 
	^self applyMap do: aMonadicValuable!

applyToView: aScintillaView 
	self view: aScintillaView.
	self applyMapDo: 
			[:tuple | 
			"Don't send the value to the control if unspecified (nil), or if has the default value"
			(self perform: tuple first) 
				ifNotNil: 
					[:value | 
					value = tuple second 
						ifFalse: 
							[aScintillaView 
								sendMessage: tuple last
								wParam: self asParameter
								lParam: value asUIntPtr]]]!

applyToView: aScintillaView at: anInteger 
	self basicId: anInteger.
	self applyToView: aScintillaView!

asParameter
	^self basicId!

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
	^self applyMap keys!

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
	^(Array with: #basicId) , self applyMap keys asArray!

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
			| tuple lParam |
			tuple := self applyMap at: aSymbol.
			"If the attribute is nil (unspecified) then set the value back to the default value from the tuple"
			lParam := (self perform: tuple first) ifNil: [tuple second] ifNotNil: [:value | value asUIntPtr].
			scintilla 
				sendMessage: tuple last
				wParam: self asParameter
				lParam: lParam].
	^self!

view
	^self subclassResponsibility!

view: aScintillaView 
	self subclassResponsibility! !
!ScintillaAttribute categoriesFor: #=!comparing!public! !
!ScintillaAttribute categoriesFor: #applyMap!constants!private! !
!ScintillaAttribute categoriesFor: #applyMapDo:!helpers!private! !
!ScintillaAttribute categoriesFor: #applyToView:!helpers!private! !
!ScintillaAttribute categoriesFor: #applyToView:at:!helpers!private! !
!ScintillaAttribute categoriesFor: #asParameter!converting!public! !
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

applyMap
	^applyMap!

icon
	^ScintillaView icon!

sortByIdBlock
	^[:a :b | a basicId ifNil: [true] ifNotNil: [:aId | b basicId ifNil: [false] ifNotNil: [:bId | aId <= bId]]]! !
!ScintillaAttribute class categoriesFor: #applyMap!constants!private! !
!ScintillaAttribute class categoriesFor: #icon!constants!development!public! !
!ScintillaAttribute class categoriesFor: #sortByIdBlock!constants!public! !

