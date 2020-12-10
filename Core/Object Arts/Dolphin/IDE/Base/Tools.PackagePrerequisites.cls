"Filed out from Dolphin Smalltalk 7"!

PackageDependencyPresenter subclass: #PackagePrerequisites
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!PackagePrerequisites categoriesFor: #childrenFor:!helpers!private! !
!PackagePrerequisites categoriesFor: #dependentPackage!accessing!private! !
!PackagePrerequisites categoriesFor: #prerequisitePackage!accessing!private! !

!PackagePrerequisites class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Package Prerequisites'! !
!PackagePrerequisites class categoriesFor: #displayOn:!displaying!public! !

