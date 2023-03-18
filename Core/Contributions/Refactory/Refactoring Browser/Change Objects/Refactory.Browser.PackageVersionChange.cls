"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryChange
	subclass: #'Refactory.Browser.PackageVersionChange'
	instanceVariableNames: 'version packageName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.PackageVersionChange guid: (Core.GUID fromString: '{c30ae03a-d2b9-4518-8375-23866457a161}')!
Refactory.Browser.PackageVersionChange comment: ''!
!Refactory.Browser.PackageVersionChange methodsFor!

afterText
	^'(Package named: <1p>) paxVersion: <2p>' << {packageName. version}!

beforeText
	^'(Package named: <1p>) paxVersion: <2p>' << {packageName. (self package ?? Package) paxVersion}!

changeString
	^'<1s> package <2p>'
		<< {version < Package paxVersion ifTrue: ['Downgrade'] ifFalse: ['Upgrade']. packageName}!

executeNotifying: aBlock 
	| pkg undo |
	pkg := self package.
	undo := PackageVersionChange packageName: packageName version: pkg paxVersion.
	undo name: self name.
	pkg paxVersion: version.
	^undo!

package
	^Package manager packageNamed: packageName ifNone: []!

packageName
	^packageName!

packageName: anObject
	packageName := anObject!

version
	^version!

version: anObject
	version := anObject! !
!Refactory.Browser.PackageVersionChange categoriesForMethods!
afterText!printing!public! !
beforeText!printing!public! !
changeString!printing!public! !
executeNotifying:!applying!private! !
package!accessing!public! !
packageName!accessing!public! !
packageName:!accessing!private! !
version!accessing!public! !
version:!accessing!private! !
!

!Refactory.Browser.PackageVersionChange class methodsFor!

package: aPackage version: aNumber
	^self packageName: aPackage name version: aNumber!

packageName: aString version: aNumber
	^self new
		packageName: aString;
		version: aNumber;
		yourself! !
!Refactory.Browser.PackageVersionChange class categoriesForMethods!
package:version:!instance creation!public! !
packageName:version:!instance creation!public! !
!

