"Filed out from Dolphin Smalltalk 7"!

ConsoleSessionManager subclass: #Catenate
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Catenate guid: (GUID fromString: '{8004fa9a-2326-4df3-8107-51cfcd06d5c9}')!
Catenate comment: 'Catenate is a sample command line application that performs the same function as the Unix ''cat'' and DOS ''type'' commands (i.e. it copies the contents of the files specified on its command line to the standard output stream).'!
!Catenate categoriesForClass!Unclassified! !
!Catenate methodsFor!

cat: fileNames 
	"Dump the contents of all the files listed as arguments to stdout"

	"One thing to watch out for is that the stdio streams are opened in translating mode by
	default - this means that sending a LF to an output stream will result in the emission of a
	CR/LF pair, and vice versa on input. This means that it doesn't make sense to mix and match
	Dolphin's standard high performance FileStreams with StdioFileStreams."

	fileNames do: 
			[:f | 
			| in next |
			in := StdioFileStream read: f.
			
			[next := in nextAvailable: 1024.
			next isEmpty] whileFalse: [self stdout nextPutAll: next]].
	self stdout flush.!

main
	self argc < 2 
		ifTrue: 
			[(self stderr)
				nextPutAll: 'Dolphin Smalltalk Catenate Sample';
				cr;
				nextPutAll: 'Copyright (c) Object Arts Ltd, 2000-2002.';
				crtab: 1;
				nextPutAll: 'Usage: ';
				display: self argv first;
				nextPutAll: ' <file1>,<file2>,...<fileN>';
				cr]
		ifFalse: [self cat: (self argv copyFrom: 2)]! !
!Catenate categoriesFor: #cat:!operations-startup!public! !
!Catenate categoriesFor: #main!operations-startup!public! !

