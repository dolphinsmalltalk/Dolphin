"Filed out from Dolphin Smalltalk 7"!

VirtualMethodCategory subclass: #LooseMethodCategory
	instanceVariableNames: 'package'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'instances'!
LooseMethodCategory guid: (GUID fromString: '{ceb19912-445e-4035-92cd-2e35a063441f}')!
LooseMethodCategory comment: ''!
!LooseMethodCategory categoriesForClass!Development! !
!LooseMethodCategory methodsFor!

includesMethod: aCompiledMethod

	^package includesMethod: aCompiledMethod!

isPseudoCategoryForClass: aClassDescription

	^package includesLooseMethodsFor: aClassDescription!

package: aPackage

	package := aPackage! !
!LooseMethodCategory categoriesFor: #includesMethod:!public!testing! !
!LooseMethodCategory categoriesFor: #isPseudoCategoryForClass:!public!testing! !
!LooseMethodCategory categoriesFor: #package:!accessing!public! !

!LooseMethodCategory class methodsFor!

forPackage: aPackage

	^instances at: aPackage name ifAbsent: []!

initialize
	"Private - Initialize the receiver.
		self initialize.
	"

	instances := LookupTable new.
	self rebuildInstances.
	Package manager when: #loadedChanged send: #onLoadedPackagesChanged to: self!

looseMethodsPrefix

	^'loose methods-'!

newForPackage: aPackage

	^(self newNamed: (self pseudPrefix, self looseMethodsPrefix, aPackage name))
		package: aPackage;
		yourself!

onLoadedPackagesChanged

	self rebuildInstances!

rebuildInstances

	| oldNames departures arrivals |

	oldNames := instances keys.

	departures := oldNames difference: PackageManager current packageNames.
	arrivals := Package manager packageNames difference: oldNames.

	departures isEmpty ifFalse: [self removeCategories: (departures collect: [ :each | instances removeKey: each])].
	arrivals isEmpty ifFalse: [self addPseuds: (arrivals collect: [ :each | instances at: each put: (self newForPackage: (Package manager packageNamed: each))])]!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	instances isNil ifTrue: [^self].

	PackageManager current removeEventsTriggeredFor: self.
	self removeCategories: instances.
	instances := nil! !
!LooseMethodCategory class categoriesFor: #forPackage:!accessing!public! !
!LooseMethodCategory class categoriesFor: #initialize!initializing!private! !
!LooseMethodCategory class categoriesFor: #looseMethodsPrefix!constants!public! !
!LooseMethodCategory class categoriesFor: #newForPackage:!instance creation!private! !
!LooseMethodCategory class categoriesFor: #onLoadedPackagesChanged!event handling!public! !
!LooseMethodCategory class categoriesFor: #rebuildInstances!helpers!private! !
!LooseMethodCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

