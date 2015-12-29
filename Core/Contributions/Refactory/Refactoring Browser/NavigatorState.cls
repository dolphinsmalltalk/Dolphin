"Filed out from Dolphin Smalltalk 2000 release 4.01"!

Object subclass: #NavigatorState
	instanceVariableNames: 'meta classNames protocols selectors applications'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NavigatorState comment: ''!

NavigatorState guid: (GUID fromString: '{A8B6C1C9-0E73-11D5-B80B-000102677BBF}')!

!NavigatorState categoriesForClass!Unclassified! !
!NavigatorState methodsFor!

= anObject 
	self class == anObject class ifFalse: [^false].
	^self applications = anObject applications and: 
			[self selectedClasses = anObject selectedClasses and: 
					[self protocols = anObject protocols
						and: [self selectors = anObject selectors]]]!

application
	^applications isEmpty ifTrue: [nil] ifFalse: [applications first]!

application: anApplication 
	applications := anApplication isNil ifTrue: [#()] ifFalse: [Array with: anApplication]!

applications
	^applications!

applications: applicationCollection 
	applications := applicationCollection!

className
	^self classNames detect: [:each | true]
		ifNone: [nil]!

className: aName 
	classNames := aName isNil ifTrue: [#()] ifFalse: [Array with: aName]!

classNames
	^classNames!

classNames: aCollection 
	classNames := aCollection!

hash
	^self application hash bitXor: (self selectedClass hash
				bitXor: (self protocol hash bitXor: self selector hash))!

initialize
	applications := classNames := protocols := selectors := #().
	meta := false!

isMetaclass
	^meta!

isMetaclass: aBoolean
	meta := aBoolean!

methods
	| class methods |
	class := self selectedClass.
	class isNil ifTrue: [^#()].
	methods := OrderedCollection new: self selectors size.
	self selectors do: 
			[:each | 
			| method |
			method := class compiledMethodAt: each ifAbsent: [nil].
			method notNil ifTrue: [methods add: method]].
	^methods!

nonMetaClass
	| classes |
	classes := self nonMetaClasses.
	^classes isEmpty ifTrue: [nil] ifFalse: [classes first]!

nonMetaClasses
	| classes |
	classes := OrderedCollection new: classNames size.
	classNames do: 
			[:each | 
			| class |
			class := Smalltalk at: each ifAbsent: [nil].
			class notNil ifTrue: [classes add: class]].
	^classes!

printOn: aStream 
	| class |
	class := self className. 
	class notNil 
		ifTrue: 
			[aStream nextPutAll: class.
			self selector notNil
				ifTrue: 
					[aStream nextPutAll: '>>';
						nextPutAll: self selector]]
		ifFalse: 
			[aStream nextPutAll: '(nothing selected)']!

protocol
	^self protocols detect: [:each | true]
		ifNone: [nil]!

protocol: aSymbol 
	protocols := aSymbol isNil ifTrue: [#()] ifFalse: [Array with: aSymbol]!

protocols
	^protocols!

protocols: aCollection 
	protocols := aCollection!

selectedClass
	| class |
	class := self nonMetaClass.
	class isNil ifTrue: [^nil].
	^meta
		ifTrue: [class class]
		ifFalse: [class]!

selectedClass: aClass 
	aClass isNil ifTrue: 
			[meta := false.
			^classNames := nil].
	self className: ((meta := aClass isMeta)
				ifTrue: [aClass primaryInstance name]
				ifFalse: [aClass name]).
	^aClass!

selectedClasses
	| classes |
	classes := self nonMetaClasses.
	^meta
		ifTrue: [classes collect: [:each | each class]]
		ifFalse: [classes]!

selectedClasses: classCollection 
	classNames := classCollection collect: 
					[:each | 
					(each isMetaclass ifTrue: [each primaryInstance] ifFalse: [each]) name].
	classCollection isEmpty ifTrue: 
			[meta := false.
			^self].
	meta := classCollection first isMetaclass!

selector
	^self selectors detect: [:each | true]
		ifNone: [nil]!

selector: aSymbol 
	selectors := aSymbol isNil ifTrue: [#()] ifFalse: [Array with: aSymbol]!

selectors
	^selectors!

selectors: aCollection 
	^selectors := aCollection! !
!NavigatorState categoriesFor: #=!*-unclassified!public! !
!NavigatorState categoriesFor: #application!*-unclassified!public! !
!NavigatorState categoriesFor: #application:!*-unclassified!public! !
!NavigatorState categoriesFor: #applications!*-unclassified!public! !
!NavigatorState categoriesFor: #applications:!*-unclassified!public! !
!NavigatorState categoriesFor: #className!*-unclassified!public! !
!NavigatorState categoriesFor: #className:!*-unclassified!public! !
!NavigatorState categoriesFor: #classNames!*-unclassified!public! !
!NavigatorState categoriesFor: #classNames:!*-unclassified!public! !
!NavigatorState categoriesFor: #hash!*-unclassified!public! !
!NavigatorState categoriesFor: #initialize!*-unclassified!public! !
!NavigatorState categoriesFor: #isMetaclass!*-unclassified!public! !
!NavigatorState categoriesFor: #isMetaclass:!*-unclassified!public! !
!NavigatorState categoriesFor: #methods!*-unclassified!public! !
!NavigatorState categoriesFor: #nonMetaClass!*-unclassified!public! !
!NavigatorState categoriesFor: #nonMetaClasses!*-unclassified!public! !
!NavigatorState categoriesFor: #printOn:!*-unclassified!public! !
!NavigatorState categoriesFor: #protocol!*-unclassified!public! !
!NavigatorState categoriesFor: #protocol:!*-unclassified!public! !
!NavigatorState categoriesFor: #protocols!*-unclassified!public! !
!NavigatorState categoriesFor: #protocols:!*-unclassified!public! !
!NavigatorState categoriesFor: #selectedClass!*-unclassified!public! !
!NavigatorState categoriesFor: #selectedClass:!*-unclassified!public! !
!NavigatorState categoriesFor: #selectedClasses!*-unclassified!public! !
!NavigatorState categoriesFor: #selectedClasses:!*-unclassified!public! !
!NavigatorState categoriesFor: #selector!*-unclassified!public! !
!NavigatorState categoriesFor: #selector:!*-unclassified!public! !
!NavigatorState categoriesFor: #selectors!*-unclassified!public! !
!NavigatorState categoriesFor: #selectors:!*-unclassified!public! !

!NavigatorState class methodsFor!

new
	^super new initialize! !
!NavigatorState class categoriesFor: #new!*-unclassified!public! !

