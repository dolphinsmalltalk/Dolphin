"Filed out from Dolphin Smalltalk"!

Core.FileLocator
	subclass: #'Kernel.ClassLocator'
	instanceVariableNames: 'packageName codeBase key'
	classVariableNames: 'Aliases DefaultFileLocator ImportedClasses ImportedClassesMutex InstallationFileLocator'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.ClassLocator guid: (Core.GUID fromString: '{87b4c462-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.ClassLocator comment: 'A ClassLocator is used to find a class for an object being read from an external serialized stream (such as STB). The locator first tries to match an exsiting class already in the image and, if this fails, it is then used to indicate the location of an external binary class that may be loaded into the image. To do this, the locator holds the code base where the external BinaryPackage file resides and a key (usually the class name) that can be used to identify a particular class within the package.  The standard ClassLocator is used when the binary package file can be found on a UNC file system.  If the class is part of an applet and is to be located by a URL then a URLClassLocator should be used instead.

Instance Variables:
	packageName 	<readableString> indicating the name of the package containing the required class.
	codeBase		<readableString> indicating the base directory from which a BinaryPackage should be loaded.
	key		<readableString> indicating the name of a class to load from the package.

Class Variables:
	ImportedClasses		<WeakLookupTable> holding the imported classes looked up by their full class keys.
	DefaultFileLocator		<ClassLocator> which is the default locator to use when loading external resource files.
	ImportedClassesMutex	<Mutex> to use when resolving imported classes.
	Aliases			<WeakLookupTable> mapping old class names to existing class.

'!

!Kernel.ClassLocator categoriesForClass!System-Binary class loading! !

!Kernel.ClassLocator methodsFor!

bindingReference
	^key asQualifiedReference!

codeBase
	"Answer the receiver's codeBase. This is used to complete a relative key."

	^codeBase!

codeBase: aString
	"Private - Sets the receiver's codeBase instVar to aString. 
	This is used to complete a relative key."

	codeBase := aString.
!

copyWithCodeBase
	"Private - Answer a instance of the same class as the receiver with the same codeBase.
	This allows both the codeBase and the mechanism for using it to be propagated."

	^self class
		codeBase: codeBase
		packageName: self packageName
		key: nil!

errorClassCircularityDetected
	"Private - Signal an error indicating there exists a circular class dependency
	in involving the class identified by the receiver."

	self
		error: ('A circular class dependency has been encountered involving class <1s>' expandMacrosWith: key)!

errorClassNotFound: aBindingReference
	"Private - Signal an error indicating that a particular was not found in the image and could not be dynamically loaded"

	NotFoundError
		signal: ('The class <1p> could not be found in the image' expandMacrosWith: aBindingReference)!

findAvailableClass
	"Answer the class referred to by the receiver if the class is either resident or a loaded foreign
	import. If the class referred to by the receiver is a foreign class that has not yet been imported
	then answer nil."

	^self findAvailableClass: self bindingReference!

findAvailableClass: aBindingReference
	"Answer the class referred to by the receiver if the class is either resident or a loaded foreign
	import. If the class referred to by the receiver is a foreign class that has not yet been imported
	then answer nil."

	^(self findResidentClass: aBindingReference)
		ifNil: [ImportedClasses ifNotNil: [ImportedClasses lookup: (self fullClassKey: aBindingReference)]]!

findResidentClass
	"Private - Answer the class referred to by the receiver if it is
	fully resident in the image."

	^self findResidentClass: self bindingReference!

findResidentClass: aBindingReference
	"Private - Answer the class referred to by the argument."

	^aBindingReference valueOrNil ifNil: [Aliases lookup: aBindingReference]!

fullClassKey
	"Answer the full specification of the class identified by the receiver."

	^self fullClassKey: self key
!

fullClassKey: aBindingReference
	"Answer the full specification of the class identified by the receiver and the key <String> argument."

	^self codeBase , aBindingReference instance fullName!

fullPackageKey
	"Answer the full specification of any package identified by the receiver or nil
	if there is none."

	^self hasPackageName ifTrue: [ self codeBase, self packageName ]!

hasPackageName
	"Private - Answer true if the receiver has a package name specified"

	^self packageName notNil!

includesClass: aClass
	"Answer whether the <Class> argument is within the allowed set."

	^true!

initialize
	"Private - Initialize the receiver's identity instance variables."

	codeBase := ''!

installImportedClass: aClass
	"Private - Install aClass, an imported class into the system"

	| classKey |
	classKey := self codeBase , aClass fullName.
	ImportedClasses at: classKey ifAbsent: [ImportedClasses at: classKey put: aClass]!

key
	"Answer the receiver's key inst var."

	^key!

key: aString
	"Private - Set the receiver's key inst var to aString."

	key := aString!

localFileSpecFor: aStringFilename
	"Answer a filespec for aStringFilename relative to the current installation
	directory and codebase."

	| filename |
	filename := aStringFilename.
	self codeBase notNil ifTrue: [filename := File composePath: codeBase subPath: filename].
	^super localFileSpecFor: filename!

locateClass
	"Answer the class referred to by the receiver."

	^self locateClass: self bindingReference!

locateClass: aBindingReference
	"Answer the class referred to by the argument."

	^(self findResidentClass: aBindingReference) ifNil: [self findOrImportForeignClass: aBindingReference]!

packageName
	"Answer the receiver's  package name <readableString>."

	^packageName!

packageName: aString
	"Private - Set the receiver's package name to aString."

	packageName := aString!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: packageName;
		nextPutAll: ', ';
		print: codeBase;
		nextPutAll: ', ';
		print: key;
		nextPut: $)! !

