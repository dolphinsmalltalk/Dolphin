"Filed out from Dolphin Smalltalk X6"!

ImageStripper subclass: #PluginImageStripper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluginImageStripper guid: (GUID fromString: '{20DCBD0F-26AC-4374-A7BA-3A13B7399B02}')!
PluginImageStripper comment: 'A PluginImageStripper is used to strip a development image and deploy it as a Web browser plug-in. 

Its default behaviour is somewhat different than a standard ImageStripper in that it is not normally appropriate to remove unreferenced methods or classes from the image, since plug-in must provide a complete base set of classes for applets to use. It would be of no use to an applet if, when trying to make use of a particular base class, it discovered that several of the methods were missing simply because they were not referenced at the time the plug-in image was deployed.

The plug-in itself is usually a DLL called NpDolphin.DLL which MUST be registered as a COM component when it is installed on a client machine. The DLL consists of an executable stub (containing the plug-in start-up code) followed by a base image tagged onto the end of the file. The stub file to use is identified by the #stubFile method and, for the standard plug-in, is provided as NpDolphinStub.

The normal way to deploy the standard plug-in is to select the ''Web Plugin Builder'' package within the Package Browser and choose to deploy this to an executable. This package comes with a correctly set up PluginImageStripper already installed.  As an alternative, you may also choose to deploy a development image as a plug-in with default options by evaluating:

	PluginImageStripper new stripAndSaveWithProgress.

If you want to deploy a non-standard plug-in, perhaps to include some additional base packages so that their contents don''t have to be imported each time the plug-in images started, then this is also possible using a PlugImageStripper. First of all create a package that references all of the additional base packages you wish to include.  Then install a PluginImageStripper into this package and choose to deploy it as an executable from within the Package Browser.  You can install a PluginImageStripper into a package by evaluating the following:

	(PackageManager current at: ''My Package'') imageStripper: PluginImageStripper new.
'!
!PluginImageStripper categoriesForClass!MVP-Models! !
!PluginImageStripper methodsFor!

defaultSessionManagerClass
	"Answer the default class of SessionManager to be installed into the 
	deployed image."

	^PluginSessionManager!

editCustomOptions
	"Open a <PublishedAspectInspector> on the version resource."

	| inspector |
	inspector := (Smalltalk at: #PublishedAspectInspector) 
				shellOn: self versionResource.
	inspector topShell caption: self class name , ' Version Resource'!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self 
		rootPackage: self class owningPackage;
		executableName: 'NpDolphin.DLL'!

keepImageFile
	"Answer whether the raw image file (which has the same name as the deployed exe/dll but with
	no extension) should be retained. By default it is deleted, but it can be useful for debugging
	purposes, or (if a plug-in image) for use with IMAGE tag."

	^true!

prepareToStrip
	"Perform pre-image stripping actions, such as opening the log file.
	This is invoked before even the development tools have been closed.
	Answer whether to proceed with the application deployment."

	"Ensure an instance of NPDolphin exists"
	NPDolphin current.

	^super prepareToStrip!

requiredPackageNames
	"Answers a Set of the package names required by the plugin. These should already have been loaded
	into the image."

	^super requiredPackageNames
		add: 'XML DOM';
		add: 'ActiveX Control Hosting';
		add: 'Sockets Connection';
		add: 'Web Plugin Builder';
		add: 'Windows Shell';
		add: 'DolphinSure';
		yourself


!

stubFile
	"Answers the stub file to be used by the receiver"

	^'NpDolphinStub.dll'.! !
!PluginImageStripper categoriesFor: #defaultSessionManagerClass!constants!public! !
!PluginImageStripper categoriesFor: #editCustomOptions!commands!public! !
!PluginImageStripper categoriesFor: #initialize!initializing!private! !
!PluginImageStripper categoriesFor: #keepImageFile!public!testing! !
!PluginImageStripper categoriesFor: #prepareToStrip!operations!public! !
!PluginImageStripper categoriesFor: #requiredPackageNames!accessing!public! !
!PluginImageStripper categoriesFor: #stubFile!accessing!public! !

!PluginImageStripper class methodsFor!

defaultOptions
	"Private - Answer the default set of flags set up in new of converted instances of the receiver."

	^(ClearGuidsMask|
		"We don't want to strip anything out apart from unused packages as we need a full image
		StripResourcesMask|
		StripClassesMask|"
		StripPackagesMask|
		"StripClassBuilderMask|
		StripMethodsMask|
		StripShouldNotImplMask|"

		"Folding empty method dicts will be unhelpful if people try to add methods at run-time
		FoldMethodDictsMask|"

		FoldStringsMask|			"But folding strings is safe"

		"We'll remove comments, etc, but preserve the inst. var names"
		StripClassInfoMask|
		RetainInstVarNamesMask|

		PreserveAspectsMask|
		"CompileStructsMask| 		We don't want to compile external structures"
		WriteLogMask|
		EmptyMethodDictsMask|
		FoldBytecodesMask)				"Folding duplicate bytecodes is always safe"

! !
!PluginImageStripper class categoriesFor: #defaultOptions!constants!private! !

