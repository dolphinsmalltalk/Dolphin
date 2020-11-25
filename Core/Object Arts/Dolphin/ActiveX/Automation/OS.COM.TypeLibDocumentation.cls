"Filed out from Dolphin Smalltalk 7"!

Object subclass: #AXTypeLibDocumentation
	instanceVariableNames: 'name helpstring helpcontext helpfile'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXTypeLibDocumentation guid: (GUID fromString: '{c06f3b78-0868-11d3-93af-00a024ca708a}')!
AXTypeLibDocumentation comment: 'AXTypeLibDocumentation is a simple class to hold documentary information from a type library - either from an ITypeLib or an ITypeInfo.

Instance Variables:
	name 		<String> name of type library element
	helpstring 	<String>. Short help text (a one-liner) describing the element.
	helpcontext 	<DWORD>. Help file cross-reference.
	helpfile		<String>. Path of help file (only valid on documentation for the library).'!
!AXTypeLibDocumentation categoriesForClass!ActiveX Automation! !
!AXTypeLibDocumentation methodsFor!

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
!AXTypeLibDocumentation categoriesFor: #helpcontext!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #helpfile!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #helpstring!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #name!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #name:helpstring:helpcontext:helpfile:!initializing!private! !
!AXTypeLibDocumentation categoriesFor: #printOn:!printing!public! !