!Kernel.ClassLocator categoriesForMethods!
bindingReference!accessing!private! !
codeBase!accessing!public! !
codeBase:!initializing!private! !
copyWithCodeBase!copying!private! !
errorClassCircularityDetected!exceptions!private! !
errorClassNotFound:!exceptions!private! !
findAvailableClass!operations!public! !
findAvailableClass:!operations!public! !
findResidentClass!operations!private! !
findResidentClass:!operations!private! !
fullClassKey!accessing!private! !
fullClassKey:!helpers!private! !
fullPackageKey!accessing!public! !
hasPackageName!accessing!private! !
includesClass:!public!testing! !
initialize!initializing!private! !
installImportedClass:!operations!private! !
key!accessing!public! !
key:!initializing!private! !
localFileSpecFor:!accessing!public! !
locateClass!operations!public! !
locateClass:!operations!public! !
packageName!accessing!public! !
packageName:!initializing!private! !
printOn:!printing!public! !
!

!Kernel.ClassLocator class methodsFor!

addAlias: aString forClass: aClass
	"Record the alias for a class for use in subsequent resolution.
	This is useful where, for example, previously binary filed classes have been renamed, and one
	does not wish to keep a global variable for that alias. It can be useful to have the global variable
	as well to permit loading subclasses, but such globals may be removed by the image stripper, so
	some mechanism is needed to maintain backwards compatibility with old binary files."

	Aliases at: aString asQualifiedReference put: aClass!

binaryPackageExtension
	"Answers the standard file extension String used for binary package files."

	^'pak'!

codeBase: codeBaseString 
	"Answer an instance of the receiver with a codeBase of codeBaseString and nil key. Such an instance
	is only useful when it also has a key."

	^self codeBase: codeBaseString packageName: nil key: nil!

codeBase: codeBaseString packageName: packageString
	"Answer an instance of the receiver with a codeBase of  codeBaseString and nil key. Such an instance
	is only useful when it also has a key."

	^self codeBase: codeBaseString packageName: packageString key: nil!

codeBase: codeBaseString packageName: packageString key: keyString
	"Answer an instance of the receiver with a codeBase of  codeBaseString and  keyString class key."

	^(super new)
		 codeBase: codeBaseString;
		 packageName: packageString;
		 key: keyString!

default
	"Answers an instance of the receiver that can be used to locate external files
	relative to the current installation directory."

	^self new
!

importedClassesMutex
	"Private - Answer the mutex used to provide mutual exclusion to the locateClass
	method."

	^ImportedClassesMutex!

initialize
	"Private - Initialize the class variables.

		self initialize
	"

	ImportedClassesMutex := Mutex new.
	SessionManager current
		when: #sessionStarted
		send: #onStartup
		to: self.
	Aliases := WeakLookupTable new haveWeakValues!

isImportedClass: aClass
	^ImportedClasses notNil and: [ImportedClasses identityIncludes: aClass]!

new
	"Answer a new, initialized, instance of the receiver."

	^super new initialize!

onStartup
	"Private - The session has started. Clear down the cached file locators"

	DefaultFileLocator := nil.
	InstallationFileLocator := nil.
	ImportedClasses := nil.
!

removeAlias: aString
	"Remove a previously established class alias.
	Note that it is not strictly necessary to do this because the Aliases collection is weak, and the alias will disappear if the class is removed."

	Aliases removeKey: aString asQualifiedReference ifAbsent: nil!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	ImportedClasses := ImportedClassesMutex := Aliases := nil.
	SessionManager current removeEventsTriggeredFor: self! !

!Kernel.ClassLocator class categoriesForMethods!
addAlias:forClass:!accessing!public! !
binaryPackageExtension!constants!public! !
codeBase:!instance creation!public! !
codeBase:packageName:!instance creation!public! !
codeBase:packageName:key:!instance creation!public! !
default!accessing!public! !
importedClassesMutex!accessing!private! !
initialize!development!initializing!private! !
isImportedClass:!public!testing! !
new!instance creation!public! !
onStartup!events-session!private! !
removeAlias:!accessing!public! !
uninitialize!class hierarchy-removing!private! !
!

