"Filed out from Dolphin Smalltalk"!

BrowserEnvironmentWrapper subclass: #ClassEnvironment
	instanceVariableNames: 'classes metaClasses'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
			| class |
			class := Smalltalk lookup: each.
			(class notNil and: [environment includesClass: class]) ifTrue: [aBlock value: class]].
	metaClasses do: 
			[:each |
			| class |
			class := Smalltalk lookup: each.
			(class notNil and: [environment includesClass: class class]) ifTrue: [aBlock value: class class]]!

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
	^(super includesCategory: aCategory)
		and: [(environment classNamesFor: aCategory)
				inject: false into: [:bool :each | bool
					or:
						[| class |
						class := Smalltalk at: each ifAbsent: [nil].
						class notNil and: [(self includesClass: class)
								or: [self includesClass: class class]]]]]!

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
				class := Smalltalk at: each ifAbsent: [nil].
				class notNil ifTrue: [sum add: class].
				sum]) , ('.
	metaClasses asArray storeOn: aStream.
	aStream nextPutAll: ' inject: OrderedCollection new into: [:sum :each | 
				| class |
				class := Smalltalk at: each ifAbsent: [nil].
				class notNil ifTrue: [sum add: class class].
				sum])))'! !
!ClassEnvironment categoriesForMethods!
addClass:!adding!public! !
classes:!initialize/release!public! !
classesAndSelectorsDo:!accessing!public! !
classesDo:!accessing/classes!public! !
classNames!accessing/classes!public! !
defaultLabel!constants!private! !
definesClass:!public!testing! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
initialize!initialize/release!public! !
isClassEnvironment!public!testing! !
isEmpty!public!testing! !
postCopy!copying!public! !
problemCount!accessing!public! !
removeClass:!public!removing! !
selectorsForClass:do:!accessing!public! !
storeOn:!printing!public! !
!

!ClassEnvironment class methodsFor!

onEnvironment: anEnvironment classes: aCollection
	^(self onEnvironment: anEnvironment)
		classes: aCollection; yourself! !
!ClassEnvironment class categoriesForMethods!
onEnvironment:classes:!instance creation!public! !
!

