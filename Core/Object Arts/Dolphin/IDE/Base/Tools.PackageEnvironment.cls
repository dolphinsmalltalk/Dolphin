﻿"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Tools.PackageEnvironment'
	instanceVariableNames: 'packages'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.PackageEnvironment guid: (Core.GUID fromString: '{1e100fa3-4c91-4f2c-8415-03d6fbca4185}')!

Tools.PackageEnvironment comment: '`PackageEnvironment` is a Dolphin specific `BrowserEnvironment` that represents the contents of one or more packages.

Instance Variables:
	packages		`<collection>` of `Kernel.Package`'!

!Tools.PackageEnvironment categoriesForClass!Refactoring-Environment! !

!Tools.PackageEnvironment methodsFor!

classesDo: aBlock
	"Note that the classes of the loose methods and the package's owned classes are non-overlapping sets, however since
	we (potentially) have multiple packages we have to be careful not to enumerate classes more than once as a result
	of them being both owned by a package in the environment, and having loose methods in another package in the
	environment (#1324)."

	| seen |
	seen := Set new: 20.
	packages do: 
			[:eachPackage |
			eachPackage classNames do: 
					[:each |
					(seen includes: each)
						ifFalse: 
							[| class |
							class := each value.
							(environment includesClass: class)
								ifTrue: 
									[seen add: each.
									aBlock value: class].
							(environment includesClass: class class)
								ifTrue: 
									[seen add: each meta.
									aBlock value: class class]]].
			eachPackage methodNames do: 
					[:each |
					| className |
					className := each className.
					(seen includes: className)
						ifFalse: 
							[| class |
							class := className valueOrNil ifNotNil: [:behavior | behavior instanceClass].
							(class notNil and: [environment includesClass: class])
								ifTrue: 
									["Both class and metaclass must be in the environment, regardless of where the loose methods reside."
									aBlock
										value: class;
										value: class class].
							seen
								add: className instance;
								add: className meta]]]!

defaultLabel
	| names count |
	names := self packageNames.
	count := names size.
	^count > 3 ifTrue: ['<d> Packages' << count] ifFalse: [', ' join: names]!

definesClass: aClass
	^packages identityIncludes: aClass owningPackage!

definesLooseMethodsInClass: aClass
	| className |
	className := aClass instanceClass fullyQualifiedReference.
	^packages
		anySatisfy: [:eachPackage | eachPackage methodNames anySatisfy: [:each | each className instance = className]]!

includesClass: aClass 
	^(super includesClass: aClass) 
		and: [(self definesClass: aClass) or: [self definesLooseMethodsInClass: aClass]]!

includesResource: aResourceIdentifier 
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
	pacman := PackageManager current.
	self packages: (aCollection collect: [:each | pacman packageNamed: each])!

packages
	^packages!

packages: aCollection
	packages := aCollection asArray!

selectorsForClass: aClass do: aBlock
	| classExtensions |
	classExtensions := PackageManager current looseMethods lookup: aClass.
	(self definesClass: aClass)
		ifTrue: 
			[classExtensions
				ifNil: 
					["There are no loose methods in the class, so it must be entirely defined in its owning package - we can just enumerate the method dictionary"
					aClass methodDictionary
						keysDo: [:each | (environment includesSelector: each in: aClass) ifTrue: [aBlock value: each]]]
				ifNotNil: 
					["The class has loose methods, which we must skip at this point (they are enumerated later)."
					aClass methodDictionary keysDo: 
							[:each |
							((classExtensions includesKey: each) not and: [environment includesSelector: each in: aClass])
								ifTrue: [aBlock value: each]]].
			"If only one package in the environment, can skip enumeration of loose methods since there cannot be any (a package cannot both define a class and own loose methods of that class)"
			self isSinglePackage ifTrue: [^self]].
	classExtensions isNil
		ifTrue: 
			["Class not extended"
			^self].
	"#1325: Must enumerate any loose methods, regardless of whether one of the packages in this environment defines the class."
	classExtensions keysAndValuesDo: 
			[:eachSelector :eachPackage |
			(packages identityIncludes: eachPackage)
				ifTrue: 
					["Because BindingReferences cache the binding they resolve to, it is typically faster to compare the target than the reference."
					(environment includesSelector: eachSelector in: aClass) ifTrue: [aBlock value: eachSelector]]]!

storeOn: aStream
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream nextPutAll: ' packageNames: '.
	self packageNames storeOn: aStream.
	aStream nextPutAll: ';yourself)'! !

!Tools.PackageEnvironment categoriesForMethods!
classesDo:!accessing/classes!public! !
defaultLabel!constants!private! !
definesClass:!public!testing! !
definesLooseMethodsInClass:!private!testing! !
includesClass:!public!testing! !
includesResource:!public!testing! !
includesSelector:in:!public!testing! !
isSinglePackage!public!testing! !
packageNames!accessing!public! !
packageNames:!accessing!public! !
packages!accessing!public! !
packages:!accessing!private! !
selectorsForClass:do:!accessing!public! !
storeOn:!printing!public! !
!

!Tools.PackageEnvironment class methodsFor!

onEnvironment: anEnvironment packageNames: aString
	^(self onEnvironment: anEnvironment)
		packageNames: aString;
		yourself!

onEnvironment: anEnvironment packages: aPackage
	^(self onEnvironment: anEnvironment)
		packages: aPackage;
		yourself! !

!Tools.PackageEnvironment class categoriesForMethods!
onEnvironment:packageNames:!instance creation!public! !
onEnvironment:packages:!instance creation!public! !
!

