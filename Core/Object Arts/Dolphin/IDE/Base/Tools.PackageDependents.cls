"Filed out from Dolphin Smalltalk 7"!

Tools.PackageDependencyPresenter subclass: #'Tools.PackageDependents'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackageDependents guid: (Core.GUID fromString: '{0e8e273e-5319-43d1-a29f-21afd906dc91}')!
Tools.PackageDependents comment: 'PackageDependents is a development tool that displays a package dependency hierarchy, rooted in the immediate depdendents of a particular <Package>. The dependents of a package are those packages for which the original package is a pre-requisite. For each dependant the list of all the links from the package to the prerequisite are listed. Each link shows: the object belonging to the package,  the nature of the dependency relationship, and the object owned by the prerequisite upon which it relies.. The links are generated and described within the Package>>tracePrerequisites method.'!
!Tools.PackageDependents categoriesForClass!MVP-Presenters! !
!Tools.PackageDependents methodsFor!

childrenFor: aTreeNode 
	| dependentPackages |
	dependentPackages := Cursor wait showWhile: [aTreeNode key dependentPackages].
	^self buildChildNodes: dependentPackages for: aTreeNode!

dependentPackage
	^self selectedPair ifNotNil: [:association | association key]!

prerequisitePackage
	^self selectedPair ifNotNil: [:association | association value key]! !
!Tools.PackageDependents categoriesFor: #childrenFor:!helpers!private! !
!Tools.PackageDependents categoriesFor: #dependentPackage!accessing!private! !
!Tools.PackageDependents categoriesFor: #prerequisitePackage!accessing!private! !

