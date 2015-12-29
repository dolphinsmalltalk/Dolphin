"Filed out from Dolphin Smalltalk X6.2"!

StsEdition subclass: #StsProjectEdition
	instanceVariableNames: 'name versionDescriptor packageEditions previousEdition blessing comment versionComment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsProjectEdition guid: (GUID fromString: '{10D6A002-AF19-11D4-B232-000000000000}')!
StsProjectEdition comment: ''!
!StsProjectEdition categoriesForClass!Unclassified! !
!StsProjectEdition methodsFor!

allPrerequisitePackageNamesIncludingBase: includeBase 
	| prereqs visited roots |
	roots := self rootPackageEditions.
	prereqs := OrderedCollection new.
	visited := Set new.
	roots do: 
			[:eachRoot | 
			self sourceControl 
				allPrerequisitePackageNamesOf: eachRoot
				prereqs: prereqs
				visited: visited
				includeBasePackages: includeBase].
	^prereqs 
		select: [:each | (self sourceControl getLatestPackageEditionFor: each) isBaseImagePackage not]!

basicExportAsXmlOn: writer 
	| pe |
	writer tag: 'project'
		do: 
			[self basicExportVersionDataOn: writer.
			(pe := self previousEdition) isNil 
				ifFalse: [writer tag: 'previousVersion' value: pe versionDescriptor].
			self packageEditions do: [:each | each basicExportAsXmlOn: writer]]!

basicExportHeaderAsXmlOn: writer 
	| pe |
	writer tag: 'projectHeader'
		do: 
			[self basicExportVersionDataOn: writer.
			(pe := self previousEdition) isNil 
				ifFalse: [writer tag: 'previousVersion' value: pe versionDescriptor].
			pe := self previousEdition.
			30 timesRepeat: 
					[pe isNil 
						ifFalse: 
							[writer tag: 'previousVersionData' do: [pe basicExportVersionDataOn: writer].
							pe := pe previousEdition]].
			self packageEditions do: [:each | each basicExportHeaderAsXmlOn: writer]]!

basicExportVersionDataOn: writer 
	writer
		tag: 'name' value: self name;
		tag: 'developer' value: self developer;
		tag: 'timestamp' value: self timestampValue;
		tag: 'version' value: self versionDescriptor;
		tag: 'blessing' value: (self blessing ifNil: ['']) asString;
		tag: 'comment' value: (self comment ifNil: ['']);
		tag: 'versionComment' value: (self versionComment ifNil: [''])!

basicLoad
	| loadedPackage |
	self packageEditions do: 
			[:each | 
			(each isLoadedAndNotChanged and: 
					[(loadedPackage := Package manager packageNamed: each name ifNone: []) notNil 
						and: [loadedPackage isChanged not]]) 
				ifFalse: [each basicLoad]]!

blessing
	^blessing!

blessing: aSymbolOrNil 
	(blessing isNil or: [self possibleBlessingLevels includes: aSymbolOrNil]) 
		ifFalse: [self error: 'Invalid blessing level'].
	blessing := aSymbolOrNil!

