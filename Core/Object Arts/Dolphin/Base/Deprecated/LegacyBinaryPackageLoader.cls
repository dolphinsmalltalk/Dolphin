"Filed out from Dolphin Smalltalk"!

Object subclass: #LegacyBinaryPackageLoader
	instanceVariableNames: 'package stream binaryFiler'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LegacyBinaryPackageLoader guid: (GUID fromString: '{3a7aef4b-b094-46e9-b52e-fcdd2a8ddb40}')!

LegacyBinaryPackageLoader comment: ''!

!LegacyBinaryPackageLoader categoriesForClass!Unclassified! !

!LegacyBinaryPackageLoader methodsFor!

declareClasses
	"Private - Load all package classes definitions."

	package isMultifilePAC
		ifTrue: [package sourceManager fileIn: package classDefinitionsFileName]
		ifFalse: [self fileInClassDefinitions]!

errorFileCorrupt
	"Private - Filing in the receiver's owned objects has failed because the
	file is corrupt."

	self error: ('FileIn of <1s> package has failed, file is corrupt' expandMacrosWith: package name)!

errorUnknownFileVersion: foundVersion
	"Private - Raise an exception to inform that an attempt was made to load a
	package file of an unknown version."

	self error:
			'Unknown package file version found ', foundVersion displayString,
			'. Current version is ', package class packageFileVersion displayString!

fileInClassDefinitions
	"Private - Load all package classes from the filestream up to the end marker.
	Note that this is only used for loading single-file binary legacy (pre 4.0) packages."

	| filer |
	stream beText.
	filer := package sourceFilerOn: stream.
	
	[filer atEnd ifTrue: [^self errorFileCorrupt].
	(Compiler evaluate: filer nextChunk logged: true) = 'end-class-definition']
			whileFalse.
	stream skipSeparators.
	stream next ~= $X ifTrue: [^self errorFileCorrupt].
	stream beBinary!

load
	"Private - Load the package the receiver represents from the Dolphin 1.0..3.x format 
	(mixed STB binary and source text) on the <readableStream> argument, aReadStream."

	| version selector |
	stream := FileStream read: package packageFileName text: false.
	binaryFiler := STBInFiler on: stream.
	"Skip over the package. We ignore this (since it represents the package we are loading)."
	binaryFiler next.
	"Package format version follows"
	version := binaryFiler next.
	selector := self loaderForVersion: version.
	package paxVersion: 1.
	package preinstall.
	self perform: selector.
	package initializeGlobals.
	package initializeLegacyResources.
	package postinstall!

