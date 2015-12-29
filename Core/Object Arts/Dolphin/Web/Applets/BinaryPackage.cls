"Filed out from Dolphin Smalltalk X6"!

Object subclass: #BinaryPackage
	instanceVariableNames: 'name classes methods resources keepSource'
	classVariableNames: 'ImportedPackages'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BinaryPackage guid: (GUID fromString: '{1F7435D9-2C57-41DD-B302-5D801BA2AD84}')!
BinaryPackage comment: 'A BinaryPackage holds the contents of a standard Dolphin source Package but in a binary only format. 

Usually, an instance will be created from a package and then used to file out the contents as binary. This can later be imported into another image that does not have the source package present. 

"Save a binary package"
bp := BinaryPackage for: (PackageManager current at: ''Scribble'').
bp fileOut.

"Load the saved package from a class locator"
locator := 	ClassLocator codeBase: ''\Program Files\Dolphin\Samples\Scribble\'' packageName: ''Scribble''.
bp := BinaryPackage loadUsing: locator.
bp importedPackages "Display it".
(bp classAt: ''Scribble'') show.

Instance Variables:
	name		<readableString> holding the package name.
	classes		<IdentitySet> holding the classes in the package.
	methods		<IdentitySet> holding the loose methods in the package.
	resources		<LookupTable> holding the resources

Class Variables:
	ImportedPackages	<LookupTable> of packages that have been imported into this image keyed by locator #fullPackageKeys.

'!
!BinaryPackage categoriesForClass!System-Binary class loading! !
!BinaryPackage methodsFor!

classAt: aClassName
	"Answer the class held by the receiver that matches aClassName"

	| className |
	className := aClassName asSymbol.
	^self classes detect:[:each | each name=className]!

classes
	"Answer the classes belonging to the receiver"

	^classes!

classes: classesCollection 
	classes := classesCollection!

defaultKeepSource
	"Answer whether binary packages should keep their source with them by default (for debugging purposes)."

	^false!

fileOut
	"File out the receiver as a binary package"

	self fileOutAs: self fileOutName!

fileOutAs: filename 
	| stream |
	stream := FileStream write: filename text: false.
	
	[| filer |
	filer := STBOutFiler on: stream.
	filer
		nextPut: self class binaryPackageVersion;
		nextPut: self class baselineImageVersion;
		nextPut: self] 
			ensure: [stream close]!

fileOutName
	"Private - Answer a filename to use when saving the receiver to a file. "

	^File composePath: self fileOutPath stem: self name extension: ClassLocator binaryPackageExtension!

fileOutPath
	"Private - Answer a path to use when saving the receiver to a file. We take this
	as being the path of any same-named package in the image."

	^(Package manager packageNamed: self name) path!

fileOutSignedWith: aCertificate privateKey: privateKey 
	"File out the receiver as a binary package and signs the class files with aCertificate and
	its private key."

	| filename stream packageData stub |
	filename := self fileOutName.
	self fileOut.
	stream := FileStream read: filename text: false.
	packageData := stream contents.
	stream close.

	"Encrypt the classdata and write back to the file. Any error encrypting the classdata is liable
	to be caused by an invalid private key"
	stream := FileStream write: filename text: false.
	
	[stub := DolphinSureTrustedData 
				data: packageData
				description: self name , ' Package'
				publisherCertificate: aCertificate
				privateKey: privateKey] 
			on: Error
			do: [:err | self error: ' Error encrypting package with Private Key: ' , privateKey displayString].
	stub binaryStoreOn: stream.
	stream close!

fileOutSignedWith: aCertificate privateKey: privateKey as: filename 
	"File out the receiver as a binary package and signs the class files with aCertificate and
	its private key."

	| stream packageData stub |
	self fileOutAs: filename.
	stream := FileStream read: filename text: false.
	packageData := stream contents.
	stream close.

	"Encrypt the classdata and write back to the file. Any error encrypting the classdata is liable
	to be caused by an invalid private key"
	stream := FileStream write: filename text: false.
	
	[stub := DolphinSureTrustedData 
				data: packageData
				description: self name , ' Package'
				publisherCertificate: aCertificate
				privateKey: privateKey] 
			on: Error
			do: [:err | self error: ' Error encrypting package with Private Key: ' , privateKey displayString].
	stub binaryStoreOn: stream.
	stream close!

