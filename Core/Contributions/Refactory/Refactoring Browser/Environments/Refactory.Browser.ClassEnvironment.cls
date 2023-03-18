"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Refactory.Browser.ClassEnvironment'
	instanceVariableNames: 'classes metaClasses'
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
	(aClass isMeta ifTrue: [metaClasses] ifFalse: [classes]) add: aClass instanceClass fullName!

classes: aCollection 
	aCollection do: [:each | self addClass: each]!

classes: classArray metaClasses: metaArray
	"Private - Used to recreate an environment from its storeString"

	classes := classArray asSet.
	metaClasses := metaArray asSet!

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
			(Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: each))
				ifNotNil: [:binding | (environment includesClass: binding value) ifTrue: [aBlock value: binding value]]].
	metaClasses do: 
			[:each |
			(Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: each))
				ifNotNil: 
					[:binding |
					| meta |
					meta := binding value class.
					(environment includesClass: meta) ifTrue: [aBlock value: meta]]]!

classNames
	^(Set withAll: classes)
		addAll: metaClasses;
		yourself!

defaultLabel
	^$\x20 join: classes!

definesClass: aClass
	^self includesClass: aClass!

includesCategory: aCategory
	^(super includesCategory: aCategory) and: 
			[(environment classNamesFor: aCategory) inject: false
				into: 
					[:bool :each |
					bool or: 
							[| binding |
							binding := Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: each).
							binding notNil
								and: [(self includesClass: binding value) or: [self includesClass: binding value class]]]]]!

includesClass: aClass
	^((aClass isMeta ifTrue: [metaClasses] ifFalse: [classes]) includes: aClass instanceClass fullName)
		and: [super includesClass: aClass]!

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
	(aClass isMeta ifTrue: [metaClasses] ifFalse: [classes]) remove: aClass instanceClass fullName
		ifAbsent: nil!

selectorsForClass: aClass do: aBlock
	#rbFix.	"Implement to avoid need for #includesClass: test in loop by performing it up front."
	(self includesClass: aClass) ifFalse: [^self].
	aClass selectorsDo: 
			[:eachSelector |
			(environment includesSelector: eachSelector in: aClass) ifTrue: [aBlock value: eachSelector]]!

storeOn: aStream
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream nextPutAll: ' classes: '.
	classes asArray storeOn: aStream.
	aStream nextPutAll: ' metaClasses: '.
	metaClasses asArray storeOn: aStream.
	aStream nextPut: $)! !
!Refactory.Browser.ClassEnvironment categoriesForMethods!
addClass:!adding!public! !
classes:!initialize/release!public! !
classes:metaClasses:!initialize/release!private! !
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

!Refactory.Browser.ClassEnvironment class methodsFor!

onEnvironment: anEnvironment classes: aCollection
	^(self onEnvironment: anEnvironment)
		classes: aCollection; yourself! !
!Refactory.Browser.ClassEnvironment class categoriesForMethods!
onEnvironment:classes:!instance creation!public! !
!

