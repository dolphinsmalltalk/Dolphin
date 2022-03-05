"Filed out from Dolphin Smalltalk"!

PackageDependencyPresenter subclass: #PackagePrerequisites
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackagePrerequisites guid: (GUID fromString: '{87b4c6c1-026e-11d3-9fd7-00a0cc3e4a32}')!
PackagePrerequisites comment: 'PackagePrerequisites is a development tool that displays a package pre-requisite hierarchy, rooted in the immedaite pre-requisites of a particular <Package>. For each prerequisite the list of all the links from the package to the prerequisite are listed. Each link shows: the object belonging to the package,  why it forced the prerequisite, and the object owned by the prerequisite which it relies upon. The links are generated and described within the Package>>tracePrerequisites method.

	'!
!PackagePrerequisites categoriesForClass!MVP-Presenters! !
!PackagePrerequisites methodsFor!

childrenFor: node 
	| prerequisitePackages |
	prerequisitePackages := Cursor wait showWhile: [node key getPrerequisites].
	^self buildChildNodes: prerequisitePackages for: node!

dependentPackage
	^self selectedPair ifNotNil: [:association | association value key]!

prerequisitePackage
	^self selectedPair ifNotNil: [:association | association key]! !
!PackagePrerequisites categoriesForMethods!
childrenFor:!helpers!private! !
dependentPackage!accessing!private! !
prerequisitePackage!accessing!private! !
!

!PackagePrerequisites class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Package Prerequisites'
! !
!PackagePrerequisites class categoriesForMethods!
displayOn:!displaying!public! !
!

