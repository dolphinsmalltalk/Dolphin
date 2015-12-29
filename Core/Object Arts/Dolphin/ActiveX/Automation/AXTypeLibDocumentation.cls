"Filed out from Dolphin Smalltalk X6"!

Object subclass: #AXTypeLibDocumentation
	instanceVariableNames: 'name helpstring helpcontext helpfile'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXTypeLibDocumentation guid: (GUID fromString: '{C06F3B78-0868-11D3-93AF-00A024CA708A}')!
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

helpcontext: anInteger 
	helpcontext := anInteger!

helpfile
	^helpfile!

helpfile: aString 
	helpfile := aString trimNulls!

helpstring
	"Answer the value of the receiver's instance variable helpstring.
	This method was automatically generated, but may be modified."

	^helpstring!

helpstring: aString 
	"Private - Set the helpstring associated with the receiver to the <readableString> argument."

	helpstring := aString trimNulls!

name
	^name!

name: anObject 
	name := anObject!

printOn: aStream 
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self name;
		nextPut: $)! !
!AXTypeLibDocumentation categoriesFor: #helpcontext!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #helpcontext:!accessing!private! !
!AXTypeLibDocumentation categoriesFor: #helpfile!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #helpfile:!accessing!private! !
!AXTypeLibDocumentation categoriesFor: #helpstring!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #helpstring:!accessing!private! !
!AXTypeLibDocumentation categoriesFor: #name!accessing!public! !
!AXTypeLibDocumentation categoriesFor: #name:!accessing!private! !
!AXTypeLibDocumentation categoriesFor: #printOn:!printing!public! !

