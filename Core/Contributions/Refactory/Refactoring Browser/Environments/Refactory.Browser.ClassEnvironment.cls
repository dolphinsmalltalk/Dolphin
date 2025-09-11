"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Refactory.Browser.ClassEnvironment'
	instanceVariableNames: 'classes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.ClassEnvironment guid: (Core.GUID fromString: '{6ced2bfc-a2ca-479f-9eef-d74b2baa9d59}')!

Refactory.Browser.ClassEnvironment comment: 'A ClassEnvironment defines a slice of the system that includes all the classes, methods, resources, etc in a particular set of classes.

Instance Variables:
	classes	<Collection of: Symbol>		the class names (not metaclasses)
	metaClasses	<Collection of: Symbol>	the class names for the metaclasses that are selected'!

!Refactory.Browser.ClassEnvironment categoriesForClass!Refactory-Environments! !

!Refactory.Browser.ClassEnvironment methodsFor!

addClass: aClass
	classes add: aClass fullyQualifiedReference!

approximateNumberOfClasses
	^classes size!

classes: aCollection
	self classReferences: (aCollection collect: [:each | each fullyQualifiedReference])!

classes: classArray metaClasses: metaArray
	"Private - Used to recreate an environment from a legacy storeString"

	classes := Set new.
	classArray do: [:each | classes add: each asQualifiedReference].
	metaArray do: [:each | classes add: (each , ' class') asQualifiedReference]!

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
			each valueOrNil
				ifNotNil: [:class | (environment includesClass: class) ifTrue: [aBlock value: class]]]!

classNames
	"Answer a <Collection> of the full names of each instance class in this environment."

	^classes collect: [:each | each instance asString]!

classReferences: aCollectionOfBindingReferences
	classes := aCollectionOfBindingReferences asSet!

defaultLabel
	^$\x20 join: self classNames!

definesClass: aClass
	^self includesClass: aClass!

includesCategory: aCategory
	^(super includesCategory: aCategory) and: 
			[(environment classNamesFor: aCategory) inject: false
				into: [:bool :each | bool or: [classes includes: each asQualifiedReference]]]!

includesClass: aClass
	^classes includes: aClass fullyQualifiedReference!

initialize
	super initialize.
	classes := Set new!

isClassEnvironment
	^true!

isEmpty
	^classes isEmpty!

postCopy
	classes := classes copy.
	^super postCopy!

problemCount
	^self numberClasses!

removeClass: aClass
	classes remove: aClass asQualifiedReference ifAbsent: nil!

selectorsForClass: aClass do: aBlock
	#rbFix.	"Implement to avoid need for #includesClass: test in loop by performing it up front."
	(self includesClass: aClass) ifFalse: [^self].
	aClass selectorsDo: 
			[:eachSelector |
			(environment includesSelector: eachSelector in: aClass) ifTrue: [aBlock value: eachSelector]]!

storeOn: aStream
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream
		nextPutAll: ' classReferences: ';
		store: classes asSortedArray;
		nextPut: $)! !

!Refactory.Browser.ClassEnvironment categoriesForMethods!
addClass:!adding!public! !
approximateNumberOfClasses!accessing!private! !
classes:!initializing!public! !
classes:metaClasses:!initializing!private! !
classesAndSelectorsDo:!enumerating!public! !
classesDo:!enumerating!public! !
classNames!accessing/classes!public! !
classReferences:!initializing!private! !
defaultLabel!constants!private! !
definesClass:!public!testing! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
initialize!initializing!public! !
isClassEnvironment!public!testing! !
isEmpty!public!testing! !
postCopy!copying!public! !
problemCount!accessing!public! !
removeClass:!public!removing! !
selectorsForClass:do:!enumerating!public! !
storeOn:!printing!public! !
!

!Refactory.Browser.ClassEnvironment class methodsFor!

onEnvironment: anEnvironment classes: aCollection
	^self basicNew
		onEnvironment: anEnvironment;
		classReferences: (aCollection collect: [:each | each fullyQualifiedReference]);
		yourself! !

!Refactory.Browser.ClassEnvironment class categoriesForMethods!
onEnvironment:classes:!instance creation!public! !
!