installUsing: aClassLocator 
	"Private - Install the receiver (having been just loaded from aClassLocator) into this running image"

	"Note installation of loose methods is normally only enabled by default
	in runtime environments to avoid confusing the development tools"

	SessionManager current isBinaryLooseMethodInstallationAllowed 
		ifTrue: 
			[self methods do: 
					[:each | 
					(each methodClass includesSelector: each selector) 
						ifFalse: [each methodClass addSelector: each selector withMethod: each loseSource]]].
	self classes do: [:each | aClassLocator installImportedClass: each].
	self classes do: [:each | each initializeAfterBinaryLoad].
	ImportedPackages at: aClassLocator fullPackageKey put: self!

keepSource: aBoolean 
	keepSource := aBoolean!

methods
	"Answer the loose methods belonging to the receiver"

	^methods!

methods: methodsCollection 
	methods := methodsCollection!

name
	"Answer the name of the receiver"

	^name!

name: aString 
	name := aString!

package: aPackage 
	"Private - Initialize the receiver from aPackage"

	| packageClasses |
	name := aPackage name.
	keepSource := self defaultKeepSource.

	"The classes must be held in superclass first order to ensure that they
	are saved out correctly"
	packageClasses := aPackage classes.
	classes := OrderedCollection new: 32.
	Object 
		allSubclassesPreOrderDo: [:each | (packageClasses includes: each) ifTrue: [classes add: each]].
	methods := aPackage methods.
	resources := LookupTable new.
	aPackage allResourceIdentifiers do: 
			[:each | 
			| resource |
			resource := each resource.
			resources at: each put: resource]!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self name;
		nextPut: $)!

resources
	"Answer a LookupTable of the resources"

	^resources!

resources: resourcesCollection 
	resources := resourcesCollection!

stbSaveOn: anSTBOutFiler 
	"Private - Output the receiver to anSTBOutFiler as a proxy"

	self classes do: 
			[:each | 
			anSTBOutFiler
				override: each with: (STBImportedClassProxy forClass: each);
				override: each class with: (STBImportedMetaclassProxy forClass: each class);
				override: each methodDictionary with: MethodDictionary new;
				override: each class methodDictionary with: MethodDictionary new.
			each classPool do: [:eachClassVar | anSTBOutFiler override: eachClassVar with: nil]].
	anSTBOutFiler override: Transcript with: DeafObject current.
	^anSTBOutFiler saveObject: self
		as: (STBBinaryPackageProxy forBinaryPackage: self keepSource: keepSource)!

uninstall
	"Private - Un-install the receiver"

	"The receiver's classes and resources will be automatically garbage collected when they
	are no longer directly referenced. Unfortunately, we must explicily uninstall the loose methods"

	| packageKey |

	"Note: Loose methods are not yet supported in all images. 
	See #installUsing:"
	self methods do: [ :each |
		each methodClass removeSelector: each selector ifAbsent: []].

	packageKey := ImportedPackages keyAtValue: self.
	ImportedPackages removeKey: packageKey

	

! !
!BinaryPackage categoriesFor: #classAt:!accessing!public! !
!BinaryPackage categoriesFor: #classes!accessing!public! !
!BinaryPackage categoriesFor: #classes:!accessing!private! !
!BinaryPackage categoriesFor: #defaultKeepSource!accessing!development!initializing!public! !
!BinaryPackage categoriesFor: #fileOut!binary filing!development!public! !
!BinaryPackage categoriesFor: #fileOutAs:!binary filing!development!public! !
!BinaryPackage categoriesFor: #fileOutName!binary filing!development!private! !
!BinaryPackage categoriesFor: #fileOutPath!binary filing!development!private! !
!BinaryPackage categoriesFor: #fileOutSignedWith:privateKey:!binary filing!development!public! !
!BinaryPackage categoriesFor: #fileOutSignedWith:privateKey:as:!binary filing!development!public! !
!BinaryPackage categoriesFor: #installUsing:!operations!private! !
!BinaryPackage categoriesFor: #keepSource:!public! !
!BinaryPackage categoriesFor: #methods!accessing!public! !
!BinaryPackage categoriesFor: #methods:!accessing!private! !
!BinaryPackage categoriesFor: #name!accessing!public! !
!BinaryPackage categoriesFor: #name:!accessing!private! !
!BinaryPackage categoriesFor: #package:!accessing!development!initializing!private! !
!BinaryPackage categoriesFor: #printOn:!printing!public! !
!BinaryPackage categoriesFor: #resources!accessing!public! !
!BinaryPackage categoriesFor: #resources:!accessing!private! !
!BinaryPackage categoriesFor: #stbSaveOn:!binary filing!private! !
!BinaryPackage categoriesFor: #uninstall!operations!private! !

