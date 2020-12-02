"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentWrapper subclass: #ClassEnvironment
	instanceVariableNames: 'classes metaClasses'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassEnvironment guid: (GUID fromString: '{6ced2bfc-a2ca-479f-9eef-d74b2baa9d59}')!
ClassEnvironment comment: 'A ClassEnvironment defines a slice of the system that includes all the classes, methods, resources, etc in a particular set of classes.

Instance Variables:
	classes	<Collection of: Symbol>		the class names (not metaclasses)
	metaClasses	<Collection of: Symbol>	the class names for the metaclasses that are selected'!
!ClassEnvironment categoriesForClass!Refactory-Environments! !
!ClassEnvironment methodsFor!

addClass: aClass 
	aClass isMeta
		ifTrue: [metaClasses add: aClass soleInstance name]
		ifFalse: [classes add: aClass name]!

classes: aCollection 
	aCollection do: [:each | self addClass: each]!

classesAndSelectorsDo: aBlock
	#rbFix.	"Override to avoid #includesClass: check in #selectorsForClass:do:"
	self classesDo: 
			[:class |
			class selectorsDo: 
					[:eachSelector |
					(environment includesSelector: eachSelector in: class)
						ifTrue: [aBlock value: class value: eachSelector]]]!

classesDo: aBlock
	classes do: 
			[:each |
			each asQualifiedReference
				ifDefined: [:class | (environment includesClass: class) ifTrue: [aBlock value: class]]].
	metaClasses do: 
			[:each |
			each asQualifiedReference
				ifDefined: [:class | (environment includesClass: class class) ifTrue: [aBlock value: class class]]]!

classNames
	^(IdentitySet withAll: classes)
		addAll: metaClasses;
		yourself!

defaultLabel
	| stream |
	stream := String new writeStream.
	#rbFix.	"Use #do:separatedBy: to avoid extraneous space at end"
	classes do: [:each | stream nextPutAll: each] separatedBy: [stream space].
	^stream contents!

definesClass: aClass
	^self includesClass: aClass!

includesCategory: aCategory
	^(super includesCategory: aCategory) and: 
			[(environment classNamesFor: aCategory) inject: false
				into: 
					[:bool :each |
					bool or: 
							[| class |
							class := each asQualifiedReference valueOrNil.
							class notNil and: [(self includesClass: class) or: [self includesClass: class class]]]]]!

includesClass: aClass
	^(aClass isMeta
		ifTrue: [metaClasses includes: aClass soleInstance name]
		ifFalse: [classes includes: aClass name]) and: [super includesClass: aClass]!

initialize
	super initialize.
	classes := Set new.
	metaClasses := Set new!

isClassEnvironment
	^true!

isEmpty
	^classes isEmpty and: [metaClasses isEmpty]!

postCopy
	classes := classes copy.
	metaClasses := metaClasses copy.
	^super postCopy!

problemCount
	^self numberClasses!

removeClass: aClass 
	aClass isMeta
		ifTrue: [metaClasses remove: aClass soleInstance name ifAbsent: []]
		ifFalse: [classes remove: aClass name ifAbsent: []]!

selectorsForClass: aClass do: aBlock
	#rbFix.	"Implement to avoid need for #includesClass: test in loop by performing it up front."
	(self includesClass: aClass) ifFalse: [^self].
	aClass selectorsDo: 
			[:eachSelector |
			(environment includesSelector: eachSelector in: aClass) ifTrue: [aBlock value: eachSelector]]!

storeOn: aStream
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream nextPutAll: ' classes: (('.
	classes asArray storeOn: aStream.
	aStream nextPutAll: ' inject: OrderedCollection new into: [:sum :each | 
				| class |
				class := each asQualifiedReference valueOrNil.
				class notNil ifTrue: [sum add: class].
				sum]) , ('.
	metaClasses asArray storeOn: aStream.
	aStream nextPutAll: ' inject: OrderedCollection new into: [:sum :each | 
				| class |
				class := each asQualifiedReference valueOrNil.
				class notNil ifTrue: [sum add: class class].
				sum])))'! !
!ClassEnvironment categoriesFor: #addClass:!adding!public! !
!ClassEnvironment categoriesFor: #classes:!initialize/release!public! !
!ClassEnvironment categoriesFor: #classesAndSelectorsDo:!accessing!public! !
!ClassEnvironment categoriesFor: #classesDo:!accessing/classes!public! !
!ClassEnvironment categoriesFor: #classNames!accessing/classes!public! !
!ClassEnvironment categoriesFor: #defaultLabel!constants!private! !
!ClassEnvironment categoriesFor: #definesClass:!public!testing! !
!ClassEnvironment categoriesFor: #includesCategory:!public!testing! !
!ClassEnvironment categoriesFor: #includesClass:!public!testing! !
!ClassEnvironment categoriesFor: #initialize!initialize/release!public! !
!ClassEnvironment categoriesFor: #isClassEnvironment!public!testing! !
!ClassEnvironment categoriesFor: #isEmpty!public!testing! !
!ClassEnvironment categoriesFor: #postCopy!copying!public! !
!ClassEnvironment categoriesFor: #problemCount!accessing!public! !
!ClassEnvironment categoriesFor: #removeClass:!public!removing! !
!ClassEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!ClassEnvironment categoriesFor: #storeOn:!printing!public! !

!ClassEnvironment class methodsFor!

onEnvironment: anEnvironment classes: aCollection
	^(self onEnvironment: anEnvironment)
		classes: aCollection; yourself! !
!ClassEnvironment class categoriesFor: #onEnvironment:classes:!instance creation!public! !

