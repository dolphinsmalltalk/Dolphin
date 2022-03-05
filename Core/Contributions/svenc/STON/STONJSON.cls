"Filed out from Dolphin Smalltalk"!

Object subclass: #STONJSON
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONJSON guid: (GUID fromString: '{5d40ba2f-84f1-44cf-970b-5ff22fd8fc7c}')!
STONJSON comment: 'I am STONJSON, a class side facade to use STON as a simple JSON parser/writer.

STON is more or less a superset of JSON and is backwards compatible with JSON while parsing, and can be compatible with it while writing. The important differences (and the whole reason why STON exists in the first place) are 

  - class information (except for lists (Array) and maps (Dictionary))
  - proper handling of shared and circular references
  - more Smalltalk like syntax (Symbols with #, single qouted Strings, nil instead of null)
  - more defined special types (Date, Time, DataAndTime, ByteArray, Point)

Parsing JSON is done using

  #fromString:
  #fromStream: 

with the results being composed of Arrays and Dictionaries.

Writing objects as JSON is done using

  #toString[Pretty]:
  #put:onStream[Pretty]:

Note that you can only write Arrays and Dictionaries !! Shared and circular references will be noted and signalled using an exception.

E x a m p l e s

  STONJSON toString: { 1. -1. Float pi. true. ''JSON'' }.
  STONJSON fromString: ''[1,-1,3.141592653589793,true,"JSON"]''.

  STONJSON toStringPretty: { #foo->1. #bar->2 } asDictionary.
  STONJSON fromString: ''{"foo":1,"bar":2,"sub":{"a":true,"b":false},"flags":[1,8,32]}''.
 
For a much more sophisticated JSON parser/writer implementation, have a look at NeoJSON.'!
!STONJSON categoriesForClass!STON-Core-Base! !
!STONJSON class methodsFor!

fromStream: stream
	^ STON fromStream: stream!

fromString: string
	^ STON fromString: string!

put: object onStream: stream
	STON put: object asJsonOnStream: stream!

put: object onStreamPretty: stream
	STON put: object asJsonOnStreamPretty: stream!

toString: object
	^ STON toJsonString: object!

toStringPretty: object
	^ STON toJsonStringPretty: object! !
!STONJSON class categoriesForMethods!
fromStream:!convenience!public! !
fromString:!convenience!public! !
put:onStream:!convenience!public! !
put:onStreamPretty:!convenience!public! !
toString:!convenience!public! !
toStringPretty:!convenience!public! !
!

