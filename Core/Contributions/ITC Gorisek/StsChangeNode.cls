"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StsChangeNode
	instanceVariableNames: 'description elementDescription leftEdition rightEdition leftSource rightSource owningPackage changeTimestamp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangeNode guid: (GUID fromString: '{848904c4-2842-11d4-b0cf-000000000000}')!
StsChangeNode comment: ''!
!StsChangeNode categoriesForClass!Unclassified! !
!StsChangeNode methodsFor!

anyEdition
	^leftEdition isNil ifTrue: [rightEdition] ifFalse: [leftEdition]!

anyEditionClassName
	"Returns any edition class name string."

	| anyEdition |
	^((anyEdition := self anyEdition) isKindOf: StsEdition) 
		ifTrue: 
			["Class name can end with ' class' so truncate it."
			anyEdition className subStrings first]
		ifFalse: ['']!

browse
	^nil!

canDoBrowseReferences
	^false!

canDoRemove
	^false!

changeTimestamp: aTimestamp 
	changeTimestamp := aTimestamp!

description
	^description!

description: aString 
	description := aString!

displayOn: aStream 
	aStream nextPutAll: description!

elementDescription
	^elementDescription!

elementDescription: aString 
	elementDescription := aString!

elementName
	^(leftEdition isNil ifTrue: [rightEdition name] ifFalse: [leftEdition name]) asString!

fileOutChangeForSmalltalkXOn: aStream 
	!

fileOutChangeForSqueakOn: aStream 
	!

fileOutChangeForVastOn: aStream 
	!

fileOutChangeForVwUsing: xmlWriter 
	!

icon
	^Boolean icon!

isCategoryChangeOnly
	^false!

isComment
	^false!

isWhitespaceChangeOnly
	^false!

isWhitespaceOrCategoryChangeOnly
	^false!

