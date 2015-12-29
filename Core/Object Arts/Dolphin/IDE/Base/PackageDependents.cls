"Filed out from Dolphin Smalltalk X6"!

PackageDependencyPresenter subclass: #PackageDependents
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageDependents guid: (GUID fromString: '{0E8E273E-5319-43D1-A29F-21AFD906DC91}')!
PackageDependents comment: 'PackageDependents is a development tool that displays a package dependency hierarchy, rooted in the immediate depdendents of a particular <Package>. The dependents of a package are those packages for which the original package is a pre-requisite. For each dependant the list of all the links from the package to the prerequisite are listed. Each link shows: the object belonging to the package,  the nature of the dependency relationship, and the object owned by the prerequisite upon which it relies.. The links are generated and described within the Package>>tracePrerequisites method.'!
!PackageDependents categoriesForClass!MVP-Presenters! !
!PackageDependents methodsFor!

childrenFor: aTreeNode 
	| dependentPackages |
	dependentPackages := Cursor wait showWhile: [aTreeNode key dependentPackages].
	^self buildChildNodes: dependentPackages for: aTreeNode!

dependentPackage
	^self selectedPair ifNotNil: [:association | association key]!

prerequisitePackage
	^self selectedPair ifNotNil: [:association | association value key]! !
!PackageDependents categoriesFor: #childrenFor:!helpers!private! !
!PackageDependents categoriesFor: #dependentPackage!accessing!private! !
!PackageDependents categoriesFor: #prerequisitePackage!accessing!private! !