!BinaryPackage class methodsFor!

baselineImageVersion
	"Answer a <Float> that indicates the base line version of image that will be required to install
	and run any package. We use a <Float> so it is easy to present the required version to the 
	user if he/she tries to use an older iamge to load the package"

	^3.0!

binaryPackageExtension
	"Answers the standard file extension String used for binary package files."

	^ClassLocator binaryPackageExtension!

binaryPackageVersion
	"Answer an <integter> version of the BinaryPackage class. Not sure what this is used
	for yet but we write it to the file anyway"

	^0!

checkVersion: aPackageImageVersion
	"Private - Check that the binary package labelled with aPackageImageVersion can legitimately
	be loaded into this image. Otherwise signal a BinaryPackageVersionError"

	(self baselineImageVersion < aPackageImageVersion) ifTrue: [
		BinaryPackageVersionError signal: aPackageImageVersion ]!

for: aPackage
	"Answer an instance of the receiver that can be used for exporting aPackage from the
	image in binary format."

	^(super new) package: aPackage!

icon
	"Answers an Icon that can be used to represent this class"

	^Package icon!

importedPackages
	"Answer the LookupTable of BinaryPackages that have been imported into this image."

	^ImportedPackages!

initialize
	"Private - Initialize the class variables.

	self initialize
"

	ImportedPackages := LookupTable new.
	SessionManager current when: #sessionStarted send: #onStartup to: self.!

loadUsing: aClassLocator 
	"Loads and answers a binary package using aClassLocator"

	| packageKey localFileSpec binaryPackage |
	localFileSpec := aClassLocator localFileSpecForPackage.
	packageKey := aClassLocator fullPackageKey.
	^ImportedPackages at: packageKey
		ifAbsent: 
			[ImportedPackages at: packageKey put: nil.
			
			[| stream filer data |
			stream := FileStream read: localFileSpec text: false.
			filer := (STBInFiler on: stream) classLocator: aClassLocator copyWithCodeBase.
			data := filer next.
			(data isKindOf: Integer) 
				ifTrue: 
					["The package was not signed"
					| description |
					self checkVersion: filer next.
					binaryPackage := filer next.
					description := aClassLocator packageName , ' Package'.
					(NotSignedCertificate new confirmTrustFor: description) 
						ifFalse: [NotTrustedError signal: description]]
				ifFalse: 
					["The package was signed"
					| binaryPackageData |
					binaryPackageData := data trustedData.
					filer := (STBInFiler on: binaryPackageData readStream) classLocator: aClassLocator.
					"Skip the binary package version"
					filer next.
					self checkVersion: filer next.
					binaryPackage := filer next].
			binaryPackage installUsing: aClassLocator.
			stream close] 
					ifCurtailed: [ImportedPackages removeKey: packageKey].
			binaryPackage]!

new
	"Private - Use #for:"

	self shouldNotImplement!

onStartup
	"Private - Clear down the collection of loaded packages on load"

	self unloadAll
!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self unloadAll.
	SessionManager current removeEventsTriggeredFor: self!

unloadAll
	"Private - Unload all installed libraries"

	self importedPackages copy do: [:each | each uninstall ].
! !
!BinaryPackage class categoriesFor: #baselineImageVersion!constants!public! !
!BinaryPackage class categoriesFor: #binaryPackageExtension!constants!public! !
!BinaryPackage class categoriesFor: #binaryPackageVersion!constants!public! !
!BinaryPackage class categoriesFor: #checkVersion:!helpers!private! !
!BinaryPackage class categoriesFor: #for:!instance creation!public! !
!BinaryPackage class categoriesFor: #icon!constants!development!public! !
!BinaryPackage class categoriesFor: #importedPackages!accessing!public! !
!BinaryPackage class categoriesFor: #initialize!initializing!private! !
!BinaryPackage class categoriesFor: #loadUsing:!instance creation!public! !
!BinaryPackage class categoriesFor: #new!instance creation!private! !
!BinaryPackage class categoriesFor: #onStartup!event handling!private! !
!BinaryPackage class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!BinaryPackage class categoriesFor: #unloadAll!operations!private! !

