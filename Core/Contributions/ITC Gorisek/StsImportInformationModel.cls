"Filed out from Dolphin Smalltalk X6.2"!

Model subclass: #StsImportInformationModel
	instanceVariableNames: 'version developer previousVersions comment previousEdition versionComment blessingLevels blessing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsImportInformationModel guid: (GUID fromString: '{2A58B366-A4C6-45E6-A35F-2DE5B64ACB08}')!
StsImportInformationModel comment: ''!
!StsImportInformationModel categoriesForClass!Unclassified! !
!StsImportInformationModel methodsFor!

blessing
	^blessing!

blessing: anObject
	blessing := anObject!

blessingLevels
	^blessingLevels!

blessingLevels: anObject
	blessingLevels := anObject!

comment
	"Private - Answer the value of the receiver's ''comment'' instance variable."

	^comment!

comment: anObject
	"Private - Set the value of the receiver's ''comment'' instance variable to the argument, anObject."

	comment := anObject!

developer
	"Private - Answer the value of the receiver's ''developer'' instance variable."

	^developer!

developer: anObject 
	"Private - Set the value of the receiver's ''developer'' instance variable to the argument, anObject."

	developer := anObject!

initialize
	version := 'version'.
	developer := 'developer'.
	previousVersions := ListModel on: OrderedCollection new.
	comment := 'comment'!

previousEdition
	"Private - Answer the value of the receiver's ''selectedVersion'' instance variable."

	^previousEdition!

previousEdition: anObject
	"Private - Set the value of the receiver's ''selectedVersion'' instance variable to the argument, anObject."

	previousEdition := anObject!

previousVersions
	"Private - Answer the value of the receiver's ''previousVersions'' instance variable."

	^previousVersions!

previousVersions: anObject
	"Private - Set the value of the receiver's ''previousVersions'' instance variable to the argument, anObject."

	previousVersions := anObject!

version
	"Private - Answer the value of the receiver's ''version'' instance variable."

	^version!

version: anObject
	"Private - Set the value of the receiver's ''version'' instance variable to the argument, anObject."

	version := anObject!

versionComment
	^versionComment!

versionComment: anObject
	versionComment := anObject! !
!StsImportInformationModel categoriesFor: #blessing!accessing!private! !
!StsImportInformationModel categoriesFor: #blessing:!accessing!private! !
!StsImportInformationModel categoriesFor: #blessingLevels!accessing!private! !
!StsImportInformationModel categoriesFor: #blessingLevels:!accessing!private! !
!StsImportInformationModel categoriesFor: #comment!accessing!private! !
!StsImportInformationModel categoriesFor: #comment:!accessing!private! !
!StsImportInformationModel categoriesFor: #developer!accessing!private! !
!StsImportInformationModel categoriesFor: #developer:!accessing!private! !
!StsImportInformationModel categoriesFor: #initialize!public! !
!StsImportInformationModel categoriesFor: #previousEdition!accessing!private! !
!StsImportInformationModel categoriesFor: #previousEdition:!accessing!private! !
!StsImportInformationModel categoriesFor: #previousVersions!accessing!private! !
!StsImportInformationModel categoriesFor: #previousVersions:!accessing!private! !
!StsImportInformationModel categoriesFor: #version!accessing!private! !
!StsImportInformationModel categoriesFor: #version:!accessing!private! !
!StsImportInformationModel categoriesFor: #versionComment!accessing!private! !
!StsImportInformationModel categoriesFor: #versionComment:!accessing!private! !

!StsImportInformationModel class methodsFor!

package: aPackage 
	| sourceControl editions |
	sourceControl := StsManager current.
	^(self new)
		version: (sourceControl 
					incrementOne: ((editions := sourceControl getPackageEditionsFor: aPackage name) isEmpty 
							ifTrue: ['0.000']
							ifFalse: [editions first versionDescriptor]));
		developer: sourceControl getCurrentDeveloper;
		previousVersions: ((ListModel on: editions)
					addFirst: nil;
					yourself);
		previousEdition: (sourceControl getLoadedPackageFor: aPackage name);
		blessingLevels: (ListModel on: StsEdition possibleBlessingLevels asOrderedCollection);
		comment: (aPackage comment ifNil: ['']);
		versionComment: '';
		yourself!

project: aProjectEdition 
	| sourceControl projectPreviousEdition |
	sourceControl := StsManager current.
	^(self new)
		version: (sourceControl 
					incrementOne: ((projectPreviousEdition := aProjectEdition previousEdition) isNil 
							ifTrue: ['0.000']
							ifFalse: [projectPreviousEdition versionDescriptor]));
		developer: aProjectEdition developer;
		previousVersions: ((ListModel on: ((sourceControl getProjectEditionsFor: aProjectEdition name) 
							reject: [:each | each isOpenEdition]))
					addFirst: nil;
					yourself);
		previousEdition: projectPreviousEdition;
		blessingLevels: (ListModel on: ((StsEdition possibleBlessingLevels asOrderedCollection)
							addFirst: nil;
							yourself));
		blessing: aProjectEdition blessing;
		comment: (aProjectEdition comment ifNil: ['']);
		versionComment: (aProjectEdition versionComment ifNil: ['']);
		yourself!

projectForPackages: aProjectEdition 
	^(self new)
		version: '';
		developer: aProjectEdition developer;
		previousVersions: nil;
		blessingLevels: (ListModel on: ((StsEdition possibleBlessingLevels asOrderedCollection)
							addFirst: nil;
							yourself));
		blessing: aProjectEdition blessing;
		comment: (aProjectEdition comment ifNil: ['']);
		versionComment: (aProjectEdition versionComment ifNil: ['']);
		yourself! !
!StsImportInformationModel class categoriesFor: #package:!public! !
!StsImportInformationModel class categoriesFor: #project:!public! !
!StsImportInformationModel class categoriesFor: #projectForPackages:!public! !

