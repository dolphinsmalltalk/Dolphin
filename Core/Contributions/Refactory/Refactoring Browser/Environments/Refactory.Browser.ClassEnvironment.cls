"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper subclass: #'Refactory.Browser.ClassEnvironment'
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
			(Smalltalk resolveBindingPath: ($. split: each))
				ifNotNil: [:binding | (environment includesClass: binding value) ifTrue: [aBlock value: binding value]]].
	metaClasses do: 
			[:each |
			(Smalltalk resolveBindingPath: ($. split: each))
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
							[| binding |
							binding := Smalltalk resolveBindingPath: ($. split: each).
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
		ifAbsent: []!

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
!Refactory.Browser.ClassEnvironment categoriesFor: #addClass:!adding!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #classes:!initialize/release!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #classes:metaClasses:!initialize/release!private! !
!Refactory.Browser.ClassEnvironment categoriesFor: #classesAndSelectorsDo:!accessing!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #classesDo:!accessing/classes!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #classNames!accessing/classes!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #defaultLabel!constants!private! !
!Refactory.Browser.ClassEnvironment categoriesFor: #definesClass:!public!testing! !
!Refactory.Browser.ClassEnvironment categoriesFor: #includesCategory:!public!testing! !
!Refactory.Browser.ClassEnvironment categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.ClassEnvironment categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #isClassEnvironment!public!testing! !
!Refactory.Browser.ClassEnvironment categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.ClassEnvironment categoriesFor: #postCopy!copying!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #problemCount!accessing!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #removeClass:!public!removing! !
!Refactory.Browser.ClassEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!Refactory.Browser.ClassEnvironment categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.ClassEnvironment class methodsFor!

onEnvironment: anEnvironment classes: aCollection
	^(self onEnvironment: anEnvironment)
		classes: aCollection; yourself! !
!Refactory.Browser.ClassEnvironment class categoriesFor: #onEnvironment:classes:!instance creation!public! !

