"Filed out from Dolphin Smalltalk 7"!

Tools.ImageStripper subclass: #'Tools.AXDllImageStripper'
	instanceVariableNames: 'typeLibPath'
	classVariableNames: ''
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AXDllImageStripper guid: (Core.GUID fromString: '{e6c57f56-c672-49b5-8157-893092e6eb6f}')!
Tools.AXDllImageStripper comment: 'AXDllImageStripper is a specialized <ImageStripper> for stripping and deploying in-process ActiveX/COM component DLLs.

See the ''ActiveX In-Process Server Kit'' package comment for further details.'!
!Tools.AXDllImageStripper categoriesForClass!Unclassified! !
!Tools.AXDllImageStripper methodsFor!

defaultSessionManagerClass
	"Answer the default class of SessionManager to be installed into the 
	deployed image."

	^AXDllSessionManager!

prepareToStrip
	"Perform pre-image stripping actions, such as opening the log file.
	This is invoked before even the development tools have been closed.
	Answer whether to proceed with the application deployment."

	(self typeLibPath isNil or: [(File exists: self typeLibPath) not])
		ifTrue: 
			[| mb |
			mb := MessageBox new.
			mb buttonStyle: #okCancel.
			mb caption: ('Deploying <1p>...' expandMacrosWith: self executableName).
			mb defaultButton: 2.
			(mb
				warning: 'There is no type library associated with this component or the type library cannot be found. You may deploy this component, but it may then be necessary to distribute and register the type library separately in order for the component to function. If this component only implements interfaces defined by other components (which themselves supply a type library), or the component is not intended for use with Automation clients (and a separate marshalling DLL is available), then you may not need a type library.<n><n>Are you sure that you want to continue?')
					== #ok ifFalse: [^false]].
	^super prepareToStrip!

requiredPackageNames
	"Answers a <Set> of the package names, in addition to the root package and any pre-requisites, 
	that are required for a Dolphin in-process COM server DLL."

	^super requiredPackageNames
		add: 'ActiveX DLL Server Kit';
		yourself


!

stubFile
	"Answers the stub file to be used by the receiver"

	^InterfaceImplementation inprocSurrogate: self isToGo!

typeLibPath
	"Answer a <readableString>, being the path of the typelibrary file (.tlb) that is to be bound into 
	the DLL deployed by the receiver. If none then answer nil."

	^typeLibPath isNil ifFalse: [FileLocator imageRelative localFileSpecFor: typeLibPath]
!

typeLibPath: aString
	"Set the path of the typelib that is to be bound into the application
	deployed by the receiver."

	typeLibPath := FileLocator imageRelative relativePathTo: aString.!

updateStubResources: anExternalHandle
	"Private - Update the resources of the exe/dll stub through the supplied resource update
	handle."

	super updateStubResources: anExternalHandle.
	self updateTypelibResource: anExternalHandle!

updateTypelibResource: anExternalHandle
	"Private - Add a typelib resource to the dll stub through the supplied resource update
	handle. This typelib will be self-registered by the deployed DLL when it is registered."

	| tlbPath resourceBytes |
	tlbPath := self typeLibPath.
	tlbPath isNil ifTrue: [^self].
	resourceBytes := (FileStream read: tlbPath text: false) contents.
	(OS.KernelLibrary default
		updateResource: anExternalHandle
		lpType: 'TYPELIB' asUtf16String
		lpName: 1
		wLanguage: 0 
		lpData: resourceBytes
		cbData: resourceBytes size)
			ifFalse: [OS.KernelLibrary default systemError]! !
!Tools.AXDllImageStripper categoriesFor: #defaultSessionManagerClass!constants!public! !
!Tools.AXDllImageStripper categoriesFor: #prepareToStrip!operations!public! !
!Tools.AXDllImageStripper categoriesFor: #requiredPackageNames!accessing!public! !
!Tools.AXDllImageStripper categoriesFor: #stubFile!accessing!public! !
!Tools.AXDllImageStripper categoriesFor: #typeLibPath!accessing!public! !
!Tools.AXDllImageStripper categoriesFor: #typeLibPath:!accessing!public! !
!Tools.AXDllImageStripper categoriesFor: #updateStubResources:!operations!private! !
!Tools.AXDllImageStripper categoriesFor: #updateTypelibResource:!operations!private! !

!Tools.AXDllImageStripper class methodsFor!

defaultOptions
	"Private - Answer the default set of flags set up in new of converted instances of the receiver."

	^super defaultOptions | KeepImageMask!

publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	"N.B. This method must be in the 'must strip' category so that it is removed before
	package pre-requisites are calculated otherwise the Development System remains
	a pre-req. of the ADK due to the references to development classes herein."

	^super publishedAspectsOfInstances
		add: (Aspect fileSave: #typeLibPath);
		yourself! !
!Tools.AXDllImageStripper class categoriesFor: #defaultOptions!constants!development!private! !
!Tools.AXDllImageStripper class categoriesFor: #publishedAspectsOfInstances!constants!development!must strip!public! !