lastChangeTimestamp
	| left right |
	left := self leftEditionTimestamp.
	right := self rightEditionTimestamp.
	(left isNil or: [right isNil]) ifFalse: [^left max: right].
	"If some edition TS is nil package or class timestamp must be checked."
	(#('method added' 'class added' 'loose method added') includes: description) 
		ifTrue: 
			[left isNil ifFalse: [^left].
			right isNil ifFalse: [^right]].
	^changeTimestamp isNil 
		ifFalse: 
			[left isNil 
				ifFalse: [changeTimestamp max: left]
				ifTrue: [right isNil ifFalse: [changeTimestamp max: right] ifTrue: [changeTimestamp]]]!

lastChangeTimestampString
	^self timestampToString: self lastChangeTimestamp!

leftComment
	^''!

leftEdition
	^leftEdition!

leftEdition: anObject 
	leftEdition := anObject!

leftEditionDeveloper
	^leftEdition isNil 
		ifTrue: ['']
		ifFalse: 
			[(leftEdition respondsTo: #developer) 
				ifTrue: [leftEdition developer isNil ifTrue: [''] ifFalse: [leftEdition developer]]]!

leftEditionTimestamp
	| ts |
	^leftEdition isNil 
		ifFalse: 
			[((leftEdition respondsTo: #timestamp) and: [(ts := leftEdition timestamp) class == TimeStamp]) 
				ifTrue: [ts]]!

leftEditionTimestampString
	| str |
	str := self timestampToString: self leftEditionTimestamp.
	(leftEdition notNil and: [(leftEdition respondsTo: #isLoaded) and: [leftEdition isLoaded]]) 
		ifTrue: [str := (str isNil or: [str isEmpty]) ifTrue: ['*'] ifFalse: [str , ' *']].
	^str!

leftSource
	^leftSource isNil ifTrue: [''] ifFalse: [leftSource]!

leftSource: aStringSource 
	leftSource := aStringSource!

owningPackage
	^owningPackage!

owningPackage: anObject
	owningPackage := anObject!

owningPackageName
	^owningPackage isNil ifTrue: [''] ifFalse: [owningPackage displayString]!

owningPackageObject
	^owningPackage isNil 
		ifFalse: 
			[owningPackage isString 
				ifTrue: [Package manager packageNamed: owningPackage ifNone: []]
				ifFalse: [owningPackage]]!

resolveProxies
	self leftEdition ifNotNil: [:value | value isString ifFalse: [value resolveProxies]].
	self rightEdition ifNotNil: [:value | value isString ifFalse: [value resolveProxies]]!

rightComment
	^''!

rightEdition
	^rightEdition!

rightEdition: anObject 
	rightEdition := anObject!

rightEditionDeveloper
	^(rightEdition notNil and: [rightEdition respondsTo: #developer]) 
		ifFalse: ['']
		ifTrue: [rightEdition developer isNil ifFalse: [rightEdition developer] ifTrue: ['']]!

rightEditionTimestamp
	^(rightEdition notNil and: [rightEdition respondsTo: #timestamp]) ifTrue: [rightEdition timestamp]!

rightEditionTimestampString
	| str |
	str := self timestampToString: self rightEditionTimestamp.
	(rightEdition notNil and: [(rightEdition respondsTo: #isLoaded) and: [rightEdition isLoaded]]) 
		ifTrue: [str := (str isNil or: [str isEmpty]) ifTrue: ['*'] ifFalse: [str , ' *']].
	^str!

rightSource
	^rightSource isNil ifTrue: [''] ifFalse: [rightSource]!

rightSource: aStringSource 
	rightSource := aStringSource!

sourceControl
	^StsManager current!

timestampToString: timestamp 
	^timestamp isNil 
		ifTrue: ['']
		ifFalse: 
			[| str n |
			n := timestamp time hours printString.
			n size < 2 ifTrue: [n := '0' , n].
			str := n.
			n := timestamp time minutes printString.
			n size < 2 ifTrue: [n := '0' , n].
			str := str , ':' , n , ' '.
			n := timestamp date dayOfMonth printString.
			n size < 2 ifTrue: [n := '0' , n].
			str := str , n , '.'.
			n := timestamp date monthIndex printString.
			n size < 2 ifTrue: [n := '0' , n].
			str := str , n , '.'.
			n := timestamp date year printString.
			n size > 2 ifTrue: [n := n copyFrom: n size - 1 to: n size].
			str , n]! !
!StsChangeNode categoriesFor: #anyEdition!private! !
!StsChangeNode categoriesFor: #anyEditionClassName!accessing!public! !
!StsChangeNode categoriesFor: #browse!private! !
!StsChangeNode categoriesFor: #canDoBrowseReferences!public! !
!StsChangeNode categoriesFor: #canDoRemove!public! !
!StsChangeNode categoriesFor: #changeTimestamp:!public! !
!StsChangeNode categoriesFor: #description!public! !
!StsChangeNode categoriesFor: #description:!public! !
!StsChangeNode categoriesFor: #displayOn:!public! !
!StsChangeNode categoriesFor: #elementDescription!public! !
!StsChangeNode categoriesFor: #elementDescription:!public! !
!StsChangeNode categoriesFor: #elementName!private! !
!StsChangeNode categoriesFor: #fileOutChangeForSmalltalkXOn:!private! !
!StsChangeNode categoriesFor: #fileOutChangeForSqueakOn:!private! !
!StsChangeNode categoriesFor: #fileOutChangeForVastOn:!private! !
!StsChangeNode categoriesFor: #fileOutChangeForVwUsing:!private! !
!StsChangeNode categoriesFor: #icon!public! !
!StsChangeNode categoriesFor: #isCategoryChangeOnly!private! !
!StsChangeNode categoriesFor: #isComment!public! !
!StsChangeNode categoriesFor: #isWhitespaceChangeOnly!private! !
!StsChangeNode categoriesFor: #isWhitespaceOrCategoryChangeOnly!public! !
!StsChangeNode categoriesFor: #lastChangeTimestamp!public! !
!StsChangeNode categoriesFor: #lastChangeTimestampString!public! !
!StsChangeNode categoriesFor: #leftComment!public! !
!StsChangeNode categoriesFor: #leftEdition!public! !
!StsChangeNode categoriesFor: #leftEdition:!public! !
!StsChangeNode categoriesFor: #leftEditionDeveloper!public! !
!StsChangeNode categoriesFor: #leftEditionTimestamp!public! !
!StsChangeNode categoriesFor: #leftEditionTimestampString!public! !
!StsChangeNode categoriesFor: #leftSource!public! !
!StsChangeNode categoriesFor: #leftSource:!public! !
!StsChangeNode categoriesFor: #owningPackage!accessing!public! !
!StsChangeNode categoriesFor: #owningPackage:!accessing!private! !
!StsChangeNode categoriesFor: #owningPackageName!public! !
!StsChangeNode categoriesFor: #owningPackageObject!public! !
!StsChangeNode categoriesFor: #resolveProxies!OmniBase!public! !
!StsChangeNode categoriesFor: #rightComment!public! !
!StsChangeNode categoriesFor: #rightEdition!public! !
!StsChangeNode categoriesFor: #rightEdition:!public! !
!StsChangeNode categoriesFor: #rightEditionDeveloper!public! !
!StsChangeNode categoriesFor: #rightEditionTimestamp!public! !
!StsChangeNode categoriesFor: #rightEditionTimestampString!public! !
!StsChangeNode categoriesFor: #rightSource!public! !
!StsChangeNode categoriesFor: #rightSource:!public! !
!StsChangeNode categoriesFor: #sourceControl!constants!development!public! !
!StsChangeNode categoriesFor: #timestampToString:!private! !

