﻿"Filed out from Dolphin Smalltalk"!

ImageStripper
	subclass: #AXDllImageStripper
	instanceVariableNames: 'typeLibPath'
	classVariableNames: ''
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!

AXDllImageStripper guid: (Core.GUID fromString: '{e6c57f56-c672-49b5-8157-893092e6eb6f}')!

AXDllImageStripper comment: 'AXDllImageStripper is a specialized <ImageStripper> for stripping and deploying in-process ActiveX/COM component DLLs.

See the ''ActiveX In-Process Server Kit'' package comment for further details.'!

!AXDllImageStripper methodsFor!

_updateStubResources: anExternalHandle
	"Private - Update the resources of the exe/dll stub through the supplied resource update
	handle."

	super _updateStubResources: anExternalHandle.
	self _updateTypelibResource: anExternalHandle!

_updateTypelibResource: anExternalHandle
	"Private - Add a typelib resource to the dll stub through the supplied resource update
	handle. This typelib will be self-registered by the deployed DLL when it is registered."

	| tlbPath resourceBytes |
	tlbPath := self typeLibPath.
	tlbPath isNil ifTrue: [^self].
	resourceBytes := (FileStream read: tlbPath text: false) contents.
	(OS.Kernel32
		updateResource: anExternalHandle
		lpType: 'TYPELIB' asUtf16String
		lpName: 1
		wLanguage: 0
		lpData: resourceBytes
		cbData: resourceBytes size) ifFalse: [OS.Kernel32 systemError]!

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
			mb
				buttonStyle: #okCancel;
				headline: 'Deploy <1p> without type library?' << self executableName;
				defaultButton: 2;
				customButtons: #(#(#ok '&Deploy'));
				detailsText: 'You may deploy this component, but it may then be necessary to distribute and register the type library separately in order for the component to function. If this component only implements interfaces defined by other components (which themselves supply a type library), or the component is not intended for use with Automation clients (and a separate marshalling DLL is available and registered), then you may not need a type library.';
				uniqueId: 'DeployNoTypelib ', rootPackageName;
				isDefaultable: true;
				beTaskModal.
			(mb
				warning: 'There is no type library associated with this component or the type library cannot be found, so it may not function as expected.')
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

	typeLibPath := FileLocator imageRelative relativePathTo: aString.! !

!AXDllImageStripper categoriesForMethods!
_updateStubResources:!operations!private! !
_updateTypelibResource:!operations!private! !
defaultSessionManagerClass!constants!public! !
prepareToStrip!operations!public! !
requiredPackageNames!accessing!public! !
stubFile!accessing!public! !
typeLibPath!accessing!public! !
typeLibPath:!accessing!public! !
!

!AXDllImageStripper class methodsFor!

defaultOptions
	"Private - Answer the default set of flags set up in new of converted instances of the receiver."

	^super defaultOptions | KeepImageMask! !

!AXDllImageStripper class categoriesForMethods!
defaultOptions!constants!development!private! !
!

