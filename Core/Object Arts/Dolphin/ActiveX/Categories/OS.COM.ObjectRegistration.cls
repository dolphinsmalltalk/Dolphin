"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'OS.COM.ObjectRegistration'
	instanceVariableNames: 'clsid name toolboxImage'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.ObjectRegistration guid: (Core.GUID fromString: '{e3aace46-398d-4cb8-8d6e-d9bf407b92fa}')!
OS.COM.ObjectRegistration comment: '<COMObjectRegistration> is a simple class to aggregate the registration information for a COM object such as its CLSID and description. It is used in conjunction with the COM Category Manager interface, <ICatInformation>.

Instance Variables:
	clsid		<CLSID>. Coclass guid.
	name		<String>. Short description of the coclass from the registry.
	toolboxBmp	<Image>. Iconic representation for the coclass.

'!
!OS.COM.ObjectRegistration categoriesForClass!COM Category Manager! !
!OS.COM.ObjectRegistration methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent (in whatever respect is appropriate for 
	the class of the receiver)."

	^comparand species == self species and: [comparand clsid = self clsid]!

clsid
	"Answer the <CLSID> of the COM component."

	^clsid!

clsid: aCLSID
	"Set the <CLSID> of the COM component."

	clsid := aCLSID!

defaultToolboxImage
	^IUnknown icon!

description
	"Answer the full type name of the COM component."

	^self getUserType: 1 "USERCLASSTYPE_FULL"
!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self name displayOn: aPuttableStream!

getUserType: form
	"Private - Answer <readableString> user class type information of the type
	specified by the <integer>, form, which is a value from the USERCLASSTYPE
	enumeration."

	| mem answer hresult |
	mem := TaskMemory new.
	hresult := Ole32
				oleRegGetUserType: clsid
				dwFormOfType: form
				pszUserType: mem.
	answer := hresult < 0
				ifTrue: ['ERROR: ' , (HRESULT fromInteger: hresult) displayString]
				ifFalse: [(Utf16String fromAddress: mem) asString].
	mem free.
	^answer!

hash
	"Answer the <integer> hash value for the receiver. By default use the identity hash
	assigned at object creation time, which is temporally invariant."

	^self clsid hash!

name
	"Answer the short type name of the COM component."

	name isNil ifTrue: [name := self getUserType: 2 "USERCLASSTYPE_SHORT"].
	^name

!

printOn: target
	"Append, to the <puttableStream>, target, a string whose characters are a 
	the same as those which would result from sending a #printString
	message to the receiver."

	target
		basicPrint: self;
		nextPut: $(;
		display: self clsid;
		nextPut: $)!

toolboxImage
	"Answer the <Icon> intended for use in toolboxes as the icon for the control described by the receiver."

	toolboxImage
		ifNil: 
			[(AdvApi32
				regGetString: WinRegConstants.HKEY_CLASSES_ROOT
				key: 'CLSID\{<1s>}\ToolboxBitmap32' << self clsid idlString
				value: nil)
					ifNotNil: 
						[:toolboxBitmap32 |
						| id path pathAndId |
						"Should be able to use PathParseIconLocation here, but it can't cope with spaces between the path and the icon id."
						pathAndId := $, split: toolboxBitmap32.
						id := Integer readFrom: (pathAndId last readStream
											skipSeparators;
											yourself).
						"Some icon ids come back as negative. Why?"
						id >= 0
							ifTrue: 
								[| resLib bmp |
								path := Kernel32 expandEnvironmentStrings: pathAndId first.
								resLib := ResourceLibrary open: path.
								bmp := Graphics.DIBSection fromId: id in: resLib.
								"bmp setMap3DColors: true."
								bmp handle isNull ifFalse: [^toolboxImage := bmp asIcon]]].
			toolboxImage := self defaultToolboxImage].
	^toolboxImage! !
!OS.COM.ObjectRegistration categoriesForMethods!
=!comparing!public! !
clsid!accessing!public! !
clsid:!accessing!public! !
defaultToolboxImage!accessing!public! !
description!accessing!public! !
displayOn:!displaying!public! !
getUserType:!accessing!private! !
hash!comparing!public! !
name!accessing!public! !
printOn:!printing!public! !
toolboxImage!accessing!public! !
!

!OS.COM.ObjectRegistration class methodsFor!

clsid: aCLSID
	"Answer a new instance of the receiver for the specified class id."

	^self new clsid: aCLSID; yourself! !
!OS.COM.ObjectRegistration class categoriesForMethods!
clsid:!instance creation!public! !
!

