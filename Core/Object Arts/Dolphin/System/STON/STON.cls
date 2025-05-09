﻿"Filed out from Dolphin Smalltalk"!

Kernel.Namespace
	subclass: #STON
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!

STON guid: (Core.GUID fromString: '{9f4c50c0-4b3c-4c6c-b0b5-98940098a150}')!

STON isNonInstantiable: true!

STON comment: 'STON implements serialization and materialization using the Smalltalk Object Notation format.

I am a class side facade offering a high level API to write and read objects using STON.

U s a g e

Basic operations

  #toString:
  #fromString:

  STON toString: DisplayScreen boundingBox.
  STON fromString:  ''Rectangle{#origin:Point[0,0],#corner:Point[1920,1030]}''.

  STON toString: { DateAndTime now. Float pi. 1 to: 10 by: 2. 3 days }.
  STON fromString:  ''[DateAndTime[''''2016-03-15T13:57:59.462422+01:00''''],3.141592653589793,Interval{#start:1,#stop:10,#step:2},Duration{#nanos:0,#seconds:259200}]''

You can also read from or write to streams

  #fromStream:
  #put:onStream:

There is also the option to do pretty printing (indenting, multi line output) 

  #toStringPretty:
  #put:onStreamPretty:

STON is more or less a superset of JSON and is backwards compatible with JSON while parsing, and can be compatible with it while writing. The important differences (and the whole reason why STON exists in the first place) are 

  - class information (except for lists (Array) and maps (Dictionary))
  - proper handling of shared and circular references
  - more Smalltalk-like syntax (Symbols with #, single quoted Strings, nil instead of null)
  - more defined special types (Date, Time, DataAndTime, ByteArray, Point)

Parsing JSON is done using #fromString: or #fromStream: with the results being composed of Arrays and Dictionaries.

Writing objects as JSON is done using: 

  #toJsonString[Pretty]:
  #put:asJsonOnStream[Pretty]:

Note that you can only write Arrays and Dictionaries !!

For a much more sophisticated JSON parser/writer implementation, have a look at NeoJSON.

Like JSON, STON does not allow for comments. However, a preprocessor option can skip C style comments before parsing.

I also define some contants used in the implementation: the class used as list, map and association, as well as the optional class name key (used when reading objects using an unknown class).


I m p l e m e n t a t i o n

The 2 key methods are

  #stonOn:
  #fromSton:

which work together with STONWriter and STONReader; read their class comments for all configuration options (you can use the #reader and #writer methods to avoid referring to these classes directly).

Several methods are used to support and/or control the implementation

  #stonName - defines the external name for a class
  #stonAllInstVarNames - defines which instance variable to write
  #stonContainSubObjects - shortcut looking into objects for subobjects
  #stonShouldWriteNilInstVars - option to skip writing nil valued instance variables


S y n t a x

	value
	  primitive-value
	  object-value
	  reference
	  nil
	primitive-value
	  number
	  true
	  false
	  symbol
	  string
	object-value
	  object
	  map
	  list
	object
	  classname map
	  classname list
	reference
	  @ int-index-previous-object-value
	map
	  {}
	  { members }
	members
	  pair
	  pair , members
	pair
	  string : value
	  symbol : value
	  number : value
	list
	  []
	  [ elements ]
	elements
	  value 
	  value , elements
	string
	  ''''
	  '' chars ''
	chars
	  char
	  char chars
	char
	  any-printable-ASCII-character-
	    except-''-"-or-\
	  \''
	  \"
	  \\
	  \/
	  \b
	  \f
	  \n
	  \r
	  \t
	  \u four-hex-digits
	symbol
	  # chars-limited
	  # '' chars ''
	chars-limited
	  char-limited
	  char-limited chars-limited
	char-limited
	  a-z A-Z 0-9 - _ . /
	classname
	  uppercase-alpha-char alphanumeric-char
	number
	  int
	  int frac
	  int exp
	  int frac exp
	int
	  digit
	  digit1-9 digits 
	  - digit
	  - digit1-9 digits
	frac
	  . digits
	exp
	  e digits
	digits
	  digit
	  digit digits
	e
	  e
	  e+
	  e-
	  E
	  E+
	  E-
'!

!STON categoriesForClass!STON-Core-Base! !

!STON class methodsFor!

associationClass
	"Return the class of STON associations, Association, a system wide constant"

	"(STON fromString: '#foo : 100') class >>> STON associationClass"

	^ Association!

classNameKey
	"Return the key that will be used to add a property with the class name 
	when an unknown class is read and the option STONReader>>#acceptUnknownClasses: is true,
	by default #className. Such unknown classes are returned as generic maps."

	"((STON reader acceptUnknownClasses: true; on: 'FooBarBaz { #foo : 100 }' readStream; next) at: STON classNameKey) >>> #FooBarBaz"

	^ #className!

fromStream: readStream
	"Parse and materialize the STON representation in the character readStream"

	"(STON fromStream: 'Point[1,2]' readStream) >>> (1@2)"

	"FileLocator temp / ('{1}.ston' format: { Time millisecondClockValue }) in: [ :file | 
		file writeStreamDo: [ :out | STON put: 1@2 onStream: out ].
		file readStreamDo: [ :in | STON fromStream: in ] ]"

	^ (self reader on: readStream) next!

fromStreamWithComments: readStream
	"Parse and materialize the STON representation in the character readStream,
	skipping C-style comments"

	"(STON fromStreamWithComments: 'Point[1,/*comment*/2]' readStream) >>> (1@2)"

	^ (self reader on: (CStyleCommentsSkipStream on: readStream)) next!

fromString: string
	"Parse and materialize the STON representation in string"

	"(STON fromString: 'Point[1,2]') >>> (1@2)"

	^ self fromStream: string readStream!

fromStringWithComments: string
	"Parse and materialize the STON representation in string,
	skipping C-style comments"

	"(STON fromStringWithComments: 'Point[1,/*comment*/2]') >>> (1@2)"

	^ self fromStreamWithComments: string readStream!

listClass
	"Return the class of STON lists, Array, a system wide constant"

	"(STON fromString: '[1 , 2 , 3]') class >>> STON listClass"

	^ Array!

mapClass
	"Return the class of STON maps, Dictionary, a system wide constant"

	"(STON fromString: '{ #foo : 1 , #bar : 2 }') class >>> STON mapClass"

	^ Dictionary!

prettyPrinter
	^PrettyPrinter new!

put: object onStream: stream
	"Write the STON serialization of object to the character writeStream"

	"(String streamContents: [ :out | STON put: 1@2 onStream: out ]) >>> 'Point[1,2]'"

	"FileLocator temp / ('{1}.ston' format: { Time millisecondClockValue }) in: [ :file | 
		file writeStreamDo: [ :out | STON put: 1@2 onStream: out ].
		file readStreamDo: [ :in | STON fromStream: in ] ]"

	(self writer on: stream) nextPut: object!

put: object onStreamPretty: stream
	"Write the pretty printed STON serialization of object to the character writeStream"

	"String streamContents: [ :out | STON put: (0@0 extent: 20@30) onStreamPretty: out ]"

	(self prettyPrinter on: stream)
		nextPut: object!

reader
	"Shortcut to create a new STONReader instance"

	^ Reader new!

readFrom: aReadStream
	^self fromStream: aReadStream!

toString: object
	"Return a String with the STON serialization of object"

	"(STON toString: 1@2) >>> 'Point[1,2]'"

	^ String streamContents: [ :stream |
		self put: object onStream: stream ]!

toStringPretty: object
	"Return a String with the pretty printed STON serialization of object"

	"STON toStringPretty: (0@0 extent: 20@30)"

	^ String streamContents: [ :stream |
		self put: object onStreamPretty: stream ]!

writer
	^Writer new! !

!STON class categoriesForMethods!
associationClass!accessing!public! !
classNameKey!accessing!public! !
fromStream:!convenience!public! !
fromStreamWithComments:!convenience!public! !
fromString:!convenience!public! !
fromStringWithComments:!convenience!public! !
listClass!accessing!public! !
mapClass!accessing!public! !
prettyPrinter!private! !
put:onStream:!convenience!public! !
put:onStreamPretty:!convenience!public! !
reader!accessing!public! !
readFrom:!convenience!public! !
toString:!convenience!public! !
toStringPretty:!convenience!public! !
writer!accessing!public! !
!

