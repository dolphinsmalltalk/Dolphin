"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #StsChangeNodesComparisonJob
	instanceVariableNames: 'compareWithImageOrProjectEdition changes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangeNodesComparisonJob guid: (GUID fromString: '{0EF8513F-E09D-4676-9C6C-B0ADF1026FBC}')!
StsChangeNodesComparisonJob comment: ''!
!StsChangeNodesComparisonJob categoriesForClass!Unclassified! !
!StsChangeNodesComparisonJob methodsFor!

changes
	changes isNil ifTrue: [changes := OrderedCollection new].
	^changes!

compare: aChangeNodes 
	| step |
	step := 100.00s / aChangeNodes size.
	(ProgressDialog create)
		caption: 'Comparing...';
		operation: 
				[:progress | 
				progress value: 0.0s.
				aChangeNodes doWithIndex: 
						[:each :ind | 
						self compareChangeNode: each.
						progress value: step * ind].
				progress value: 100.0s];
		showModal!

compareChangeNode: aChangeNode 
	| oldEdition tokens selector method |
	(aChangeNode class == StsChangedClassNode and: [aChangeNode description = 'class removed']) 
		ifTrue: 
			[^(oldEdition := self getClassEdition: aChangeNode elementDescription subStrings first asSymbol) 
				isNil 
					ifFalse: 
						[self changes add: ((StsChangedClassNode new)
									description: aChangeNode description;
									rightEdition: oldEdition;
									yourself)]].
	aChangeNode class == StsChangedClassNode 
		ifTrue: 
			["Other variation of this change type class is created or changed class."
			^(oldEdition := self getClassEdition: aChangeNode leftEdition name) isNil 
				ifTrue: [self changes add: aChangeNode]
				ifFalse: [aChangeNode leftEdition compareDefinitionWith: oldEdition on: self changes]].
	(aChangeNode class == StsChangedMethodNode and: [aChangeNode description = 'method removed']) 
		ifTrue: 
			[tokens := aChangeNode elementDescription subStrings.
			^(oldEdition := self getClassEdition: tokens first asSymbol) isNil 
				ifFalse: 
					[selector := tokens last asSymbol.
					(method := ((tokens at: 2) = 'class' ifTrue: [oldEdition classMethods] ifFalse: [oldEdition methods]) 
								detect: [:each | each selector == selector]
								ifNone: []) isNil 
						ifFalse: 
							[self changes add: ((StsChangedMethodNode new)
										elementDescription: aChangeNode elementDescription;
										description: 'method removed';
										rightEdition: method;
										yourself)]]].
	aChangeNode class == StsChangedMethodNode 
		ifTrue: 
			["Other variation of this change type class is created or changed methods."
			tokens := aChangeNode leftEdition className subStrings.
			^(oldEdition := self getClassEdition: tokens first asSymbol) isNil 
				ifTrue: [self changes add: aChangeNode]
				ifFalse: 
					[method := (tokens last = 'class' ifTrue: [oldEdition classMethods] ifFalse: [oldEdition methods]) 
								detect: [:each | each selector == aChangeNode leftEdition selector]
								ifNone: [].
					method := method isNil ifFalse: [Array with: method] ifTrue: [#()].
					(tokens := oldEdition compareMethods: (Array with: aChangeNode leftEdition) with: method) isEmpty 
						ifFalse: [self changes addAll: tokens]]]!

compareWithImageOrProjectEdition: aSymbolOrProjectEdition 
	"Private - Contains #compareWithImage symbol or project edition object."

	compareWithImageOrProjectEdition := aSymbolOrProjectEdition!

getClassEdition: className 
	| edition |
	^compareWithImageOrProjectEdition == #compareWithImage 
		ifTrue: 
			[(edition := Smalltalk at: className ifAbsent: []) isNil 
				ifFalse: 
					[self sourceControl findOrCreateClassEditionFor: edition
						in: self sourceControl databaseConnection newLongReadOnlyTransaction]]
		ifFalse: 
			[(compareWithImageOrProjectEdition packageEditions detect: 
					[:eachPackage | 
					(eachPackage classes detect: [:eachClass | (edition := eachClass) name == className] ifNone: []) 
						notNil]
				ifNone: []) notNil 
				ifTrue: [edition]]!

processNewClassesMethods
	| newClassesMethods |
	self changes do: 
			[:eachChange | 
			(eachChange class == StsChangedClassNode 
				and: [eachChange rightEdition isNil and: [eachChange description = 'class added']]) 
					ifTrue: 
						[newClassesMethods := self changes select: 
										[:eachMethodChange | 
										eachMethodChange class == StsChangedMethodNode and: 
												[eachMethodChange rightEdition isNil and: 
														[eachMethodChange description = 'method added' 
															and: [eachChange leftEdition name = eachMethodChange leftEdition classSymbol]]]].
						newClassesMethods do: [:each | self changes remove: each].
						(newClassesMethods collect: [:each | each leftEdition]) do: 
								[:eachNewClassesMethod | 
								eachNewClassesMethod className subStrings last = 'class' 
									ifTrue: 
										[eachChange leftEdition 
											classMethods: ((eachChange leftEdition classMethods asOrderedCollection)
													add: eachNewClassesMethod;
													yourself) asArray]
									ifFalse: 
										[eachChange leftEdition 
											methods: ((eachChange leftEdition methods asOrderedCollection)
													add: eachNewClassesMethod;
													yourself) asArray]]]]!

sourceControl
	^StsManager current! !
!StsChangeNodesComparisonJob categoriesFor: #changes!public! !
!StsChangeNodesComparisonJob categoriesFor: #compare:!private! !
!StsChangeNodesComparisonJob categoriesFor: #compareChangeNode:!private! !
!StsChangeNodesComparisonJob categoriesFor: #compareWithImageOrProjectEdition:!private! !
!StsChangeNodesComparisonJob categoriesFor: #getClassEdition:!private! !
!StsChangeNodesComparisonJob categoriesFor: #processNewClassesMethods!private! !
!StsChangeNodesComparisonJob categoriesFor: #sourceControl!private! !

!StsChangeNodesComparisonJob class methodsFor!

compare: aChangeNodes with: aSymbolOrProjectEdition 
	^(self new)
		compareWithImageOrProjectEdition: aSymbolOrProjectEdition;
		compare: aChangeNodes;
		processNewClassesMethods;
		changes! !
!StsChangeNodesComparisonJob class categoriesFor: #compare:with:!public! !