checkPrerequisites
	| changedPackages loadedPackage missingNames str |
	changedPackages := self packageEditions select: 
					[:each | 
					(loadedPackage := Package manager packageNamed: each name ifNone: []) notNil 
						and: [loadedPackage isChanged]].
	changedPackages notEmpty 
		ifTrue: 
			[str := 'You are about to load packages that are already
loaded in your image and have been changed.
If you continue changes to the following packages will be lost:

- ' 
						, changedPackages first name.
			2 to: changedPackages size do: [:i | str := str , '
- ' , (changedPackages at: i) name].
			(MessageBox confirm: str , '

Are you sure you want to continue?'
				caption: 'Loading project ' , name) ifFalse: [^false]].
	missingNames := Set new.
	self packageEditions do: 
			[:each | 
			missingNames addAll: (each prerequisiteNames 
						select: [:eachName | (Package manager includesPackageNamed: eachName) not])].
	self packageEditions do: [:each | missingNames remove: each name ifAbsent: []].
	^(missingNames := missingNames asOrderedCollection) isEmpty 
		ifTrue: [true]
		ifFalse: 
			[str := 'The following prerequisite packages should be loaded before:

   - ' , missingNames first.
			2 to: missingNames size do: [:i | str := str , '
   - ' , (missingNames at: i)].
			MessageBox confirm: str , '

Are you sure you want to continue?'
				caption: 'Loading project ' , name]!

comment
	^comment!

comment: anObject
	comment := anObject!

displayOn: aStream 
	aStream
		nextPutAll: name;
		space;
		nextPutAll: (versionDescriptor ifNil: ['(open)'])!

exportAsXmlOn: stream 
	| writer |
	stream nextPutAll: '<?xml version="1.0"?>
'.
	writer := StsXmlWriter on: stream.
	self basicExportAsXmlOn: writer!

exportHeaderAsXmlOn: stream 
	| writer |
	stream nextPutAll: '<?xml version="1.0"?>
'.
	writer := StsXmlWriter on: stream.
	self basicExportHeaderAsXmlOn: writer!

isOpenEdition
	"Answer <true> if this project edition can be changed i.e. if it is open edition.
		When an open edition is versioned it can not be changed anymore."

	^versionDescriptor isNil!

load
	self checkPrerequisites 
		ifTrue: 
			[Package manager beNotProcessingEvents.
			[self basicLoad] ensure: 
					[(Package manager)
						beProcessingEvents;
						loadedChanged]]!

name
	^name!

name: aString 
	name := aString!

packageEditions
	packageEditions isNil ifTrue: [packageEditions := OrderedCollection new].
	^packageEditions!

packageEditions: anOrderedCollection 
	packageEditions := anOrderedCollection!

previousEdition
	^previousEdition!

previousEdition: aProjectEdition 
	previousEdition := aProjectEdition!

printOn: aStream 
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	super printOn: aStream.
	aStream
		nextPut: $(;
		display: self;
		nextPut: $)!

projectVersion
	^versionDescriptor!

resolveProxies
	super resolveProxies.
	self packageEditions do: [:each | each resolveProxies]!

rootPackageEditions
	"Answer the package editions for the receiver that are the roots of the project, i.e. they
	aren't there just as prerequisites of the other packages"

	| roots |
	roots := self packageEditions collect: [:each | each name].
	self packageEditions do: 
			[:eachPackageEdition | 
			| prereqs |
			prereqs := eachPackageEdition prerequisiteNames.
			prereqs do: [:eachName | roots remove: eachName ifAbsent: []]].
	^self packageEditions select: [:each | roots includes: each name]!

versionComment
	^versionComment!

versionComment: anObject
	versionComment := anObject!

versionDescriptor
	^versionDescriptor isNil ifTrue: ['-new edition-'] ifFalse: [versionDescriptor]!

versionDescriptor: aString 
	versionDescriptor := aString!

versionIdString
	^self versionDescriptor printString , ' ' , self timestamp printString , ' ' 
		, self developer printString! !
!StsProjectEdition categoriesFor: #allPrerequisitePackageNamesIncludingBase:!accessing!public! !
!StsProjectEdition categoriesFor: #basicExportAsXmlOn:!accessing!public! !
!StsProjectEdition categoriesFor: #basicExportHeaderAsXmlOn:!accessing!public! !
!StsProjectEdition categoriesFor: #basicExportVersionDataOn:!accessing!private! !
!StsProjectEdition categoriesFor: #basicLoad!operations!public! !
!StsProjectEdition categoriesFor: #blessing!accessing!public! !
!StsProjectEdition categoriesFor: #blessing:!accessing!public! !
!StsProjectEdition categoriesFor: #checkPrerequisites!operations!public! !
!StsProjectEdition categoriesFor: #comment!accessing!public! !
!StsProjectEdition categoriesFor: #comment:!accessing!public! !
!StsProjectEdition categoriesFor: #displayOn:!public! !
!StsProjectEdition categoriesFor: #exportAsXmlOn:!accessing!public! !
!StsProjectEdition categoriesFor: #exportHeaderAsXmlOn:!accessing!public! !
!StsProjectEdition categoriesFor: #isOpenEdition!public! !
!StsProjectEdition categoriesFor: #load!operations!public! !
!StsProjectEdition categoriesFor: #name!accessing!public! !
!StsProjectEdition categoriesFor: #name:!accessing!public! !
!StsProjectEdition categoriesFor: #packageEditions!accessing!public! !
!StsProjectEdition categoriesFor: #packageEditions:!accessing!public! !
!StsProjectEdition categoriesFor: #previousEdition!accessing!public! !
!StsProjectEdition categoriesFor: #previousEdition:!accessing!public! !
!StsProjectEdition categoriesFor: #printOn:!printing!public! !
!StsProjectEdition categoriesFor: #projectVersion!accessing!public! !
!StsProjectEdition categoriesFor: #resolveProxies!OmniBase!public! !
!StsProjectEdition categoriesFor: #rootPackageEditions!accessing!public! !
!StsProjectEdition categoriesFor: #versionComment!accessing!public! !
!StsProjectEdition categoriesFor: #versionComment:!accessing!public! !
!StsProjectEdition categoriesFor: #versionDescriptor!accessing!public! !
!StsProjectEdition categoriesFor: #versionDescriptor:!accessing!public! !
!StsProjectEdition categoriesFor: #versionIdString!accessing!public! !

!StsProjectEdition class methodsFor!

displayName
	^'Project'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

projectIcon
	^Icon fromId: 'STSPROJECT.ICO'! !
!StsProjectEdition class categoriesFor: #displayName!public! !
!StsProjectEdition class categoriesFor: #icon!constants!public! !
!StsProjectEdition class categoriesFor: #projectIcon!constants!public! !

