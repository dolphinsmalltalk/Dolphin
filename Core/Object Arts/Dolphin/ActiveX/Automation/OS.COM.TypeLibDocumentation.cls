"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'OS.COM.TypeLibDocumentation'
	instanceVariableNames: 'name helpstring helpcontext helpfile'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TypeLibDocumentation guid: (Core.GUID fromString: '{c06f3b78-0868-11d3-93af-00a024ca708a}')!
OS.COM.TypeLibDocumentation comment: 'AXTypeLibDocumentation is a simple class to hold documentary information from a type library - either from an ITypeLib or an ITypeInfo.

Instance Variables:
	name 		<String> name of type library element
	helpstring 	<String>. Short help text (a one-liner) describing the element.
	helpcontext 	<DWORD>. Help file cross-reference.
	helpfile		<String>. Path of help file (only valid on documentation for the library).'!
!OS.COM.TypeLibDocumentation categoriesForClass!ActiveX Automation! !
!OS.COM.TypeLibDocumentation methodsFor!

helpcontext
	^helpcontext!

helpfile
	^helpfile!

helpstring
	"Answer the value of the receiver's instance variable helpstring.
	This method was automatically generated, but may be modified."

	^helpstring!

name
	^name!

name: nameString helpstring: helpString helpcontext: anInteger helpfile: helpfileString
	name := nameString.
	helpstring := helpString.
	helpcontext := anInteger.
	helpfile := helpfileString!

printOn: aStream 
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self name;
		nextPut: $)! !
!OS.COM.TypeLibDocumentation categoriesFor: #helpcontext!accessing!public! !
!OS.COM.TypeLibDocumentation categoriesFor: #helpfile!accessing!public! !
!OS.COM.TypeLibDocumentation categoriesFor: #helpstring!accessing!public! !
!OS.COM.TypeLibDocumentation categoriesFor: #name!accessing!public! !
!OS.COM.TypeLibDocumentation categoriesFor: #name:helpstring:helpcontext:helpfile:!initializing!private! !
!OS.COM.TypeLibDocumentation categoriesFor: #printOn:!printing!public! !

