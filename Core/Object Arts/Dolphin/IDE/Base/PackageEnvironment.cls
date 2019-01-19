"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentWrapper subclass: #PackageEnvironment
	instanceVariableNames: 'packages'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageEnvironment guid: (GUID fromString: '{1e100fa3-4c91-4f2c-8415-03d6fbca4185}')!
PackageEnvironment comment: 'PackageEnvironment is a Dolphin specific BrowserEnvironment that represents the contents of one or more packages.

Instance Variables:
	packages		<Array> of <Package>'!
!PackageEnvironment categoriesForClass!Refactoring-Environment! !
!PackageEnvironment methodsFor!

classesDo: aBlock 
	"Note that the classes of the loose methods and the package's owned classes are non-overlapping sets, however since
	we (potentially) have multiple packages we have to be careful not to enumerate classes more than once as a result
	of them being both owned by a package in the environment, and having loose methods in another package in the
	environment (#1324)."

	| seen |
	seen := Set new: 20.
	packages do: 
			[:eachPackage | 
			eachPackage behaviorsDo: 
					[:each | 
					(environment includesClass: each) 
						ifTrue: 
							[seen add: each name.	"#1324"
							aBlock value: each]].
			eachPackage methodNames do: 
					[:each | 
					| className |
					className := each key.
					(seen includes: className) 
						ifFalse: 
							[| class |
							class := (eachPackage behaviorFromName: className ifAbsent: []) instanceClass.
							(class notNil and: [environment includesClass: class]) 
								ifTrue: 
									["Both class and metaclass must be in the environment, regardless of the where loose methods reside."
									aBlock
										value: class;
										value: class class].
							seen
								add: class name;
								add: class class name]]]!

defaultLabel
	| stream |
	stream := String new writeStream.
	self packageNames do: [:each | stream nextPutAll: each]
		separatedBy: [stream nextPutAll: ', '].
	^stream contents!

definesClass: aClass
	^packages anySatisfy: [:each | each includesClass: aClass]!

definesLooseMethodsInClass: aClass 
	| class className metaclassName |
	class := aClass instanceClass.
	className := class name.
	metaclassName := class class name.
	^packages anySatisfy: 
			[:eachPackage | 
			eachPackage methodNames 
				anySatisfy: [:each | each key == className or: [each key = metaclassName]]]!

includesClass: aClass 
	^(super includesClass: aClass) 
		and: [(self definesClass: aClass) or: [self definesLooseMethodsInClass: aClass]]!

includesResource: aResourceIdentifier 
	#rbFix.	"Dolphin specific extension"
	^(self definesClass: aResourceIdentifier owningClass) or: 
			[self packages 
				anySatisfy: [:each | each resourceIdentifiers includes: aResourceIdentifier]]!

includesSelector: aSelector in: aClass
	^(environment includesSelector: aSelector in: aClass) and: 
			[| method |
			method := aClass methodFor: aSelector.
			method notNil and: [packages includes: method owningPackage]]!

isSinglePackage
	^packages size = 1!

packageNames
	^packages collect: [:each | each name]!

packageNames: aCollection
	| pacman |
	pacman := Smalltalk developmentSystem packageManager.
	self packages: (aCollection collect: [:each | pacman packageNamed: each])!

packages
	^packages!

packages: aCollection
	packages := aCollection asArray!

selectorsForClass: aClass do: aBlock 
	| name |
	(self definesClass: aClass) 
		ifTrue: 
			[aClass selectorsAndMethodsDo: 
					[:eachSelector :eachMethod | 
					(eachMethod isLoose not and: [environment includesSelector: eachSelector in: aClass]) 
						ifTrue: [aBlock value: eachSelector]].
			"If only one package in the environment, can skip enumeration of loose
			methods since there cannot be any (a package cannot both define a class and
			own loose methods of that class)"
			self isSinglePackage ifTrue: [^self]].

	"#1325: Must enumerate any loose methods, regardless of whether one of the packages in this
	environment defines the class."
	name := aClass name.
	packages do: 
			[:eachPackage | 
			eachPackage methodNames do: 
					[:each | 
					each key = name 
						ifTrue: [(environment includesSelector: each value in: aClass) ifTrue: [aBlock value: each value]]]]!

storeOn: aStream
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream nextPutAll: ' packageNames: '.
	self packageNames storeOn: aStream.
	aStream nextPutAll: ';yourself)'! !
!PackageEnvironment categoriesFor: #classesDo:!accessing/classes!public! !
!PackageEnvironment categoriesFor: #defaultLabel!constants!private! !
!PackageEnvironment categoriesFor: #definesClass:!public!testing! !
!PackageEnvironment categoriesFor: #definesLooseMethodsInClass:!private!testing! !
!PackageEnvironment categoriesFor: #includesClass:!public!testing! !
!PackageEnvironment categoriesFor: #includesResource:!public!testing! !
!PackageEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!PackageEnvironment categoriesFor: #isSinglePackage!public!testing! !
!PackageEnvironment categoriesFor: #packageNames!accessing!public! !
!PackageEnvironment categoriesFor: #packageNames:!accessing!public! !
!PackageEnvironment categoriesFor: #packages!accessing!public! !
!PackageEnvironment categoriesFor: #packages:!accessing!private! !
!PackageEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!PackageEnvironment categoriesFor: #storeOn:!printing!public! !

!PackageEnvironment class methodsFor!

onEnvironment: anEnvironment packageNames: aString
	^(self onEnvironment: anEnvironment)
		packageNames: aString;
		yourself!

onEnvironment: anEnvironment packages: aPackage
	^(self onEnvironment: anEnvironment)
		packages: aPackage;
		yourself! !
!PackageEnvironment class categoriesFor: #onEnvironment:packageNames:!instance creation!public! !
!PackageEnvironment class categoriesFor: #onEnvironment:packages:!instance creation!public! !