loaderForVersion: anInteger
	^(#(#loadVersion1 #loadVersion2 #loadVersion3 #loadVersion4 #loadVersion5) lookup: anInteger)
		ifNil: [self errorUnknownFileVersion: anInteger]!

loadGlobals
	"Private - File in binary definitions of all the globals held by
	the receiver are directly or indirectly through class ownership.
	Note that this is only used for loading legacy (pre 4.0 packages."

	package globalNames size timesRepeat: [binaryFiler next].

	"If the receiver is a source package then file in the individual global from files if this can be done. We can only do this if the files actually exist."
	package isMultifilePAC ifFalse: [^self].
	package globalNames do: 
			[:each |
			| fileName |
			fileName := package fileNameForSourceVariable: each.
			(File exists: fileName) ifTrue: [package sourceManager fileIn: fileName].
			each value isChanged: false]!

loadResources
	"Private - File in binary definitions of all the resources held by
	the receiver are directly or indirectly through class ownership."

	| aResourceIdentifier resourceNames |
	resourceNames := OrderedCollection new.
	[(aResourceIdentifier := binaryFiler next) notNil] whileTrue: 
			[| resource |
			"Read in the binary resource"
			resource := binaryFiler next.
			aResourceIdentifier assign: resource.
			resourceNames add: aResourceIdentifier owningClass name -> aResourceIdentifier name].
	package allResourceNames: resourceNames!

loadVersion1
	"Private - File in the objects owned by the receiver. The binaryFiler is positioned to
	a number of stored objects, organized into file version 1."

	self vmVersionCheck: -1.
	package declareVariables.
	self fileInClassDefinitions.
	self loadGlobals.
	package isMultifilePAC ifTrue: [package fileInClasses].
	"File in any trailing source code of class/methods"
	package sourceManager fileInFrom: stream beText!

loadVersion2
	"Private - File in the objects owned by the receiver. The binaryFiler is positioned to
	a number of stored objects, organized into file version 2."

	self vmVersionCheck: -1.
	package declareGlobals.
	self declareClasses.
	self loadGlobals.
	package isMultifilePAC ifTrue: [package fileInClasses].
	"File in any trailing source code of class/methods"
	package sourceManager fileInFrom: stream beText!

loadVersion3
	"Private - File in the objects owned by the receiver. The binaryFiler is positioned to
	a number of stored objects, organized into file version 3."

	self vmVersionCheck: -1.
	package declareVariables.
	self declareClasses.
	self loadGlobals.

	"Load in resources for each class"
	package classNames size timesRepeat: 
			[| className resourceClass |
			className := binaryFiler next.
			resourceClass := package classFromName: className.
			binaryFiler next
				keysAndValuesDo: [:resourceName :resource | (ResourceIdentifier class: resourceClass name: resourceName) assign: resource]].
	package isMultifilePAC ifTrue: [package fileInClasses].
	"File in any trailing source code of class/methods"
	package sourceManager fileInFrom: stream beText!

loadVersion4
	"Private - File in the objects owned by the receiver. The binaryFiler is positioned to
	a number of stored objects, organized into file version 4."

	self vmVersionCheck: -1.
	package declareGlobals.
	self declareClasses.
	self loadGlobals.
	self loadResources.	"File in any trailing source code of class/methods"
	package isMultifilePAC ifTrue: [package fileInClasses].
	package sourceManager fileInFrom: stream beText!

loadVersion5
	"Private - File in the objects owned by the receiver. The binaryFiler is positioned to
	a number of stored objects, organized into file version 5."

	self vmVersionCheck: binaryFiler next.
	"The old multi-file package is no longer a possibility - .pax is used for this instead"
	package declareGlobals.
	self fileInClassDefinitions.
	self loadGlobals.
	self loadResources.	"File in any trailing source code of class/methods"
	package sourceManager fileInFrom: stream beText!

package: aPackage
	package := aPackage!

vmVersionCheck: anInteger
	"Private - Raise a warning to the effect that the package being loaded
	was saved with an older, and incompatible, version of the VM, and so
	it may need to be modified (e.g. by recompiling blocks in version resources)
	in order to work - it should load OK though."

	| versionString verOnLoad |
	verOnLoad := VMLibrary default bytecodeVersion.
	anInteger = verOnLoad ifTrue: [^self].
	versionString := anInteger > 0
				ifTrue: [anInteger highWord displayString , '.' , anInteger lowWord displayString]
				ifFalse: ['unknown'].
	Notification
		signal: ('The package <1p> was saved with a different version of the Dolphin VM (<2s>). 
It will probably load, but it may not operate correctly. 
If you experience subsequent problems please contact the package supplier for an updated version.'
				expandMacrosWith: package name
				with: versionString)! !

!LegacyBinaryPackageLoader categoriesForMethods!
declareClasses!helpers!private! !
errorFileCorrupt!exceptions!private! !
errorUnknownFileVersion:!exceptions!legacy package loading!private! !
fileInClassDefinitions!development!private!source filing! !
load!legacy package loading!private! !
loaderForVersion:!legacy package loading!private! !
loadGlobals!legacy package loading!private! !
loadResources!legacy package loading!private! !
loadVersion1!legacy package loading!private! !
loadVersion2!legacy package loading!private! !
loadVersion3!legacy package loading!private! !
loadVersion4!legacy package loading!private! !
loadVersion5!legacy package loading!private! !
package:!initializing!private! !
vmVersionCheck:!constants!private! !
!

!LegacyBinaryPackageLoader class methodsFor!

loadPackage: aPackage
	(self package: aPackage) load!

package: aPackage
	^self new
		package: aPackage;
		yourself!

readFrom: aReadStream
	| package |
	package := (STBInFiler on: aReadStream) next.
	^(package isKindOf: Package) ifTrue: [package]! !

!LegacyBinaryPackageLoader class categoriesForMethods!
loadPackage:!operations!public! !
package:!instance creation!public! !
readFrom:!operations!public! !
!

